--------------------------------
-- [ CONEXAO ] --
--------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
src = {}
Tunnel.bindInterface("wnBoostv2", src)
vSERVER = Tunnel.getInterface("wnBoostv2")

--------------------------------
-- [ PREPARAR SQL ] --
--------------------------------
Citizen.CreateThread(function()
    Config.Functions.prepare("wnBoost/createTable", [[
        CREATE TABLE IF NOT EXISTS wnBoost_feedbacks (
            id INT AUTO_INCREMENT PRIMARY KEY,
            user_id INT NOT NULL,
            nome VARCHAR(100) NOT NULL,
            imagem TEXT,
            estrelas INT NOT NULL DEFAULT 5,
            status VARCHAR(20) DEFAULT 'ONLINE',
            data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]])
    Config.Functions.execute("wnBoost/createTable", {})
    
    Config.Functions.prepare("wnBoost/insertFeedback", "INSERT INTO wnBoost_feedbacks (user_id, nome, imagem, estrelas, status) VALUES (@user_id, @nome, @imagem, @estrelas, @status)")
    Config.Functions.prepare("wnBoost/getFeedbacks", "SELECT * FROM wnBoost_feedbacks ORDER BY data DESC LIMIT 50")
    Config.Functions.prepare("wnBoost/checkFeedback", "SELECT * FROM wnBoost_feedbacks WHERE user_id = @user_id")
end)

--------------------------------
-- [ FUNCOES DO SERVIDOR ] --
--------------------------------

-- Retorna informações do usuário
function src.informacoes_usuario()
    local source = source
    local user_id = Config.Functions.getUserId(source)
    
    if user_id then
        local nome, nome2 = Config.Functions.get_name(user_id)
        local nome_completo = nome .. " " .. (nome2 or "")
        local imagem = "https://i.imgur.com/nKvFXrG.png" -- Imagem padrão
        local passaporte = user_id
        local nome_cidade = Config.Nome_Cidade
        local estrelas = 0
        
        -- Verificar se já deu feedback
        local feedback = Config.Functions.query("wnBoost/checkFeedback", {user_id = user_id})
        if feedback and feedback[1] then
            estrelas = feedback[1].estrelas or 0
        end
        
        -- Tentar pegar avatar do Discord (se disponível)
        local identifiers = GetPlayerIdentifiers(source)
        for _, identifier in pairs(identifiers) do
            if string.find(identifier, "discord:") then
                local discordId = string.gsub(identifier, "discord:", "")
                -- Você pode implementar uma API para pegar o avatar do Discord aqui
            end
        end
        
        return nome_completo, imagem, passaporte, nome_cidade, estrelas
    end
    
    return "Desconhecido", "https://i.imgur.com/nKvFXrG.png", 0, Config.Nome_Cidade, 0
end

-- Verifica se o jogador tem permissão de admin
function src.verificarPermissao()
    local source = source
    local user_id = Config.Functions.getUserId(source)
    
    if user_id then
        if Config.Functions.hasPermission(user_id, Config.Permissoes['Abrir-painel']) then
            return true
        end
    end
    
    return false
end

-- Retorna informações de admin (contagem de veículos e peds)
function src.informacoes_admin()
    local contagemVehs = 0
    local contagemPeds = 0
    
    -- Contar veículos no servidor
    local vehicles = GetAllVehicles()
    if vehicles then
        contagemVehs = #vehicles
    end
    
    -- Contar peds no servidor (NPCs)
    local peds = GetAllPeds()
    if peds then
        contagemPeds = #peds
    end
    
    return contagemVehs, contagemPeds
end

-- Consulta feedbacks (apenas para carregar)
function src.consultFeedback()
    return true
end

-- Retorna lista de feedbacks
function src.consultList()
    local feedbacks = Config.Functions.query("wnBoost/getFeedbacks", {})
    local lista = {}
    
    if feedbacks then
        for _, feedback in pairs(feedbacks) do
            local status = "OFFLINE"
            local user_source = Config.Functions.getSource(feedback.user_id)
            if user_source then
                status = "ONLINE"
            end
            
            table.insert(lista, {
                user_id = feedback.user_id,
                nome = feedback.nome,
                imagem = feedback.imagem or "https://i.imgur.com/nKvFXrG.png",
                estrelas = feedback.estrelas,
                status = status,
                data = feedback.data
            })
        end
    end
    
    return lista
end

-- Deleta veículos (função admin)
function src.deletar_vehs()
    local source = source
    local user_id = Config.Functions.getUserId(source)
    
    if user_id and Config.Functions.hasPermission(user_id, Config.Permissoes['Abrir-painel']) then
        local vehicles = GetAllVehicles()
        local count = 0
        
        for _, vehicle in pairs(vehicles) do
            local owner = NetworkGetEntityOwner(vehicle)
            if owner then
                DeleteEntity(vehicle)
                count = count + 1
            end
        end
        
        -- Enviar webhook
        enviarWebhook(Config.Webhooks['Deletar'], "Veículos Deletados", "**Admin:** " .. user_id .. "\n**Quantidade:** " .. count .. " veículos deletados", 16711680)
        
        Config.Functions.notify(source, Config.Notify['Sucesso'], "Você deletou " .. count .. " veículos!", 5000)
        
        return true
    end
    
    return false
end

-- Deleta peds (função admin)
function src.deletar_peds()
    local source = source
    local user_id = Config.Functions.getUserId(source)
    
    if user_id and Config.Functions.hasPermission(user_id, Config.Permissoes['Abrir-painel']) then
        local peds = GetAllPeds()
        local count = 0
        
        for _, ped in pairs(peds) do
            if not IsPedAPlayer(ped) then
                DeleteEntity(ped)
                count = count + 1
            end
        end
        
        -- Enviar webhook
        enviarWebhook(Config.Webhooks['Deletar'], "Peds Deletados", "**Admin:** " .. user_id .. "\n**Quantidade:** " .. count .. " peds deletados", 16711680)
        
        Config.Functions.notify(source, Config.Notify['Sucesso'], "Você deletou " .. count .. " peds!", 5000)
        
        return true
    end
    
    return false
end

-- Registra feedback do usuário
function src.feedback(quantidade)
    local source = source
    local user_id = Config.Functions.getUserId(source)
    
    if user_id then
        local nome, nome2 = Config.Functions.get_name(user_id)
        local nome_completo = nome .. " " .. (nome2 or "")
        local imagem = "https://i.imgur.com/nKvFXrG.png"
        
        -- Verificar se já deu feedback
        local feedback_existente = Config.Functions.query("wnBoost/checkFeedback", {user_id = user_id})
        
        if feedback_existente and feedback_existente[1] then
            Config.Functions.notify(source, Config.Notify['Aviso'], "Você já enviou um feedback anteriormente!", 5000)
            return false
        end
        
        -- Inserir feedback
        Config.Functions.execute("wnBoost/insertFeedback", {
            user_id = user_id,
            nome = nome_completo,
            imagem = imagem,
            estrelas = quantidade,
            status = "ONLINE"
        })
        
        -- Enviar webhook
        local estrelas_emoji = string.rep("⭐", quantidade)
        enviarWebhook(Config.Webhooks['Feedbacks'], "Novo Feedback Recebido", "**Jogador:** " .. nome_completo .. "\n**Passaporte:** " .. user_id .. "\n**Avaliação:** " .. estrelas_emoji .. " (" .. quantidade .. "/5)", 65280)
        
        Config.Functions.notify(source, Config.Notify['Sucesso'], "Obrigado pelo seu feedback!", 5000)
        
        return true
    end
    
    return false
end

--------------------------------
-- [ FUNCAO WEBHOOK ] --
--------------------------------
function enviarWebhook(webhook, titulo, descricao, cor)
    if webhook and webhook ~= "" then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
            username = "wnBoost - FPS System",
            embeds = {{
                title = titulo,
                description = descricao,
                color = cor or 65280,
                footer = {
                    text = "wnBoost - Sistema de Otimização | " .. os.date("%d/%m/%Y %H:%M:%S")
                }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
end

--------------------------------
-- [ COMANDO ADMIN ] --
--------------------------------
RegisterCommand("abrirfps", function(source, args)
    local user_id = Config.Functions.getUserId(source)
    if user_id then
        TriggerClientEvent("wnBoost:abrir", source)
    end
end)

print("^2[wnBoost]^0 Script de otimização carregado com sucesso!")

