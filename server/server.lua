if not CanResourceBeUsed(true) then return end

local targetScripts, _ = lib.getFilesInDirectory(("@%s/client/modules/targets/"):format(GetCurrentResourceName()), "%.lua")
local zoneScripts, _ = lib.getFilesInDirectory(("@%s/client/modules/zones/"):format(GetCurrentResourceName()), "%.lua")
local target

for _, script in pairs(Config.Options.Target and targetScripts or zoneScripts) do
    if IsResourceStarting(script:gsub("%.lua$", "")) then
        target = ("%s.%s"):format(Config.Options.Target and "targets" or "zones", script:gsub("%.lua$", ""))
        break
    end
end
if not target then error("No Target/Zone Script Found ! This resource will not work.") end


lib.callback.register("5m-Elevator:ZoneHandler", function () return target end)

if Config.VersionCheck then
    lib.versionCheck('Maximus7474/mps-elevator')
end