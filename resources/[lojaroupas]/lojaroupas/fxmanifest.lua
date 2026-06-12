fx_version "bodacious"
game "gta5"
lua54 "yes"

author "RADEX STORE"
description "Loja de Roupas - Catalogo moderno com preview e compra"
version "1.0.0"

ui_page "web-side/index.html"

client_scripts {
    "@vrp/config/Native.lua",
    "@vrp/lib/Utils.lua",
    "config.lua",
    "client-side/*"
}

server_scripts {
    "@vrp/lib/Utils.lua",
    "config.lua",
    "server-side/*"
}

shared_scripts {
    "@vrp/config/Item.lua",
    "@vrp/config/Vehicle.lua",
    "@vrp/config/Global.lua",
    "@vrp/config/Drops.lua"
}

files {
    "web-side/index.html",
    "web-side/style.css",
    "web-side/script.js",
    "web-side/images/*.png",
    "web-side/images/*.jpg"
}
