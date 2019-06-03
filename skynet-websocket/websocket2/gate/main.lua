local skynet = require "skynet"
local max_client = 64

skynet.start(function()
    skynet.error("Server start")
    
    skynet.newservice("wsserver")

    skynet.newservice("gameserver")

    skynet.exit()
end)
