local wallActive = false
local PlayersTable = {}

local WallConfig = {
    distance = 500,
    lines = true,
    health = true,
    armour = true,
    showGroups = true,
    showSelf = config.myinfo == true
}

local function ToBool(value)
    value = tostring(value or ""):lower()
    return value == "sim" or value == "s" or value == "true" or value == "1" or value == "ligado" or value == "on"
end

RegisterNetEvent("goianox:AdvancedSystem")
AddEventHandler("goianox:AdvancedSystem",function(bool)
    SetWall(bool)
end)

RegisterNetEvent("goianox:getTableSystem")
AddEventHandler("goianox:getTableSystem",function(tablePlayers)
    if tablePlayers ~= nil then
        PlayersTable = tablePlayers
    end
end)

RegisterNetEvent("promise:gamePolPed")
AddEventHandler("promise:gamePolPed",function()
    local emptyTable = {
        ["wallActive"] = tostring(wallActive),
        ["gamePolId"] = PlayerId()
    }

    TriggerServerEvent("response:gamePolId",emptyTable)
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    TriggerServerEvent("Send:TableSystem")
end)

function SetWall(Active)
    wallActive = Active
    Citizen.Wait(100)

    Citizen.CreateThread(function()
        while wallActive do
            TriggerServerEvent("Send:TableSystem")
            Citizen.Wait(2000)
        end
    end)

    Citizen.CreateThread(function()
        while wallActive do
            local ped = PlayerPedId()
            local Coords = GetEntityCoords(ped)

            for k,v in pairs(GetActivePlayers()) do
                local nped = GetPlayerPed(v)
                local ncoords = GetEntityCoords(nped)
                local nsource = GetPlayerServerId(v)
                local distance = GetDistanceBetweenCoords(ncoords,Coords,false)

                if WallConfig.lines and distance < WallConfig.distance then
                    DrawLineW(Coords.x,Coords.y,Coords.z,ncoords.x,ncoords.y,ncoords.z,255,255,255,255)
                end

                if PlayersTable[nsource] then
                    local userId = PlayersTable[nsource].userId
                    local userName = tostring(PlayersTable[nsource].GetName or "N/E")
                    local userGroups = PlayersTable[nsource].Groups or {}
                    local userGroup = "N/E"

                    if WallConfig.showGroups and type(userGroups) == "table" then
                        local list = {}

                        for groupName,level in pairs(userGroups) do
                            if type(groupName) == "string" then
                                table.insert(list,groupName)
                            else
                                table.insert(list,tostring(level))
                            end
                        end

                        userGroup = table.concat(list,", ")
                        if userGroup == "" then
                            userGroup = "N/E"
                        end
                    elseif WallConfig.showGroups then
                        userGroup = tostring(userGroups)
                    end

                    local msg = "~y~ ID: ~w~"..(userId or "N/E").." ~b~Name: ~w~"..userName
                    if WallConfig.showGroups then
                        msg = msg.." ~o~[~w~"..userGroup.."~o~]"
                    end

                    local msg2 = ""
                    if WallConfig.health then
                        msg2 = msg2.."\n~g~HP ~w~"..GetEntityHealth(nped)
                    end
                    if WallConfig.armour then
                        msg2 = msg2.." ~b~AP ~w~"..GetPedArmour(nped)
                    end

                    if PlayersTable[nsource].wallActive then
                        msg2 = msg2.."\n~w~[~g~Wall~w~]"
                    end

                    if (v == PlayerId() and WallConfig.showSelf) or (v ~= PlayerId()) then
                        DrawTextW(ncoords.x,ncoords.y,ncoords.z + 1.3,msg)
                        DrawTextW(ncoords.x,ncoords.y,ncoords.z + 1.3,msg2)
                    end
                end
            end

            Citizen.Wait(0)
        end
    end)
end

local function BoolLabel(value)
    if value then
        return "Ativar"
    end

    return "Desativar"
end

local function ApplyToggle(option,value)
    local enabled = value == "Ativar" or value == "Sim" or value == "Ligado"

    if option == "Linhas" then WallConfig.lines = enabled end
    if option == "Vida" then WallConfig.health = enabled end
    if option == "Colete" then WallConfig.armour = enabled end
    if option == "Grupos" then WallConfig.showGroups = enabled end
    if option == "Minha Info" then WallConfig.showSelf = enabled end
end

RegisterCommand("wallconfig",function()
    if not wallActive then
        TriggerEvent("Notify","amarelo","Ative o wall primeiro com /wall.",5000)
        return
    end

    local Menu = exports["keyboard"]:Instagram({
        "Distância",
        "Linhas",
        "Vida",
        "Colete",
        "Grupos",
        "Minha Info"
    },"WallConfig","Escolha o que deseja configurar")

    if not Menu or not Menu[1] then
        return
    end

    local Option = tostring(Menu[1])

    if Option == "Distância" then
        local Keyboard = exports["keyboard"]:Primary("Distância atual: "..WallConfig.distance.." | Digite a nova distância")

        if not Keyboard or not Keyboard[1] then
            return
        end

        local Distance = tonumber(Keyboard[1])

        if Distance and Distance > 0 then
            WallConfig.distance = Distance
            TriggerEvent("Notify","verde","Distância do wall alterada para "..WallConfig.distance.."m.",5000)
        else
            TriggerEvent("Notify","vermelho","Distância inválida.",5000)
        end

        return
    end

    local Status = exports["keyboard"]:Instagram({
        "Ativar",
        "Desativar"
    },"WallConfig",Option.." - escolha o status")

    if not Status or not Status[1] then
        return
    end

    ApplyToggle(Option,tostring(Status[1]))
    TriggerEvent("Notify","verde",Option.." atualizado para "..tostring(Status[1])..".",5000)
end)

RegisterKeyMapping("wallconfig","Abrir configuração do Wall","keyboard","F7")

function DrawTextW(x,y,z,text,r,g,b)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz,x,y,z,1)
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextFont(4)
        SetTextProportional(10)
        SetTextScale(0.35,0.35)
        SetTextColour(r or 255,g or 255,b or 255,255)
        SetTextEntry("STRING")
        SetTextCentre(2)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function DrawLineW(x1,y1,z1,x2,y2,z2,r,g,b,a)
    DrawLine(x1,y1,z1,x2,y2,z2,r,g,b,a)
end
