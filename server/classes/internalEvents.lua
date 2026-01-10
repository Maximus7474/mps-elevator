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
---@param callback fun(source: number, elevator: Elevator, ...): any
function Events:ElevatorCallback(event, callback)
    lib.callback.register(event, function (source, ...)
        local elevatorId = self.activePlayers[tostring(source)]
        if (not elevatorId) then
            warn(string.format('Player %d is not listed as active, could be a cheat attempt', source))
            return
        end

        local elevator = Elevator.elevators[elevatorId]

        if (not elevator) then
            warn(string.format('No elevator found for active player %d with id %s', source, elevatorId))
            return
        end

        return callback(source, elevator, ...)
    end)
end
