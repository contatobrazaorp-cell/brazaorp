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
Tunnel.bindInterface("perimeter",Creative)
vSERVER = Tunnel.getInterface("perimeter")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Perimeter = {}
local Blips = {}
local Inside = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPERS (dynamic compat)
-----------------------------------------------------------------------------------------------------------------------------------------
local function dynAddMenu(title, desc, menuId)
	if GetResourceState("dynamic") ~= "started" then return false end
	return pcall(function()
		exports["dynamic"]:AddMenu(title, desc, menuId)
	end)
end

local function dynAddButton(title, desc, eventName, param, menuId)
	if GetResourceState("dynamic") ~= "started" then return false end

	-- Existem bases que mudam a ordem/assinatura do AddButton.
	-- Vamos tentar as formas mais comuns sem quebrar o script.
	local ok = pcall(function()
		-- Forma comum (Creative): title, desc, event, param, menuId, close, server
		exports["dynamic"]:AddButton(title, desc, eventName, param or "", menuId, true, true)
	end)
	if ok then return true end

	ok = pcall(function()
		-- Outra forma: title, desc, event, param, menuId, server
		exports["dynamic"]:AddButton(title, desc, eventName, param or "", menuId, true)
	end)
	if ok then return true end

	ok = pcall(function()
		-- Outra forma: title, desc, event, param, close, server, menuId
		exports["dynamic"]:AddButton(title, desc, eventName, param or "", true, true, menuId)
	end)
	return ok
end

local function dynOpen()
	if GetResourceState("dynamic") ~= "started" then return false end
	return pcall(function()
		exports["dynamic"]:Open()
	end)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO CRIAR BLIP
-----------------------------------------------------------------------------------------------------------------------------------------
local function CreatePerimeterBlip(id, data)
	if not data or not data.Coords then return end

	if Blips[id] then
		RemoveBlip(Blips[id])
		Blips[id] = nil
	end

	local radius = tonumber(data.Distance) or 100
	if radius < 5 then radius = 5 end

	Blips[id] = AddBlipForRadius(
		(data.Coords.x or 0) + 0.0,
		(data.Coords.y or 0) + 0.0,
		(data.Coords.z or 0) + 0.0,
		radius + 0.0
	)

	SetBlipColour(Blips[id], 1) -- vermelho
	SetBlipAlpha(Blips[id], 180)
	SetBlipAsShortRange(Blips[id], false)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERIMETER:LIST (quando entra no servidor)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("perimeter:List")
AddEventHandler("perimeter:List", function(Table)
	Perimeter = Table or {}
	for k,v in pairs(Perimeter) do
		CreatePerimeterBlip(k,v)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERIMETER:ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("perimeter:Add")
AddEventHandler("perimeter:Add", function(Selected, Table)
	Perimeter[Selected] = Table
	CreatePerimeterBlip(Selected, Table)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERIMETER:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("perimeter:Remove")
AddEventHandler("perimeter:Remove", function(Selected)
	if Blips[Selected] then
		RemoveBlip(Blips[Selected])
		Blips[Selected] = nil
	end
	Perimeter[Selected] = nil
	if Inside == Selected then
		Inside = false
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFICAR ENTRADA / SAÍDA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 1000
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k,v in pairs(Perimeter) do
			if v and v.Coords then
				local center = vector3(v.Coords.x, v.Coords.y, v.Coords.z)
				local radius = tonumber(v.Distance) or 0
				local distance = #(coords - center)

				-- ENTROU NO PERÍMETRO
				if radius > 0 and distance <= radius and Inside ~= k then
					Inside = k

					TriggerEvent("Notify","🚨 ÁREA ISOLADA",
						"Você entrou no perímetro <b>"..tostring(v.Name).."</b>.\n\n"..
						"Esta região está <b>restrita</b> e sob operação das autoridades.\n"..
						"Evite permanecer no local e utilize rotas alternativas.",
						"amarelo",7000
					)

					timeDistance = 200

				-- SAIU DO PERÍMETRO
				elseif Inside == k and distance > radius then
					TriggerEvent("Notify","✅ FORA DA ÁREA",
						"Você saiu do perímetro <b>"..tostring(v.Name).."</b>.\n\n"..
						"A circulação está liberada fora da zona isolada.",
						"verde",5000
					)

					Inside = false
					timeDistance = 200
				end
			end
		end

		Wait(timeDistance)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDO: /perimetro (ABRE MENU)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("perimetro", function()
	if GetResourceState("dynamic") ~= "started" then
		TriggerEvent("Notify","negado","Dynamic não está iniciado.",5000)
		return
	end

	-- Monta o menu
	local okMenu = dynAddMenu("Perímetro","Funções do perímetro policial.","perimeter_menu")
	if not okMenu then
		TriggerEvent("Notify","negado","Não consegui criar menu no Dynamic (AddMenu).",5000)
		return
	end

	dynAddButton("Adicionar","Criar um perímetro na sua posição.","perimeter:New","", "perimeter_menu")

	-- Puxa lista do server e cria botões de remover
	local list = vSERVER.Perimeters() or {}
	for Selected,Table in pairs(list) do
		dynAddButton("Remover: "..tostring(Table.Name),"Remover este perímetro.","perimeter:Remove", Selected, "perimeter_menu")
	end

	-- Abre o menu
	local okOpen = dynOpen()
	if not okOpen then
		TriggerEvent("Notify","negado","Não consegui abrir o Dynamic (Open).",5000)
	end
end)