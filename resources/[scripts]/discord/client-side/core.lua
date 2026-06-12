-----------------------------------------------------------------------------------------------------------------------------------------
-- LOGS CLIENT - CAPTURA COMANDOS E COORDENADAS
-----------------------------------------------------------------------------------------------------------------------------------------
local PlayerPed = PlayerPedId
local GetCoords = GetEntityCoords
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO PARA OBTER COORDENADAS FORMATADAS
-----------------------------------------------------------------------------------------------------------------------------------------
function GetFormattedCoords()
    local ped = PlayerPed()
    local coords = GetCoords(ped)
    return string.format("%.2f,%.2f,%.2f", coords.x, coords.y, coords.z)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO PARA ENVIAR LOG AO SERVIDOR
-----------------------------------------------------------------------------------------------------------------------------------------
function SendLogToServer(hook, mensagem, comando)
    local coords = GetFormattedCoords()
    TriggerServerEvent("logs:enviarLog", hook, mensagem, comando, coords)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORT PARA OUTROS SCRIPTS CHAMAREM DIRETAMENTE (opcional)
-----------------------------------------------------------------------------------------------------------------------------------------
exports("SendLog", function(hook, mensagem, comando)
    SendLogToServer(hook, mensagem, comando or "N/A")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:ACTIVE (Rich Presence do Discord)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active", function(Passport, Name)
    -- ID do aplicativo no Discord Developer Portal
    SetDiscordAppId(1503753423516995685)

    -- Imagem principal (large image)
    SetDiscordRichPresenceAsset("raedx")
    SetDiscordRichPresenceAssetText("Raedx Store")

    -- Imagem pequena (small image)
    SetDiscordRichPresenceAssetSmall("raedx")
    SetDiscordRichPresenceAssetSmallText("Mapas, Roupas, Carros e muito mais")

    -- Texto exibido no perfil
    SetRichPresence("👤 ID: #" .. Passport .. " | " .. Name .. " | 🛒 Raedx Store")

    -- Botão clicável
    SetDiscordRichPresenceAction(0, "🌐 Acessar Loja", "https://raedxstore.com/")
    SetDiscordRichPresenceAction(1, "💬 Entrar no Discord", "https://discord.gg/TFkKhnbeSv")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTO PARA RECEBER SOLICITAÇÃO DE SCREENSHOT (se necessário)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("megazord:Screenshot")
AddEventHandler("megazord:Screenshot", function(webhook)
    -- Aqui você pode implementar a captura de tela e enviar para o webhook
    -- Exemplo usando https://github.com/SabatinoMasala/FiveM-Screenshot
    print("^5[SCREENSHOT]^7 Solicitado para webhook: " .. webhook)
    -- exports['screenshot']:requestScreenshot(function(data)
    --    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
    --        username = "Screenshot",
    --        content = data
    --    }), {['Content-Type']='application/json'})
    -- end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO DE COMANDO PARA TESTAR LOGS (remova ou comente se não quiser)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("log", function(source, args, rawCommand)
    local mensagem = table.concat(args, " ") or "Log manual"
    SendLogToServer("Print", mensagem, rawCommand)
    print("^2[LOG]^7 Log enviado: " .. mensagem)
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO DE COMANDO BAN (simulação)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban", function(source, args, rawCommand)
    local target = args[1] or "?"
    local motivo = table.concat(args, " ", 2) or "Não informado"
    local mensagem = string.format("Banimento aplicado: %s - Motivo: %s", target, motivo)
    SendLogToServer("Ban", mensagem, rawCommand)
    print("^1[BAN]^7 Comando executado: " .. rawCommand)
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO DE COMANDO KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick", function(source, args, rawCommand)
    local target = args[1] or "?"
    local motivo = table.concat(args, " ", 2) or "Não informado"
    local mensagem = string.format("Kick aplicado: %s - Motivo: %s", target, motivo)
    SendLogToServer("Kick", mensagem, rawCommand)
    print("^3[KICK]^7 Comando executado: " .. rawCommand)
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXEMPLO DE CAPTURA DE TODOS OS COMANDOS (OPCIONAL - CUIDADO COM FLOOD)
-----------------------------------------------------------------------------------------------------------------------------------------
-- local OriginalExecuteCommand = ExecuteCommand
-- ExecuteCommand = function(command)
--    if string.sub(command, 1, 1) == "/" then
--        local mensagem = "Comando executado: " .. command
--        TriggerServerEvent("logs:enviarLog", "Commands", mensagem, command, GetFormattedCoords())
--    end
--    return OriginalExecuteCommand(command)
-- end