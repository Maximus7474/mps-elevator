if not CanResourceBeUsed(true) then return end

local NUI = require 'client.modules.nui'

RegisterNetEvent('elevator:updateelevators', function (elevators --[[ @as {name: string; id: string; floors: vector4[]} ]])
    for i = 1, #elevators, 1 do
        ClElevator:new(elevators[i])
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

    NUI.SendMessage('SetElevatorData', {
        access = response.success and 'authorised' or 'denied',
        restricted = response.restricted,
        floors = response.floors,
    });
end)