local Target = {}

local zones = {}

local zoneKey <const> = Config.Options.Key
local textUiText <const> = string.format(Config.Options.TextUI, zoneKey.name)
local markerData <const> = Config.Options.Marker

---Used for debugging zones
---Code credit @eblio - https://github.com/eblio/3dme/blob/master/client.lua#L12-L37
---@param pos vector3
---@param text string
---@param color { r: number; g: number; b: number; a: number; }
local function DrawText3D(pos, text, color)
    local camCoords = GetGameplayCamCoord()
    local dist = #(pos - camCoords)

    local scale = 200 / (GetGameplayCamFov() * dist)

    SetTextColour(color.r, color.g, color.b, 255)
    SetTextScale(0.0, 0.25 * scale)
    SetTextFont(0)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(pos.x, pos.y, pos.z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

local function drawZoneMarker(CZone)
    DrawMarker(
        markerData.marker,
        CZone.coords.x + markerData.offset.x, CZone.coords.y + markerData.offset.y, CZone.coords.z + markerData.offset.z,
        0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        markerData.size.x, markerData.size.y, markerData.size.z,
        markerData.color.r, markerData.color.g, markerData.color.b, markerData.color.a,
        true, true, 2, false, false, false, false
    )

    if (Config.DebugZones) then
        DrawText3D(
            CZone.coords + vector3(markerData.offset.x, markerData.offset.y, markerData.offset.z),
            CZone.debugLabel,
            CZone.debugColour
        )
    end
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
---@param data { xyz: vector3, name: string, floor: number; }
---@param cb fun(): nil
---@return number targetId
function Target:AddTarget(data, cb)
    if (Config.Options.Target) then
        return exports.ox_target:addSphereZone({
            coords = data.xyz,
            debug = Config.DebugZones,
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

            debug = Config.DebugZones,
            debugLabel = string.format("elevator: '%s' - floor: %d", data.name, data.floor),

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