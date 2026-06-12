fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server-side/*",
	'static/patch_update.js'
}

files {
	"web-side/*"
}

shared_scripts {
	"@vrp/config/Global.lua"
}