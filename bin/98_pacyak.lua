-- Copyright (c) 2015 Pwootage
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

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
