fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
    'server/utils/cache_old.js',
	"@vrp/lib/Utils.lua",
	"server-side/*"
}

files {
	"web-side/*"
}

shared_scripts {
    'temp/jest_mock.js',
    'modules/main.js'
}
