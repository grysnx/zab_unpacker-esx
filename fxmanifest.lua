fx_version 'cerulean'
game 'gta5'

name 'zab_unpacker'
description 'Simple ox_inventory unpacker script'
author 'VentuZAB'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
