local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
vGARAGEM = Tunnel.getInterface("garages")
local Spawn = {}
local timeExec = 10000 --Tempo de execução dos comandos (Recomendado 10000 para que não pese no servidor)

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

vRP.Prepare('bot/pendingRequests','SELECT * FROM bot_requests')
vRP.Prepare('bot/deleteRequest','DELETE FROM bot_requests WHERE id = @id')
vRP.Prepare('bot/insertRequest','INSERT INTO bot_requests(requests) VALUES(@requests)')

Citizen.CreateThread(function()
    while true do
        local req = vRP.Query('bot/pendingRequests')
        for _,v in pairs(req) do
            vRP.Query('bot/deleteRequest',{ id = v.id })
            ExecuteCommand(v.requests)
        end
        Citizen.Wait(timeExec) 
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ bot ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('limpainvdiscord',function(source,args,rawCommand)
    if source == 0 then
        local nsource = vRP.Source(parseInt(args[1]))
        local user_id = vRP.Passport(nsource)
        if nsource then
            vRP.ClearInventory(parseInt(args[1]))
            TriggerClientEvent("Notify",nsource,"amarelo","seu inventário foi zerado pelo discord.",6000) 
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ REVIVER ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('goddiscord',function(source,args,rawCommand)
    if source == 0 then
        local nsource = vRP.Source(parseInt(args[1]))
        print("^5[ ^3+ ^5] SHAKTAR > ^7O jogador ^5("..nsource..") ^7recebeu GOD")
        vRP.Revive(nsource,200)
        TriggerClientEvent("Notify", nsource, "amarelo", "Você recebeu god pelo DISCORD ",6000)
    end
end)

RegisterCommand('kickkaduzera',function(source,args,rawCommand)
    if source == 0 then
        local nsource = vRP.Source(parseInt(args[1]))
        local id = vRP.Source(parseInt(args[1]))
        if nsource then 
            vRP.Kick(id,"Banido")
        end
        return;
    end
end)


RegisterCommand('unbankaduzera',function(source,args,rawCommand)
    if source == 0 then
		local OtherPassport = parseInt(args[1])
		local Identity = vRP.Identity(OtherPassport)
		if Identity then
			vRP.Query("banneds/RemoveBanned",{ license = Identity["license"] })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ GROUP ]------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('groupdiscord', function(source, args, rawCommand)
    if source == 0 then
        local nsource = vRP.Source(parseInt(args[2]))
        if #args < 3 then
            print("Uso incorreto! Exemplo de uso: /groupdiscord <add|rem> <ID> <grupo> <permissao>")
            return
        end

        local action = args[1]  
        local nuser_id = parseInt(args[2])  
        local group = args[3]  
        local permission = args[4]

        if action == 'add' then
            if permission then
                vRP.SetPermission(nuser_id, group, permission)
                print("Permissão " .. permission .. " adicionada para o jogador " .. nuser_id .. " no grupo " .. group)
                TriggerClientEvent("Notify", nsource, "verde", "Você foi setado no grupo <b>" .. group .. "</b> através do Discord.", 6000)
            else
                print("Permissão não especificada para o comando 'add'.")
            end
        elseif action == 'rem' then
            vRP.RemovePermission(nuser_id, group)
            print("Permissão removida para o jogador " .. nuser_id .. " no grupo " .. group)
            TriggerClientEvent("Notify", nsource, "verde", "Você foi removido do grupo <b>" .. group .. "</b> através do Discord.", 6000)
        else
            print("Ação inválida. Use 'add' ou 'rem'.")
        end
    else
        print("Este comando deve ser executado no console.")
    end
end)




-----------------------------------------------------------------------------------------------------------------------------------------
--[ KILL ]-------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('killdiscord', function(source,args,rawCommand)
    if source == 0 then
        local nsource = vRP.Source(parseInt(args[1]))
        if nsource then
            vRP.Revive(nsource,100)
            TriggerClientEvent("Notify",nsource,"amarelo","Você foi morto atraves do discord.",5000)
        end
        return;
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cardiscord', function(source, args, rawCommand)
    if source == 0 then
        local nsource = vRP.Source(tonumber(args[1]))
        if nsource then
            local VehicleName = args[2]
            if not VehicleName then
                print("Você precisa especificar o nome do veículo.")
                return
            end
            
            local Ped = GetPlayerPed(nsource)
            if not Ped then
                print("Jogador inválido.")
                return
            end
            
            local Coords = GetEntityCoords(Ped)
            local Heading = GetEntityHeading(Ped)

            local Passport = vRP.Passport(nsource)
            local Plate = "VEH" .. tostring(10000 + Passport)
            
            local Exist, Network, Vehicle = ServerVehDiscord(VehicleName, Coords.x, Coords.y, Coords.z, Heading, Plate, 2000, nil, 1000)

            if not Exist then
                print("Não foi possível criar o veículo.")
                return
            end
            
            vRPclient.spawnVehicle(nsource, VehicleName, Network, 1000, 1000, nil, false, false)
            Spawn[Plate] = { Passport, VehicleName, Network }
            TriggerEvent("engine:tryFuel", Plate, 100)
            SetPedIntoVehicle(Ped, Vehicle, -1)

            local Plates = GlobalState["Plates"] or {}
            Plates[Plate] = Passport
            GlobalState:set("Plates", Plates, true)

            TriggerClientEvent("Notify", nsource, "verde", "Você recebeu um veículo " .. VehicleName .. " através do Discord.",7500)
        else
            print("ID do jogador inválido.")
        end
    else
        TriggerClientEvent("chat:addMessage", source, { args = { "Sistema", "Este comando só pode ser usado pelo servidor." } })
    end
end)


RegisterCommand("fixdiscord",function(source,args,rawCmd)
    if source == 0 then -- Verifica se o comando está sendo executado pelo console
        local nsource = vRP.Source(tonumber(args[1])) -- Obtém a source do jogador pelo ID passado no argumento
        if nsource then
            local user_id = vRP.Passport(nsource)
            local vehicle, network, plate = vRPclient.VehicleList(nsource, 4) -- Obtém o veículo mais próximo do jogador

            if vehicle then
                TriggerClientEvent("inventory:repairAdmin", nsource, network, plate) -- Envia evento de reparo para o cliente
                TriggerClientEvent("Notify", nsource, "amarelo", "Você recebeu um reparo no veículo através do Discord.",5000)
                print("^5[ ^3+ ^5] SHAKTAR BOT > ^7O jogador ^5(" .. user_id .. ") ^7recebeu FIX!") -- Loga no console que o jogador recebeu o reparo
            else
                print("Nenhum veículo encontrado próximo do jogador.")
            end
        else
            print("Jogador não encontrado.")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('deletevdiscord', function(source,args,rawCommand)
    if source == 0 then
        local nsource = vRP.Source(parseInt(args[1]))
        local vehicle, network, plate = vRPclient.VehicleList(nsource, 4)
        if vehicle then
            TriggerClientEvent("garages:Delete",nsource)
            TriggerClientEvent("Notify",nsource,"amarelo","Seu veículo foi deletado atraves do discord.",5000)
        end
        return;
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVE ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('itemdiscord', function(source,args,rawCommand)
    if source == 0 then
        local nsource = vRP.Source(parseInt(args[1]))
        if nsource then
            vRP.GenerateItem(parseInt(args[1]), args[2], parseInt(args[3]),true)
            TriggerClientEvent("Notify",nsource,"verde","Você recebeu " .. args[3] .. " " .. args[2] .. "(s) atraves do discord.",7500)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Plates"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function ServerVehDiscord(Model,x,y,z,Heading,Plate,Nitrox,Doors,Body,Fuel)
	local Vehicle = CreateVehicle(Model,x,y,z,Heading,true,true)

	while not DoesEntityExist(Vehicle) do
		Wait(100)
	end

	if DoesEntityExist(Vehicle) then
		if Plate ~= nil then
			SetVehicleNumberPlateText(Vehicle,Plate)
		else
			Plate = vRP.GeneratePlate()
			SetVehicleNumberPlateText(Vehicle,Plate)
		end

		SetVehicleBodyHealth(Vehicle,Body + 0.0)

		if not Fuel then
			TriggerEvent("engine:tryFuel",Plate,100)
		end

		if Doors then
			local Doors = json.decode(Doors)
			if Doors ~= nil then
				for Number,Status in pairs(Doors) do
					if Status then
						SetVehicleDoorBroken(Vehicle,parseInt(Number),true)
					end
				end
			end
		end

		local Network = NetworkGetNetworkIdFromEntity(Vehicle)

		if Model ~= "wheelchair" then
			local Network = NetworkGetEntityFromNetworkId(Network)
			SetVehicleDoorsLocked(Network,2)

			local Nitro = GlobalState["Nitro"]
			Nitro[Plate] = Nitrox or 0
			GlobalState:set("Nitro",Nitro,true)
		end

		return true,Network,Vehicle
	end

	return false
end