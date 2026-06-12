-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("inventory")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMAÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local animacoes = {
    ["aitomatoma@animation"] = { dict = "aitomatoma@animation", anim = "animation", walk = false, loop = false },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMOTES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("emotes")
AddEventHandler("emotes",function(Name)
	local Ped = PlayerPedId()
	if animacoes[Name] and not IsPedArmed(Ped,7) and not IsPedSwimming(Ped) and GetEntityHealth(Ped) > 100 and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Buttons"] and not LocalPlayer["state"]["Cancel"] and not LocalPlayer["state"]["Handcuff"] then
		if not IsPedInAnyVehicle(Ped) and not animacoes[Name]["cars"] then
			if animacoes[Name]["altura"] and not animacoes[Name]["anim"] then
				vRP.CreateObjects("","",animacoes[Name]["prop"],animacoes[Name]["flag"],animacoes[Name]["mao"],animacoes[Name]["altura"],animacoes[Name]["pos1"],animacoes[Name]["pos2"],animacoes[Name]["pos3"],animacoes[Name]["pos4"],animacoes[Name]["pos5"])
			elseif animacoes[Name]["altura"] and animacoes[Name]["anim"] then
				vRP.CreateObjects(animacoes[Name]["dict"],animacoes[Name]["anim"],animacoes[Name]["prop"],animacoes[Name]["flag"],animacoes[Name]["mao"],animacoes[Name]["altura"],animacoes[Name]["pos1"],animacoes[Name]["pos2"],animacoes[Name]["pos3"],animacoes[Name]["pos4"],animacoes[Name]["pos5"])
			elseif animacoes[Name]["prop"] then
				vRP.CreateObjects(animacoes[Name]["dict"],animacoes[Name]["anim"],animacoes[Name]["prop"],animacoes[Name]["flag"],animacoes[Name]["mao"])
			elseif animacoes[Name]["dict"] then
				vRP.playAnim(animacoes[Name]["walk"],{animacoes[Name]["dict"],animacoes[Name]["anim"]},animacoes[Name]["loop"])
			else
				vRP.playAnim(false,{ task = animacoes[Name]["anim"] },false)
			end
		else
			if IsPedInAnyVehicle(Ped) and animacoes[Name]["cars"] then
				local Vehicle = GetVehiclePedIsUsing(Ped)

				if (GetPedInVehicleSeat(Vehicle,-1) == Ped or GetPedInVehicleSeat(Vehicle,1) == Ped) and Name == "sexo4" then
					vRP.playAnim(animacoes[Name]["walk"],{animacoes[Name]["dict"],animacoes[Name]["anim"]},animacoes[Name]["loop"])
				elseif (GetPedInVehicleSeat(Vehicle,0) == Ped or GetPedInVehicleSeat(Vehicle,2) == Ped) and (Name == "sexo5" or Name == "sexo6") then
					vRP.playAnim(animacoes[Name]["walk"],{animacoes[Name]["dict"],animacoes[Name]["anim"]},animacoes[Name]["loop"])
				elseif Name == "hotwired" then
					vRP.playAnim(animacoes[Name]["walk"],{animacoes[Name]["dict"],animacoes[Name]["anim"]},animacoes[Name]["loop"])
				end
			end
		end
	end
end)



-----------------------------------------------------------------------------------------------------------------------------------------
-- EMOTES
-----------------------------------------------------------------------------------------------------------------------------------------
local inEmote = false

RegisterNetEvent("emotes")
AddEventHandler("emotes",function(Name)
	local Ped = PlayerPedId()

	vRP.DeletarObjeto()
	inEmote = false

	if LocalPlayer["state"]["PlayerJogando"] and animacoes[Name] and not IsPedArmed(Ped, 7) and not IsPedSwimming(Ped) and GetEntityHealth(Ped) >= 102 and not LocalPlayer["state"]["Buttons"] then
		if not IsPedInAnyVehicle(Ped) and not animacoes[Name]["cars"] then
			if animacoes[Name]["altura"] and not animacoes[Name]["anim"] then
				vRP.CriarObjeto("","",animacoes[Name]["prop"],animacoes[Name]["flag"],animacoes[Name]["mao"],animacoes[Name]["altura"],animacoes[Name]["pos1"],animacoes[Name]["pos2"],animacoes[Name]["pos3"],animacoes[Name]["pos4"],animacoes[Name]["pos5"])
			elseif animacoes[Name]["altura"] and animacoes[Name]["anim"] then
				vRP.CriarObjeto(animacoes[Name]["dict"],animacoes[Name]["anim"],animacoes[Name]["prop"],animacoes[Name]["flag"],animacoes[Name]["mao"],animacoes[Name]["altura"],animacoes[Name]["pos1"],animacoes[Name]["pos2"],animacoes[Name]["pos3"],animacoes[Name]["pos4"],animacoes[Name]["pos5"])
			elseif animacoes[Name]["prop"] then
				vRP.CriarObjeto(animacoes[Name]["dict"],animacoes[Name]["anim"],animacoes[Name]["prop"],animacoes[Name]["flag"],animacoes[Name]["mao"])
			elseif animacoes[Name]["dict"] then
				vRP.PlayAnim(animacoes[Name]["walk"],{animacoes[Name]["dict"],animacoes[Name]["anim"]},animacoes[Name]["loop"])
			else
				vRP.PlayAnim(false,{ task = animacoes[Name]["anim"] },false)
			end

			inEmote = true
		else
			if IsPedInAnyVehicle(Ped) and animacoes[Name]["cars"] then
				local Vehicle = GetVehiclePedIsUsing(Ped)
				if (GetPedInVehicleSeat(Vehicle,-1) == Ped or GetPedInVehicleSeat(Vehicle,1) == Ped) and Name == "sexo4" then
					vRP.PlayAnim(animacoes[Name]["walk"],{animacoes[Name]["dict"],animacoes[Name]["anim"]},animacoes[Name]["loop"])
				elseif (GetPedInVehicleSeat(Vehicle,0) == Ped or GetPedInVehicleSeat(Vehicle,2) == Ped) and (Name == "sexo5" or Name == "sexo6") then
					vRP.PlayAnim(animacoes[Name]["walk"],{animacoes[Name]["dict"],animacoes[Name]["anim"]},animacoes[Name]["loop"])
				elseif Name == "hotwired" then
					vRP.PlayAnim(animacoes[Name]["walk"],{animacoes[Name]["dict"],animacoes[Name]["anim"]},animacoes[Name]["loop"])
				end

				inEmote = true
			end
		end
	end
end)