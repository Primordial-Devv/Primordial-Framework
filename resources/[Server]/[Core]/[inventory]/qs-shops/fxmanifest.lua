fx_version 'cerulean'

game 'gta5'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/*.lua'
}

client_scripts {
    'client/custom/**',
    'client/main.lua',
    'client/deliveries.lua',
}

dependencies {
    'ox_lib', -- Required
}

server_scripts {
    'server/custom/**',
    'server/main.lua'
}

file 'json/shops-inventory.json'

escrow_ignore {
    'config.lua',
    'locales/*.lua',
    'client/custom/target/*.lua',
    'client/custom/framework/*.lua',
    'server/custom/framework/*.lua'
}

dependency '/assetpacks'