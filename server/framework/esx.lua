local Framework = {}

local ESX = exports.es_extended:getSharedObject()

---Check if a user has the appropriate group
---@param source number
---@param permissions table<string, number>
---@return boolean
function Framework:HasGroup(source, permissions)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job, grade = xPlayer.job.name, xPlayer.job.grade

    if (not permissions[job]) then return false end

    local requiredGrade = permissions[job]

    return requiredGrade <= grade
end

---Checks if a player has a specific item
---@param source number
---@param items table<string, table<string, any> | true>
---@return boolean
function Framework:HasItem(source, items)
    if (not items) then return true end

    if (IsResourceStarting('ox_inventory')) then
        for item, metadata in pairs(items) do
            local count = exports.ox_inventory:Search(
                source,
                'count',
                item,
                type(metadata) == "table" and metadata or nil
            )

            if (count > 0) then return true end
        end

        return false
    else
        local xPlayer = ESX.GetPlayerFromId(source)
        for item, metadata in pairs(items) do
            if (xPlayer.hasItem(item)) then

                if (metadata ~= true) then
                    warn(string.format("Required item has metadata parameters, but this method doesn't support metadata."))
                end

                return true
            end
        end

        return false
    end
end

return Framework