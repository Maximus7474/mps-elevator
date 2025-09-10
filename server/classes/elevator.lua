Elevator = {}
Elevator.__index = Elevator
Elevator.elevators = {}

local FW = GetFrameworkObject()

---@class ElevatorFloorData
---@field name string
---@field icon? string used for floor number i.e. "-01", "G", "SB"
---@field groups? string | string[] | table<string, number> either a group name, array of groups or group and grade pair
---@field items? string | string[] | table<string, table<string, any>> either an item name, array of items or item and metadata table pair
---@field coords vector4
---@field bucket? number

---@class ElevatorData
---@field id string unique identifier
---@field name string
---@field groups? string | table<string, number>
---@field items? string | string[] | table<string, table<string, any>> either an item name, array of items or item and metadata table pair
---@field floors ElevatorFloorData[]

---@class ElevatorFloor
---@field name string
---@field current boolean
---@field icon? string used for floor number i.e. "-01", "G", "SB"

---@class Elevator
---@field id string unique identifier
---@field name string
---@field groups table<string, number> | false
---@field items table<string, true | table<string, any>> | false
---@field canUse fun(self: Elevator, source: number): boolean
---@field getFloors fun(self: Elevator, source: number): ElevatorFloor[]

---Creates a new elevator
---@param data ElevatorData
---@return table Elevator
function Elevator:new(data)
    local self = setmetatable({}, Elevator)

    self.id = data.id
    self.name = data.name

    self.groups = SanitizeGroups(data.groups)
    self.items = SanitizeItems(data.items)

    return self
end

---Checks if a player can use an elevator
---@param source number
---@return boolean
function Elevator:canUse(source)
    if (not self.groups) then return true end

    return FW:HasGroup(source, self.groups)
end

function Elevator:getFloors(source)
end