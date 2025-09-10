local Framework = {}

---Check if a user has the appropriate group
---@param source number
---@param permissions table<string, number>
---@return boolean
function Framework:HasGroup(source, permissions)
    if (not permissions) then return true end

    return exports.qbx_core:HasGroup(source, permissions)
end

---Checks if a player has a specific item
---@param source number
---@param items table<string, table<string, any> | true>
---@return boolean
function Framework:HasItem(source, items)
    if (not items) then return true end

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
end

return Framework