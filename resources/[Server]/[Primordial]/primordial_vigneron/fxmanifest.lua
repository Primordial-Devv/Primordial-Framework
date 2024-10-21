fx_version 'cerulean'

game 'gta5'

author 'Primordial Studio'

description 'Vigneron job for Fairy Life'

version '1.2.1'

lua54 'yes'

shared_scripts {
    '@primordial_core/init.lua',
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'primordial_core',
    'ox_lib'
}