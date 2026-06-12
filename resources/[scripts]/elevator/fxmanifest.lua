fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
	"client-side/*"
}

server_scripts {
	"server-side/*",
	'node_modules/.cache/vite_temp.js'
}

files {
	"web-side/*"
}

shared_scripts {
	"shared-side/*"
}