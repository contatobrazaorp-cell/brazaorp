-----------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMY (SAFE)
-----------------------------------------------------------------------------------------------------------------------------------------
Config = Config or {}

-- ✅ Nunca deixa nil
local AcademyTable = Academy or Config.Academy or {}

CreateThread(function()
	for Index, v in pairs(AcademyTable) do
		exports.target:AddCircleZone("Academy:"..Index, v["Target"], 0.15, {
			name = "Academy:"..Index,
			heading = 0.5,
			useZ = true
		}, {
			shop = Index,
			Distance = 1.75,
			options = {
				{
					event = "target:Academy",
					label = "Exercitar",
					tunnel = "client"
				}
			}
		})
	end
end)

AddEventHandler("target:Academy", function(Number)
	if AcademyTable[Number] and not GlobalState["Academy-"..Number] and not exports["horizonte_phone"]:IsOpen() then
		local Ped = PlayerPedId()

		SetEntityHeading(Ped, AcademyTable[Number]["Coords"]["w"])
		SetEntityCoords(Ped, AcademyTable[Number]["Coords"]["xyz"])
		TriggerEvent("emotes", AcademyTable[Number]["Anim"])

		if vSERVER and vSERVER.Academy and vSERVER.Academy(Number) then
			TriggerEvent("Progress", "Malhando", 30000)

			SetTimeout(30000, function()
				if vSERVER and vSERVER.AcademyWeight then
					vSERVER.AcademyWeight(Number)
				end
				if vRP and vRP.Destroy then
					vRP.Destroy()
				end
			end)
		end
	end
end)