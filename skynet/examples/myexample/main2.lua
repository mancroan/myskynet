local skynet = require "skynet"

-- 启动服务(启动函数)
skynet.start(function()
    -- 启动函数里调用Skynet API开发各种服务
    print("======Server start=======")
    -- skynet.newservice(name, ...)启动一个新的 Lua 服务(服务脚本文件名)

    local service2 = skynet.newservice("service2")
    -- 向service2服务发出请求，设置key1的值
    skynet.call(service2,"lua","set","key1","value111111")  
    -- 向service2服务发出请求，获取key1的值
    local kv = skynet.call(service2,"lua","get","key1")
    print(kv)

    -- 退出当前的服务
    skynet.exit()
end)
