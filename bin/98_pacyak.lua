local function main()
    local event = require("event")
    local term = require("term")
    local filesystem = require("filesystem")
    local serialization = require("serialization")

    term.clear()

    -- Add pacyak's lib to the lib path
    package.path = package.path .. ";/usr/share/pacyak/pacyak/lib/?.lua"

    local json = require("json")
    local libpacyak = require("libpacyak")

    local packageDir = "/usr/share/pacyak/"

    for package in filesystem.list(packageDir) do
        if filesystem.isDirectory(packageDir..package) and filesystem.exists(packageDir..package .. "package.json") then
            print("Loading package: " .. package)
            libpacyak.loadPackage(packageDir..package)
        end
    end

    -- event.pull("key_down")
end

-- Main entry point
local status, err = pcall(main)
if status then
else
    print("Error booting")
    print(err)
    require("event").pull("key_down")
end
