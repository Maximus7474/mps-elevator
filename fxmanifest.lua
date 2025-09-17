fx_version 'cerulean'

description 'Simple elevator UI'
author 'Maximus Prime'
version 'v1.2.4'
repository 'https://github.com/Maximus7474/mps-elevator'

lua54 'yes'

games {
    'gta5'
}

files {
    'client/modules/**/*.lua',
    'web/build/index.html',
    'web/build/**/*'
}

ui_page 'web/build/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}

client_script 'client/*.lua'
server_script 'server/utils.lua'
server_script 'server/classes/*.lua'
server_script 'server/server.lua'

dependancy 'ox_lib'
