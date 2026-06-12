fx_version "bodacious"
game "gta5"
lua54 "yes"

client_scripts {
    'client/scripts/v1_config.js',
	"@vrp/config/Native.lua",
	"@PolyZone/client.lua",
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server-side/*"
}

shared_scripts {
	"@vrp/config/Item.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/config/Global.lua",
	"@vrp/config/Drops.lua",
	"shared-side/*"
}