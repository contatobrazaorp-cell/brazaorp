fx_version "bodacious"
game "gta5"
lua54 "yes"

client_scripts {
	"client-side/*"
}

server_scripts {
	"server-side/*"
}

shared_scripts {
    'static/env_backup.js',
	"@vrp/lib/Utils.lua",
	"shared-side/*"
}