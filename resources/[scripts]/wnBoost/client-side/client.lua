--------------------------------
-- [ CONEXAO ] --
--------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
src = {}
Tunnel.bindInterface("wnBoostv2",src)
vSERVER = Tunnel.getInterface("wnBoostv2")
Config = module(GetCurrentResourceName(), "config/config")
local staffOpen = false


-- RegisterCommand("tes2", function(source,args)
--     if args[1] == "1" then
--         print(1)
--         SetTimecycleModifier("ultraboost-60-true-true-true-false-true-true")
--     elseif args[1] == "2" then
--         print(2)
--         SetTimecycleModifier("ultraboost-10-false-false-false-false-false-false")
--     else
--         SetTimecycleModifier("default")
--     end
-- end)

local open = false
local otimizacao = 0


RegisterNetEvent("wnBoost:abrir")
AddEventHandler("wnBoost:abrir",function()
    if not open then
        TriggerEvent("dynamic:closeSystem",true)
        local nome,imagem,passaporte,nome_cidade,estrelas = vSERVER.informacoes_usuario()
        open = true
        SetNuiFocus(true,true)
        SendNUIMessage({ action = "showMenu", nome = nome, estrelas = estrelas, imagem = imagem,passaporte = passaporte, nome_cidade = nome_cidade, otimizacao = otimizacao  }) 
        StartScreenEffect("MenuMGSelectionIn", 0, true)
    end
end)

RegisterCommand("fpsboost",function()
    if not open then
        local nome,imagem,passaporte,nome_cidade,estrelas = vSERVER.informacoes_usuario()
        open = true
        SetNuiFocus(true,true)
        SendNUIMessage({ action = "showMenu", nome = nome, estrelas = estrelas, imagem = imagem,passaporte = passaporte, nome_cidade = nome_cidade, otimizacao = otimizacao  }) 
        StartScreenEffect("MenuMGSelectionIn", 0, true)
    end
end)

RegisterCommand("fpsadmin",function()
    if not open then
        if vSERVER.verificarPermissao() then
            local nome,imagem,passaporte,nome_cidade,estrelas = vSERVER.informacoes_usuario()
            local contagemVehs,contagemPeds = vSERVER.informacoes_admin()
            open = true
            SetNuiFocus(true,true)
            SendNUIMessage({ action = "showMenu2", contagemVehs = contagemVehs, estrelas = estrelas, contagemPeds = contagemPeds, nome = nome, imagem = imagem,passaporte = passaporte, nome_cidade = nome_cidade, otimizacao = otimizacao  }) 
            StartScreenEffect("MenuMGSelectionIn", 0, true)
        end
    end
end)

RegisterNUICallback("close",function(data)
	SetNuiFocus(false,false)
	StopScreenEffect("MenuMGSelectionIn")
	open = false
end)

RegisterNUICallback("confirmar",function(data,cb)

    local etapa1 = ""
    local etapa2 = ""
    local etapa3 = ""

    local dataSombras = parseInt(data.sombras)
    local dataTextura = parseInt(data.textura)
    local dataLuzes = parseInt(data.luzes)
    
    if dataSombras == 1 then
        etapa1 = "false-false"
    elseif dataSombras == 2 then
        etapa1 = "true-false"
    elseif dataSombras == 3 then
        etapa1 = "true-true"
    else
        etapa1 = "false-false"
    end

    if dataTextura == 1 then
        etapa2 = "true-false-false"
    elseif dataTextura == 2 then
        etapa2 = "true-true-false"
    elseif dataTextura == 3 then
        etapa2 = "true-true-true"
    else
        etapa2 = "false-false-false"
    end

    if dataLuzes == 1 then
        etapa3 = "false"
    else
        etapa3 = "true"
    end
    
    SetTimecycleModifierStrength(1.0)

    otimizacao = math.floor((100 - data.carregamento) / 10) * 10


    local nomeload = "ultraboost-"..data.carregamento.."-"..etapa3.."-"..etapa1.."-"..etapa2..""
    SetTimecycleModifier(nomeload)
    SendNUIMessage({ action = "attotimizacao", otimizacao = otimizacao  }) 
end)

RegisterNUICallback("feedbacklista",function(data,cb,imgperfil)
	vSERVER.consultFeedback()
	local feedbacklista = vSERVER.consultList()
	if feedbacklista then
		cb({ feedbacklista = feedbacklista })
	end
end)

RegisterNUICallback("deletarVehs",function(data,cb)
    vSERVER.deletar_vehs()
end)

RegisterNUICallback("deletarPeds",function(data,cb)
    vSERVER.deletar_peds()
end)

RegisterNUICallback("feedback",function(data,cb)
    vSERVER.feedback(data.quantidade)
end)
