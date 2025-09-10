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

return Framework