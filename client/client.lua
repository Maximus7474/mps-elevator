if not CanResourceBeUsed(true) then return end

State = {
    UIOpen = false,
}

local NUI = require 'client.modules.nui'
local isTravelling = false

RegisterNetEvent('elevator:updateelevators', function (
    elevators --[[ @as {name: string; id: string; floors: vector4[]} ]],
    hardReset --[[ @as boolean ]]
)

    if (hardReset) then
        ClElevator.clearAll()
    end

    for i = 1, #elevators, 1 do
        local data = elevators[i]
        -- Only in the case of an elevator getting an update during runtime
        -- if not hardReset flag takes care of it
        if ClElevator.elevators[data.id] then
            local elevator = ClElevator.elevators[data.id]

            elevator:delete()
            ClElevator.elevators[data.id] = nil
        end

        ClElevator:new(elevators[i])
    end
end)

RegisterNetEvent('elevator:client:changingfloor', function (start)
    isTravelling = start
    if (start) then
        DoScreenFadeOut(200)
    else
        Wait(200)
        DoScreenFadeIn(200)
    end
end)

RegisterNUICallback('hideFrame', function(_, cb)
    NUI.ToggleNui(false)
    DebugPrint('Hide NUI frame')
    cb({})

    TriggerServerEvent('elevator:internal:closedinterface')
end)

RegisterNUICallback('SetNewFloor', function(data, cb)
    local floorIndex = data.floorIndex

    cb({})

    local response = lib.callback.await('elevator:internal:setnewfloor', false, floorIndex) --[[ @as { success: boolean; restricted: boolean; floors: ElevatorFloor[] } ]]

    lib.print.info('received response from "elevator:internal:setnewfloor"')

    if (response.success and Config.Options.CloseUI) then
        NUI.ToggleNui(false)
    else
        NUI.SendMessage('SetElevatorData', {
            access = response.success and 'authorised' or 'denied',
            restricted = response.restricted,
            floors = response.floors,
        })
    end
end)

RegisterCommand('elevator_fix_fade', function ()
    if (not isTravelling) then return print("[^3INFO^7] Not currently travelling") end

    DoScreenFadeOut(200)
    print("[^3INFO^7] Hopefully this cleared any issues, if not well shit then not much I can foreshadow from a single command.")
end)
