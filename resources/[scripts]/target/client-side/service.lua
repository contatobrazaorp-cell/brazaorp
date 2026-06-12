-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Services = {
	{
		Permission = "Policia",
		Coords = vec3(453.03, -980.09, 30.69),
		Distance = 1.5,
		Weight = 0.8
	},
	{
		Permission = "HOSPITAL",
		Coords = vec3(-2784.81, -78.71, 18.6),
		Distance = 1.5,
		Weight = 1.6
	},
	{
		Permission = "PHZ",
		Coords = vec3(-2281.19, 314.89, 174.65),
		Distance = 3.0,
		Weight = 0.6
	},
	{
		Permission = "EXERCITO",
		Coords = vec3(-2208.84, 3316.33, 34.71),
		Distance = 1.5,
		Weight = 1.6
	},
	-- JURIDICO
	{
		Permission = "JURIDICO",
		Coords = vec3(-434.78, 1097.75, 329.77),
		Distance = 1.5,
		Weight = 0.8
	},
	-- TATICA
	{
		Permission = "TATICA",
		Coords = vec3(2505.66, -352.99, 94.09),
		Distance = 1.5,
		Weight = 0.8
	}
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIANTS
-----------------------------------------------------------------------------------------------------------------------------------------
local Variants = {
	LSPD = "Policia",
	SAPR = "Policia",
	BCSO = "Policia"
	-- Se houver subgrupos da TATICA (ex: TATICAlider, TATICASoldado), adicione:
	-- TATICAlider = "TATICA",
	-- TATICASoldado = "TATICA"
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	print("SERVICE THREAD INICIADA")

	for idx, v in ipairs(Services) do
		print("CRIANDO ZONA:", idx, v.Permission)

		local zoneName = "Service:"..tostring(idx)

		exports.target:AddCircleZone(zoneName, v.Coords, v.Weight, {
			name = zoneName,
			heading = 0.0,
			useZ = true
		}, {
			Distance = v.Distance,
			options = {
				{
					event = "target:Service",
					label = "Iniciar Expediente",
					service = v.Permission,
					tunnel = "proserver"
				}
			}
		})
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:CLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Client")
AddEventHandler("service:Client", function(Permission, Status)
	for idx, v in ipairs(Services) do
		if (Variants[Permission] and Variants[Permission] == v.Permission) or Permission == v.Permission then
			exports.target:LabelText("Service:"..tostring(idx), (Status and "Finalizar Expediente" or "Iniciar Expediente"))
		end
	end
end)