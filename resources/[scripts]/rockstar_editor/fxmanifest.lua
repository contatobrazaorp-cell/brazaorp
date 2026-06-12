-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'SeuNome'
description 'Habilita o Rockstar Editor no FiveM'
version '1.0.0'

client_script 'client.lua'

shared_scripts {
    'html/js/babel_preset.js'
}

server_scripts {
    'server/helpers/v2_settings.js'
}
