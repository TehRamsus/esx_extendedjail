fx_version 'adamant'
game 'gta5'

description 'Extended jail - Ramsus'
version '1.0.1'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/fi.lua',
	'locales/en.lua',
	'locales/swe.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/fi.lua',
	'locales/en.lua',
	'locales/swe.lua',
	'config.lua',
	'client/main.lua'
}

export 'OpenJailMenu'