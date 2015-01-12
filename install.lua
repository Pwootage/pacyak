-----------------------------------------
-- Install.lua                         --
-----------------------------------------
-- Installs PacYak into the filesystem --
-----------------------------------------

local process = require("process")
local filesystem = require("filesystem")
local serialization = require("serialization")

-- So we know where we are
local currentProcess = process.running()

-- Dirty dirty hack (won't work if anyone renames anything)
local parent = currentProcess:sub(0, currentProcess:len() - 11)

-- Backup original path
local origPath = package.path

-- And pacyak's dirs to the path, temporaily
package.path = package.path .. ";" .. parent .. "/lib/?.lua"

function bootstrap()
    local json = require("json")
    local libpacyak = require("libpacyak")

    local pkg = json.decode(libpacyak.loadFile(parent .. "/package.json"))
    libpacyak.loadPackage(pkg)
end

local status, err = pcall(bootstrap)

if status then
    print("Successfully installed :D")
else
    print("Failed to install :(")
    print(err)
end

-- Revert path
package.path = origPath

