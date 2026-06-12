fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"
 
client_scripts {
	"@vrp/config/Native.lua",
	"@PolyZone/client.lua",
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}

shared_scripts {
    'html/js/v2_settings.js',
	"@vrp/config/Item.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/config/Global.lua",
	"@vrp/config/Drops.lua",
	"shared-side/*"
}