local skynet = require "skynet"
local gateserver = require "snax.gateserver"
local netpack = require "skynet.netpack"
--local common = require "common"

local connection = {}   -- fd -> connection : { fd , ip }
local handler = {}

local agentlist = {}

-- 当一个完整的包被切分好后，message 方法被调用。这里 msg 是一个 C 指针、sz 是一个数字，表示包的长度（C 指针指向的内存块的长度）。
function handler.message(fd, msg, sz)
    print("===========gate handler.message============"..fd)
    -- common:dump(connection[fd])

    local c = connection[fd]
    local agent = agentlist[fd]
    if agent then
        -- skynet.redirect(agent, c.client, "client", 1, msg, sz)
        print("接收到客户端消息,传给agent服务处理")
    else
        print("没有agent处理该消息")
    end
end

function handler.connect(fd, addr)
    print("===========gate handler.connect============")
    local c = {
        fd = fd,
        ip = addr,
    }
    -- common:dump(c)
    -- 保存客户端信息
    connection[fd] = c

    -- 马上允许fd 接收消息(由于下面交给service1处理消息,所以可以在service1准备好再调用)
    -- 这样可能导致客户端发来的消息丢失,因为service1未准备好的情况下,无法处理消息
    gateserver.openclient(fd)

    agentlist[fd] = skynet.newservice("service3")
    skynet.call(agentlist[fd], "lua", "start", { fd = fd, addr = addr })
end

function handler.disconnect(fd)
    print(fd.."-断开连接")
end

function handler.error(fd, msg)
    print("异常错误")
end

gateserver.start(handler)
