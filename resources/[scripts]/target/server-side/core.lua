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
Tunnel.bindInterface("target",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Workout = {}
local Blackout = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE: CLEAN ILLEGAL ITEMS (ENTER/EXIT DUTY)
-----------------------------------------------------------------------------------------------------------------------------------------
local PoliceGroups = { "Policia","LSPD","SAPR","BCSO","PHZ","TATICA" }

local IllegalItems = {
    -- Drogas
    "joint",
    "weedsack",
    "cocaine",
    "cokesack",
    "meth",
    "methsack",
    "crack",
    "heroin",
    "metadone",
    "codeine",
    "amphetamine",

    -- Anexos de armas
    "ATTACH_FLASHLIGHT",
    "ATTACH_CROSSHAIR",
    "ATTACH_SILENCER",
    "ATTACH_MAGAZINE",
    "ATTACH_GRIP",

    -- Armas brancas e corpo a corpo
    "WEAPON_KATANA",
    "WEAPON_HATCHET",
    "WEAPON_BAT",
    "WEAPON_BATTLEAXE",
    "WEAPON_CROWBAR",
    "WEAPON_SWITCHBLADE",
    "WEAPON_GOLFCLUB",
    "WEAPON_HAMMER",
    "WEAPON_MACHETE",
    "WEAPON_POOLCUE",
    "WEAPON_STONE_HATCHET",
    "WEAPON_WRENCH",
    "WEAPON_KNUCKLE",
    "WEAPON_FLASHLIGHT",
    "WEAPON_NIGHTSTICK",
    "WEAPON_PETROLCAN",

    -- Componentes de armas e explosivos
    "gunpowder",
    "pistolbody",
    "smgbody",
    "riflebody",
    "explosives",
    "c4",
    "weaponparts",

    -- Munições
    "WEAPON_RPG_AMMO",
    "WEAPON_PISTOL_AMMO",
    "WEAPON_RIFLE_AMMO",
    "WEAPON_SHOTGUN_AMMO",
    "WEAPON_MUSKET_AMMO",
    "WEAPON_PETROLCAN_AMMO",

    -- Arremessáveis
    "WEAPON_ACIDPACKAGE",
    "WEAPON_BRICK",
    "WEAPON_SNOWBALL",
    "WEAPON_SHOES",
    "WEAPON_MOLOTOV",
    "WEAPON_SMOKEGRENADE",

    -- Armas de fogo
    "WEAPON_STUNGUN",
    "WEAPON_PISTOL",
    "WEAPON_PISTOL_MK2",
    "WEAPON_COMPACTRIFLE",
    "WEAPON_APPISTOL",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_MICROSMG",
    "WEAPON_RPG",
    "WEAPON_MINISMG",
    "WEAPON_SNSPISTOL",
    "WEAPON_SNSPISTOL_MK2",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_PISTOL50",
    "WEAPON_COMBATPISTOL",
    "WEAPON_CARBINERIFLE",
    "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_BULLPUPRIFLE",
    "WEAPON_BULLPUPRIFLE_MK2",
    "WEAPON_SPECIALCARBINE",
    "WEAPON_SPECIALCARBINE_MK2",
    "WEAPON_PUMPSHOTGUN",
    "WEAPON_PUMPSHOTGUN_MK2",
    "WEAPON_MUSKET",
    "WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_SMG",
    "WEAPON_SMG_MK2",
    "WEAPON_TACTICALRIFLE",
    "WEAPON_HEAVYRIFLE",
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_ASSAULTRIFLE_MK2",
    "WEAPON_ASSAULTSMG",
    "WEAPON_GUSENBERG",

    -- Kits e dispositivos
    "gsrkit",
    "gdtkit",
    "dogtag",
    "dismantle",
    "racesticket",
    "blocksignal",
    "ballisticplate",
    "lockpick",
    "handcuff",
    "hood",

    -- Dinheiro e valores
    "dollar",
    "dirtydollar",
    "wetdollar",
    "promissory1000",
    "promissory2000",
    "promissory3000",
    "promissory4000",
    "promissory5000",
    "pager"
}

local IllegalSet = {}
for _,it in pairs(IllegalItems) do IllegalSet[it] = true end

local function IsPoliceService(Passport)
	for _,g in pairs(PoliceGroups) do
		if vRP.HasService(Passport,g) then
			return true, g
		end
	end
	return false, nil
end

local function CleanIllegalItems(Passport)
	local inv = vRP.Inventory(Passport)
	if not inv then return 0 end

	local removedAny = 0
	for _,slotData in pairs(inv) do
		local itemName = slotData.item
		local amount = slotData.amount or 0

		if itemName and amount > 0 then
			-- se o item tiver sufixo (ex: coke-123), usa a base
			local base = SplitOne(itemName) or itemName

			if IllegalSet[itemName] or IllegalSet[base] then
				if vRP.TakeItem(Passport,itemName,amount,true) then
					removedAny = removedAny + 1
				end
			end
		end
	end

	return removedAny
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
for Number,_ in pairs(Academy) do
	GlobalState["Academy-"..Number] = false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Academy(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not GlobalState["Academy-"..Number] and not Workout[Passport] then
		Player(source)["state"]["Buttons"] = true
		Player(source)["state"]["Cancel"] = true
		GlobalState["Academy-"..Number] = true
		Workout[Passport] = Number
		return true
	end

	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMYWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AcademyWeight(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Academy-"..Number] and Workout[Passport] == Number then
		local MaxWeight = 75
		for Permission,Multiplier in pairs({ Ouro = 60, Prata = 40, Bronze = 20 }) do
			if vRP.HasService(Passport,Permission) then
				MaxWeight = MaxWeight + Multiplier
			end
		end

		if vRP.GetWeight(Passport,true) < MaxWeight then
			vRP.UpgradeWeight(Passport,1,"+")
			TriggerClientEvent("Notify",source,"Academia","Sinto minha força alcançando novos patamares, não há limites quando se trata de determinação e dedicação.","verde",5000)
		end

		Player(source)["state"]["Buttons"] = false
		Player(source)["state"]["Cancel"] = false
		GlobalState["Academy-"..Number] = false
		Workout[Passport] = nil
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Workout[Passport] then
		GlobalState["Academy-"..Workout[Passport]] = false
		Workout[Passport] = nil
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckIn()
	local Return = false
	local source = source
	local Alimentation = false
	local Valuation,Repose = 1000,1200
	local Passport = vRP.Passport(source)
	if Passport then
		local MedicPlan = vRP.DatatableInformation(Passport,"MedicPlan")
		if MedicPlan and MedicPlan > os.time() then
			Valuation,Repose = 500,600
		end

		if vRP.Request(source,"Centro Médico","Deseja adicionar o serviço de alimentação pagando <b>$500</b>?") then
			Valuation = Valuation + 500
			Alimentation = true
		end

		if vRP.GetHealth(source) <= 100 then
			Valuation = Valuation + 500
			Repose = Repose + 600
		end

		if vRP.PaymentFull(Passport,Valuation) then
			if Alimentation then
				vRP.UpgradeThirst(Passport,25)
				vRP.UpgradeHunger(Passport,25)
			end

			TriggerEvent("Repose",source,Passport,Repose)
			Return = true
		else
			TriggerClientEvent("Notify",source,"Aviso","Dinheiro insuficiente.","amarelo",5000)
		end
	end

	return Return
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:REPOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Repose")
AddEventHandler("target:Repose",function(OtherSource)
	local source = source
	local Passport = vRP.Passport(source)
	local OtherPassport = vRP.Passport(OtherSource)
	local Keyboard = vKEYBOARD.Primary(source,"Minutos.")
	if Passport and OtherPassport and Keyboard and parseInt(Keyboard[1]) > 0 then
		TriggerClientEvent("Notify",source,"Centro Médico","Adicionou "..Keyboard[1].." minutos de repouso.","sangue",5000)
		TriggerEvent("Repose",OtherSource,OtherPassport,parseInt(Keyboard[1]) * 60)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:SERVICE (ARRUMADO + LIMPA ILEGAIS AO ENTRAR/SAIR)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Service")
AddEventHandler("target:Service",function(Permission)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	-- Estava em serviço de polícia antes?
	local WasOnDuty = IsPoliceService(Passport)

	-- Quando o ponto é "Policia", não dá pra exigir HasGroup("Policia"),
	-- porque geralmente o player tem LSPD/SAPR/BCSO/PHZ e não o grupo "Policia".
	if Permission == "Policia" then
		local Found = false

		for _,v in pairs({ "LSPD","SAPR","BCSO","PHZ" }) do
			-- algumas bases usam HasPermission, outras HasGroup, então aceitamos ambos
			if vRP.HasGroup(Passport,v) or vRP.HasPermission(Passport,v) then
				Permission = v
				Found = true
				break
			end
		end

		if not Found then
			return false
		end
	else
		-- Para pontos diretos (PHZ/Paramedico/etc) exige ter o grupo
		if not vRP.HasGroup(Passport,Permission) then
			return false
		end
	end

	-- Entrando em serviço (antes do toggle)
	if not WasOnDuty then
		local removed = CleanIllegalItems(Passport)
		if removed > 0 then
			TriggerClientEvent("Notify",source,"Polícia","Itens ilegais removidos para iniciar o serviço.","amarelo",5000)
		end
	end

	-- Toggle
	vRP.ServiceToggle(source,Passport,Permission)

	-- Saiu de serviço (após o toggle)
	local IsOnDutyNow = IsPoliceService(Passport)
	if WasOnDuty and not IsOnDutyNow then
		local removed = CleanIllegalItems(Passport)

		-- recomendado: limpar armas ao sair
		if vRP.ClearWeapons then
			vRP.ClearWeapons(source)
		end

		if removed > 0 then
			TriggerClientEvent("Notify",source,"Polícia","Você saiu de serviço e itens ilegais foram removidos.","amarelo",5000)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:BLACKOUT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Blackout")
AddEventHandler("target:Blackout",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Permission = "Policia"
	local IsBlackout = GlobalState.Blackout
	local IsPolice = vRP.HasService(Passport,Permission)

	if (IsPolice and not IsBlackout) or (not IsPolice and IsBlackout) or vRP.AmountService(Permission) < 10 then
		return false
	end

	local Item = "encryptedkey"
	local ConsultItem = vRP.ConsultItem(Passport,Item)
	if not ConsultItem then
		TriggerClientEvent("Notify",source,"Atenção","Você precisa de <b>1x "..ItemName(Item).."</b>.","amarelo",5000)
		return false
	end

	if vRP.TakeItem(Passport,ConsultItem.Item) and vRP.LetterGame(source) then
		IsBlackout = not IsBlackout
		GlobalState.Blackout = IsBlackout

		if IsBlackout then
			Blackout = os.time() + 1800
			TriggerClientEvent("Notify",-1,"Companhia Elétrica","A energia da cidade foi desligada.<br>A iluminação retornará em até <b>30 minutos</b> ou quando a <b>Polícia</b> realizar a religação.","verde",5000)
		else
			Blackout = false
			TriggerClientEvent("Notify",-1,"Companhia Elétrica","A energia da cidade foi restaurada.<br>A iluminação foi normalizada.","verde",5000)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLACKOUT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(10000)

		if GlobalState.Blackout and Blackout and Blackout <= os.time() then
			GlobalState.Blackout = false
			Blackout = false
		end
	end
end)