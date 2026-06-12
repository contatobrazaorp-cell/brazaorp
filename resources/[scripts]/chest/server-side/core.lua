-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("chest",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Open = {}
local Cooldown = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- LEGAL SERVICES (PRECISA BATER PONTO / SERVIÇO)
-----------------------------------------------------------------------------------------------------------------------------------------
local LegalServices = {
	["Policia"] = true,
	["LSPD"] = true,
	["SAPR"] = true,
	["BCSO"] = true,
	["PHZ"] = true,
	["Paramedico"] = true,
	["Mecanica"] = true,
	["EXERCITO"] = true,
	["SEGURANCA"] = true   -- <-- ADICIONADO
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPER: ACCESS CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
local function HasChestAccess(Passport, Permission)
	if not Permission or Permission == "" then
		return false
	end

	-- =============================
	-- SISTEMA POLÍCIA INTELIGENTE
	-- =============================
	if Permission == "Policia" then
		for _,group in pairs({ "LSPD","SAPR","BCSO","PHZ" }) do
			if vRP.HasService(Passport, group) then
				return true
			end
		end
		return false
	end

	-- Se for subgrupo direto
	if LegalServices[Permission] then
		return vRP.HasService(Passport, Permission)
	end

	-- Facções e outros grupos
	if vRP.HasGroup and vRP.HasGroup(Passport, Permission) then
		return true
	end

	if vRP.HasPermission and vRP.HasPermission(Passport, Permission) then
		return true
	end

	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTITENS
-----------------------------------------------------------------------------------------------------------------------------------------
local ChestItens = {
	["personalp"] = {
		Slots = 100,
		Weight = 100,
		Block = true
	},
	["personalm"] = {
		Slots = 100,
		Weight = 250,
		Block = true
	},
	["personalg"] = {
		Slots = 100,
		Weight = 500,
		Block = true
	},
	["chestgroupp"] = {
		Slots = 100,
		Weight = 1000,
		Block = true
	},
	["chestgroupm"] = {
		Slots = 100,
		Weight = 2500,
		Block = true
	},
	["chestgroupg"] = {
		Slots = 100,
		Weight = 5000,
		Block = true
	},
	["suitcase"] = {
		Slots = 25,
		Weight = 10,
		Close = true,
		Itens = {
			["dollar"] = true,
			["dirtydollar"] = true,
			["wetdollar"] = true,
			["promissory"] = true
		}
	},
	["ammobox"] = {
		Slots = 25,
		Weight = 12,
		Close = true,
		Itens = {
			["WEAPON_PISTOL_AMMO"] = true,
			["WEAPON_SMG_AMMO"] = true,
			["WEAPON_RIFLE_AMMO"] = true,
			["WEAPON_SHOTGUN_AMMO"] = true,
			["WEAPON_MUSKET_AMMO"] = true
		}
	},
	["weaponbox"] = {
		Slots = 50,
		Weight = 100,
		Close = true,
		Itens = {
			["WEAPON_STUNGUN"] = true,
			["WEAPON_PISTOL"] = true,
			["WEAPON_PISTOL_MK2"] = true,
			["WEAPON_COMPACTRIFLE"] = true,
			["WEAPON_APPISTOL"] = true,
			["WEAPON_HEAVYPISTOL"] = true,
			["WEAPON_MACHINEPISTOL"] = true,
			["WEAPON_MICROSMG"] = true,
			["WEAPON_RPG"] = true,
			["WEAPON_MINISMG"] = true,
			["WEAPON_SNSPISTOL"] = true,
			["WEAPON_SNSPISTOL_MK2"] = true,
			["WEAPON_VINTAGEPISTOL"] = true,
			["WEAPON_PISTOL50"] = true,
			["WEAPON_COMBATPISTOL"] = true,
			["WEAPON_CARBINERIFLE"] = true,
			["WEAPON_CARBINERIFLE_MK2"] = true,
			["WEAPON_ADVANCEDRIFLE"] = true,
			["WEAPON_BULLPUPRIFLE"] = true,
			["WEAPON_BULLPUPRIFLE_MK2"] = true,
			["WEAPON_SPECIALCARBINE"] = true,
			["WEAPON_SPECIALCARBINE_MK2"] = true,
			["WEAPON_PUMPSHOTGUN"] = true,
			["WEAPON_PUMPSHOTGUN_MK2"] = true,
			["WEAPON_MUSKET"] = true,
			["WEAPON_SAWNOFFSHOTGUN"] = true,
			["WEAPON_SMG"] = true,
			["WEAPON_SMG_MK2"] = true,
			["WEAPON_TACTICALRIFLE"] = true,
			["WEAPON_HEAVYRIFLE"] = true,
			["WEAPON_ASSAULTRIFLE"] = true,
			["WEAPON_ASSAULTRIFLE_MK2"] = true,
			["WEAPON_ASSAULTSMG"] = true,
			["WEAPON_GUSENBERG"] = true
		}
	},
	["medicbag"] = {
		Slots = 25,
		Weight = 10,
		Close = true,
		Itens = {
			["bandage"] = true,
			["gauze"] = true,
			["gdtkit"] = true,
			["medkit"] = true,
			["sinkalmy"] = true,
			["analgesic"] = true,
			["ritmoneury"] = true,
			["adrenaline"] = true
		}
	},
	["treasurebox"] = {
		Slots = 25,
		Weight = 50,
		Close = true
	}
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permissions(Name,Mode,Item)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	-- ✅ Compartimento Pessoal: facção NÃO precisa bater ponto, legal precisa
	if Mode == "Personal" then
		local ServiceName = SplitOne(Name)

		if HasChestAccess(Passport, ServiceName) then
			Open[Passport] = {
				Name = "Personal:"..Passport,
				Weight = 50,
				Save = true,
				Slots = 25
			}

			return true
		end

	-- ✅ Bandeja / Tray (livre)
	elseif Mode == "Tray" then
		local isRecycle = (Name == "Recycle")

		Open[Passport] = {
			Slots = 25,
			Name = Name,
			Save = true,
			Recycle = isRecycle,
			Weight = isRecycle and 100 or 25
		}

		return true

	-- ✅ Custom / Trash (livre, com cooldown em helicrash)
	elseif Mode == "Custom" or Mode == "Trash" then
		if SplitBoolean(Name,"Helicrash",":") and Cooldown[Name] and Cooldown[Name] > os.time() then
			TriggerClientEvent("Notify",source,"Atenção","Aguarde até que esfrie o compartimento.","amarelo",10000)
			vRPC.DowngradeHealth(source,10)
			return false
		end

		Open[Passport] = {
			Name = (Mode == "Trash" and "Trash:"..Name or Name),
			Weight = 50,
			Slots = 25,
			Mode = "Custom"
		}

		return true

	-- ✅ Baú por item (mochilas/caixas)
	elseif Mode == "Item" then
		local UniqueName = SplitOne(Name,":")
		if ChestItens[UniqueName] then
			Open[Passport] = {
				Name = Name,
				Save = true,
				Unique = UniqueName,
				Slots = ChestItens[UniqueName].Slots,
				Weight = ChestItens[UniqueName].Weight,
				Item = Item
			}

			return true
		end

	-- ✅ Baú normal (facção/empresa): facção NÃO precisa bater ponto, legal precisa
	else
		local Consult = vRP.SingleQuery("chests/GetChests",{ Name = Name })
		if not Consult then
			vRP.Query("chests/AddChests",{ Name = Name })
			Consult = vRP.SingleQuery("chests/GetChests",{ Name = Name })
		end

		if Consult and HasChestAccess(Passport, Consult.Permission) then
			local IsPremium = vRP.Permissions(Consult.Permission, "Premium") > os.time()

			Open[Passport] = {
				Weight = IsPremium and Consult.Weight * 2 or Consult.Weight,
				Chest = Name,
				Slots = Consult.Slots,
				Name = "Chest:"..Name,
				Permission = Consult.Permission,
				Save = true
			}

			return true
		end
	end

	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Mount()
	local source = source
	local Passport = vRP.Passport(source)

	if not (Passport and Open[Passport]) then
		return false
	end

	local function ProcessItem(Slot,v,Prefix,Key,Save)
		if v.amount <= 0 or not ItemExist(v.item) then
			if Prefix == "Inventory" then
				vRP.CleanSlot(Passport,Slot)
			elseif Prefix == "Chest" then
				vRP.CleanSlotChest(Key,Slot,Save)
			end

			return false
		end

		v.key = v.item

		local Split = splitString(v.item)
		local Item = Split[1]

		if Prefix == "Inventory" and ChestItens[Item] and ChestItens[Item].Close then
			v.block = true
		end

		if not v.desc then
			if Item == "vehiclekey" and Split[3] then
				local Consult = exports.oxmysql:single_async("SELECT * FROM vehicles WHERE Plate = ? LIMIT 1",{ Split[3] })
				if Consult and VehicleExist(Consult.Vehicle) then
					v.desc = "Proprietário: <common>"..vRP.FullName(Consult.Passport).."</common><br>Modelo: <common>"..VehicleName(Consult.Vehicle).."</common><br>Placa: <common>"..Split[3].."</common>"
				end
			elseif Item == "propertys" and Split[2] then
				local Consult = exports.oxmysql:single_async("SELECT * FROM propertys WHERE Serial = ? LIMIT 1",{ Split[2] })
				if Consult then
					v.desc = "Proprietário: <common>"..vRP.FullName(Consult.Passport).."</common>"
				end
			elseif ItemNamed(Item) and Split[2] and vRP.Identity(Split[2]) then
				if Item == "identity" then
					v.desc = "Passaporte: <rare>"..Dotted(Split[2]).."</rare><br>Nome: <rare>"..vRP.FullName(Split[2]).."</rare><br>Telefone: <rare>"..vRP.Phone(Split[2]).."</rare>"
				else
					v.desc = "Proprietário: <common>"..vRP.FullName(Split[2]).."</common>"
				end
			end
		end

		if Split[2] then
			local Loaded = ItemLoads(v.item)
			if Loaded then
				v.charges = parseInt(Split[2] * (100 / Loaded))
			end

			if ItemDurability(v.item) then
				v.durability = parseInt(os.time() - Split[2])
				v.days = ItemDurability(v.item)
			end
		end

		return v
	end

	local Primary = {}
	local Inventory = vRP.Inventory(Passport)
	for Slot,v in pairs(Inventory) do
		local Processed = ProcessItem(Slot,v,"Inventory")
		if Processed then
			Primary[Slot] = Processed
		end
	end

	local Secondary = {}
	if Open[Passport] and Open[Passport].Name then
		local ChestData = Open[Passport].Name
		local Chest = vRP.GetSrvData(ChestData,Open[Passport].Save)
		for Slot,v in pairs(Chest) do
			local Processed = ProcessItem(Slot,v,"Chest",ChestData,Open[Passport].Save)
			if Processed then
				Secondary[Slot] = Processed
			end
		end
	end

	return Primary,Secondary,vRP.GetWeight(Passport),Open[Passport].Weight,Open[Passport].Slots
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Slot,Amount,Target,Inactived)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)

	if not (Passport and Open[Passport] and not Inactived) then
		TriggerClientEvent("inventory:Update",source)
		return false
	end

	if Open[Passport].Recycle then
		local Recycled = ItemRecycle(Item)
		if Recycled and vRP.TakeItem(Passport,Item,Amount) then
			for Index,Number in pairs(Recycled) do
				vRP.GenerateItem(Passport,Index,Number * Amount)
			end

			TriggerClientEvent("inventory:Update",source)
		else
			TriggerClientEvent("inventory:Notify",source,"Atenção",ItemName(Item).." não pode ser reciclado.","amarelo")
			TriggerClientEvent("inventory:Update",source)
		end

		return false
	end

	if Item == "diagram" and Open[Passport].Chest and vRP.TakeItem(Passport,Item,Amount) then
		vRP.Update("chests/UpdateWeight",{ Name = Open[Passport].Chest, Multiplier = Amount })
		TriggerClientEvent("inventory:Notify",source,"Sucesso","Armazenamento melhorado.","verde")
		Open[Passport].Weight = Open[Passport].Weight + (10 * Amount)
		TriggerClientEvent("inventory:Update",source)
		return false
	end

	local CleanedItem = SplitOne(Item)
	local Unique = Open[Passport].Unique
	if (ChestItens[CleanedItem] and ChestItens[CleanedItem].Block) or (Unique and ChestItens[Unique] and ChestItens[Unique].Itens and not ChestItens[Unique].Itens[CleanedItem]) then
		if Unique and CleanedItem == Unique then
			TriggerClientEvent("inventory:Open",source,{ Type = "Inventory", Resource = "inventory", Right = "Proximidade" },true)
		else
			TriggerClientEvent("inventory:Update",source)
		end

		return false
	end

	if vRP.StoreChest(Passport,Open[Passport].Name,Amount,Open[Passport].Weight,Slot,Target,Open[Passport].Save,ChestItens[Unique]) then
		TriggerClientEvent("inventory:Update",source)
		return false
	end

	return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Item,Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)

	if not Passport or not Open[Passport] then
		TriggerClientEvent("inventory:Update",source)
		return false
	end

	local Name = Open[Passport].Name
	local Saved = Open[Passport].Save
	if vRP.TakeChest(Passport,Name,Amount,Slot,Target,Saved) then
		TriggerClientEvent("inventory:Update",source)
		return false
	end

	local Data = vRP.GetSrvData(Name,Saved)
	if (Open[Passport].Mode or Open[Passport].Item) and json.encode(Data) == "[]" then
		if Open[Passport].Item and vRP.TakeItem(Passport,Open[Passport].Item) then
			TriggerClientEvent("inventory:Open",source,{ Type = "Inventory", Resource = "inventory", Right = "Baú" },true)
		end

		if SplitBoolean(Name,"Helicrash",":") then
			GlobalState.Helibox = (GlobalState.Helibox or 1) - 1
		elseif SplitBoolean(Name,"Halloween",":") then
			GlobalState.Hallobox = (GlobalState.Hallobox or 1) - 1
			GlobalState[Name] = false
		end
	end

	return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)

	if not Passport or not Open[Passport] then
		return false
	end

	local Name = Open[Passport].Name
	local Saved = Open[Passport].Save
	if vRP.UpdateChest(Passport,Name,Slot,Target,Amount,Saved) then
		TriggerClientEvent("inventory:Update",source)
	end

	return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:COOLDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:Cooldown",function(Name)
	Cooldown[Name] = os.time() + 600
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:ARMOUR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("chest:Armour")
AddEventHandler("chest:Armour",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end

	-- Polícia geral
	if vRP.HasService(Passport,"Policia") then
		vRP.Armour(source,100)
		return
	end

	-- Subgrupos polícia
	for _,group in pairs({ "LSPD","SAPR","BCSO","PHZ" }) do
		if vRP.HasService(Passport,group) then
			vRP.Armour(source,100)
			return
		end
	end

	-- EXERCITO
	if vRP.HasService(Passport,"EXERCITO") then
		vRP.Armour(source,100)
		return
	end

	-- SEGURANCA
	if vRP.HasService(Passport,"SEGURANCA") then
		vRP.Armour(source,100)
		return
	end

	-- TATICA (adicionado)
	if vRP.HasGroup(Passport, "TATICA") then
		vRP.Armour(source, 100)
		return
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE: ILLEGAL ITEMS LIST (gerado do vrp.zip -> vrp/config/Item.lua onde Arrest = true)
-----------------------------------------------------------------------------------------------------------------------------------------
local PoliceGroupsAll = { "Policia","LSPD","SAPR","BCSO","PHZ","EXERCITO","SEGURANCA" }   -- <-- SEGURANCA ADICIONADO

-- Itens marcados como Arrest = true em vrp/config/Item.lua
local IllegalItems = {
	-- =====================================================================
	-- ITENS
	-- =====================================================================
	"amphetamine",
	"ballisticplate",
	"blocksignal",
	"c4",
	"circuit",
	"cocaine",
	"codeine",
	"cokesack",
	"crack",
	"dirtydollar",
	"dismantle",
	"dogtag",
	"dollar",
	"emptybottle",
	"fishingrod",
	"fuse",
	"gold_pure",
	"heroin",
	"inductor",
	"joint",
	"lockpick",
	"magnesium",
	"meth",
	"methsack",
	"pager",
	"pistolbody",
	"plate",
	"plasticbottle",
	"promissory1000",
	"promissory2000",
	"promissory3000",
	"promissory4000",
	"promissory5000",
	"riflebody",
	"smgbody",
	"weedsack",
	"wetdollar",

	-- =====================================================================
	-- ANEXOS
	-- =====================================================================
	"ATTACH_CROSSHAIR",
	"ATTACH_FLASHLIGHT",
	"ATTACH_GRIP",
	"ATTACH_MAGAZINE",
	"ATTACH_SILENCER",

	-- =====================================================================
	-- MUNIÇÕES
	-- =====================================================================
	"WEAPON_MUSKET_AMMO",
	"WEAPON_PETROLCAN_AMMO",
	"WEAPON_PISTOL_AMMO",
	"WEAPON_RIFLE_AMMO",
	"WEAPON_RPG_AMMO",
	"WEAPON_SHOTGUN_AMMO",

	-- =====================================================================
	-- ARMAS
	-- =====================================================================
	"WEAPON_ACIDPACKAGE",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_APPISTOL",
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_ASSAULTSMG",
	"WEAPON_BAT",
	"WEAPON_BATTLEAXE",
	"WEAPON_BRICK",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_BULLPUPRIFLE_MK2",
	"WEAPON_CARBINERIFLE",
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_COMBATPISTOL",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_CROWBAR",
	"WEAPON_FLASHLIGHT",
	"WEAPON_GOLFCLUB",
	"WEAPON_GUSENBERG",
	"WEAPON_HAMMER",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_HEAVYRIFLE",
	"WEAPON_KNUCKLE",
	"WEAPON_MACHETE",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_MICROSMG",
	"WEAPON_MINISMG",
	"WEAPON_MOLOTOV",
	"WEAPON_MUSKET",
	"WEAPON_NIGHTSTICK",
	"WEAPON_PETROLCAN",
	"WEAPON_PISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_PISTOL_MK2",
	"WEAPON_POOLCUE",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_PUMPSHOTGUN_MK2",
	"WEAPON_RPG",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_SHOES",
	"WEAPON_SMG",
	"WEAPON_SMG_MK2",
	"WEAPON_SMOKEGRENADE",
	"WEAPON_SNOWBALL",
	"WEAPON_SNSPISTOL",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_SPECIALCARBINE_MK2",
	"WEAPON_STONE_HATCHET",
	"WEAPON_STUNGUN",
	"WEAPON_SWITCHBLADE",
	"WEAPON_TACTICALRIFLE",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_WRENCH",
	"WEAPON_SMG_AMMO",
}
local IllegalSet = {}
for _,it in pairs(IllegalItems) do IllegalSet[it] = true end

-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPER: SERVICE CHECK + REMOVE ILLEGAL
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetActivePoliceGroup(Passport)
	for _,group in pairs({ "LSPD","SAPR","BCSO","PHZ","EXERCITO","SEGURANCA" }) do   -- <-- SEGURANCA ADICIONADO
		if vRP.HasService(Passport,group) then
			return group
		end
	end
	-- se usa "Policia" como serviço geral também:
	if vRP.HasService(Passport,"Policia") then
		return "Policia"
	end
	return nil
end

local function IsPolice(Passport)
	for _,group in pairs(PoliceGroupsAll) do
		if vRP.HasService(Passport,group) then
			return true
		end
	end
	return false
end

local function GetAmount(Passport, item)
	if vRP.GetItemAmount then
		return (vRP.GetItemAmount(Passport,item) or 0)
	end
	return 0
end

local function RemoveAmount(Passport, item, amount)
	if amount <= 0 then return end

	-- tenta funções comuns do Creative/vRP
	if vRP.RemoveItem then
		vRP.RemoveItem(Passport,item,amount,true)
		return
	end

	if vRP.TryGetInventoryItem then
		vRP.TryGetInventoryItem(Passport,item,amount,true)
		return
	end

	if vRP.TakeItem then
		vRP.TakeItem(Passport,item,amount,true)
		return
	end

	-- fallback: não encontrou função de remover
	print("[POLICE] Nenhuma função de remover item encontrada (RemoveItem/TryGetInventoryItem/TakeItem).")
end

local function RemoveAllItem(Passport, item)
	local amount = GetAmount(Passport, item)
	if amount > 0 then
		RemoveAmount(Passport, item, amount)
	end
end

local function RemoveIllegalItems(Passport)
	for _,item in pairs(IllegalItems) do
		-- remove item normal
		RemoveAllItem(Passport, item)

		-- remove também wbody|WEAPON_* (se for arma)
		if type(item) == "string" and item:sub(1,7) == "WEAPON_" then
			RemoveAllItem(Passport, "wbody|"..item)
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTO PRA LIMPEZA AO SAIR DE SERVIÇO
-- -> CHAME ISSO no seu script do "bater ponto/sair"
-- TriggerEvent("police:OffDutyCleanup", source)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:OffDutyCleanup")
AddEventHandler("police:OffDutyCleanup",function(customSource)
	local source = customSource or source
	local Passport = vRP.Passport(source)
	if not Passport then return end

	-- só aplica se for polícia (pra não apagar item de civil por engano)
	if not IsPolice(Passport) then return end

	-- remove ilegais + tira armas equipadas
	RemoveIllegalItems(Passport)
	vRP.ClearWeapons(source)

	TriggerClientEvent("Notify",source,"Polícia","Itens ilegais removidos ao sair de serviço.","amarelo",5000)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE ARMORY SYSTEM (REMOVE ILEGAIS AO BATER PONTO + TASER + MUNIÇÃO AUTO)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:Armory")
AddEventHandler("police:Armory",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end

	-- Só pode se estiver em serviço
	local ActiveGroup = GetActivePoliceGroup(Passport)
	if not ActiveGroup or ActiveGroup == "Policia" then
		-- se você não quer permitir "Policia" como grupo do arsenal, deixa assim:
		if not ActiveGroup or ActiveGroup == "Policia" then
			TriggerClientEvent("Notify",source,"Aviso","Você precisa estar em serviço.","amarelo",5000)
			return
		end
	end

	-- ✅ REMOVE ILEGAIS AO "BATER PONTO" (ao pegar armamento)
	RemoveIllegalItems(Passport)

	-- Remove armas antigas (equipadas)
	vRP.ClearWeapons(source)

	---------------------------------------------------------------------
	-- CONFIG: munições que existem na sua base
	---------------------------------------------------------------------
	local AmmoByWeapon = {
		-- Pistolas
		WEAPON_PISTOL = "WEAPON_PISTOL_AMMO",
		WEAPON_PISTOL_MK2 = "WEAPON_PISTOL_AMMO",
		WEAPON_COMBATPISTOL = "WEAPON_PISTOL_AMMO",
		WEAPON_APPISTOL = "WEAPON_PISTOL_AMMO",
		WEAPON_HEAVYPISTOL = "WEAPON_PISTOL_AMMO",

		-- SMGs
		WEAPON_SMG = "WEAPON_SMG_AMMO",
		WEAPON_SMG_MK2 = "WEAPON_SMG_AMMO",
		WEAPON_ASSAULTSMG = "WEAPON_SMG_AMMO",
		WEAPON_COMBATPDW = "WEAPON_SMG_AMMO",
		WEAPON_MICROSMG = "WEAPON_SMG_AMMO",

		-- Rifles
		WEAPON_CARBINERIFLE = "WEAPON_RIFLE_AMMO",
		WEAPON_CARBINERIFLE_MK2 = "WEAPON_RIFLE_AMMO",
		WEAPON_ASSAULTRIFLE = "WEAPON_RIFLE_AMMO",
		WEAPON_ASSAULTRIFLE_MK2 = "WEAPON_RIFLE_AMMO",
		WEAPON_SPECIALCARBINE = "WEAPON_RIFLE_AMMO",
		WEAPON_SPECIALCARBINE_MK2 = "WEAPON_RIFLE_AMMO",
		WEAPON_BULLPUPRIFLE = "WEAPON_RIFLE_AMMO",
		WEAPON_BULLPUPRIFLE_MK2 = "WEAPON_RIFLE_AMMO",

		-- Shotguns
		WEAPON_PUMPSHOTGUN = "WEAPON_SHOTGUN_AMMO",
		WEAPON_PUMPSHOTGUN_MK2 = "WEAPON_SHOTGUN_AMMO",
		WEAPON_ASSAULTSHOTGUN = "WEAPON_SHOTGUN_AMMO",
		WEAPON_BULLPUPSHOTGUN = "WEAPON_SHOTGUN_AMMO",
		WEAPON_SAWNOFFSHOTGUN = "WEAPON_SHOTGUN_AMMO",

		-- Musket
		WEAPON_MUSKET = "WEAPON_MUSKET_AMMO",

		-- RPG
		WEAPON_RPG = "WEAPON_RPG_AMMO",

		-- Galão
		WEAPON_PETROLCAN = "WEAPON_PETROLCAN_AMMO"
	}

	local AmmoAmountByType = {
		WEAPON_PISTOL_AMMO   = 150,
		WEAPON_SMG_AMMO      = 250,
		WEAPON_RIFLE_AMMO    = 300,
		WEAPON_SHOTGUN_AMMO  = 60,
		WEAPON_MUSKET_AMMO   = 30,
		WEAPON_RPG_AMMO      = 2,
		WEAPON_PETROLCAN_AMMO = 4500
	}

	local NoAmmoWeapons = {
		WEAPON_STUNGUN = true,
		WEAPON_NIGHTSTICK = true,
		WEAPON_FLASHLIGHT = true
	}

	---------------------------------------------------------------------
	-- Helpers SMART: tenta WEAPON_* e wbody|WEAPON_*
	---------------------------------------------------------------------
	local function GiveItem(passport, item, amount)
		vRP.GenerateItem(passport, item, amount, true)
	end

	local function HasItem(passport, item)
		if vRP.GetItemAmount then
			return (vRP.GetItemAmount(passport, item) or 0) > 0
		end
		return true
	end

	local function GiveWeaponSmart(passport, weapon)
		GiveItem(passport, weapon, 1)

		if vRP.GetItemAmount and not HasItem(passport, weapon) then
			local body = "wbody|"..weapon
			GiveItem(passport, body, 1)

			if not HasItem(passport, body) then
				print(("[ARMORY] Arma NÃO existe como item: %s (nem %s)"):format(weapon, body))
			end
		end
	end

	local function GiveAmmoForWeapons(passport, weaponList)
		local ammoToGive = {}

		for _,w in pairs(weaponList) do
			if not NoAmmoWeapons[w] then
				local ammoItem = AmmoByWeapon[w]
				if ammoItem then
					local add = AmmoAmountByType[ammoItem] or 0
					if add > 0 then
						ammoToGive[ammoItem] = (ammoToGive[ammoItem] or 0) + add
					end
				end
			end
		end

		for ammoItem,total in pairs(ammoToGive) do
			GiveItem(passport, ammoItem, total)
		end
	end

	---------------------------------------------------------------------
	-- Monta loadout (TASER pra todos)
	---------------------------------------------------------------------
	local weapons = {}
	local baseKit = { "WEAPON_STUNGUN", "WEAPON_NIGHTSTICK", "WEAPON_FLASHLIGHT" }

	if ActiveGroup == "PHZ" then
		if vRP.HasPermission(Passport,"SoldadoPHZ") then
			weapons = { "WEAPON_PISTOL" }
		elseif vRP.HasPermission(Passport,"CaboPHZ") then
			weapons = { "WEAPON_PISTOL", "WEAPON_SMG" }
		elseif vRP.HasPermission(Passport,"SargentoPHZ") then
			weapons = { "WEAPON_PISTOL", "WEAPON_SMG", "WEAPON_CARBINERIFLE" }
		else
			weapons = { "WEAPON_PISTOL_MK2", "WEAPON_CARBINERIFLE_MK2", "WEAPON_SMG_MK2" }
		end

	elseif ActiveGroup == "EXERCITO" then
		-- Mesma lógica da PHZ, usando as permissões do EXERCITO
		if vRP.HasPermission(Passport,"SoldadoEXERCITO") then
			weapons = { "WEAPON_PISTOL" }
		elseif vRP.HasPermission(Passport,"CaboEXERCITO") then
			weapons = { "WEAPON_PISTOL", "WEAPON_SMG" }
		elseif vRP.HasPermission(Passport,"SargentoEXERCITO") then
			weapons = { "WEAPON_PISTOL", "WEAPON_SMG", "WEAPON_CARBINERIFLE" }
		else
			-- Oficiais e superiores (Tenente, Capitão, Major, etc.) recebem versões MK2
			weapons = { "WEAPON_PISTOL_MK2", "WEAPON_CARBINERIFLE_MK2", "WEAPON_SMG_MK2" }
		end

	elseif ActiveGroup == "LSPD" then
		weapons = { "WEAPON_PISTOL", "WEAPON_SMG" }
	elseif ActiveGroup == "SAPR" then
		weapons = { "WEAPON_PISTOL", "WEAPON_CARBINERIFLE" }
	elseif ActiveGroup == "BCSO" then
		weapons = { "WEAPON_PISTOL", "WEAPON_PUMPSHOTGUN" }
	end

	for _,w in pairs(baseKit) do
		table.insert(weapons, w)
	end

	---------------------------------------------------------------------
	-- Entrega armas + munições automáticas
	---------------------------------------------------------------------
	for _,w in pairs(weapons) do
		if w == "WEAPON_STUNGUN" or w == "WEAPON_NIGHTSTICK" or w == "WEAPON_FLASHLIGHT" then
			GiveItem(Passport, w, 1)
		else
			GiveWeaponSmart(Passport, w)
		end
	end

	GiveAmmoForWeapons(Passport, weapons)

	TriggerClientEvent("Notify",source,"Arsenal","Armamento entregue com sucesso.","verde",5000)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SECURITY ARMORY SYSTEM (SEGURANÇA)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("security:Armory")
AddEventHandler("security:Armory",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end

	-- Verifica se está em serviço no grupo SEGURANCA
	if not vRP.HasService(Passport, "SEGURANCA") then
		TriggerClientEvent("Notify", source, "Aviso", "Você precisa estar em serviço como Segurança.", "amarelo", 5000)
		return
	end

	-- Opcional: remover itens ilegais (se desejar)
	-- RemoveIllegalItems(Passport)

	-- Remove armas antigas
	vRP.ClearWeapons(source)

	-- Funções auxiliares (reutilizando as mesmas definidas acima)
	local function GiveItem(passport, item, amount)
		vRP.GenerateItem(passport, item, amount, true)
	end

	local function GiveWeaponSmart(passport, weapon)
		GiveItem(passport, weapon, 1)
		-- Se a base usar wbody, tente também:
		-- GiveItem(passport, "wbody|"..weapon, 1)
	end

	-- Loadout base para seguranças
	local weapons = {
		"WEAPON_STUNGUN",      -- Taser
		"WEAPON_NIGHTSTICK",   -- Cassetete
		"WEAPON_FLASHLIGHT",   -- Lanterna
		"WEAPON_PISTOL",       -- Pistola
		-- Opcional: se quiser dar submetralhadora para cargos mais altos
	}

	-- Exemplo de hierarquia para dar SMG a supervisores/chefes
	if vRP.HasPermission(Passport, "SupervisorSeguranca") or vRP.HasPermission(Passport, "DiretorSeguranca") then
		table.insert(weapons, "WEAPON_SMG")
	end

	-- Entrega as armas
	for _, w in pairs(weapons) do
		if w == "WEAPON_STUNGUN" or w == "WEAPON_NIGHTSTICK" or w == "WEAPON_FLASHLIGHT" then
			GiveItem(Passport, w, 1)
		else
			GiveWeaponSmart(Passport, w)
		end
	end

	-- Munição
	GiveItem(Passport, "WEAPON_PISTOL_AMMO", 100)
	if vRP.HasPermission(Passport, "SupervisorSeguranca") or vRP.HasPermission(Passport, "DiretorSeguranca") then
		GiveItem(Passport, "WEAPON_SMG_AMMO", 200)
	end

	TriggerClientEvent("Notify", source, "Arsenal", "Armamento de Segurança entregue.", "verde", 5000)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TATICA ARMORY SYSTEM (armamento pesado para todos os membros)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tatica:Armory")
AddEventHandler("tatica:Armory",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end

	-- Verifica se o jogador pertence à organização TATICA (grupo OU cargo)
	local isTatica = vRP.HasGroup(Passport, "TATICA")
	if not isTatica then
		for _, rank in pairs({ "CoronelTatica","Ten.CoronelTatica","MajorTatica","CapitaoTatica","TenenteTatica","SubTenenteTatica","SargentoTatica","CaboTatica","SoldadoTatica","RecrutaTatica" }) do
			if vRP.HasPermission(Passport, rank) then
				isTatica = true
				break
			end
		end
	end

	if not isTatica then
		TriggerClientEvent("Notify", source, "Aviso", "Você não é membro da TATICA.", "amarelo", 5000)
		return
	end

	-- Remove armas antigas
	vRP.ClearWeapons(source)

	-- Funções auxiliares
	local function GiveItem(passport, item, amount)
		vRP.GenerateItem(passport, item, amount, true)
	end

	local function GiveWeaponSmart(passport, weapon)
		GiveItem(passport, weapon, 1)
		-- Se usar wbody|, descomente abaixo:
		-- GiveItem(passport, "wbody|"..weapon, 1)
	end

	-- Mapeamento de munição por arma
	local AmmoByWeapon = {
		WEAPON_PISTOL          = "WEAPON_PISTOL_AMMO",
		WEAPON_PISTOL_MK2      = "WEAPON_PISTOL_AMMO",
		WEAPON_COMBATPISTOL    = "WEAPON_PISTOL_AMMO",
		WEAPON_APPISTOL        = "WEAPON_PISTOL_AMMO",
		WEAPON_HEAVYPISTOL     = "WEAPON_PISTOL_AMMO",
		WEAPON_SMG             = "WEAPON_SMG_AMMO",
		WEAPON_SMG_MK2         = "WEAPON_SMG_AMMO",
		WEAPON_ASSAULTSMG      = "WEAPON_SMG_AMMO",
		WEAPON_MICROSMG        = "WEAPON_SMG_AMMO",
		WEAPON_MINISMG         = "WEAPON_SMG_AMMO",
		WEAPON_MACHINEPISTOL   = "WEAPON_SMG_AMMO",
		WEAPON_CARBINERIFLE    = "WEAPON_RIFLE_AMMO",
		WEAPON_CARBINERIFLE_MK2= "WEAPON_RIFLE_AMMO",
		WEAPON_ASSAULTRIFLE    = "WEAPON_RIFLE_AMMO",
		WEAPON_ASSAULTRIFLE_MK2= "WEAPON_RIFLE_AMMO",
		WEAPON_SPECIALCARBINE  = "WEAPON_RIFLE_AMMO",
		WEAPON_SPECIALCARBINE_MK2 = "WEAPON_RIFLE_AMMO",
		WEAPON_BULLPUPRIFLE    = "WEAPON_RIFLE_AMMO",
		WEAPON_BULLPUPRIFLE_MK2= "WEAPON_RIFLE_AMMO",
		WEAPON_ADVANCEDRIFLE   = "WEAPON_RIFLE_AMMO",
		WEAPON_TACTICALRIFLE   = "WEAPON_RIFLE_AMMO",
		WEAPON_HEAVYRIFLE      = "WEAPON_RIFLE_AMMO",
		WEAPON_PUMPSHOTGUN     = "WEAPON_SHOTGUN_AMMO",
		WEAPON_PUMPSHOTGUN_MK2 = "WEAPON_SHOTGUN_AMMO",
		WEAPON_SAWNOFFSHOTGUN  = "WEAPON_SHOTGUN_AMMO",
		WEAPON_MUSKET          = "WEAPON_MUSKET_AMMO",
		WEAPON_RPG             = "WEAPON_RPG_AMMO",
		WEAPON_PETROLCAN       = "WEAPON_PETROLCAN_AMMO",
	}

	local AmmoAmountByType = {
		WEAPON_PISTOL_AMMO   = 150,
		WEAPON_SMG_AMMO      = 250,
		WEAPON_RIFLE_AMMO    = 300,
		WEAPON_SHOTGUN_AMMO  = 60,
		WEAPON_MUSKET_AMMO   = 30,
		WEAPON_RPG_AMMO      = 2,
		WEAPON_PETROLCAN_AMMO = 4500,
	}

	-- Armas que NÃO usam munição (vamos excluir as brancas, manter só taser/etc se quiser)
	local NoAmmoWeapons = {
		WEAPON_STUNGUN       = true,
		WEAPON_NIGHTSTICK    = true,
		WEAPON_FLASHLIGHT    = true,
		-- Se quiser incluir algumas brancas, descomente:
		-- WEAPON_SWITCHBLADE = true,
		-- WEAPON_KNUCKLE     = true,
	}

	-- Função para dar munição automaticamente
	local function GiveAmmoForWeapons(passport, weaponList)
		local ammoToGive = {}
		for _, w in pairs(weaponList) do
			if not NoAmmoWeapons[w] then
				local ammoItem = AmmoByWeapon[w]
				if ammoItem then
					local add = AmmoAmountByType[ammoItem] or 0
					if add > 0 then
						ammoToGive[ammoItem] = (ammoToGive[ammoItem] or 0) + add
					end
				end
			end
		end
		for ammoItem, total in pairs(ammoToGive) do
			GiveItem(passport, ammoItem, total)
		end
	end

	---------------------------------------------------------------------
	-- LOADOUT PESADO PARA TODOS OS MEMBROS (SEM ARMAS BRANCAS)
	---------------------------------------------------------------------
	local weapons = {
		-- Armas não letais / básicas (opcional)
		"WEAPON_STUNGUN",      -- Taser (se quiser manter)
		"WEAPON_NIGHTSTICK",   -- Cassetete (se quiser)
		"WEAPON_FLASHLIGHT",   -- Lanterna (pode ser útil)

		-- Pistolas
		"WEAPON_PISTOL_MK2",   -- T54

		-- Submetralhadoras
		"WEAPON_MINISMG",      -- MAC-10
		"WEAPON_MACHINEPISTOL",-- Tec-9

		-- Rifles
		"WEAPON_ASSAULTRIFLE_MK2", -- AK-102
		"WEAPON_BULLPUPRIFLE_MK2", -- L85
		"WEAPON_TACTICALRIFLE", -- M16
		"WEAPON_HEAVYRIFLE",   -- Scar-H

		-- Escopetas
		"WEAPON_PUMPSHOTGUN_MK2", -- MP133


		-- Especiais
		"WEAPON_SMOKEGRENADE",  -- Granada de fumaça
	}

	-- Entrega as armas
	for _, w in pairs(weapons) do
		if NoAmmoWeapons[w] then
			GiveItem(Passport, w, 1)
		else
			GiveWeaponSmart(Passport, w)
		end
	end

	-- Munição
	GiveAmmoForWeapons(Passport, weapons)

	-- Opcional: paraquedas
	-- GiveItem(Passport, "GADGET_PARACHUTE", 1)

	TriggerClientEvent("Notify", source, "Arsenal TATICA", "Armamento pesado entregue a todos os membros.", "verde", 5000)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Open[Passport] then
		Open[Passport] = nil
	end
end)