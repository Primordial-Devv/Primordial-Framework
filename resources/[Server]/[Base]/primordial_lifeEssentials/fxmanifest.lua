fx_version 'cerulean'

game 'gta5'

author 'Primordial Studio'

description 'System to handle essentials for life (hunger, thirst, etc) for Primordial Core Framework.'

version '1.2.1'

lua54 'yes'

shared_scripts {
	'@primordial_core/init.lua',
	'@ox_lib/init.lua',

	'shared/config.lua',

	'translations/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',

	'server/lifeEssentials.lua',

	'server/mainNeeds.lua',
	'server/drunkNeeds.lua',
}

client_scripts {
	'client/classes/lifeEssentials.lua',

	'client/lifeEssentials.lua',

	'client/mainNeeds.lua',
	'client/drunkNeeds.lua',
}

dependency 'primordial_core'