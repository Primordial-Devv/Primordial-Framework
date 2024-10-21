fx_version 'cerulean'

game 'gta5'

use_experimental_fxv2_oal 'yes'

author 'Primordial Studio'

description 'Notification System for Primordial Framework'

version '1.0.0'

name 'Primordial Notification'

lua54 'yes'

ui_page 'web/notification/dist/index.html'

files {
    'web/notification/dist/index.html',
    'web/notification/dist/**/*',
}

shared_scripts {
    '@primordial_core/init.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/main.lua',

    'client/modules/notification.lua'
}

dependencies {
    'primordial_core',
    'ox_lib'
}