fx_version 'cerulean'

game 'gta5'

author 'Primordial Studio'

description 'Framework of Primordial Studio (modified from ESX)'

version '2.9.1'

name 'Primordial Core'

lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',

	'translations/*.lua',

	'shared/common.lua',

	'lib/**/**/shared.lua',

	'shared/config_admin.lua',
	'shared/config_society.lua',
	'shared/config_start.lua',
	'shared/config_logs.lua',
	'shared/config.lua',

}

server_scripts {
	'@oxmysql/lib/MySQL.lua',

	'server/common.lua',

	'server/classes/player.lua',

	'core/society/initSociety.lua',
	'core/society/society.lua',
	'core/**/server.lua',
	'core/resources/server.lua',

	'lib/**/**/server.lua',
	'lib/**/server.lua',

	'server/modules/adminPermissions.lua',
	'server/modules/callback.lua',
	'server/modules/events.lua',
	'server/modules/playerLicense.lua',

	'server/paycheck.lua',

	'core/modules/**/server.lua',
}

client_scripts {
	'client/common.lua',

	'lib/**/**/client.lua',

	'core/spawn/client.lua',
	'core/player/client.lua',

	'client/modules/events.lua',
	'client/modules/callbacks.lua',

	'core/society/menu/*.lua',
	'core/society/createSociety.lua',
	'core/resources/client.lua',
	'core/resources/interface/main.lua',

	'core/modules/*.lua',
	'core/modules/**/client.lua',
	'client/modules/society.lua',
	'client/modules/target.lua',

}

files {
	'init.lua',
}

server_exports {
    'GetSocietyAccount',
    'AddSocietyAccount'
}

dependencies {
	'/native:0x6AE51D4B',
    '/native:0xA61C8FC6',
	'oxmysql',
}
