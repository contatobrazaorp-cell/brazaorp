-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("moneywash", Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES (importadas do shared.lua com fallback)
-----------------------------------------------------------------------------------------------------------------------------------------
BleachDuration = BleachDuration or 21600           -- 6 horas
BatteryDuration = BatteryDuration or 604800        -- 7 dias
BleachPercentage = BleachPercentage or 0.01        -- 1% extra
local Cooldown = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO AUXILIAR: gerar string aleatória (se não existir)
-----------------------------------------------------------------------------------------------------------------------------------------
if not GenerateString then
    function GenerateString(pattern)
        local result = ""
        for i = 1, #pattern do
            local c = pattern:sub(i,i)
            if c == "D" then
                result = result .. math.random(0,9)
            elseif c == "L" then
                result = result .. string.char(math.random(65,90))
            else
                result = result .. c
            end
        end
        return result
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO DE VERIFICAÇÃO DE ACESSO POR FACÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local function HasAccess(Passport, Machine)
    -- Se a máquina não tem permissão definida, libera para todos (compatibilidade)
    if not Machine.Permission then
        return true
    end
    -- Verifica se o jogador pertence ao grupo da facção
    return vRP.HasGroup(Passport, Machine.Permission)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD PRINCIPAL DE LAVAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        if os.time() >= Cooldown then
            Cooldown = os.time() + 10

            local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
            for Number, Machines in pairs(Moneywash) do
                if Machines.Timer and Machines.Timer > os.time() 
                   and Machines.Bleach and Machines.Bleach > os.time() 
                   and Machines.Money > 0 then
                    
                    local Efficiency = 0.05
                    if Machines.Bleach > os.time() then
                        Efficiency = Efficiency + BleachPercentage
                    end
                    
                    local Amount = math.floor(Machines.Money * Efficiency)
                    if Amount > 0 then
                        Moneywash[Number].Money = Machines.Money - Amount
                        Moneywash[Number].Washed = (Machines.Washed or 0) + Amount
                        Moneywash[Number].Last = os.time() + 300
                    end
                end
            end

            vRP.SetSrvData("MoneyWash",Moneywash,true)
            TriggerClientEvent("moneywash:Table",-1,Moneywash)
        end
        Wait(1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFORMATION (agora com verificação de acesso)
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Information(Number)
    local source = source
    if not source then return false end

    local Passport = vRP.Passport(source)
    if not Passport then return false end

    local Moneywash = vRP.GetSrvData("MoneyWash", true) or {}
    local Machine = Moneywash[Number]
    if not Machine then return false end

    -- Verifica permissão
    if not HasAccess(Passport, Machine) then
        return false
    end

    return Machine
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OSTIME
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.OsTime()
    return os.time()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WASH (EXPORT modificado para aceitar permissão)
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Wash", function(Passport, Item, Hash, Coords, Route, Permission)
    local Moneywash = vRP.GetSrvData("MoneyWash", true) or {}

    repeat
        Number = GenerateString("DDLLDDLL")
    until not Moneywash[Number]

    -- Se Item for nil, define como string vazia (não será usado)
    Item = Item or ""

    Moneywash[Number] = {
        Route = Route,
        Coords = Coords,
        Hash = Hash,
        Item = Item,
        Money = 0,
        Washed = 0,
        Timer = 0,
        Bleach = 0,
        Last = 0,
        Passport = Passport,
        Password = nil,
        Permission = Permission   -- 👈 NOVO: facção permitida
    }

    vRP.SetSrvData("MoneyWash",Moneywash,true)
    TriggerClientEvent("moneywash:New",-1,Number,Moneywash[Number])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Add")
AddEventHandler("moneywash:Add", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    -- Verifica permissão
    if not HasAccess(Passport, Moneywash[Selected]) then
        TriggerClientEvent("Notify", source, "Aviso", "Você não tem permissão para usar esta máquina.", "vermelho", 5000)
        return
    end

    if Moneywash[Selected].Timer <= os.time() then
        TriggerClientEvent("Notify",source,"Aviso","Adicione uma bateria primeiro.","vermelho",5000)
        return
    end

    local Keyboard = vKEYBOARD.Primary(source, "Quantidade:")
    if Keyboard then
        TriggerClientEvent("dynamic:Close",source)
        local Quantity = parseInt(Keyboard[1])
        if Quantity <= 0 then return end

        if vRP.TakeItem(Passport,"dirtydollar",Quantity,true) then
            Moneywash[Selected].Money = Moneywash[Selected].Money + Quantity
            vRP.SetSrvData("MoneyWash",Moneywash,true)
            TriggerClientEvent("moneywash:Update",-1,Selected,Moneywash[Selected])
            TriggerClientEvent("Notify",source,"Sucesso","Dinheiro adicionado.","verde",5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Money")
AddEventHandler("moneywash:Money", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    -- Verifica permissão
    if not HasAccess(Passport, Moneywash[Selected]) then
        TriggerClientEvent("Notify", source, "Aviso", "Você não tem permissão para usar esta máquina.", "vermelho", 5000)
        return
    end

    local Amount = Moneywash[Selected].Money or 0
    if Amount > 0 then
        vRP.GenerateItem(Passport,"wetdollar",Amount,true)
        Moneywash[Selected].Money = 0
        vRP.SetSrvData("MoneyWash",Moneywash,true)
        TriggerClientEvent("dynamic:Close",source)
        TriggerClientEvent("moneywash:Update",-1,Selected,Moneywash[Selected])
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:WASHED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Washed")
AddEventHandler("moneywash:Washed", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    -- Verifica permissão
    if not HasAccess(Passport, Moneywash[Selected]) then
        TriggerClientEvent("Notify", source, "Aviso", "Você não tem permissão para usar esta máquina.", "vermelho", 5000)
        return
    end

    local Amount = Moneywash[Selected].Washed or 0
    if Amount > 0 then
        vRP.GenerateItem(Passport,"dollar",Amount,true)
        Moneywash[Selected].Washed = 0
        vRP.SetSrvData("MoneyWash",Moneywash,true)
        TriggerClientEvent("dynamic:Close",source)
        TriggerClientEvent("moneywash:Update",-1,Selected,Moneywash[Selected])
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:BATTERY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Battery")
AddEventHandler("moneywash:Battery", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    -- Verifica permissão
    if not HasAccess(Passport, Moneywash[Selected]) then
        TriggerClientEvent("Notify", source, "Aviso", "Você não tem permissão para usar esta máquina.", "vermelho", 5000)
        return
    end

    if Moneywash[Selected].Timer > os.time() then
        TriggerClientEvent("Notify", source, "Aviso", "Já tem uma bateria ativa.", "amarelo", 5000)
        return
    end

    if vRP.TakeItem(Passport,"washbattery",1,true) then
        Moneywash[Selected].Timer = os.time() + BatteryDuration
        vRP.SetSrvData("MoneyWash",Moneywash,true)
        TriggerClientEvent("dynamic:Close",source)
        TriggerClientEvent("Notify",source,"Sucesso","Bateria colocada.","verde",5000)
        TriggerClientEvent("moneywash:Update",-1,Selected,Moneywash[Selected])
    else
        TriggerClientEvent("Notify",source,"Aviso","Você precisa de 1x Bateria 75Ah","amarelo",5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:BLEACH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Bleach")
AddEventHandler("moneywash:Bleach", function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    -- Verifica permissão
    if not HasAccess(Passport, Moneywash[Selected]) then
        TriggerClientEvent("Notify", source, "Aviso", "Você não tem permissão para usar esta máquina.", "vermelho", 5000)
        return
    end

    if Moneywash[Selected].Bleach > os.time() then
        TriggerClientEvent("Notify", source, "Aviso", "Já tem alvejante ativo.", "amarelo", 5000)
        return
    end

    if vRP.TakeItem(Passport,"washbleach",1,true) then
        Moneywash[Selected].Bleach = os.time() + BleachDuration
        vRP.SetSrvData("MoneyWash",Moneywash,true)
        TriggerClientEvent("dynamic:Close",source)
        TriggerClientEvent("Notify",source,"Sucesso","Alvejante adicionado","verde",5000)
        TriggerClientEvent("moneywash:Update",-1,Selected,Moneywash[Selected])
    else
        TriggerClientEvent("Notify",source,"Aviso","Você precisa de 1x Alvejante","amarelo",5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:PASSWORD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:Password")
AddEventHandler("moneywash:Password",function(Selected)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    if not Moneywash[Selected] then return end

    -- Verifica permissão
    if not HasAccess(Passport, Moneywash[Selected]) then
        TriggerClientEvent("Notify", source, "Aviso", "Você não tem permissão para usar esta máquina.", "vermelho", 5000)
        return
    end

    local Keyboard = vKEYBOARD.Password(source,"Senha")
    if Keyboard then
        TriggerClientEvent("dynamic:Close",source)
        local Password = Keyboard[1]
        Moneywash[Selected].Password = Password
        vRP.SetSrvData("MoneyWash",Moneywash,true)
        TriggerClientEvent("Notify",source,"Sucesso","Palavra chave atualizada","verde",5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:STOREOBJECTS (BLOQUEADO - NINGUÉM GUARDA A MÁQUINA)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("moneywash:StoreObjects")
AddEventHandler("moneywash:StoreObjects", function(Selected)
    local source = source
    TriggerClientEvent("Notify", source, "Aviso", "Esta máquina não pode ser guardada.", "vermelho", 5000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    TriggerClientEvent("moneywash:Table",-1,Moneywash)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
    if Passport then
        Passport = nil
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVESERVER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("SaveServer",function(Silenced)
    local Moneywash = vRP.GetSrvData("MoneyWash",true) or {}
    vRP.Query("entitydata/SetData",{ Name = "MoneyWash", Information = json.encode(Moneywash) })

    if not Silenced then
        print("O resource ^2Moneywash^7 salvou os dados.")
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN DAS MÁQUINAS FIXAS NO MAPA (POR FACÇÃO)
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    Wait(5000) -- aguarda o resource moneywash carregar completamente

    local route = "Default"  -- rota padrão (ajuste conforme necessário)
    local prop = "prop_washer_01"  -- modelo da máquina

    -- Lista de máquinas com coordenadas e permissão
    local machines = {
        { perm = "VANILLA",          coords = { 124.82,  -1339.52, 33.55, 34.02  } },
        { perm = "ABSOLUT",          coords = { 753.42,  -578.83,  33.63, 201.26 } },
        { perm = "BAHAMAS",          coords = { -1371.62, -618.19, 30.31, 218.27 } },
        { perm = "TROPA_DO_PORTUGA", coords = { 1463.98, 6319.8,  31.16, 345.83 } },
    }

    for _, m in ipairs(machines) do
        exports["moneywash"]:Wash(
            0,              -- Passport (não utilizado)
            nil,            -- Item (não será gerado porque não pode guardar)
            prop,           -- Hash do prop (string, o cliente fará o LoadModel)
            m.coords,       -- {x, y, z, h}
            route,          -- Rota
            m.perm          -- Permissão da facção
        )
        print("^2[Moneywash]^7 Máquina da facção " .. m.perm .. " spawnada.")
    end
end)