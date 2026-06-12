-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Sources = {}
Playing = {}
Playing.Online = {}
Characters = {}
local Arena = {}
local Prepare = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Prepare(Name,Query)
	Prepare[Name] = Query
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Query(Name,Params)
	return exports.oxmysql:query_async(Prepare[Name],Params)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Update(Name,Params)
    return exports.oxmysql:update_async(Prepare[Name],Params)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SINGLEQUERY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SingleQuery(Name,Params)
    return exports.oxmysql:single_async(Prepare[Name],Params)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCALAR
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Scalar(Name,Params)
	return exports.oxmysql:scalar_async(Prepare[Name],Params)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTITIES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Identities(source)
	local Identities = GetPlayerIdentifierByType(source,"license")

	return Identities and SplitTwo(Identities,":") or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARCHIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Archive(Archive,Text)
	local Message = LoadResourceFile("archives",Archive)
	SaveResourceFile("archives",Archive,(Message or "")..Text.."\n",-1)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Account(License)
	return vRP.SingleQuery("accounts/Account",{ License = License })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Discord(Discord)
	return vRP.SingleQuery("accounts/Discord",{ Discord = Discord })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNTINFORMATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.AccountInformation(Passport,Mode)
	local Passport = parseInt(Passport)
	local Identity = vRP.Identity(Passport)
	if not Identity then return false end

	local Account = vRP.Account(Identity.License)
	return Account and Account[Mode] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNTOPTIMIZE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.AccountOptimize(Passport)
	local Passport = parseInt(Passport)
	local Identity = vRP.Identity(Passport)

	return Identity and vRP.Account(Identity.License) or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserData(Passport,Key)
	local Consult = vRP.SingleQuery("playerdata/GetData",{ Passport = Passport, Name = Key })

	return Consult and json.decode(Consult.Information) or {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIMPLEDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SimpleData(Passport,Key)
	local Consult = vRP.SingleQuery("playerdata/GetData",{ Passport = Passport, Name = Key })

	return Consult and json.decode(Consult.Information) or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSIDEPROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InsidePropertys(Passport,Coords)
	local Datatable = vRP.Datatable(Passport)
	if Datatable then
		Datatable.Pos = Coords
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Inventory(Passport)
	local Datatable = vRP.Datatable(Passport)

	return Datatable and (Datatable.Inventory or {}) or {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVETEMPORARY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SaveTemporary(Passport,source,Table)
	if not Arena[Passport] then
		local Datatable = vRP.Datatable(Passport)
		if Datatable then
			local Route = Table.Route
			local Ped = GetPlayerPed(source)

			Arena[Passport] = {
				Inventory = Datatable.Inventory,
				Health = GetEntityHealth(Ped),
				Armour = GetPedArmour(Ped),
				Stress = Datatable.Stress,
				Hunger = Datatable.Hunger,
				Thirst = Datatable.Thirst,
				Pos = GetEntityCoords(Ped),
				Route = Route
			}

			vRP.Armour(source,100)
			Datatable.Inventory = {}
			vRPC.SetHealth(source,200)
			vRP.UpgradeHunger(Passport,100)
			vRP.UpgradeThirst(Passport,100)
			vRP.DowngradeStress(Passport,100)

			TriggerEvent("DebugWeapons",Passport)
			GlobalState["Arena:"..Route] = GlobalState["Arena:"..Route] + 1
			TriggerEvent("inventory:SaveArena",Passport,Table.Attachs,Table.Ammos)

			for Item,v in pairs(Table.Itens) do
				vRP.GenerateItem(Passport,Item,v.Amount,false,v.Slot)
			end

			exports["vrp"]:Bucket(source,"Enter",Route)
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYTEMPORARY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ApplyTemporary(Passport,source)
	if Arena[Passport] then
		local Route = Arena[Passport].Route
		local Datatable = vRP.Datatable(Passport)
		if Datatable then
			Datatable.Stress = Arena[Passport].Stress
			Datatable.Hunger = Arena[Passport].Hunger
			Datatable.Thirst = Arena[Passport].Thirst
			Datatable.Inventory = Arena[Passport].Inventory

			TriggerClientEvent("hud:Thirst",source,Datatable.Thirst)
			TriggerClientEvent("hud:Hunger",source,Datatable.Hunger)
			TriggerClientEvent("hud:Stress",source,Datatable.Stress)
		end

		vRP.Armour(source,Arena[Passport].Armour)
		vRPC.SetHealth(source,Arena[Passport].Health)
		GlobalState["Arena:"..Route] = GlobalState["Arena:"..Route] - 1
		TriggerEvent("inventory:ApplyArena",Passport)
		TriggerEvent("vRP:ReloadWeapons",source)
		exports["vrp"]:Bucket(source,"Exit")

		Arena[Passport] = nil
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SkinCharacter(Passport,Hash)
	vRP.Query("characters/SetSkin",{ Passport = Passport, Skin = Hash })

	local source = vRP.Source(Passport)
	if Characters[source] then
		Characters[source].Skin = Hash
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Passport(source)
	return Characters[source] and Characters[source].id or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Players()
	return Sources
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERSOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Source(Passport)
	return Sources[parseInt(Passport)] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATATABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Datatable(Passport)
	local Passport = parseInt(Passport)
	local source = vRP.Source(Passport)

	if Characters[source] then
		return Characters[source].Datatable
	else
		return vRP.UserData(Passport,"Datatable")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATATABLEINFORMATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DatatableInformation(Passport,Mode)
	local Passport = parseInt(Passport)

	return vRP.Datatable(Passport)[Mode] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEDATATABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpdateDatatable(Passport,Mode,Value)
	local source = vRP.Source(Passport)
	local Datatable = Characters[source] and vRP.Datatable(Passport) or vRP.UserData(Passport,"Datatable")

	Datatable[Mode] = Value

	if not Characters[source] then
		vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "Datatable", Information = json.encode(Datatable) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Kick(source,Reason)
	if Disconnect(source,Reason) then
		DropPlayer(source,Reason)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function(Reason)
	Disconnect(source,Reason)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Disconnect(source,Reason)
	local Armour = 0
	local Health = 100
	local Coords = SpawnCoords[1]
	local Ped = GetPlayerPed(source)

	if DoesEntityExist(Ped) then
		Armour = GetPedArmour(Ped)
		Health = GetEntityHealth(Ped)
		Coords = GetEntityCoords(Ped)
	end

	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Datatable = vRP.Datatable(Passport)
	if not Datatable then
		return false
	end

	if Arena[Passport] then
		Datatable.Pos = Arena[Passport].Pos
		Datatable.Stress = Arena[Passport].Stress
		Datatable.Hunger = Arena[Passport].Hunger
		Datatable.Thirst = Arena[Passport].Thirst
		Datatable.Armour = Arena[Passport].Armour
		Datatable.Health = Arena[Passport].Health
		Datatable.Inventory = Arena[Passport].Inventory

		local Route = Arena[Passport].Route
		GlobalState["Arena:"..Route] = GlobalState["Arena:"..Route] - 1
		Arena[Passport] = nil
	else
		Datatable.Armour = Armour
		Datatable.Health = Health
		Datatable.Pos = Coords
	end
	
	if DisconnectReason then
		exports.chat:Postit(Passport,Coords,Reason,DisconnectReason)
	end

	local License = vRP.Identities(source)
	TriggerEvent("Disconnect",Passport,source,License)
	vRP.Query("characters/LastLogin",{ Passport = Passport })
	vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "Datatable", Information = json.encode(Datatable) })
	exports["discord"]:Embed("Disconnect","**[SOURCE]:** "..source.."\n**[PASSAPORTE]:** "..Passport.."\n**[VIDA]:** "..Datatable.Health.."\n**[COLETE]:** "..Datatable.Armour.."\n**[COORDS]:** "..Datatable.Pos.."\n**[MOTIVO]:** "..Reason)

	if Characters[source] then
		Characters[source] = nil
	end

	if Sources[Passport] then
		Sources[Passport] = nil
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerConnecting",function(_,__,deferrals)
	deferrals.defer()

	local Source = source
	local License = vRP.Identities(Source)

	local function Present(Card,Fallback)
		if deferrals.presentCard then
			deferrals.presentCard(Card,function()
				deferrals.done()
			end)
		else
			deferrals.done(Fallback)
		end
	end

	local function Generate(Body,Actions)
		return json.encode({ ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json", type = "AdaptiveCard", version = "1.5", body = Body, actions = Actions })
	end

	if not License then
		Present(
			Generate({{ type = "RichTextBlock", inlines = { { type = "TextRun", text = "Não foi possível efetuar conexão com a ", size = "Medium", weight = "Lighter" }, { type = "TextRun", text = "Steam", size = "Medium", weight = "Bolder" }}}}),
			"\n\nNão foi possível efetuar conexão com a Steam."
		)
		return false
	end

	local Account = vRP.Account(License) or ( vRP.Query("accounts/NewAccount", { License = License, Token = vRP.GenerateToken() }) and vRP.Account(License) )

	if Account then
		-- 🔒 NORMALIZA CAMPOS NUMÉRICOS QUE ÀS VEZES VÊM STRING DO DB
		Account.Banned = tonumber(Account.Banned) or 0
		Account.Gemstone = tonumber(Account.Gemstone) or 0
		Account.Whitelist = (Account.Whitelist == true or Account.Whitelist == 1 or Account.Whitelist == "1")

		if Maintenance then
			if Maintenance[License] then
				deferrals.done()
			else
				deferrals.done("\n\nO servidor encontra-se em manutenção.\nPara mais informações, acesse: "..ServerLink)
			end
			return
		end
	end

	if not Account then
		deferrals.done("\n\nNão foi possível efetuar conexão com a " ..(BaseMode == "steam" and "Steam" or "Rockstar") .. ".")
		return false
	end

	local Banned = vRP.Banned(Source,Account)
	if Banned and Account.Banned == -1 then
		local Duration = "Permanente"
		local Reason = Banned[1] == "Other" and (Banned[2] or "Banimento") or (Account.Reason or "Banimento administrativo")

		Present(
			Generate({
				{ type = "Image", url = ServerAvatar or "", size = "Medium", style = "Person" },
				{ type = "RichTextBlock", inlines = {{ type = "TextRun", text = "Consequência: ", size = "Medium", weight = "Bolder" },{ type = "TextRun", text = "Banido", size = "Medium", weight = "Lighter" }} },
				{ type = "RichTextBlock", inlines = {{ type = "TextRun", text = "Tempo: ", size = "Medium", weight = "Bolder" },{ type = "TextRun", text = Duration, size = "Medium", weight = "Lighter" }} },
				{ type = "RichTextBlock", inlines = {{ type = "TextRun", text = "Motivo: ", size = "Medium", weight = "Bolder" },{ type = "TextRun", text = Reason, size = "Medium", weight = "Lighter" }} }
			}),
			Banned[1] == "Other"
				and ("\n\nBanido | "..Banned[2].."\nMotivo unilateral.")
				or ("\n\n<b>Consequência:</b> Banido\n<b>Tempo:</b> "..Duration.."\n<b>Motivo:</b> "..Reason)
		)
		return false
	end

	-- ✅ AQUI: MOSTRA O ID (Account.id) PRA LIBERAR
	if Whitelisted and not Account.Whitelist then
		local PlayerId = tostring(Account.id or "")

		local Card = Generate(
			{
				{
					type = "RichTextBlock",
					inlines = {
						{ type = "TextRun", text = "Efetue sua liberação através do botão abaixo enviando o seu ID: ", wrap = true, size = "Medium", weight = "Lighter" },
						{ type = "TextRun", text = PlayerId, weight = "Bolder", size = "Medium" },
						{ type = "TextRun", text = ".", size = "Medium", weight = "Lighter" }
					}
				}
			},
			{ { type = "Action.OpenUrl", title = "Clique para abrir o Discord", url = ServerLink } }
		)

		Present(Card, "\n\nEfetue sua liberação através do link <b>" ..ServerLink .. "</b> enviando seu <b>ID:</b> <b>" .. PlayerId .. "</b>")
		return
	end

	vRP.Query("accounts/LastLogin",{ License = License })
	deferrals.done()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CharacterChosen(source,Passport,Model)
	Sources[Passport] = source

	if not Characters[source] then
		vRP.Query("characters/LastLogin",{ Passport = Passport })

		local License = vRP.Identities(source)
		local Account = vRP.Account(License)
		local Character = vRP.SingleQuery("characters/Person",{ Passport = Passport })

		Characters[source] = { Datatable = vRP.UserData(Passport,"Datatable") }

		for Index,v in pairs(Account) do
			Characters[source][Index] = v
		end

		for Index,v in pairs(Character) do
			Characters[source][Index] = v
		end

		if Model then
			Characters[source].Datatable.Inventory = {}

			for Item,Amount in pairs(CharacterItens) do
				vRP.GenerateItem(Passport,Item,Amount,false)
			end

			local Table = {
				{ Name = "Barbershop", Information = json.encode(BarbershopInit[Model]) },
				{ Name = "Clothings", Information = json.encode(SkinshopInit[Model]) },
				{ Name = "Tattooshop", Information = json.encode({}) },
				{ Name = "Datatable", Information = json.encode({}) }
			}

			for _,v in ipairs(Table) do
				vRP.Query("playerdata/SetData",{ Passport = Passport, Name = v.Name, Information = v.Information })
			end
		end

		if Account.Gemstone > 0 then
			TriggerClientEvent("hud:AddGemstone",source,Account.Gemstone)
		end

		exports["discord"]:Embed("Connect","**[SOURCE]:** "..source.."\n**[PASSAPORTE]:** "..Passport.."\n**[ADDRESS]:** "..GetPlayerEndpoint(source).."\n**[LICENSE]:** "..Account.License.."\n**[discord:** <@"..Account.Discord..">")

		if DiscordBot then
			exports["discord"]:Content("Rename",Account.Discord.." #"..Passport.." "..Character.Name.." "..Character.Lastname)
		end

		TriggerEvent("CharacterChosen",Passport,source,Model ~= nil)
	else
		DropPlayer(source,"Desconectado")
	end
end