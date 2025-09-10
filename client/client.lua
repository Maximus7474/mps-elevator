if not CanResourceBeUsed(true) then return end

if Config.Debug then
    RegisterCommand('show-nui', function()
        NUI.ToggleNui(true)
        State.UIOpen = true
        DebugPrint('Show NUI frame')
    end)
end

RegisterNUICallback('hideFrame', function(_, cb)
    State.UIOpen = false
    NUI.ToggleNui(false)
    currentElevator = nil
    DebugPrint('Hide NUI frame')
    cb({})
end)

RegisterNUICallback('setNewFloor', function(data, cb)

    if isMoving then DebugPrint("Player is already moving, cancelling") return cb(nil) end

    isMoving = true
    DebugPrint('Data received from NUI', json.encode(data))

    local success = Citizen.Await(TP.GoToNewFloor(currentElevator, data.floorIndex))

    cb(success)

    if Config.Options.CloseUI then
        SetTimeout(success and 250 or 500, function ()
            isMoving = false
            NUI.ToggleNui(false)
            State.UIOpen = false
        end)
    else
        isMoving = false
        State.UIOpen = false
    end
end)