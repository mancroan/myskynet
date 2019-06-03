local skynet = require "skynet"
local socket = require "skynet.socket"

local fd = ...

fd = tonumber(fd)

local function echo(id)
    socket.start(id)

    while true do
        local str = socket.read(id)
        if str then
            print("client say:"..str)
            -- socket.write(id, str)
        else
            socket.close(id)
            return
        end
    end
end

skynet.start(function()
    skynet.fork(function()
        echo(fd)
        skynet.exit()
    end)
end)