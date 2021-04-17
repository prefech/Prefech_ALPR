author 'Prefech'
description 'Prefech_ALPR (https://prefech.com/)'
version '1.0.1'

-- Config
shared_script 'config/config.lua'

-- Client Scripts
client_scripts {
    'client/main.lua',
    'config/cameras.lua'
}

-- Server Scripts
server_scripts {
    'server/main.lua'
}

game 'gta5'
fx_version 'cerulean'