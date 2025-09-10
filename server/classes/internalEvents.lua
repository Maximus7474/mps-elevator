Events = {}
Events.activePlayers = {} --[[ @as table<string, string> key: player source, value: elevator identifier ]]

function Events:setActive(source, elevatorId)
    local elevator = Elevator.elevators[elevatorId]

    if (not elevator) then
        return
    end

    local isAcceptable = elevator:isInElevator(source)

    if (not isAcceptable) then
        warn(string.format('Player %s (%d) tried to exploit Events.setActive !', GetPlayerName(source), tonumber(source)))
        return
    end

    Events.activePlayers[tostring(source)] = elevator.id
end

function Events:removeActive(source)
    Events.activePlayers[tostring(source)] = nil
end

---@param event string
---@param callback fun(source: number, elevator: Elevator, ...)
function Events:NetEvent(event, callback)
    RegisterNetEvent(event, function (...)
        local src = tonumber(source)

        if (not src) then return end

        local elevatorId = self.activePlayers[tostring(src)]

        if (not elevatorId) then
            warn(string.format('Player %d is not listed as active, could be a cheat attempt', src))
            return
        end

        local elevator = Elevator.elevators[elevatorId]

        if (not elevator) then
            warn(string.format('No elevator found for active player %d with id %s', src, elevatorId))
            return
        end

        callback(src, elevator, ...)
    end)
end
