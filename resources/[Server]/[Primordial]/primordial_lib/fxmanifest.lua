fx_version 'cerulean'

game 'gta5'

author 'Primordial Studio'

description 'A library of shared functions to utilise in other resources to make development easier.'

version "1.0.0"

lua54 'yes'

name 'Primordial Lib'

dependencies {
    '/server:8470',
    '/onesync',
}

ui_page 'web/build/index.html'

files {
    'init.lua',
    'web/build/index.html',
    'web/build/**/*',
}

shared_script 'resource/init.lua'

shared_scripts {
    'resource/**/shared.lua',
    -- 'resource/**/shared/*.lua'
}

client_scripts {
    'resource/**/client.lua',
    'resource/**/client/*.lua'
}

server_scripts {
    'imports/callback/server.lua',
    'imports/getFilesInDirectory/server.lua',
    'resource/**/server.lua',
    'resource/**/server/*.lua',
}
