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

---@class ElevatorFloorInternal: ElevatorFloorData
---@field groups table<string, number> | false
---@field items table<string, table<string, any>|true> | false
---@field bucket number

---@class ElevatorFloor
---@field name string
---@field current boolean
---@field accessible boolean
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

    local floors = {} --[[ @as ElevatorFloorInternal[] ]]
    for i = 1, #data.floors, 1 do
        local floorData = data.floors[i]

        local sanitizedData = {
            name = floorData.name,
            icon = floorData.icon,
            groups = SanitizeGroups(floorData.groups),
            items = SanitizeItems(floorData.items),
            bucket = floorData.bucket or 0,
            coords = floorData.coords,
        } --[[ @as ElevatorFloorInternal ]]

        floors[i] = sanitizedData
    end

    self.floors = floors

    Elevator.elevators[data.name] = self

    return self
end

---Checks if a player can use an elevator
---@param source number
---@return boolean
function Elevator:canUse(source)
    if (not self.groups) then return true end

    return FW:HasGroup(source, self.groups)
end

---Returns a list of floors for the elevator
---@param source number
---@return ElevatorFloor[]
function Elevator:getFloors(source)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local playerBucket = GetPlayerRoutingBucket(tostring(source))
    local floors = {} --[[ @as ElevatorFloor[] ]]

    for i = 1, #self.floors, 1 do
        local floorData = self.floors[i] --[[ @as ElevatorFloorInternal ]]

        local isCurrentFloor = false
        if (#(floorData.coords - playerCoords) < Config.Options.Distance) then
            isCurrentFloor = true

            if (type(floorData.bucket) == "number") then
                isCurrentFloor = floorData.bucket == playerBucket
            end
        end

        local canAccess = true
        if (canAccess and floorData.groups and not FW:HasGroup(source, floorData.groups)) then
            canAccess = false
        end
        if (canAccess and floorData.items and not FW:HasItem(source, floorData.items)) then
            canAccess = false
        end

        floors[i] = {
            name = floorData.name,
            icon = floorData.icon,
            current = isCurrentFloor,
            accessible = canAccess,
        }
    end

    return floors
end