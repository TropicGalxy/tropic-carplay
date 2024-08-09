fx_version 'cerulean'
game 'gta5'


lua54 'yes'
author 'TropicGalxy'
description 'a very simple carplay script'
version '1.0.0'

shared_script {
 'config.lua',
 '@ox_lib/init.lua'
}

server_script 'server.lua'

client_script { 
'client.lua'

}

-- Dependencies
dependencies {
    'qb-core',   
    'ox_lib',      
    'xsound',      
    'oxmysql'      
}
