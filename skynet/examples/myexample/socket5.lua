local skynet = require "skynet"
--local common = require "common"

local gate

skynet.start(function()
    print("==========Socket Start=========")
    print("Listen socket :", "127.0.0.1", 8888)

    -- Socket服务配置
    local conf = {
        address = "127.0.0.1",
        port = 8888,
        maxclient = 1024,
        nodelay = true,
    }

    -- common:dump(conf)
    -- 启动Socket管理网关
    gate=skynet.newservice("mygate")

    -- 打开监听端口
    skynet.call(gate, "lua", "open" , conf)

end)