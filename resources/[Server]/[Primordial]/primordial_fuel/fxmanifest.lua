fx_version 'cerulean'

game 'gta5'

author 'Primordial Studio'

description 'Primordial Fuel System'

version '1.0.0'

name 'Prilmordial Fuel'

lua54 'yes'

shared_scripts {
    '@primordial_core/init.lua',
    '@ox_lib/init.lua',

    'shared/config_debug.lua',

    'shared/config_consumption.lua',
    'shared/config_fuelStation.lua',

    'translations/*.lua',
}

client_scripts {
    'client/main.lua',

    'client/modules/fuelConsumption.lua',
    'client/modules/fuelStation.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    'server/main.lua',
}

export 'GetFuel'
export 'SetFuel'
export 'StopFuel'
export 'StartFuel'
export 'GetFuelConsumptionStatus'

dependencies {
    'primordial_core',
    'ox_lib',
    'oxmysql'
}