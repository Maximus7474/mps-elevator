local NUI = require 'client.modules.nui'
local Target = require 'client.modules.target'

ClElevator = {}
ClElevator.__index = ClElevator
ClElevator.elevators = {} --[[ @as table<string, ClElevator> ]]

---@class ClElevatorData
---@field name string
---@field id string
---@field floors vector4[]

---@class ClElevator : ClElevatorData
---@field targets string[]|number[]
---@field openElevator fun(): nil
---@field delete fun(): nil

function ClElevator.clearAll()
    for i = 1, #ClElevator.elevators, 1 do
        local elevator = ClElevator.elevators[i]

        elevator:delete()
    end

    ClElevator.elevators = {}
end

---Creates a new client elevator target/zone
---@param data ClElevatorData
function ClElevator:new(data)
    local self = setmetatable({}, ClElevator)

    self.id = data.id
    self.name = data.name
    self.floors = data.floors

    self.targets = {}

    for i = 1, #data.floors, 1 do
        local floor = data.floors[i]

        local id = Target:AddTarget({
            xyz = floor.xyz,
            name = self.name,
            floor = i,
        }, function ()
            self:openElevator()
        end)

        table.insert(self.targets, id)
    end

    ClElevator.elevators[data.id] = self
end

function ClElevator:openElevator()
    local elevatorData = lib.callback.await('elevator:getfloordata', false, self.id)

    DebugPrint(string.format(
        'Open elevator called on %s %s response:', self.id, self.name),
        elevatorData
    )

    if (not elevatorData) then return end

    NUI.SendMessage("SetElevatorData", elevatorData)
    NUI.ToggleNui(true)
end

function ClElevator:delete()
    for i = 1, #self.targets, 1 do
        Target:RemoveTarget(self.targets[i])
    end
end