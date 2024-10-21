fx_version 'cerulean'

game 'gta5'

author 'Primordial Studio'

description 'Primordial Hud System'

version '1.0.0'

name 'Prilmordial Hud'

lua54 'yes'

shared_scripts {
    '@primordial_core/init.lua',
    '@ox_lib/init.lua',

    'shared/config_fuel.lua',

    'translations/*.lua',
}

client_scripts {
    'client/main.lua',

    'client/modules/fuel.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    'server/modules/fuel.lua',
}

dependencies {
    'primordial_core',
    'ox_lib',
    'oxmysql'
}