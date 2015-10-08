require 'luarocks.loader'
luasql = require "luasql.mysql"

migrate = {}

function printf(s,...)
    print(s:format(...))
end;

hex2bin = {
    ["0"] = "0000",
    ["1"] = "0001",
    ["2"] = "0010",
    ["3"] = "0011",
    ["4"] = "0100",
    ["5"] = "0101",
    ["6"] = "0110",
    ["7"] = "0111",
    ["8"] = "1000",
    ["9"] = "1001",
    ["A"] = "1010",
    ["B"] = "1011",
    ["C"] = "1100",
    ["D"] = "1101",
    ["E"] = "1110",
    ["F"] = "1111"
}

function migrate.connect()
    migrate.env = assert (luasql.mysql())

    print("Loading conf/map_darkstar.conf")

    -- Grab mysql credentials
    local filename = "../conf/map_darkstar.conf"
    migrate.credentials = { }
    for l in io.lines(filename) do
        local n, a = l:match '(mysql_%g+):%s+(%g+)'

        if (n ~= nil) then
            migrate.credentials[n] = a
        end
    end

    local database = migrate.credentials["mysql_database"]
    local host = migrate.credentials["mysql_host"]
    local port = migrate.credentials["mysql_port"]
    local login = migrate.credentials["mysql_login"]
    local password = migrate.credentials["mysql_password"]

    -- print(database, host, port, login, password)

    migrate.con = assert(migrate.env:connect(database, login, password, host, port))

    print("Connected to database")

    return migrate.con
end

function migrate.close()
    migrate.con:close()
    migrate.env:close()
end
