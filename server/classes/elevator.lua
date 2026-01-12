Elevator = {}
Elevator.__index = Elevator
Elevator.elevators = {} --[[ @as table<string, Elevator> ]]

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
---@field id number
---@field groups table<string, number> | false
---@field items table<string, table<string, any>|true> | false
---@field bucket number

---@class ElevatorFloor
---@field id number
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
---@field getFloors fun(self: Elevator, source: number): { restricted: boolean; floors: ElevatorFloor[] }
---@field getFloorPositions fun(self: Elevator, source: number, bucket: number): false | {name: string; id: string; floors: vector4[]}
---@field isInElevator fun(self: Elevator, source): boolean
---@field gotoFloor fun(self: Elevator, source, floorid: number): boolean

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
            id = i,
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

    Elevator.elevators[data.id] = self

    Citizen.CreateThreadNow(function()
        local players = GetPlayers()

        for i = 1, #players do
            local player = tonumber(players[i])
            exports['mps-elevator']:UpdatePlayerTargets(player, false)
        end
    end)

    return self
end

---Checks if a player can use an elevator
---@param source number
---@return boolean
function Elevator:canUse(source)
    if (not self.groups) then return true end

    return FW:HasGroup(source, self.groups)
end

---Get the floor positions where the user can interact
---@param source any
---@param bucket number
---@return false | {name: string; id: string; floors: vector4[]}
function Elevator:getFloorPositions(source, bucket)
    local floors = {}

    if (not self:canUse(source)) then return false end

    for i = 1, #self.floors, 1 do
        local floorData = self.floors[i] --[[ @as ElevatorFloorInternal ]]

        if (floorData.bucket ~= bucket) then
            goto continue
        elseif (floorData.groups and not FW:HasGroup(source, floorData.groups)) then
            goto continue
        elseif (floorData.items and not FW:HasItem(source, floorData.items)) then
            goto continue
        end

        table.insert(floors, floorData.coords)

        ::continue::
    end

    return {
        id = self.id,
        name = self.name,
        floors = floors,
    }
end

---Returns a list of floors for the elevator
---@param source number
---@return { restricted: boolean; floors: ElevatorFloor[]}
function Elevator:getFloors(source)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local playerBucket = GetPlayerRoutingBucket(tostring(source))
    local floors = {} --[[ @as ElevatorFloor[] ]]
    local hasRestrictions = false

    for i = 1, #self.floors, 1 do
        local floorData = self.floors[i] --[[ @as ElevatorFloorInternal ]]

        local isCurrentFloor = false
        if (
                floorData.bucket == playerBucket
            and #(floorData.coords.xyz - playerCoords) < Config.Options.Distance
        ) then
            isCurrentFloor = true
        end

        local canAccess = true
        if (canAccess and floorData.groups and not FW:HasGroup(source, floorData.groups)) then
            canAccess = false
        end
        if (canAccess and floorData.items and not FW:HasItem(source, floorData.items)) then
            canAccess = false
        end

        if (not hasRestrictions and (floorData.items or floorData.groups)) then
            hasRestrictions = true
        end

        floors[i] = {
            id = floorData.id,
            name = floorData.name,
            icon = floorData.icon,
            current = isCurrentFloor,
            accessible = canAccess,
        } --[[ @as ElevatorFloor ]]
    end

    return {
        restricted = hasRestrictions or (self.groups or self.items) ~= false,
        floors = floors
    }
end

---Teleport a player to the desired floor
---@param source number | string
---@param floorid number
---@return boolean success
function Elevator:gotoFloor(source, floorid)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local playerBucket = GetPlayerRoutingBucket(tostring(source))

    local isInElevator = false
    local floorToGoto
    for i = 1, #self.floors, 1 do
        local floorData = self.floors[i] --[[ @as ElevatorFloorInternal ]]

        if (
                floorData.bucket == playerBucket
            and #(floorData.coords.xyz - playerCoords) < Config.Options.Distance
        ) then
            isInElevator = true
        elseif floorData.id == floorid then
            floorToGoto = floorData
        end
    end

    if (not isInElevator or not floorToGoto) then
        warn(string.format('Player %s (%d) tried to exploit Elevator:gotoFloor !', GetPlayerName(source), tonumber(source)))
        return false
    end

    TriggerClientEvent('elevator:client:changingfloor', source, true)

    if (playerBucket ~= floorToGoto.bucket) then
        SetPlayerRoutingBucket(source --[[ @as string ]], floorToGoto.bucket)

        -- Shared method with ox_inventory, this will make drops limited
        -- to the new routing bucket
        Player(source).state:set('instance', floorToGoto.bucket, true)
    end

    if (Config.Options.ScreenFade) then Wait(Config.Options.FadeDuration) end

    SetEntityCoords(playerPed, floorToGoto.coords.x, floorToGoto.coords.y, floorToGoto.coords.z, true, false, false, false)
    SetEntityHeading(playerPed, floorToGoto.coords.w)

    if (Config.Options.ScreenFade) then Wait(Config.Options.FadeDuration) end

    TriggerClientEvent('elevator:client:changingfloor', source, false)

    return true
end

---Checks if a player is within the elevator
---@param source number
---@return boolean
function Elevator:isInElevator(source)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local playerBucket = GetPlayerRoutingBucket(tostring(source))

    for i = 1, #self.floors, 1 do
        local floorData = self.floors[i] --[[ @as ElevatorFloorInternal ]]

        if (
                floorData.bucket == playerBucket
            and #(floorData.coords.xyz - playerCoords) < Config.Options.Distance
        ) then
            return true
        end
    end

    return false
end
