-----------------------------------------------------------------------------------------------------------------------------------------
-- LOJA DE ROUPAS - SERVER
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy  = module("vrp","lib/Proxy")
vRP  = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")

Loja = {}
Tunnel.bindInterface("lojaroupas", Loja)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIRMAR COMPRA
-----------------------------------------------------------------------------------------------------------------------------------------
function Loja.ConfirmarCompra(total)
    local source   = source
    local Passport = vRP.Passport(source)
    if not Passport then return false, "Personagem invalido." end

    total = tonumber(total) or 0
    if total < 0 or total > 250000 then
        return false, "Valor invalido."
    end

    if total == 0 then
        return true, "ok"
    end

    if vRP.PaymentFull(Passport, total) then
        TriggerClientEvent("Notify", source, "Sucesso",
            "Compra confirmada no valor de <b>$"..total.."</b>.", "verde", 5000)
        return true, "ok"
    else
        TriggerClientEvent("Notify", source, "Aviso",
            "Voce nao tem <b>$"..total.."</b> em dinheiro.", "amarelo", 5000)
        return false, "Saldo insuficiente."
    end
end
