-----------------------------------------------------------------------------------------------------------------------------------------
-- BRAZAO STORE - CLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy  = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

Loja = {}
Tunnel.bindInterface("lojaroupas", Loja)
vSERVER = Tunnel.getInterface("lojaroupas")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local IsOpen     = false
local Camera     = nil
local OriginalClothes = nil
local Pending    = {}
local CategoryFocus = "tshirt"

-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS
-----------------------------------------------------------------------------------------------------------------------------------------
local SlotComponentId = {}
local SlotPropId = {}
for _,c in ipairs(Config.Categories) do
    if c.mode == "variation" then SlotComponentId[c.slot] = c.compId end
    if c.mode == "prop"      then SlotPropId[c.slot]      = c.propId end
end

-- Agora: cada categoria tem MODELOS (drawables), e cada modelo tem VARIACOES (texturas/cores)
local function BuildCategories()
    local Ped = PlayerPedId()
    local Result = {}
    for _,cat in ipairs(Config.Categories) do
        local models = {}

        if cat.allowNone then
            table.insert(models, {
                id = -1,
                nome = (cat.mode == "prop") and "Remover" or "Padrao",
                isNone = true,
                variations = {
                    { nome = "Unico", drawable = (cat.mode == "prop") and -1 or 0, texture = 0, preco = 0 }
                }
            })
        end

        if cat.mode == "variation" then
            local count = GetNumberOfPedDrawableVariations(Ped, cat.compId)
            for d = 0, count - 1 do
                local tex = GetNumberOfPedTextureVariations(Ped, cat.compId, d)
                if tex < 1 then tex = 1 end
                local variations = {}
                for t = 0, tex - 1 do
                    table.insert(variations, {
                        nome = "Cor "..(t+1),
                        drawable = d, texture = t,
                        preco = cat.basePrice + (d * 5) + (t * 10),
                    })
                end
                table.insert(models, {
                    id = d,
                    nome = cat.label.." Modelo "..(d+1),
                    variations = variations,
                })
            end
        else
            local count = GetNumberOfPedPropDrawableVariations(Ped, cat.propId)
            for d = 0, count - 1 do
                local tex = GetNumberOfPedPropTextureVariations(Ped, cat.propId, d)
                if tex < 1 then tex = 1 end
                local variations = {}
                for t = 0, tex - 1 do
                    table.insert(variations, {
                        nome = "Cor "..(t+1),
                        drawable = d, texture = t,
                        preco = cat.basePrice + (d * 5) + (t * 10),
                    })
                end
                table.insert(models, {
                    id = d,
                    nome = cat.label.." Modelo "..(d+1),
                    variations = variations,
                })
            end
        end

        table.insert(Result, {
            id = cat.id, label = cat.label, icon = cat.icon,
            slot = cat.slot, mode = cat.mode, models = models,
        })
    end
    return Result
end

local function ApplyPreviewSlot(slot, mode, drawable, texture)
    local Ped = PlayerPedId()
    if mode == "variation" then
        SetPedComponentVariation(Ped, SlotComponentId[slot], drawable, texture, 0)
    else
        if drawable == -1 or drawable == 0 then
            ClearPedProp(Ped, SlotPropId[slot])
        else
            SetPedPropIndex(Ped, SlotPropId[slot], drawable, texture, false)
        end
    end
end

local function RestoreOriginal()
    if OriginalClothes then
        exports.skinshop:Apply(OriginalClothes)
    end
end

local function MergedClothes()
    local Merged = {}
    for k,v in pairs(OriginalClothes or {}) do
        Merged[k] = { item = v.item, texture = v.texture }
    end
    for slot,info in pairs(Pending) do
        Merged[slot] = { item = info.drawable, texture = info.texture }
    end
    return Merged
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRIR / FECHAR
-----------------------------------------------------------------------------------------------------------------------------------------
local function AbrirLoja()
    if IsOpen then return end
    if exports.hud and exports.hud:Wanted() then return end
    if exports.hud and exports.hud:Repose() then return end

    IsOpen = true
    Pending = {}

    local okCurrent, currentClothes = pcall(function()
        return exports["skinshop"]:CurrentClothes()
    end)

    if okCurrent and currentClothes then
        OriginalClothes = currentClothes
    else
        local sk = Tunnel.getInterface("skinshop")
        if sk and sk.CurrentClothes then
            local okTunnel, tunnelClothes = pcall(sk.CurrentClothes)
            OriginalClothes = okTunnel and tunnelClothes or {}
        else
            OriginalClothes = {}
        end
    end

    local Ped = PlayerPedId()
    FreezeEntityPosition(Ped, true)
    SetEntityCollision(Ped, false, false)
    SetEntityInvincible(Ped, true)
    SetEntityVisible(Ped, true, false)

    local Heading = GetEntityHeading(Ped)
    local PedCoords = GetEntityCoords(Ped)
    -- Camera deslocada para a esquerda do personagem para que ele apareca no lado DIREITO da tela
    -- (o painel da loja ocupa o lado esquerdo)
    local Coords  = GetOffsetFromEntityInWorldCoords(Ped, -1.1, 3.6, 0.75)
    local Target  = GetOffsetFromEntityInWorldCoords(Ped, 0.6, 0.0, 0.25)
    Camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",
        Coords.x, Coords.y, Coords.z,
        0.0, 0.0, Heading + 180.0,
        55.0, false, 0)
    PointCamAtCoord(Camera, Target.x, Target.y, Target.z)
    SetCamActive(Camera, true)
    RenderScriptCams(true, false, 0, true, true)

    if exports.hud then TriggerEvent("hud:Active", false) end
    LocalPlayer.state:set("Hoverfy", false, false)

    SendNUIMessage({ action = "open", categories = BuildCategories(), focus = CategoryFocus })
    SetNuiFocus(true, true)
end

local function FecharLoja(comprou)
    if not IsOpen then return end
    IsOpen = false

    if DoesCamExist(Camera) then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(Camera, false)
        Camera = nil
    end
    local Ped = PlayerPedId()
    FreezeEntityPosition(Ped, false)
    SetEntityCollision(Ped, true, true)
    SetEntityInvincible(Ped, false)

    SetNuiFocus(false, false)
    if exports.hud then TriggerEvent("hud:Active", true) end
    LocalPlayer.state:set("Hoverfy", true, false)

    if not comprou then
        RestoreOriginal()
    end

    Pending = {}
    OriginalClothes = nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIP + INTERACAO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    local blip = AddBlipForCoord(Config.Location.x, Config.Location.y, Config.Location.z)
    SetBlipSprite(blip, Config.Blip.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, Config.Blip.color)
    SetBlipScale(blip, Config.Blip.scale)
    SetBlipAsShortRange(blip, Config.Blip.shortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Blip.name)
    EndTextCommandSetBlipName(blip)

    if TriggerEvent then
        TriggerEvent("hoverfy:Insert", {
            { vec3(Config.Location.x, Config.Location.y, Config.Location.z),
              Config.InteractDistance, "E", "Pressione", "para abrir a loja" }
        })
    end
end)

CreateThread(function()
    while true do
        local wait = 1000
        local Ped = PlayerPedId()
        if not IsPedInAnyVehicle(Ped) then
            local Coords = GetEntityCoords(Ped)
            local dist = #(Coords - Config.Location)
            if dist <= Config.MarkerDistance then
                wait = 0
                DrawMarker(1,
                    Config.Location.x, Config.Location.y, Config.Location.z - 1.0,
                    0,0,0, 0,0,0,
                    1.5, 1.5, 0.6,
                    220, 30, 40, 130,
                    false, false, 2, false, nil, nil, false)

                if dist <= Config.InteractDistance and not IsOpen then
                    if IsControlJustPressed(0, Config.OpenKey) then
                        AbrirLoja()
                    end
                end
            end
        end
        Wait(wait)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("preview", function(data, cb)
    if not IsOpen then cb("ok") return end
    Pending[data.slot] = {
        drawable = data.drawable,
        texture  = data.texture,
        preco    = data.preco,
        nome     = data.nome,
        mode     = data.mode,
    }
    ApplyPreviewSlot(data.slot, data.mode, data.drawable, data.texture)
    cb("ok")
end)

RegisterNUICallback("rotate", function(data, cb)
    local Ped = PlayerPedId()
    local h = GetEntityHeading(Ped)
    if data.dir == "left"  then SetEntityHeading(Ped, h - 10) end
    if data.dir == "right" then SetEntityHeading(Ped, h + 10) end
    cb("ok")
end)

RegisterNUICallback("cancel", function(_, cb)
    FecharLoja(false)
    cb("ok")
end)

RegisterNUICallback("setFocus", function(data, cb)
    CategoryFocus = data.id or CategoryFocus
    cb("ok")
end)

RegisterNUICallback("buy", function(_, cb)
    local Compras = {}
    local Total = 0
    for slot,info in pairs(Pending) do
        table.insert(Compras, {
            slot = slot, drawable = info.drawable, texture = info.texture,
            preco = info.preco, nome = info.nome,
        })
        Total = Total + (info.preco or 0)
    end

    if #Compras == 0 then
        cb({ ok = false, msg = "Nada selecionado." })
        return
    end

    local ok, msg = vSERVER.ConfirmarCompra(Total)
    if not ok then
        cb({ ok = false, msg = msg or "Falha no pagamento." })
        return
    end

    local Merged = MergedClothes()
    TriggerEvent("skinshop:Apply", Merged, true)

    cb({ ok = true, msg = "Compra realizada! Total: $"..Total })
    SetTimeout(700, function() FecharLoja(true) end)
end)

RegisterNetEvent("lojaroupas:Open", AbrirLoja)
