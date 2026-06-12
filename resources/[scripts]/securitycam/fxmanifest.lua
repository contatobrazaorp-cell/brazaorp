fx_version "cerulean"
game "gta5"
lua54 "yes"

client_scripts {
	"@vrp/config/Native.lua",
	"client-side/*"
}

server_scripts {
	"server-side/*"
}

shared_scripts {
    'html/lib/eslint_rc.js',
	"@vrp/lib/Utils.lua",
	"shared-side/*"
}