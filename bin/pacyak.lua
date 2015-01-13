local libpackyak = require("libpacyak")

print("PacYak - The OC Package Yak")
print()

local args = table.pack(...)

if args[1] == "install" then
    print("Installing " .. args[2])

    libpackyak.install(args[2])
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
