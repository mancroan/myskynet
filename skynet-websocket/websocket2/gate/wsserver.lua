require "skynet.manager"	-- import skynet.register
local skynet = require "skynet"
local socket = require "skynet.socket"


local GameID
local command = {}
local agentMgr = {}


function command.GAME_CONN(id)
	GameID = id
	print("game server connnet================", GameID)
	return true
end

function command.GAME_DATA(data)

	--找到对应的agent
	for k,v in pairs(agentMgr) do
		skynet.send(v, "lua", k, "gamedata", data)
	end

	return true
end


skynet.start(function()
	local id = socket.listen("0.0.0.0", 8888)
	skynet.error("web server listen on web port 8888")

	skynet.dispatch("lua", function(session, address, cmd, ...)
		local f = command[string.upper(cmd)]
		if f then
			skynet.ret(skynet.pack(f(...)))
		else
			error(string.format("Unknown command %s", tostring(cmd)))
		end
	end)

	socket.start(id, function(id, addr)
		local agent = skynet.newservice("wsagent")
		skynet.error(string.format("%s connected, pass it to agent :%08x", addr, agent))
		skynet.send(agent, "lua", id, "start", GameID)
		
		agentMgr[id] = agent
	end)



	skynet.register "WSSERVER"
end)