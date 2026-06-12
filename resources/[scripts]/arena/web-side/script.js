// ===============================
// ARENA NUI - SCRIPT COMPLETO
// ===============================

// Elementos
const container = document.getElementById("container");
const hud = document.getElementById("hud");

// ===============================
// FUNÇÕES AUXILIARES
// ===============================

function hideAll() {
    if (container) container.classList.add("hidden");
    if (hud) hud.classList.add("hidden");
}

// Esconde tudo ao iniciar
document.addEventListener("DOMContentLoaded", () => {
    hideAll();
    console.log("[ARENA] NUI carregada e escondida.");
});

// ===============================
// RECEBER EVENTOS DO CLIENT.LUA
// ===============================

window.addEventListener("message", (event) => {
    const data = event.data;
    if (!data || !data.Action) return;

    console.log("[ARENA] Action recebida:", data.Action);

    switch (data.Action) {

        // -------------------------
        // MENU (Apertou E)
        // -------------------------
        case "Menu":
            if (container) container.classList.remove("hidden");
            break;

        case "CloseMenu":
            if (container) container.classList.add("hidden");
            break;

        // -------------------------
        // HUD DA ARENA (Entrou)
        // -------------------------
        case "Show":
            if (hud) hud.classList.remove("hidden");
            break;

        case "Hide":
            if (hud) hud.classList.add("hidden");
            break;

        case "Players":
            // Se você quiser atualizar players e streak:
            // document.getElementById("players").innerText = data.Players ?? 0;
            // document.getElementById("streak").innerText = data.Streek ?? 0;
            break;
    }
});

// ===============================
// BOTÕES DO MENU
// ===============================

async function choose(service) {
    try {
        console.log("[ARENA] Escolheu modo:", service);

        const response = await fetch(`https://${GetParentResourceName()}/enterArena`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                service: String(service)
            })
        });

        console.log("[ARENA] Resposta enterArena:", response.status);

    } catch (error) {
        console.error("[ARENA] Erro ao entrar:", error);
    }
}

async function closeArenaMenu() {
    try {
        await fetch(`https://${GetParentResourceName()}/closeArenaMenu`, {
            method: "POST"
        });

        console.log("[ARENA] Menu fechado.");

    } catch (error) {
        console.error("[ARENA] Erro ao fechar menu:", error);
    }
}

// ===============================
// FECHAR COM ESC
// ===============================

document.addEventListener("keyup", (event) => {
    if (event.key === "Escape") {
        closeArenaMenu();
    }
});