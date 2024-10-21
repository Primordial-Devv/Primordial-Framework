fx_version 'adamant'

game 'gta5'
description 'Allows the player to Pick their characters: Name, Gender, Height and Date-of-birth.'
lua54 'yes'
version '1.10.6'

shared_scripts {
	'@primordial_core/init.lua',
	'@ox_lib/init.lua',
	'translations/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/js/script.js',
	'html/css/style.css',
}

dependency 'primordial_core'
