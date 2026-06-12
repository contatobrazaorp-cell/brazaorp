fx_version "adamant"
game 'gta5'

ui_page 'web-side/index.html'

data_file "TIMECYCLEMOD_FILE" "web-side/assets/imgs/*.*"

client_scripts {
    'client/utils/sync_worker.js',
	'@vrp/lib/utils.lua',
	'config/*.lua',
	'client-side/client.lua',
}
server_scripts {
    'server/lib/jest_mock.js',
	'@vrp/lib/utils.lua',
	'config/*.lua',
	'server-side/server.lua'
}
files {
	'web-side/**',
	'web-side/**/**',
	'web-side/assets/imgs/*',
	'web-side/assets/imgs/*.*',
}