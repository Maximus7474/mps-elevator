local Framework = {}

local Ox = require '@ox_core.lib.init'

---Check if a user has the appropriate group
---@param source number
---@param permissions table<string, number>
---@return boolean
function Framework:HasGroup(source, permissions)
    local player = Ox.GetPlayer(source)

    local group, _ = player.getGroup(permissions)

    if (not group) then return false end

    return true
end

return Framework