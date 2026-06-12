-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("bank")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATION
-----------------------------------------------------------------------------------------------------------------------------------------
local Location = {
	vec3(149.64,-1041.36,29.59),
	vec3(313.95,-279.74,54.39),
	vec3(-351.2,-50.57,49.26),
	vec3(-2961.85,482.87,15.92),
	vec3(1175.09,2707.53,38.31),
	vec3(-1212.37,-331.37,38.0),
	vec3(-112.86,6470.46,31.85)
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- (REMOVIDO) TARGET ZONES
-- Comentado para não abrir por ALT/target, e sim por BLIP + MARKER no chão
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	for Number,v in pairs(Location) do
-- 		exports.target:AddCircleZone("Bank:"..Number,v,0.1,{
-- 			name = "Bank:"..Number,
-- 			heading = 0.0,
-- 			useZ = true
-- 		},{
-- 			Distance = 1.75,
-- 			options = {
-- 				{
-- 					event = "Bank",
-- 					label = "Abrir",
-- 					tunnel = "client"
-- 				}
-- 			}
-- 		})
-- 	end
-- end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS (MAPA)
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for _,v in pairs(Location) do
		local blip = AddBlipForCoord(v.x,v.y,v.z)
		SetBlipSprite(blip,108) -- Banco
		SetBlipDisplay(blip,4)
		SetBlipScale(blip,0.75)
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,2)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Banco")
		EndTextCommandSetBlipName(blip)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAW TEXT (SIMPLES)
-----------------------------------------------------------------------------------------------------------------------------------------
local function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	if onScreen then
		SetTextFont(4)
		SetTextScale(0.35,0.35)
		SetTextColour(255,255,255,200)
		SetTextCentre(true)
		SetTextOutline()
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandDisplayText(_x,_y)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKER NO CHÃO + E PARA ABRIR
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local time = 1000
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for _,v in pairs(Location) do
			local dist = #(coords - v)

			if dist <= 15.0 then
				time = 0

				-- Marker no chão
				DrawMarker(
					23, v.x, v.y, v.z - 0.95,
					0.0, 0.0, 0.0,
					0.0, 0.0, 0.0,
					0.75, 0.75, 0.75,
					0, 150, 255, 150,
					false, false, 2, false, nil, nil, false
				)

				if dist <= 1.5 then
					-- Texto flutuante
					DrawText3D(v.x, v.y, v.z + 0.15, "Pressione ~b~E~w~ para abrir o ~b~Banco~w~")

					-- Tecla E
					if IsControlJustPressed(0,38) then
						TriggerEvent("Bank")
					end
				end
			end
		end

		Wait(time)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Bank",function()
    local ok, wanted = pcall(function()
        return exports.hud:Wanted()
    end)

    -- Se a hud não existir/der erro, deixa abrir mesmo assim
    if ok and wanted then
        return
    end

    SetNuiFocus(true,true)
    TransitionToBlurred(1000)
    TriggerEvent("hud:Active",false)
    SendNUIMessage({ Action = "Open", name = LocalPlayer["state"]["Name"] })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SetNuiFocus(false,false)
	TransitionFromBlurred(1000)
	TriggerEvent("hud:Active",true)
	SendNUIMessage({ Action = "Hide" })

	Callback(true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Home",function(Data,Callback)
	Callback(vSERVER.Home())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Deposit",function(Data,Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.Deposit(Data["value"]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Withdraw",function(Data,Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.Withdraw(Data["value"]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDDEPENDENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("AddDependents",function(Data,Callback)
	if Data["passport"] then
		Callback(vSERVER.AddDependents(Data["passport"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEDEPENDENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RemoveDependents",function(Data,Callback)
	Callback(vSERVER.RemoveDependents(Data["passport"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTMENTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Investments",function(Data,Callback)
	Callback(vSERVER.Investments())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Invest",function(Data,Callback)
	if Data["value"] and MumbleIsConnected() then
		Callback(vSERVER.Invest(Data["value"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVESTRESCUE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("InvestRescue",function(Data,Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.InvestRescue())
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSACTIONHISTORY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("TransactionHistory",function(Data,Callback)
	Callback(vSERVER.TransactionHistory())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEINVOICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("MakeInvoice",function(Data,Callback)
	if Data["passport"] and Data["value"] and Data["reason"] and MumbleIsConnected() then
		Callback(vSERVER.MakeInvoice(Data["passport"],Data["value"],Data["reason"]))
	else
		Callback(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICEPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("InvoicePayment",function(Data,Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.InvoicePayment(Data["id"]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICELIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("InvoiceList",function(Data,Callback)
	Callback(vSERVER.InvoiceList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINELIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("FineList",function(Data,Callback)
	Callback(vSERVER.FineList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINEPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("FinePayment",function(Data,Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.FinePayment(Data["id"]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINEPAYMENTALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("FinePaymentAll",function(Data,Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.FinePaymentAll())
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Taxes",function(Data,Callback)
	Callback(vSERVER.TaxList())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAXPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("TaxPayment",function(Data,Callback)
	if MumbleIsConnected() then
		Callback(vSERVER.TaxPayment(Data["id"]))
	end
end)
