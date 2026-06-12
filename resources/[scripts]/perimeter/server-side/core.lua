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
vKEYBOARD = Tunnel.getInterface("keyboard")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Perimeters = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERIMETERS (CLIENT PEGA LISTA)
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Perimeters()
	return Perimeters
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERIMETER:NEW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("perimeter:New")
AddEventHandler("perimeter:New",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end

	TriggerClientEvent("dynamic:Close",source)

	-- PEGA COORDENADAS E CONVERTE PARA TABLE
	local coords = vRP.GetEntityCoords(source)
	local Coords = {
		x = coords.x + 0.0,
		y = coords.y + 0.0,
		z = coords.z + 0.0
	}

	-- ABRE TECLADO
	local Keyboard = vKEYBOARD.Secondary(source,"Nome","Distancia")
	if not Keyboard then return end

	-- GERA ID ÚNICO
	local Selected
	repeat
		Selected = GenerateString("DDLLDDLL")
	until Selected and not Perimeters[Selected]

	-- LIMPA DISTÂNCIA (ACEITA 100, 100m, 100,0 ETC)
	local raw = tostring(Keyboard[2] or "")
	raw = raw:gsub(",", ".")
	raw = raw:gsub("[^%d%.]", "")
	local dist = tonumber(raw) or 0
	if dist < 5 then dist = 5 end

	Perimeters[Selected] = {
		Name = tostring(Keyboard[1] or "Perímetro"),
		Distance = dist,
		Coords = Coords
	}

	-- ENVIA PARA TODOS OS PLAYERS
	TriggerClientEvent("perimeter:Add",-1,Selected,Perimeters[Selected])

	-- LOG DISCORD
	if exports.discord then
		exports.discord:Embed("Perimeter",
			"**[PASSAPORTE]:** "..Passport..
			"\n**[NOME]:** "..Perimeters[Selected].Name..
			"\n**[RAIO]:** "..dist..
			"\n**[COORDS]:** "..Coords.x..","..Coords.y..","..Coords.z
		)
	end

	-- NOTIFICA TODOS (MELHORADO)
	TriggerClientEvent("Notify",-1,"🚨 PERÍMETRO FECHADO",
		"O perímetro <b>"..Perimeters[Selected].Name.."</b> foi oficialmente isolado pelas autoridades.\n\n"..
		"Pedimos que todos evitem a área e utilizem rotas alternativas até nova liberação.\n\n"..
		"Agradecemos a colaboração de todos.",
		"policia",30000
	)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERIMETER:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("perimeter:Remove")
AddEventHandler("perimeter:Remove",function(Selected)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end
	if not Perimeters[Selected] then return end

	-- NOTIFICA TODOS (MELHORADO)
	TriggerClientEvent("Notify",-1,"✅ PERÍMETRO LIBERADO",
		"O perímetro <b>"..Perimeters[Selected].Name.."</b> foi liberado pelas autoridades.\n\n"..
		"A circulação está normalizada e a área encontra-se segura.\n\n"..
		"Agradecemos a compreensão e colaboração da população.",
		"policia",30000
	)

	TriggerClientEvent("perimeter:Remove",-1,Selected)
	TriggerClientEvent("dynamic:Close",source)
	Perimeters[Selected] = nil
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SINCRONIZA QUANDO PLAYER ENTRA
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("perimeter:List",source,Perimeters)
end)