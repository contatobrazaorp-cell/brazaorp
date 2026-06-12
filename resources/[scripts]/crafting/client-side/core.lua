-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("crafting")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Opened = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	Opened = false
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
function OpenCrafting(Mode)
	Opened = Mode

	TriggerEvent("inventory:Open",{
		Mode = "Buy",
		Type = "Shops",
		Right = "Produção",
		Resource = "crafting"
	})
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Mount",function(Data,Callback)
	local Primary,PrimaryWeight = vSERVER.Mount(Opened)
	if Primary then
		Callback({
			Primary = Primary,
			Secondary = ItemList[Opened],
			PrimaryMaxWeight = PrimaryWeight,
			SecondarySlots = math.max(CountTable(ItemList[Opened]),25)
		})
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Take(Data.item,Data.amount,Data.target,Opened)
	end

	Callback("Ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTING:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("crafting:Open",function(Number)
	if exports.hud:Wanted() then
		return false
	end

	local Data = Location[Number]
	if Data then
		if vSERVER.Permission(Data.Mode) then
			OpenCrafting(Data.Mode)
		end
	else
		if vSERVER.Permission(Number) then
			OpenCrafting(Number)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TOVEC3
-----------------------------------------------------------------------------------------------------------------------------------------
local function ToVec3(c)
	if not c then
		return nil
	end

	-- caso já seja vector3
	if type(c) == "vector3" then
		return c
	end

	-- caso seja tabela
	if type(c) == "table" then
		local x = c.x or c[1]
		local y = c.y or c[2]
		local z = c.z or c[3]

		if x and y and z then
			return vector3(x + 0.0,y + 0.0,z + 0.0)
		end
	end

	return nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 1000
		local Ped = PlayerPedId()

		if DoesEntityExist(Ped) then
			local Coords = GetEntityCoords(Ped)

			if Location and next(Location) then
				for Number,v in pairs(Location) do
					local loc = v and ToVec3(v.Coords)

					if loc then
						local Distance = #(Coords - loc)

						if Distance <= 10.0 then
							TimeDistance = 1

							local Size = (v.Circle and tonumber(v.Circle)) or 0.30

							DrawMarker(
								2,
								loc.x, loc.y, loc.z + 0.05,
								0.0, 0.0, 0.0,
								0.0, 0.0, 0.0,
								Size, Size, Size,
								0, 150, 255, 180,
								false, false, 2,
								false, nil, nil, false
							)

							if Distance <= 2.0 then
								DrawText3D(loc.x, loc.y, loc.z + 0.20, "~b~E~w~  Abrir")

								if IsControlJustPressed(0,38) then
									if v.Perm and vSERVER and vSERVER.HasPermission then
										if not vSERVER.HasPermission(v.Perm) then
											TriggerEvent("Notify","vermelho","Você não tem permissão para usar este crafting.",5000)
										else
											TriggerEvent("crafting:Open",Number)
										end
									else
										TriggerEvent("crafting:Open",Number)
									end
								end
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)

	if onScreen then
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255,255,255,215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end