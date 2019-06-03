local skynet = require "skynet"
require "skynet.manager"    -- import skynet.register

local CMD = {}
local client_fd
local host

-- TODO
-- skynet.register_protocol
-- 注册新的消息类别 PTYPE_CLIENT，新的类别必须提供 pack 和 unpack 函数，用于消息的编码和解码。

function CMD.start(conf)
    print("service3 CMD.start")
    -- common:dump(conf)
    -- SOCKET处理
end

function CMD.disconnect()
    -- todo: do something before exit
    skynet.exit()
end

skynet.start(function()
    print("==========Service3 Start=========")
    skynet.dispatch("lua", function(session, address, cmd, ...)
        print("==========Service3 dispatch============"..cmd)
        local f = CMD[cmd]
        skynet.ret(skynet.pack(f(...)))
    end)
end)
