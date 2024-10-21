fx_version 'cerulean'

game 'gta5'


author 'Primordial Studio'

description 'Primordial Test'

version '1.0.0'

lua54 'yes'

shared_scripts {
    '@primordial_core/init.lua',
    '@ox_lib/init.lua',
    'shared/main.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'primordial_core',
    'ox_lib'
}