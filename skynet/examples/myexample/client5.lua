package.cpath = "luaclib/?.so"
package.path = "lualib/?.lua;examples/myexample/?.lua"

if _VERSION ~= "Lua 5.3" then
    error "Use lua 5.3"
end

local socket = require "client.socket"

-- 通信协议
local proto = require "proto"
local sproto = require "sproto"

local host = sproto.new(proto.s2c):host "package"
local request = host:attach(sproto.new(proto.c2s))

local fd = assert(socket.connect("127.0.0.1", 8888))

local session = 0

-- 封包(长度+内容)
local function send_package(fd, pack)
    local package = string.pack(">s2", pack)
    socket.send(fd, package)
end

local function send_request(name, args)
    session = session + 1
    local str = request(name, args, session)

    -- socket.send(fd, str)

    -- 添加数据长度包头,gateserver接收自动判断类型为data(gateserver使用了netpack进行解析)
    -- skynet 提供了一个 lua 库 netpack ，用来把 tcp 流中的数据解析成 长度 + 内容的包。
    send_package(fd,str);

    print("Request:", session)
end

send_request("handshake")
socket.usleep(100)
send_request("say", { name = "soul", msg = "hello world" })


while true do
    -- 接收服务器返回消息
    local str   = socket.recv(fd)

    -- print(str)
    if str~=nil and str~="" then
            print("server says: "..str)
            -- socket.close(fd)
            -- break;
    end

    -- 读取用户输入消息
    local readstr = socket.readstdin()

    if readstr then
        if readstr == "quit" then
            send_request("quit")
            -- socket.close(fd)
            -- break;
        else
            -- 把用户输入消息发送给服务器
            send_request("say", { name = "soul", msg = readstr })
        end
    else
        socket.usleep(100)
    end

end