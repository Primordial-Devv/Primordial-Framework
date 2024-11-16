fx_version 'cerulean'

game 'gta5'

author 'Primordial Studio'

description 'Banking system for Primordial Studio'

version '1.0.0'

name 'Primordial Bank'

lua54 'yes'

shared_scripts {
    '@primordial_core/init.lua',
    '@ox_lib/init.lua',

    'translations/*.lua',

    'shared/config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    'server/main.lua',
}

client_scripts {
    'client/main.lua',
}

dependencies {
    'ox_lib',
    'primordial_core',
    'oxmysql',
}