-----------------------------------------
-- Install.lua                         --
-----------------------------------------
-- Installs PacYak into the filesystem --
-----------------------------------------
local process = require("process")
local filesystem = require("filesystem")
local serialization = require("serialization")
local internet = require("internet")
local term = require("term")
local event = require("event")
local computer = require("computer")

local tmplib = os.tmpname()

local localInstall = false
local args = table.pack(...)

function main()
    if args[1] == "local" then
        localInstall = true
    end

    local webBase = "https://raw.githubusercontent.com/Pwootage/pacyak/master"
    local localBase = getParent(process.running())

    if localInstall then
        print("Copying JSON lib to " .. tmplib .. "/json.lua")
        filesystem.copy(localBase .. "/lib/json.lua", tmplib .. "/json.lua")
    else
        print("Downloading JSON lib to " .. tmplib .. "/json.lua")
        write(tmplib .. "/json.lua", dl(webBase .. "/lib/json.lua"))
    end

    print("Loading JSON lib...")
    local json = require("json")

    local pacyak
    if localInstall then
        print("Loading PacYak package definition")
        pacyak = json.decode(read(localBase .. "/package.json"))
        print("Number of files to copy: " .. #pacyak.files)
    else
        print("Downloading PacYak package definition")
        pacyak = json.decode(dl(webBase .. "/package.json"))
        print("Number of files to download: " .. #pacyak.files)
    end

    local fsBase = "/usr/share/pacyak/pacyak"
    filesystem.makeDirectory(fsBase)

    for _, file in ipairs(pacyak.files) do
        if localInstall then
            local src = localBase .. "/" .. file
            local dest = fsBase .. "/" .. file

            print("Copying " .. src .. " to " .. dest)

            local parent = getParent(dest)
            filesystem.makeDirectory(parent)

            filesystem.copy(src, dest)
        else
            local webUrl = webBase .. "/" .. file
            local fsUrl = fsBase .. "/" .. file

            print("Downloading '" .. file .. "'...")

            write(fsUrl, dl(webUrl))
        end
    end

    for dest, src in pairs(pacyak.install) do
        local sfile = fsBase .. "/" .. src

        print("Copying " .. sfile .. " to " .. dest)

        local parent = getParent(dest)
        filesystem.makeDirectory(parent)

        filesystem.copy(sfile, dest)
    end
end

function dl(url)
    local res = ""

    local req = internet.request(url)
    for line in req do
        res = res .. line
    end

    return res
end

function getParent(path)
    -- Find last "/"
    local last = path:len()
    for i = path:len(), 1, -1 do
        local c = path:sub(i, i)
        if c == '/' then
            last = i
            break
        end
    end

    return path:sub(1, last)
end

function write(path, data)
    local parent = getParent(path)

    filesystem.makeDirectory(parent)

    local file = io.open(path, "w")
    file:write(data)
    file:close()
end

function read(path)
    local file = io.open(path, "r")
    local res = ""
    local done = false
    while true do
        local r = file:read(1024)
        if r == nil then break end
        res = res .. r
    end
    file:close()
    return res
end

-- Setup temp path
local origPath = package.path
filesystem.makeDirectory(tmplib)
package.path = origPath .. ";" .. tmplib .. "/?.lua"

-- Main entry point
local status, err = pcall(main)
if status then
    print("Successfully installed :D")
    print("Rebooting in 5 seconds to complete install...")
    os.sleep(5)
    computer.shutdown(true)
else
    print("Failed to install :(")
    print(err)
end

-- Cleanup
package.path = origPath
filesystem.remove(tmplib)