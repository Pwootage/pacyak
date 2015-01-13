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

local tmplib = os.tmpname()

function main()
    local webBase = "https://raw.githubusercontent.com/Pwootage/pacyak/master"

    print("Downloading JSON lib to " .. tmplib .. "/json.lua")
    write(tmplib .. "/json.lua", dl(webBase .. "/lib/json.lua"))

    print("Loading downloaded lib...")
    local json = require("json")

    print("Downloading PacYak package definition")
    local pacyak = json.decode(dl(webBase .. "/package.json"))

    print("Number of files to download: " .. #pacyak.files)

    local fsBase = "/usr/share/pacyak/pacyak"
    filesystem.makeDirectory(webBase)

    for _, file in ipairs(pacyak.files) do
        local webUrl = webBase .. "/" .. file
        local fsUrl = fsBase .. "/" .. file

        print("Downloading '" .. file .. "'...")

        write(fsUrl, dl(webUrl))
    end

    for src, dest in pairs(pacyak.install) do
        local sfile = fsBase.."/"..src
        print(sfile)
        print(dest)
--        write(fsUrl, dl(webUrl))
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

function write(path, data)
    -- Find last "/"
    local last = path:len()
    for i = path:len(), 1, -1 do
        local c = path:sub(i, i)
        if c == '/' then
            last = i
            break
        end
    end

    local parent = path:sub(1, last)

    filesystem.makeDirectory(parent)

    local file = io.open(path, "w")
    file:write(data)
    file:close()
end

-- Setup temp path
local origPath = package.path
filesystem.makeDirectory(tmplib)
package.path = origPath .. ";" .. tmplib .. "/?.lua"

-- Main entry point
local status, err = pcall(main)
if status then
    print("Successfully installed :D")
else
    print("Failed to install :(")
    print(err)
end

-- Cleanup
package.path = origPath
filesystem.remove(tmplib)