local skynet = require "skynet"
local sprotoloader = require "sprotoloader"

skynet.start(function()
	skynet.error("Server start")
	local watchdog = skynet.newservice("testwebsocket")
	skynet.exit()
end)
