-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("moneywash")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Objects = {}
local MoneyWash = {}

-- Se sua base já define Currency globalmente, isso aqui não atrapalha.
local Currency = Currency or "$"

-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS
-----------------------------------------------------------------------------------------------------------------------------------------
local function LoadModel(Hash)
	if type(Hash) == "string" then
		Hash = GetHashKey(Hash)
	end

	if not IsModelInCdimage(Hash) then
		return false
	end

	RequestModel(Hash)
	local Timeout = 0
	while not HasModelLoaded(Hash) do
		Timeout = Timeout + 1
		if Timeout >= 200 then
			return false
		end
		Wait(10)
	end

	return true
end

local function Dotted(Value)
	Value = tonumber(Value) or 0
	local Str = tostring(math.floor(Value))
	local Result, Count = Str:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
	while Count > 0 do
		Result, Count = Result:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
	end
	return Result
end

local function CompleteTimers(Seconds)
	Seconds = tonumber(Seconds) or 0
	if Seconds < 0 then Seconds = 0 end

	local H = math.floor(Seconds / 3600)
	local M = math.floor((Seconds % 3600) / 60)
	local S = math.floor(Seconds % 60)

	if H > 0 then
		return string.format("%02dh %02dm %02ds", H, M, S)
	elseif M > 0 then
		return string.format("%02dm %02ds", M, S)
	else
		return string.format("%02ds", S)
	end
end

local function TryRemoveZone(Name)
	if exports.target and exports.target.RemCircleZone then
		pcall(function() exports.target:RemCircleZone(Name) end)
		return
	end
	if exports.target and exports.target.RemBoxZone then
		pcall(function() exports.target:RemBoxZone(Name) end)
		return
	end
	if exports.target and exports.target.RemoveZone then
		pcall(function() exports.target:RemoveZone(Name) end)
		return
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999

		if LocalPlayer.state.Active then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)

			for Index,v in pairs(MoneyWash) do
				if v.Route == LocalPlayer.state.Route then
					local OtherCoords = vec3(v.Coords[1],v.Coords[2],v.Coords[3])

					if #(Coords - OtherCoords) <= 50 then
						if not Objects[Index] then
							exports.target:AddBoxZone("MoneyWash:"..Index,vec3(OtherCoords.x,OtherCoords.y,OtherCoords.z + 1.1),1.4,1.4,{
								name = "MoneyWash:"..Index,
								heading = v.Coords[4],
								minZ = OtherCoords.z + 0.0,
								maxZ = OtherCoords.z + 2.25
							},{
								shop = Index,
								Distance = 1.5,
								options = {
									{
										event = "moneywash:Information",
										label = "Informações",
										tunnel = "client"
									}
									-- OPÇÃO "Guardar" FOI REMOVIDA PARA QUE A MÁQUINA FIQUE FIXA NO MAPA
								}
							})

							CreateModels(Index,v.Hash,v.Coords)
							TimeDistance = 100
						else
							local Vehicle = GetVehiclePedIsUsing(Ped)
							if Vehicle ~= 0 then
								SetEntityNoCollisionEntity(Objects[Index],Vehicle,false)
							end
						end
					elseif Objects[Index] then
						ClearObjects(Index)
					end
				elseif Objects[Index] then
					ClearObjects(Index)
				end
			end
		end

		Wait(TimeDistance)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:INFORMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("moneywash:Information",function(Selected)
	local Information = vSERVER.Information(Selected)
	if Information then
		local OsTime = vSERVER.OsTime()

		local Battery = "Coloque uma bateria de 75Ah."
		if Information.Timer and Information.Timer >= OsTime then
			Battery = "Restam "..CompleteTimers(Information.Timer - OsTime).."."
		end

		local Bleach = "Adicione um alvejante."
		if Information.Bleach and Information.Bleach >= OsTime then
			Bleach = "Restam "..CompleteTimers(Information.Bleach - OsTime).."."
		end

		exports.dynamic:AddButton("Compartimento","Primário: <rare>"..Currency..Dotted(Information.Money).."</rare>  /  Secundário: <epic>"..Currency..Dotted(Information.Washed).."</epic>","","",false,false)
		exports.dynamic:AddButton("Primário","Esvaziar compartimento primário.","moneywash:Money",Selected,false,true)
		exports.dynamic:AddButton("Secundário","Esvaziar compartimento secundário.","moneywash:Washed",Selected,false,true)
		exports.dynamic:AddButton("Adicionar","Guardar no compartimento primário.","moneywash:Add",Selected,false,true)
		exports.dynamic:AddButton("Energia",Battery,"moneywash:Battery",Selected,false,true)
		exports.dynamic:AddButton("Alvejante",Bleach,"moneywash:Bleach",Selected,false,true)

		if Information.Passport == LocalPlayer.state.Passport then
			exports.dynamic:AddButton("Senha","Trocar palavra chave.","moneywash:Password",Selected,false,true)
		end

		exports.dynamic:Open()
	else
		-- Se o servidor retornou false, o jogador não tem permissão
		TriggerEvent("Notify", "Aviso", "Você não tem permissão para usar esta máquina.", "vermelho", 5000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MENU EVENTS (CLIENT -> SERVER)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("moneywash:Add")
AddEventHandler("moneywash:Add",function(Selected)
	if Selected then
		vSERVER.Add(Selected)
	end
end)

RegisterNetEvent("moneywash:Money")
AddEventHandler("moneywash:Money",function(Selected)
	if Selected then
		vSERVER.Money(Selected)
	end
end)

RegisterNetEvent("moneywash:Washed")
AddEventHandler("moneywash:Washed",function(Selected)
	if Selected then
		vSERVER.Washed(Selected)
	end
end)

RegisterNetEvent("moneywash:Battery")
AddEventHandler("moneywash:Battery",function(Selected)
	if Selected then
		vSERVER.Battery(Selected)
	end
end)

RegisterNetEvent("moneywash:Bleach")
AddEventHandler("moneywash:Bleach",function(Selected)
	if Selected then
		vSERVER.Bleach(Selected)
	end
end)

RegisterNetEvent("moneywash:Password")
AddEventHandler("moneywash:Password",function(Selected)
	if Selected then
		vSERVER.Password(Selected)
	end
end)

-- esse aqui pode vir pelo target com tunnel="server", mas deixo também pra compatibilidade
RegisterNetEvent("moneywash:StoreObjects")
AddEventHandler("moneywash:StoreObjects",function(Selected)
	if Selected then
		vSERVER.StoreObjects(Selected)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEMODELS
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateModels(Number,Hash,Coords)
	if LoadModel(Hash) then
		Objects[Number] = CreateObjectNoOffset(Hash,Coords[1],Coords[2],Coords[3],false,false,false)

		local Ped = PlayerPedId()
		local Vehicle = GetVehiclePedIsUsing(Ped)
		if Vehicle ~= 0 then
			SetEntityNoCollisionEntity(Objects[Number],Vehicle,false)
		end

		SetEntityHeading(Objects[Number],Coords[4])
		PlaceObjectOnGroundProperly(Objects[Number])
		FreezeEntityPosition(Objects[Number],true)
		SetModelAsNoLongerNeeded(Hash)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("moneywash:Table")
AddEventHandler("moneywash:Table",function(Table)
	MoneyWash = Table or {}
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:NEW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("moneywash:New")
AddEventHandler("moneywash:New",function(Selected,Table)
	MoneyWash[Selected] = Table
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEAROBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function ClearObjects(Index)
	if Objects[Index] then
		if DoesEntityExist(Objects[Index]) then
			DeleteEntity(Objects[Index])
		end

		TryRemoveZone("MoneyWash:"..Index)
		Objects[Index] = nil
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEYWASH:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("moneywash:Remove")
AddEventHandler("moneywash:Remove",function(Selected)
	if MoneyWash[Selected] then
		MoneyWash[Selected] = nil
	end

	ClearObjects(Selected)
end)