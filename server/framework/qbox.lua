local Framework = {}

---Check if a user has the appropriate group
---@param source number
---@param permissions table<string, number>
---@return boolean
function Framework:HasGroup(source, permissions)
    return exports.qbx_core:HasGroup(source, permissions)
end

return Framework