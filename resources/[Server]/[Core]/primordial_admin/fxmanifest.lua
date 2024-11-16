fx_version 'cerulean'

game 'gta5'

author 'Primordial Studio'

description 'Primordial Admin Menu for Primordial Framework'

version '1.0.0'

name 'Prilmordial Admin'

lua54 'yes'

shared_scripts {
    '@primordial_core/init.lua',
    '@ox_lib/init.lua',

    'shared/config_adminPerm.lua',
    'shared/config_noclip.lua',
    'shared/config_command.lua',
    'shared/config_ped.lua',
    'shared/config_spectate.lua',
    'shared/config_ban.lua',
    'shared/config_boost.lua',
    'shared/config_jobs.lua',
    'shared/config_weather.lua',

    'translations/*.lua',
}

client_scripts {
    'client/main.lua',

    'client/modules/interface/homepage.lua',
    'client/modules/interface/selfOptions.lua',
    'client/modules/interface/playerOptions.lua',
    'client/modules/interface/vehicleOptions.lua',
    'client/modules/interface/zoneOptions.lua',
    'client/modules/interface/reportOptions.lua',
    'client/modules/interface/serverOptions.lua',
    'client/modules/interface/developerOptions.lua',

    'client/modules/utils/noclip.lua',
    'client/modules/utils/revive.lua',
    'client/modules/utils/tpToMarker.lua',
    'client/modules/utils/pedMenu.lua',
    'client/modules/utils/spectate.lua',
    'client/modules/utils/playerBlips.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    'server/modules/adminPermissions.lua',
    'server/modules/callbacks.lua',
    'server/modules/command.lua',
    'server/modules/event.lua',
    'server/modules/logging.lua',

    'server/utils/spectate.lua',
    'server/utils/warn.lua',
    'server/utils/ban.lua',
    'server/utils/zone.lua',
    'server/utils/report.lua',
    'server/utils/playerBlips.lua',
}

dependencies {
    'primordial_core',
    'ox_lib',
    'oxmysql'
}