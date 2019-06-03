local skynet = require "skynet"

-- 启动服务(启动函数)
skynet.start(function()
    -- 启动函数里调用Skynet API开发各种服务
    print("======Server start=======")
    -- skynet.newservice(name, ...)启动一个新的 Lua 服务(服务脚本文件名)

    skynet.newservice("socket3")

    -- 退出当前的服务
    skynet.exit()
end)
