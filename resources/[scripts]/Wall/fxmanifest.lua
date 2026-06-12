fx_version 'cerulean'
game 'gta5'
lua54 'yes'

shared_scripts {
    '@vrp/lib/Utils.lua',
    'lib/tunnel.lua',
    'config.lua'
}

client_scripts {
    'client/client-wall.lua'
}

server_scripts {
    'server/server-wall.lua'
}

dependency 'keyboard'
