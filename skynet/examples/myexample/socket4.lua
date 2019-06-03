local skynet = require "skynet"
require "skynet.manager"    -- import skynet.register
local socket = require "skynet.socket"

local function accept1(id)
    socket.start(id)
    socket.write(id, "Hello Skynet\n")
    skynet.newservice("agent1", id)
    -- notice: Some data on this connection(id) may lost before new service start.
    -- So, be careful when you want to use start / abandon / start .
    socket.abandon(id)
end


local function accept2(id)
    socket.start(id)
    local agent2 = skynet.newservice("agent2")
    skynet.call(agent2,"lua",id)

    -- socket.abandon(id)清除 socket id 在本服务内的数据结构，但并不关闭这个 socket 。这可以用于你把 id 发送给其它服务，以转交 socket 的控制权。
    socket.abandon(id)
end

skynet.start(function()
    print("==========Socket Start=========")
    local id = socket.listen("127.0.0.1", 8888)
    print("Listen socket :", "127.0.0.1", 8888)

    socket.start(id , function(id, addr)
            -- 接收到客户端连接或发送消息()
            print("connect from " .. addr .. " " .. id)

            -- 处理接收到的消息（交给angent1或agent2处理）
            -- accept1(id)
            accept2(id)
        end)
    --可以为自己注册一个别名。（别名必须在 32 个字符以内）
    skynet.register "SOCKET4"
end)
