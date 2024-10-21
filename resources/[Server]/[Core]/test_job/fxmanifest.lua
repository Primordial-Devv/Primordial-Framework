fx_version 'cerulean'

game 'gta5'

author 'Primordial Studio'

description 'This is a test job'

version '1.0.0'

lua54 'yes'

shared_scripts {
    '@primordial_core/init.lua',
    '@ox_lib/init.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

dependencies {
    'primordial_core',
    'oxmysql'
}