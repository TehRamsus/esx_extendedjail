fx_version 'adamant'
game 'gta5'

description 'Extended jail - Ramsus'
version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@RM_Framework/locale.lua',
	'locales/fi.lua',
	'locales/en.lua',
	'locales/swe.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@RM_Framework/locale.lua',
	'locales/fi.lua',
	'locales/en.lua',
	'config.lua',
	'locales/swe.lua',
	'client/main.lua'
}
