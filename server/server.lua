if not CanResourceBeUsed(true) then return end

---updates the elevators targetable by a client
---@param source any
local function updatePlayerTargets(source)
    if (not tonumber(source)) then return end

    local bucket = GetPlayerRoutingBucket(source)
    local targets = {}

    for _, elevator in pairs(Elevator.elevators) do
        local data = elevator:getFloorPositions(source, bucket)

        if (data) then
            table.insert(targets, data)
        end
    end

    TriggerLatentClientEvent('elevator:updateelevators', source, -1, targets)
end
exports('UpdatePlayerTargets', updatePlayerTargets)

if Config.VersionCheck then
    lib.versionCheck('Maximus7474/mps-elevator')
end