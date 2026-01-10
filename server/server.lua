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

Citizen.SetTimeout(500, function ()
    local players = GetPlayers()

    for i = 1, #players do
        local player = tonumber(players[i])
        updatePlayerTargets(player)
    end
end)

lib.callback.register("elevator:getfloordata", function (source, elevatorId)
    local elevator = Elevator.elevators[elevatorId]
    lib.print.info('elevator found:', not not elevator)
    if (not elevator) then return false end

    local isAcceptable = elevator:isInElevator(source)
    lib.print.info('elevator acceptable:', isAcceptable)
    if (not isAcceptable) then return false end

    Events:setActive(source, elevator.id);

    local floorData = elevator:getFloors(source)

    return floorData
end)

Events:ElevatorCallback('elevator:internal:setnewfloor', function (source, elevator --[[ @as Elevator ]], floorIndex)
    local success = elevator:gotoFloor(source, floorIndex)

    local data = elevator:getFloors(source)

    return {
        restricted = data.restricted,
        floors = data.floors,
        access = success and 'authorized' or 'denied',
    }
end)

RegisterNetEvent('elevator:internal:closedinterface', function ()
    Events:removeActive(source)
end)

---Create a new elevator or batch of elevators
---@param payload ElevatorData|ElevatorData[]
---@return Elevator|Elevator[]
function NewElevator(payload)
    local payloadType = lib.table.type(payload)

    if (payloadType == 'empty') then
        error("An empty array was provided, can't generate stuff without data")
    elseif (payloadType== 'mixed') then
        error("An invalid array was provided, please follow documentation")
    end

    if (payloadType == 'hash') then
        return Elevator:new(payload)
    elseif (payloadType == 'array') then
        local generatedElevators = {}

        for i = 1, #payload do
            local res = Elevator:new(payload[i])
            table.insert(generatedElevators, res)
        end

        return generatedElevators
    end
end
exports('NewElevator', NewElevator)

if Config.VersionCheck then
    lib.versionCheck('Maximus7474/mps-elevator')
end