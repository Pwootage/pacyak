-- Library that contains all PacYak functions
local json = require("json")
local filesystem = require("filesystem")
local serialization = require("serialization")

-- Export module
local libpacyak = {}

local packages = {}

function libpacyak.init()
    -- Load packages
end

--- Useful function
function libpacyak.loadFile(path)
    local f = io.open(path, "r")
    local res = ""
    local done = false
    while true do
        local r = f:read(1024)
        if r == nil then break end
        res = res .. r
    end
    f:close()
    return res
end

--- Load a package
function libpacyak.loadPackage(package)
    packages[package.name] = package
end

return libpacyak