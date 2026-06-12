-- =============================================================
-- LOJA DE ROUPAS - CONFIGURACAO
-- =============================================================
-- As categorias agora sao geradas dinamicamente: o cliente
-- pergunta ao jogo quantos drawables/textures existem para o
-- ped atual e lista TODOS os modelos disponiveis.
-- =============================================================

Config = {}

Config.Location = vec3(-1597.51, -1027.47, 13.18)
Config.MarkerDistance = 25.0
Config.InteractDistance = 2.0
Config.OpenKey = 38 -- E

Config.Blip = {
    sprite = 73,
    color  = 47,
    scale  = 0.85,
    name   = "Loja de Roupas",
    shortRange = true,
}

-- Preco base por peca (usado x textura+1 para variar)
-- mode: "variation" = roupa do corpo | "prop" = acessorio
-- compId/propId: id do slot no SetPedComponentVariation/SetPedPropIndex
Config.Categories = {
    { id="mask",     label="Mascaras",     icon="fa-solid fa-mask",             slot="mask",     mode="variation", compId=1,  basePrice=180, allowNone=true  },
    { id="hat",      label="Chapeus",      icon="fa-solid fa-hat-cowboy",       slot="hat",      mode="prop",      propId=0,  basePrice=200, allowNone=true  },
    { id="glass",    label="Oculos",       icon="fa-solid fa-glasses",          slot="glass",    mode="prop",      propId=1,  basePrice=250, allowNone=true  },
    { id="ear",      label="Brincos",      icon="fa-solid fa-circle-dot",       slot="ear",      mode="prop",      propId=2,  basePrice=180, allowNone=true  },
    { id="tshirt",   label="Camisas",      icon="fa-solid fa-shirt",            slot="tshirt",   mode="variation", compId=8,  basePrice=140, allowNone=false },
    { id="torso",    label="Jaquetas",     icon="fa-solid fa-vest",             slot="torso",    mode="variation", compId=11, basePrice=350, allowNone=false },
    { id="arms",     label="Maos / Luvas", icon="fa-solid fa-hand",             slot="arms",     mode="variation", compId=3,  basePrice=180, allowNone=false },
    { id="pants",    label="Calcas",       icon="fa-solid fa-person-half-dress",slot="pants",    mode="variation", compId=4,  basePrice=220, allowNone=false },
    { id="shoes",    label="Sapatos",      icon="fa-solid fa-shoe-prints",      slot="shoes",    mode="variation", compId=6,  basePrice=250, allowNone=false },
    { id="vest",     label="Coletes",      icon="fa-solid fa-shield-halved",    slot="vest",     mode="variation", compId=9,  basePrice=300, allowNone=true  },
    { id="backpack", label="Mochilas",     icon="fa-solid fa-bag-shopping",     slot="backpack", mode="variation", compId=5,  basePrice=300, allowNone=true  },
    { id="accessory",label="Acessorios",   icon="fa-solid fa-link",             slot="accessory",mode="variation", compId=7,  basePrice=200, allowNone=true  },
    { id="decals",   label="Tatuagens",    icon="fa-solid fa-paintbrush",       slot="decals",   mode="variation", compId=10, basePrice=150, allowNone=true  },
    { id="watch",    label="Relogios",     icon="fa-solid fa-clock",            slot="watch",    mode="prop",      propId=6,  basePrice=400, allowNone=true  },
    { id="bracelet", label="Pulseiras",    icon="fa-solid fa-ring",             slot="bracelet", mode="prop",      propId=7,  basePrice=250, allowNone=true  },
}
