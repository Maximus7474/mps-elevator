---@class Framework
---@field HasGroup fun(self: Framework, source: number, permissions: table<string, number>): boolean
---@field HasItem fun(self: Framework, source: number, items: table<string, table<string, any>|true>): boolean

---@type Framework
local framework = require (string.format('server.framework.%s', GetFramework()))

---@return Framework
function GetFrameworkObject()
    return framework
end

---@param groups? string | string[] | table<string, number>
---@return false | table<string, number>
function SanitizeGroups(groups)
    if (not groups) then return false end

    local sanitizedGroups = {}

    if (type(groups) == "string") then
        sanitizedGroups[groups] = 0

    elseif (type(groups) == "table") then

        for key, value in pairs(groups) do

            if (type(key) == "number") then
                sanitizedGroups[key] = 0

            elseif (type(key) == "string" and type(value) == "number") then
                sanitizedGroups[key] = value
            end
        end
    end

    return next(sanitizedGroups) and sanitizedGroups or false
end

---@param items? string | string[] | table<string, table<string, any>>
---@return false | table<string, true | table<string, any>>
function SanitizeItems(items)
    if (not items) then return false end

    local sanitizedItems = {}

    if (type(items) == "string") then
        sanitizedItems[items] = true

    elseif (type(items) == "table") then

        for key, value in pairs(items) do

            if (type(key) == "number") then
                sanitizedItems[key] = true

            elseif (type(key) == "string" and type(value) ~= "table") then
                sanitizedItems[key] = value
            end
        end
    end

    return next(sanitizedItems) and sanitizedItems or false
end