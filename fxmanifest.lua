fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

name         'Ed Farm Drugs 🐼'
version      '1.0.0'
description  'Ox target intercation for farm drugs'
author       'Edmondio'

dependency 'ox_lib'

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'shared/*.lua',
	'logs.lua'
}

server_scripts {
	'server/*.lua',
}

client_scripts {
	'client/*.lua'
}

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_plant_coca_a.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/prop_weed_slash.ytyp'



-- SUPPORT ON DISCORD 
-- https://discord.gg/yRfwHxynpg