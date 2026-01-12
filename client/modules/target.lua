local Target = {}

local zones = {}

local zoneKey <const> = Config.Options.Key
local textUiText <const> = string.format(Config.Options.TextUI, zoneKey.name)

local function drawZoneMarker(CZone)
    DrawMarker(
        markerData.marker,
        CZone.coords.x + markerData.offset.x, CZone.coords.y + markerData.offset.y, CZone.coords.z + markerData.offset.z,
        0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        markerData.size.x, markerData.size.y, markerData.size.z,
        markerData.color.r, markerData.color.g, markerData.color.b, markerData.color.a,
        true, true, 2, false, false, false, false
    )
end

local function drawZoneTextUi(CZone, openFunc)
    local coords = cache.coords

    if #(CZone.coords - coords) < Config.Options.Distance and not cache.vehicle then
        if not lib.isTextUIOpen() and not State.UIOpen then
            lib.showTextUI(textUiText)
        end

        if IsControlJustPressed(0, zoneKey.id) then
            lib.hideTextUI()
            openFunc()
        end
    elseif lib.isTextUIOpen() then
        lib.hideTextUI()
    end
end

---Create a new zone / target to open elevator
---@param data { xyz: vector3, name: string }
---@param cb fun(): nil
---@return number targetId
function Target:AddTarget(data, cb)
    if (Config.Options.Target) then
        return exports.ox_target:addSphereZone({
            coords = data.xyz,
            options = {{
                label = data.name,
                icon = Config.Options.Icon or nil,
                onSelect = cb,
            }}
        })
    else
        local zone = lib.zones.sphere({
            coords = data.xyz,
            radius = Config.Options.MarkerDistance,

            onEnter = function (self)
                lib.showTextUI(textUiText)
            end,
            inside = function (self)
                if (Config.Options.DrawMarker) then
                    drawZoneMarker(self)
                end

                drawZoneTextUi(self, cb)
            end
        })

        zones[zone.id] = zone

        return zone.id
    end
end

---Remove a zone / target
---@param id string|number
function Target:RemoveTarget(id)
    if (Config.Options.Target) then
        exports.ox_target:removeZone(id)
    else
        local zone = zones[id]

        if (not zone) then return end
        zone:remove()
    end
end

return Target