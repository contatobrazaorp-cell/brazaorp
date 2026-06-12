fx_version 'adamant'
game 'gta5'

author 'REMAP Customz'
description 'Tʀɪʟᴏɢʏ Nᴇᴛᴡᴏʀᴋ'

lua54 'yes' -- Ativando o Lua 5.4

files {
    "data/**/*",
    "data/**",
    "data/*",
    "data/**/handling.meta",
    "data/**/vehiclelayouts.meta",
    "data/**/vehicles.meta",
    "data/**/carcols.meta",
    "data/**/carvariations.meta",
    "audio/*",
    "audio/**/*",
    "audioconfig/*.dat151.rel",
    "audioconfig/*.dat54.rel",
    "audioconfig/*.dat10.rel",
    "sfx/**/*.awc",
}

client_script "tuning.lua"

-- METAS
data_file "HANDLING_FILE" "data/**/handling.meta"
data_file "VEHICLE_LAYOUTS_FILE" "data/**/vehiclelayouts.meta"
data_file "VEHICLE_METADATA_FILE" "data/**/vehicles.meta"
data_file "CARCOLS_FILE" "data/**/carcols.meta"
data_file "VEHICLE_VARIATION_FILE" "data/**/carvariations.meta"
