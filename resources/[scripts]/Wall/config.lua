config = config or {}

-- Na sua base Creative, normalmente a permissão correta é "Admin".
-- Se quiser liberar só para cargos específicos, deixe apenas os nomes desejados aqui.
config.perms = {
    "Admin",
    "Moderador",
    "Suporte",
    "Ajudante",
    "admin.permissao"
}

config.command = "wall"
config.myinfo = true

function IDsEQPG(source)
    if vRP.Passport then
        return vRP.Passport(source)
    end

    if vRP.getUserId then
        return vRP.getUserId(source)
    end

    return false
end

function UsersEQPG(user_id)
    if vRP.Source then
        return vRP.Source(user_id)
    end

    if vRP.getUserSource then
        return vRP.getUserSource(user_id)
    end

    return false
end

function GroupsEQPG(user_id)
    if vRP.UserGroups then
        return vRP.UserGroups(user_id)
    end

    if vRP.getUserGroups then
        return vRP.getUserGroups(user_id)
    end

    return {}
end

function PermEQPG(user_id,permission)
    if vRP.HasPermission then
        return vRP.HasPermission(user_id,permission)
    end

    if vRP.hasPermission then
        return vRP.hasPermission(user_id,permission)
    end

    return false
end

function hasGroupEQPG(user_id,group)
    if vRP.HasPermission then
        return vRP.HasPermission(user_id,group)
    end

    if vRP.hasGroup then
        return vRP.hasGroup(user_id,group)
    end

    return false
end

function NameEQPG(user_id)
    if vRP.FullName then
        return vRP.FullName(user_id)
    end

    if vRP.Identity then
        local identity = vRP.Identity(user_id)
        if identity then
            return tostring(identity.Name or identity.name or "").." "..tostring(identity.Lastname or identity.name2 or identity.firstname or "")
        end
    end

    if vRP.getUserIdentity then
        local identity = vRP.getUserIdentity(user_id)
        if identity then
            return tostring(identity.name or identity.Name or "").." "..tostring(identity.firstname or identity.Lastname or "")
        end
    end

    return "N/E"
end

-- Painel de configuração no jogo: /wallconfig ou F7.
-- Precisa do resource keyboard iniciado na base.
