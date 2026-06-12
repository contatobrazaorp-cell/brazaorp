-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("chest")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Block = false
local Opened = false
local Animation = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTS
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTS
-----------------------------------------------------------------------------------------------------------------------------------------
local Chests = {

    -- =========================
    -- IRLANDA
    -- =========================
    { Name = "IRLANDA", Coords = vec3(1934.23,712.33,194.38), Mode = "2" },
    { Name = "IRLANDALider", Coords = vec3(1932.12,704.62,194.38), Mode = "2" },

    -- =========================
    -- GROTA
    -- =========================
    { Name = "GROTA", Coords = vec3(1229.68,-260.91,76.36), Mode = "2" },
    { Name = "GROTALider", Coords = vec3(1235.62,-250.52,76.36), Mode = "2" },

    -- =========================
    -- VATICANO
    -- =========================
    { Name = "VATICANO", Coords = vec3(168.02,641.73,207.44), Mode = "2" },
    { Name = "VATICANOLider", Coords = vec3(174.12,636.08,207.44), Mode = "2" },

    -- =========================
    -- EGITO
    -- =========================
    { Name = "EGITO", Coords = vec3(1323.29,-782.26,79.09), Mode = "2" },
    { Name = "EGITOLider", Coords = vec3(1317.04,-787.38,79.09), Mode = "2" },

    -- =========================
    -- CARTEL
    -- =========================
    { Name = "CARTEL", Coords = vec3(1395.04,1135.46,109.74), Mode = "2" },
    { Name = "CARTELLider", Coords = vec3(1401.38,1139.27,109.74), Mode = "2" },

    -- =========================
    -- ROXOS
    -- =========================
    { Name = "ROXOS", Coords = vec3(806.6,1835.71,138.98), Mode = "2" },
    { Name = "ROXOSLider", Coords = vec3(798.49,1835.79,138.98), Mode = "2" },

    -- =========================
    -- HELIPA
    -- =========================
    { Name = "HELIPA", Coords = vec3(-2960.75,2170.53,41.89), Mode = "2" },
    { Name = "HELIPALider", Coords = vec3(-2971.56,2155.72,41.89), Mode = "2" },

    -- =========================
    -- FRANCA
    -- =========================
    { Name = "FRANCA", Coords = vec3(-3360.54,1797.28,26.13), Mode = "2" },
    { Name = "FRANCALider", Coords = vec3(-3350.37,1788.55,26.13), Mode = "2" },

    -- =========================
    -- ELEMENTS
    -- =========================
    { Name = "ELEMENTS", Coords = vec3(-3135.3,1402.91,24.75), Mode = "2" },
    { Name = "ELEMENTSLider", Coords = vec3(-3138.13,1394.06,24.75), Mode = "2" },

    -- =========================
    -- ESCOCIA
    -- =========================
    { Name = "ESCOCIA", Coords = vec3(-1181.49,-1750.87,8.53), Mode = "2" },
    { Name = "ESCOCIALider", Coords = vec3(-1182.05,-1743.15,8.53), Mode = "2" },

    -- =========================
    -- TEQUILA
    -- =========================
    { Name = "TEQUILA", Coords = vec3(-571.97,286.13,79.18), Mode = "2" },
    { Name = "TEQUILALider", Coords = vec3(-572.98,286.22,79.18), Mode = "2" },

    -- =========================
    -- MEDELLIN
    -- =========================
    { Name = "MEDELLIN", Coords = vec3(-1491.79,840.26,183.49), Mode = "2" },
    { Name = "MEDELLINLider", Coords = vec3(-1494.89,838.91,183.49), Mode = "2" },

    -- =========================
    -- JAMAICA
    -- =========================
    { Name = "JAMAICA", Coords = vec3(3737.77,4496.43,27.43), Mode = "2" },
    { Name = "JAMAICALider", Coords = vec3(3746.01,4497.39,27.43), Mode = "2" },

    -- =========================
    -- YAKUZA
    -- =========================
    { Name = "YAKUZA", Coords = vec3(-3355.75,1140.62,9.65), Mode = "2" },
    { Name = "YAKUZALider", Coords = vec3(-3354.13,1146.8,9.65), Mode = "2" },

    -- =========================
    -- ALEMANHA
    -- =========================
    { Name = "ALEMANHA", Coords = vec3(122.09,6732.88,46.44), Mode = "2" },
    { Name = "ALEMANHALider", Coords = vec3(114.16,6731.61,46.44), Mode = "2" },

    -- =========================
    -- PAQUISTAO
    -- =========================
    { Name = "PAQUISTAO", Coords = vec3(1803.88,4524.06,40.39), Mode = "2" },
    { Name = "PAQUISTAOLider", Coords = vec3(1800.2,4517.19,40.39), Mode = "2" },

    -- =========================
    -- MAGNATAS
    -- =========================
    { Name = "MAGNATAS", Coords = vec3(2027.08,3347.54,46.79), Mode = "2" },
    { Name = "MAGNATASLider", Coords = vec3(2029.59,3384.56,46.79), Mode = "2" },

    -- =========================
    -- PSICO
    -- =========================
    { Name = "PSICO", Coords = vec3(1393.92,-2491.1,60.57), Mode = "2" },
    { Name = "PSICOLider", Coords = vec3(1396.13,-2483.61,60.57), Mode = "2" },

    -- =========================
    -- VANILLASUL
    -- =========================
    { Name = "VANILLASUL", Coords = vec3(124.78,-1338.79,29.22), Mode = "2" },
    { Name = "VANILLASULLider", Coords = vec3(132.23,-1330.64,33.55), Mode = "2" },

    -- =========================
    -- RUSSIA
    -- =========================
    { Name = "RUSSIA", Coords = vec3(-2672.84,1333.51,144.25), Mode = "2" },
    { Name = "RUSSIASemAcento", Coords = vec3(-2677.46,1336.11,144.25), Mode = "2" },  -- Líder

    -- =========================
    -- INFINITY
    -- =========================
    { Name = "INFINITY", Coords = vec3(995.81,-1838.79,21.38), Mode = "2" },
    { Name = "INFINITYLider", Coords = vec3(991.34,-1838.37,21.38), Mode = "2" },

    -- =========================
    -- ANONYMOUS
    -- =========================
    { Name = "ANONYMOUS", Coords = vec3(298.42,-2074.93,17.71), Mode = "2" },
    { Name = "ANONYMOUSLider", Coords = vec3(302.81,-2083.59,17.71), Mode = "2" },

    -- =========================
    -- AZTECAS
    -- =========================
    { Name = "Aztecas", Coords = vec3(2552.05,3748.32,62.8), Mode = "2" },
    { Name = "AztecasLider", Coords = vec3(2545.11,3744.57,62.8), Mode = "2" },

    -- =========================
    -- FAZENNDINHA
    -- =========================
    { Name = "FAZENNDINHA", Coords = vec3(2433.91,5039.19,41.05), Mode = "2" },
    { Name = "FAZENNDINHALider", Coords = vec3(2431.49,5036.75,41.05), Mode = "2" },

    -- =========================
    -- BABEL
    -- =========================
    { Name = "BABEL", Coords = vec3(1013.02,-900.42,17.81), Mode = "2" },
    { Name = "BABELLider", Coords = vec3(1012.95,-898.47,17.81), Mode = "2" },

    -- =========================
    -- ABSOLUT
    -- =========================
    { Name = "ABSOLUT", Coords = vec3(753.08,-579.49,33.63), Mode = "2" },
    { Name = "ABSOLUTLider", Coords = vec3(750.82,-582.1,33.63), Mode = "2" },

    -- =========================
    -- GRECIA
    -- =========================
    { Name = "GRECIA", Coords = vec3(1983.09,3837.43,32.12), Mode = "2" },
    { Name = "GRECIALider", Coords = vec3(1974.88,3835.17,32.12), Mode = "2" },

    -- =========================
    -- ITALIA
    -- =========================
    { Name = "ITALIA", Coords = vec3(-297.67,1569.09,360.89), Mode = "2" },
    { Name = "ITALIALider", Coords = vec3(-293.61,1562.34,360.89), Mode = "2" },

    -- =========================
    -- OUTROS (mantidos do original)
    -- =========================
    { Name = "MECANICA", Coords = vec3(-322.35,-149.57,40.34), Mode = "2" },
    { Name = "MECANICALider", Coords = vec3(-333.78,-161.39,40.34), Mode = "2" },
    { Name = "ABUTRES", Coords = vec3(1931.66,705.42,190.52), Mode = "2" },
    { Name = "ABUTRESLider", Coords = vec3(1932.1,704.77,194.38), Mode = "2" },
    { Name = "BAHAMAS", Coords = vec3(-1384.87,-591.95,30.31), Mode = "2" },
    { Name = "BAHAMASLider", Coords = vec3(-1367.45,-625.62,30.31), Mode = "2" },
    { Name = "Policia", Coords = vec3(-2273.48,327.06,174.65), Mode = "1" },
    { Name = "Restaurante", Coords = vec3(-588.34,-1054.47,22.33), Mode = "2" },
    { Name = "EXERCITO", Coords = vec3(-2143.83,3161.74,32.87), Mode = "3" },
    { Name = "SEGURANCA", Coords = vec3(-403.31,1088.63,334.89), Mode = "4" },
    { Name = "LIDERJURIDICO", Coords = vec3(-385.54,1086.0,334.99), Mode = "2" },
    { Name = "JURIDICO", Coords = vec3(-496.7,1085.58,334.94), Mode = "2" },

    -- =========================
    -- TATICA (apenas arsenal, sem baú de inventário)
    -- =========================
    { Name = "TATICA", Coords = vec3(2528.25, -340.28, 101.89), Mode = "6" },        -- Modo 6 = arsenal apenas

    -- =========================
    -- TROPA DO PORTUGA
    -- =========================
    { Name = "TROPA_DO_PORTUGA", Coords = vec3(1465.22,6322.4,31.16), Mode = "2" },
    { Name = "TROPA_DO_PORTUGALider", Coords = vec3(1459.65,6328.05,31.16), Mode = "2" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LABELS
-----------------------------------------------------------------------------------------------------------------------------------------
local Labels = {
	["1"] = {
		{
			event = "police:Armory",
			label = "🔫 Pegar Armamento",
			tunnel = "server"
		},{
			event = "chest:Armour",
			label = "🛡️ Colete Balístico",
			tunnel = "server"
		}
	},
	["2"] = {
		{
			event = "chest:Open",
			label = "Abrir",
			tunnel = "client",
			service = "Normal"
		}
	},
	["3"] = {
		{
			event = "army:Armory",
			label = "🔫 Pegar Armamento (Exército)",
			tunnel = "server"
		},{
			event = "chest:Armour",
			label = "🛡️ Colete Balístico",
			tunnel = "server"
		}
	},
	["4"] = {
		{
			event = "security:Armory",
			label = "🔫 Pegar Armamento (Segurança)",
			tunnel = "server"
		},{
			event = "chest:Armour",
			label = "🛡️ Colete Balístico",
			tunnel = "server"
		}
	},
	-- NOVO MODO: Arsenal TATICA (apenas entrega de armas, sem inventário)
	["6"] = {
		{
			event = "tatica:Armory",
			label = "🔫 Pegar Armamento Tático",
			tunnel = "server"
		}
		-- Se quiser adicionar colete futuramente, basta incluir outro item aqui
	}
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for k,v in pairs(Chests) do
		exports["target"]:AddCircleZone("Chest:"..v.Name,v.Coords,0.45,{
			name = "Chest:"..v.Name,
			heading = 0.0,
			useZ = true
		},{
			Distance = 1.5,
			shop = v.Name,
			options = Labels[v.Mode]
		})
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Open")
AddEventHandler("chest:Open",function(Name,Mode,Item,Blocked,Force)
	if vSERVER.Permissions(Name,Mode,Item) and GetEntityHealth(PlayerPedId()) > 100 then

		if Blocked then
			Block = true
		end

		Opened = Name

		Animation = true
		vRP.playAnim(false,{"amb@prop_human_bum_bin@base","base"},true)

		TriggerEvent("inventory:Open",{
			Type = "Chest",
			Resource = "chest",
			Force = Force,
			Right = "Baú"
		})
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function(Force)
	if (not Force and Opened) or (Force and Opened and Opened == Force) then
		if Animation then
			Animation = false
			vRP.Destroy()
		end
		Opened = false
		Block = false
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	Callback(vSERVER.Take(Data.item,Data.slot,Data.amount,Data.target))
end)

RegisterNUICallback("Store",function(Data,Callback)
	Callback(vSERVER.Store(Data.item,Data.slot,Data.amount,Data.target,Block))
end)

RegisterNUICallback("Update",function(Data,Callback)
	Callback(vSERVER.Update(Data.slot,Data.target,Data.amount))
end)

RegisterNUICallback("Mount",function(Data,Callback)
	local Primary,Secondary,PrimaryWeight,SecondaryWeight,Slots = vSERVER.Mount()
	if Primary then
		Callback({
			Primary = Primary,
			Secondary = Secondary,
			PrimaryMaxWeight = PrimaryWeight,
			SecondaryMaxWeight = SecondaryWeight,
			SecondarySlots = Slots
		})
	end
end)