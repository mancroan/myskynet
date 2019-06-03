require "skynet.manager"	-- import skynet.register
local skynet = require "skynet"
local socket = require "skynet.socket"


function conn_game()
    local id = socket.open("127.0.0.1", 9999)
    if id > 0 then
        skynet.error("connect gameserver 9999", id)
        skynet.send("WSSERVER", "lua", "GAME_CONN", id)
    end
    return id
end

skynet.start(function()
    local id = conn_game() 
	recvdata(id)
	skynet.register "GAMESERVER"
end)

function recvdata(fd)
	while true do
        local str = socket.read(fd)
        if str then
            --转发到wsserver
            skynet.send("WSSERVER", "lua", "GAME_DATA", str)
        else
            socket.close(fd)
            return
        end
    end
end