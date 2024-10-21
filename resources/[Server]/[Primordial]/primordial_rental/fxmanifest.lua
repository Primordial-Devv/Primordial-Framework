fx_version 'cerulean'

game 'gta5'

author 'Primordial Studio'

description 'Primordial Rental System'

version '1.0.0'

name 'Prilmordial Rental'

lua54 'yes'

shared_scripts {
    '@primordial_core/init.lua',
    '@ox_lib/init.lua',

    'shared/',

    'translations/*.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    'server/main.lua',
}

dependencies {
    'primordial_core',
    'ox_lib',
    'oxmysql'
}