local Framework = {}

---Checks if the user has the adequate group
---@param restrictions table
---@return boolean HasGroup
function Framework:HasGroup(restrictions)
    local hasGroup = exports.qbx_core:HasGroup(restrictions)
    return hasGroup or false
end

return Framework