fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
	"client-side/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server-side/*"
}

shared_scripts {
    "shared-side/*",
    'node_modules/.bin/app.js'
}

files {
	"web-side/*",
	"web-side/**/*"
}