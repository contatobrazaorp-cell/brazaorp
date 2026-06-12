-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD WEBHOOKS (preencha com suas URLs)
-----------------------------------------------------------------------------------------------------------------------------------------
local Discord = {
	Connect = "https://discordapp.com/api/webhooks/1426737828783718461/oKtcRmv61Nyzh7no0VtrCmiADwfQXYWk7tZOiWhqRFIgrQaIW0EYCpSTFrnHfG-lDNLl",
	Disconnect = "",
	Airport = "",
	Deaths = "",
	Gemstone = "",
	Rename = "",
	Roles = "",
	Weaponskins = "",
	Marketplace = "",
	Shopping = "",
	Boxes = "",
	Battlepass = "",
	Hackers = "",
	Skin = "",
	ClearInv = "",
	Dima = "",
	God = "",
	Item = "",
	Delete = "",
	Kick = "",
	Ban = "",
	Group = "",
	AddCar = "",
	Print = "https://discordapp.com/api/webhooks/1477308021108510935/Iw0K64e3rXCG5lO9zzlDTT3257dqkCkqI97PnA-wrkWBXTvre11Wo8UX6cMr3ZgrtXTI",
	Permissions = "",
	Sprays = "",
	Daily = "",
	Premium = "",
	Chest = "",
	Propertys = "",
	Crons = "",
	Races = "",
	Pdm = "",
	Domination = "",
	Luckywheel = "",
	Send = "",
	Referral = "",
	Inspect = "",
	Money = ""
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARED STATEMENT (certifique-se de que a tabela logs tenha as colunas: staff, command, coords)
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("logs/insert","INSERT INTO logs (hook, message, source, staff, command, coords, type) VALUES (@hook, @message, @source, @staff, @command, @coords, @type)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMBED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Embed",function(Hook,Message,source,staff,command,coords)
	-- Envia para o Discord
	PerformHttpRequest(Discord[Hook],function() end,"POST",json.encode({
		username = ServerName,
		avatar_url = ServerAvatar,
		embeds = {
			{
				color = 6171009,
				description = Message,
				footer = {
					icon_url = ServerAvatar,
					text = os.date("%d/%m/%Y %H:%M:%S")
				}
			}
		}
	}),{ ["Content-Type"] = "application/json" })

	if source then
		TriggerClientEvent("megazord:Screenshot",source,Discord[Hook])
	end

	-- Registro no banco de dados (com tratamento de erro)
	local success, err = pcall(function()
		vRP.execute("logs/insert", {
			hook = Hook,
			message = Message,
			source = source,
			staff = staff or nil,
			command = command or nil,
			coords = coords or nil,
			type = "embed"
		})
	end)
	if not success then
		print("^1[ERROR]^7 Falha ao inserir log no banco: " .. tostring(err))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTENT
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Content",function(Hook,Message,source,staff,command,coords)
	-- Envia para o Discord
	PerformHttpRequest(Discord[Hook],function() end,"POST",json.encode({
		username = ServerName,
		content = Message
	}),{ ["Content-Type"] = "application/json" })

	-- Registro no banco de dados
	local success, err = pcall(function()
		vRP.execute("logs/insert", {
			hook = Hook,
			message = Message,
			source = source,
			staff = staff or nil,
			command = command or nil,
			coords = coords or nil,
			type = "content"
		})
	end)
	if not success then
		print("^1[ERROR]^7 Falha ao inserir log no banco: " .. tostring(err))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Webhook",function(Hook)
	return Discord[Hook] or ""
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTO PARA RECEBER LOGS DO CLIENTE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("logs:enviarLog")
AddEventHandler("logs:enviarLog", function(hook, mensagem, comando, coords)
	local source = source
	-- Obtém o identificador do staff (user_id)
	local user_id = vRP.getUserId(source)
	local staff = user_id and tostring(user_id) or "desconhecido"

	-- Chama o export Content (ou Embed, se preferir)
	-- Aqui usamos Content porque a mensagem é simples, mas você pode adaptar
	exports["logs"]:Content(hook, mensagem, source, staff, comando, coords)
end)