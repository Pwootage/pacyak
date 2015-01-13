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
    if not filesystem.exists(path) then
        error("File not found: " .. path)
    end
    local f = io.open(path, "r")
    local res = ""
    while true do
        local r = f:read(1024)
        if r == nil then break end
        res = res .. r
    end
    f:close()
    return res
end


--- Download a URL and return it as a string
function libpacyak.download(url)
    local res = ""

    local req = internet.request(url)
    for line in req do
        res = res .. line
    end

    return res
end

--- Load a package
function libpacyak.loadPackage(path)
    local pkg = json.decode(libpacyak.loadFile(path .. "package.json"))
    packages[pkg.name] = pkg

    for dest, src in pairs(pkg.links) do
        local target = path .. src
        print("Linking " .. dest .. " to " .. target)
        local res, err = filesystem.link(target, dest)
        if not res then
            print("Error linking: " .. err)
        end
    end
end

--- Load KVP
function libpacyak.loadKVP(path)
    local res = {}

    local file = io.open(path)

    for line in file:lines() do
        if line:find("#", 1, true) == 0 then
            --Comment
        else
            local equals = line:find("=", 1, true)
            local key = line:sub(1, equals - 1)
            local value = line:sub(equals + 1)
            res[key] = value
        end
    end

    file:close()

    return res
end

--- Load all package lists
function libpacyak.loadLists()
    local ret = {}

    return ret
end

--- Update all lists
function libpacyak.updateLists()
    print("Updating all lists... ")

    local lists = libpacyak.loadKVP("/etc/pacyak/lists.txt")
    local listd = "/etc/pacyak/lists.d/"

    filesystem.makeDirectory(listd)

    for list, url in pairs(lists) do
        print("Downloading list " .. list .. " from " .. url)

        local file = io.open(listd .. list, "w")
        file:write(libpacyak.download(url))
        file:close()
    end

    print("Done.")
end

--- Install a package by name
function libpacyak.install(package)
    local pkg = libpacyak.findPacakgeInLists(package)
end

function libpacyak.findPacakgeInLists(package)
    local lists = libpacyak.loadLists()
end

function libpacyak.httpInstall(path)
end

return libpacyak