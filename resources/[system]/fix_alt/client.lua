-- Fix v3 (mais agressivo):
-- Problema: às vezes o mouse/cursor fica preso na tela (NUI focus ficou ligado em algum resource).
-- Solução:
-- 1) Mantém a regra: ALT não libera mouse; só libera após clique (LMB) por uma janela curta.
-- 2) Se o jogo detectar que o NUI está focado (IsNuiFocused()) fora dessa janela, força SetNuiFocus(false,false).
-- 3) Também limpa foco quando o player abre o mapa/pausa (evita ficar "travado" após menus).

local altWindowUntil = 0
local allowFocusUntil = 0

local function altDown()
    return IsControlPressed(0, 19) or IsDisabledControlPressed(0, 19) or
           IsControlPressed(0, 346) or IsDisabledControlPressed(0, 346)
end

local function canAllowFocus(now)
    return now <= allowFocusUntil
end

CreateThread(function()
    while true do
        local idle = 150
        local now = GetGameTimer()

        -- Se abriu pause/mapa, sempre limpa foco (pra não ficar mouse preso)
        if IsPauseMenuActive() then
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
            allowFocusUntil = 0
            altWindowUntil = 0
            Wait(200)
            goto continue
        end

        if altDown() then
            idle = 0
            altWindowUntil = now + 1500

            -- clique esquerdo libera foco por um curto tempo (pra clicar na opção)
            if IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24) then
                allowFocusUntil = now + 900
            end
        end

        -- Enquanto estiver na janela do ALT, bloqueia foco fora da janela de clique
        if now < altWindowUntil and not canAllowFocus(now) then
            idle = 0
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
        end

        -- "Limpeza" geral: se NUI estiver focado quando não deveria, desliga (isso resolve o cursor preso)
        if IsNuiFocused() and not canAllowFocus(now) then
            idle = 0
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)
        end

        ::continue::
        Wait(idle)
    end
end)

-- Tecla de emergência (F7) pra limpar foco se travar.
RegisterCommand("fixmouse", function()
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
end, false)

RegisterKeyMapping("fixmouse", "Fix: liberar mouse travado (limpa NUI focus)", "keyboard", "F7")
