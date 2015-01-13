-- Library that contains all PacYak functions
local json = require("json")
local filesystem = require("filesystem")
local serialization = require("serialization")
local computer = require("computer")
local event = require("event")

-- Export module
local libpacyak = {}

local packages = {}

function libpacyak.init()
    -- Load packages
end

--- Useful
function libpacyak.getParent(path)
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

--- Another useful funciton
function libpacyak.writeFile(path, data)
    local parent = libpacyak.getParent(path)
    filesystem.makeDirectory(parent)

    local file = io.open(path, "w")
    file:write(data)
    file:close()
end

--- Download a URL and return it as a string
function libpacyak.download(url)
    local internet = require("internet")

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
function libpacyak.packageUrls()
    local ret = {}

    local listd = "/etc/pacyak/lists.d/"

    for list in filesystem.list(listd) do
        if not filesystem.isDirectory(listd .. list) then
            local l = libpacyak.loadKVP(listd .. list)
            for k, v in pairs(l) do
                ret[k] = v
            end
        end
    end

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
    if packages[package] then
        print("Warning: Package " .. package .. " is already installed; install will stomp files, but it may not work for all packages. If it does not, try uninstalling and reinstalling.")
        io.write("Continue? [Y]/n ")
        while true do
            local _, _, k = event.pull("key_down")
            if k == string.byte("n") or k == string.byte("N") then
                print(string.char(k))
                return
            elseif k == string.byte("y") or k == string.byte("Y") then
                print(string.char(k))
                break
            elseif k == 10 or k == 13 then
                print("Y")
                break
            else
                -- Continue
            end
        end
    end

    local url = libpacyak.packageUrls()[package]
    if url then
        print("Installing " .. package)
        libpacyak.httpInstall(url)
        print("Rebooting in 5 seconds to complete install...")
        os.sleep(5)
        computer.shutdown(true)
    else
        print("Unknown package: " .. package)
    end
end

--- Uninstall a package by name
function libpacyak.uninstall(package)
    if not packages[package] then
        print("Error: Package " .. package .. " is not installed; cannot uninstall.")
    else
        local pkg = packages[package]

        print("Removing package " .. package)
        print("Files to remove: " .. (#pkg.files + #pkg.install))

        local fsBase = "/usr/share/pacyak/" .. pkg.name .. "/"

        for _, file in ipairs(pkg.files) do
            local fsUrl = fsBase .. "/" .. file

            print("Removing '" .. fsUrl .. "'...")

            filesystem.remove(fsUrl)
        end

        for dest, src in pairs(pkg.install) do
            print("Removing '" .. dest .. "'...")

            filesystem.remove(dest)
        end

        print("Removing '" .. fsBase.. "'...")
        filesystem.remove(fsBase)

        print("Rebooting in 5 seconds to complete install...")
        os.sleep(5)
        computer.shutdown(true)
    end
end

function libpacyak.findPacakgeInLists(package)
    local lists = libpacyak.loadLists()
end

function libpacyak.httpInstall(path)
    print("Downloading package description from " .. path .. "/package.json")

    local pkg = json.decode(libpacyak.download(path .. "/package.json"))

    local fsBase = "/usr/share/pacyak/" .. pkg.name .. "/"

    print("Found " .. #pkg.files .. " files to download.")

    for _, file in ipairs(pkg.files) do
        local webUrl = path .. "/" .. file
        local fsUrl = fsBase .. "/" .. file

        print("Downloading '" .. webUrl .. "'...")

        libpacyak.writeFile(fsUrl, libpacyak.download(webUrl))
    end

    for dest, src in pairs(pkg.install) do
        local sfile = fsBase .. "/" .. src

        print("Copying " .. sfile .. " to " .. dest)

        local parent = libpacyak.getParent(dest)
        filesystem.makeDirectory(parent)

        filesystem.copy(sfile, dest)
    end
end

return libpacyak