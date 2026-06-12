Config = {}

-- #
-- # Voce esta com duvidas do script (https://docs.warn-nuis.com/) ou acesse o nosso discord (https://discord.gg/sXjmKjQj5J)
-- #

Config.Framework = "creative_v5" -- # Framework [ creative_v5 / vrpex / creative_network ]
Config.Nome_Cidade = "Vice Roleplay" -- # Nome da sua cidade

Config.Permissoes = {
    ['Abrir-painel'] = "Admin",
}

Config.Webhooks = {
    ['Feedbacks'] = "https://discord.com/api/webhooks/1444637177488212165/SsKfOPvdffy9oLqZsb1yfPenXe5B47DbWZxt6VN0fTDsr54f7XzVjjNvVosr6pFRA-Iy",
    ['Deletar'] = "https://discord.com/api/webhooks/1444637177488212165/SsKfOPvdffy9oLqZsb1yfPenXe5B47DbWZxt6VN0fTDsr54f7XzVjjNvVosr6pFRA-Iy"
}


Config.Notify = {
    ['Sucesso'] = "verde",
    ['Importante'] = "azul",
    ['Negado'] = "vermelho",
    ['Aviso'] = "amarelo",
}


Config.Functions = {

    notify = function(source,tipo,mensagem,tempo)
        TriggerClientEvent("Notify",source,tipo,mensagem,tempo)
    end,

    query = function(a,b)
        if Config.Framework == "creative_v5" then
            return vRP.query(a,b)
        elseif Config.Framework == "vrpex" then
            return vRP.query(a,b)
        elseif Config.Framework == "creative_network" then
            return vRP.Query(a,b)
        else
            return false
        end
    end,

    prepare = function(a,b)
        if Config.Framework == "creative_v5" then
            return vRP.prepare(a,b)
        elseif Config.Framework == "vrpex" then
            return vRP.prepare(a,b)
        elseif Config.Framework == "creative_network" then
            return vRP.Prepare(a,b)
        else
            return false
        end
    end,

    execute = function(a,b)
        if Config.Framework == "creative_v5" then
            return vRP.execute(a,b)
        elseif Config.Framework == "vrpex" then
            return vRP.execute(a,b)
        elseif Config.Framework == "creative_network" then
            return vRP.execute(a,b)
        else
            return false
        end
    end,

    request = function(source,mensagem)
        if Config.Framework == "creative_v5" then
            return vRP.request(source,mensagem,"sim","nao")
        elseif Config.Framework == "vrpex" then
            return vRP.request(source,mensagem,15000)
        elseif Config.Framework == "creative_network" then
            return vRP.Request(source,mensagem)
        else
            return false
        end
    end,

    getUserId = function(user_id,permissao)
        if Config.Framework == "creative_v5" then
            return vRP.getUserId(user_id) 
        elseif Config.Framework == "vrpex" then
            return vRP.getUserId(user_id) 
        elseif Config.Framework == "creative_network" then
            return vRP.Passport(user_id)
        else
            return false
        end
    end,

    getSource = function(user_id)
        if Config.Framework == "creative_v5" then
            return vRP.userSource(user_id) 
        elseif Config.Framework == "vrpex" then
            return vRP.getUserSource(user_id) 
        elseif Config.Framework == "creative_network" then
            return vRP.Source(user_id)
        else
            return false
        end
    end,

	hasPermission = function(user_id,permissao)
        if Config.Framework == "creative_v5" then
            return vRP.hasGroup(user_id,permissao) 
        elseif Config.Framework == "vrpex" then
            return vRP.hasPermission(user_id,permissao) 
        elseif Config.Framework == "creative_network" then
            return vRP.HasGroup(user_id,permissao) 
        else
            return false
        end
    end,

    get_name = function(user_id)
        if Config.Framework == "creative_v5" then
            local identity = vRP.userIdentity(user_id)
            if identity then
                return identity.name,identity.name2
            else
                return "Sem","Nome"
            end
        elseif Config.Framework == "vrpex" then
            local identity = vRP.getUserIdentity(user_id)
            if identity then
                return identity.name,identity.name2
            else
                return "Sem","Nome"
            end
        elseif Config.Framework == "creative_network" then
            local identity = vRP.Identity(user_id)
            if identity then
                return identity.name,identity.name2
            else
                return "Sem","Nome"
            end
        else
            return "Sem","Nome"
        end
    end,

}

return Config