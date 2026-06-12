local WallStatus = {}
local TableSystem = {}

local function Notify(source,message)
    TriggerClientEvent("Notify",source,"amarelo",message,5000)
end

local function HasWallPermission(source)
    local user_id = IDsEQPG(source)
    if not user_id then
        return false
    end

    for _,permission in pairs(config.perms) do
        if PermEQPG(user_id,permission) or hasGroupEQPG(user_id,permission) then
            return true
        end
    end

    return false
end

local function BuildTableSystem()
    local players = GetPlayers()
    local tableSystem = {}

    for _,src in pairs(players) do
        local source = tonumber(src)
        local user_id = IDsEQPG(source)

        if user_id then
            tableSystem[source] = {
                userId = user_id,
                GetName = NameEQPG(user_id),
                Groups = GroupsEQPG(user_id) or {},
                wallActive = WallStatus[source] or false
            }
        end
    end

    TableSystem = tableSystem
    return tableSystem
end

RegisterCommand(config.command,function(source,args,rawCommand)
    if source <= 0 then
        return
    end

    if not HasWallPermission(source) then
        Notify(source,"Você não tem permissão para usar o wall.")
        return
    end

    WallStatus[source] = not WallStatus[source]

    TriggerClientEvent("goianox:AdvancedSystem",source,WallStatus[source])
    TriggerClientEvent("goianox:getTableSystem",source,BuildTableSystem())

    if WallStatus[source] then
        Notify(source,"Wall ativado.")
    else
        Notify(source,"Wall desativado.")
    end
end)

RegisterServerEvent("Send:TableSystem")
AddEventHandler("Send:TableSystem",function()
    local source = source

    if source and HasWallPermission(source) then
        TriggerClientEvent("goianox:getTableSystem",source,BuildTableSystem())
    end
end)

RegisterServerEvent("response:gamePolId")
AddEventHandler("response:gamePolId",function(data)
    local source = source

    if data and data.wallActive ~= nil then
        WallStatus[source] = data.wallActive == true or data.wallActive == "true"
    end

    BuildTableSystem()
end)

AddEventHandler("playerDropped",function()
    local source = source
    WallStatus[source] = nil
    TableSystem[source] = nil
end)
