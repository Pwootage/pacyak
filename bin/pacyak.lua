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

local libpackyak = require("libpacyak")

print("PacYak - The OC Package Yak")
print()

local args = table.pack(...)

if args[1] == "install" then
    libpackyak.install(args[2])
elseif args[1] == "uninstall" then
    libpackyak.uninstall(args[2])
elseif args[1] == "update" then
    libpackyak.updateLists()
elseif args[1] == "list" then
    print("Loading package lists...")
    local l = libpackyak.packageUrls()

    local count = 0
    for _, _ in pairs(l) do count = count + 1 end

    print("Found " .. count .. " packages:")
    print()

    for k, v in pairs(l) do
        print(k .. " - " .. v)
    end
end
