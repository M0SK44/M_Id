fx_version 'adamant'
games { 'gta5' }

author 'M0SK4'

client_scripts {
    'config.lua', -- Asegúrate de que esté aquí
    'client.lua',
}

server_scripts {
    'config.lua', -- Asegúrate de que esté aquí también
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
}

shared_script '@es_extended/imports.lua'
