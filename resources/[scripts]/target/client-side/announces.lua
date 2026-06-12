-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCES (SAFE)
-----------------------------------------------------------------------------------------------------------------------------------------
Config = Config or {}

-- Puxa Announces de qualquer lugar comum e garante que nunca seja nil:
-- 1) Announces (global)
-- 2) Config.Announces
-- 3) vazio {}
local AnnouncesTable = Announces or (Config and Config.Announces) or {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number, v in pairs(AnnouncesTable) do
		-- blindagens pra evitar crash se algum announce vier incompleto
		local coords = v.Coords
		local service = v.Service

		if coords then
			exports["target"]:AddCircleZone("Announces:"..Number, coords, 0.45, {
				name = "Announces:"..Number,
				heading = 0.0,
				useZ = true
			}, {
				shop = Number,
				Distance = 1.25,
				options = {
					{
						event = "target:Announces",
						tunnel = "proserver",
						label = "Anúnciar",
						service = service
					}
				}
			})
		end
	end
end)