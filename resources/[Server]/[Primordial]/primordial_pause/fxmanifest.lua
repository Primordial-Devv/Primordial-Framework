fx_version 'cerulean'

game 'gta5'

author 'Primordial Studio'

description 'Primordial Pause Menu for Primordial Framework'

version '0.0.1'

name 'Primordial Pause Menu'

lua54 'yes'

ui_page 'web/Pause_Menu/dist/index.html'

files {
    'web/Pause_Menu/dist/index.html',
    'web/Pause_Menu/dist/**/*',
}

shared_scripts {
    '@primordial_core/init.lua',
    '@ox_lib/init.lua',

    'shared/config_pause.lua',
}

client_scripts {
    'client/main.lua',

    'client/modules/pause.lua',

}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

exports {

}

dependencies {
    'ox_lib',
    'primordial_core'
}