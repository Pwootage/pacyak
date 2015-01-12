-----------------------------------------
-- Install.lua                         --
-----------------------------------------
-- Installs PacYak into the filesystem --
-----------------------------------------
local process = require("process")
local filesystem = require("filesystem")
local serialization = require("serialization")
local internet = require("internet")
local event = require("event")

local tmplib = os.tmpname()

function main()
    -- Find the list of files to download
    print("Downloading JSON lib")

    local json = dl("https://raw.githubusercontent.com/Pwootage/pacyak/master/lib/json.lua")

    write(tmplib.."/json.lua", json)


end

function dl(url)
    local res = ""

    local req = internet.request(url)
    for line in req do
        res = res .. line .. "\n"
    end

    return res
end

function write(path, data)
    local f = io.open(path, "w")
    f:write(data)
    f:close()
end

local origPath = package.path
filesystem.makeDirectory(tmplib)
-- Main entry point
local status, err = pcall(main)
if status then
    print("Successfully installed :D")
else
    print("Failed to install :(")
    print(err)
end
package.path = origPath
filesystem.remove(tmplib)