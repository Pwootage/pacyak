local libpackyak = require("libpacyak")

print("PacYak - The OC Package Yak")

local args = table.pack(...)

if args[1] == "install" then
    print("Installing " .. args[2])

    libpackyak.install(args[2])
elseif args[1] == "update" then
    libpackyak.updateLists()
end
