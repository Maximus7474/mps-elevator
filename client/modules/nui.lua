local NUI = {}

---@param action string The action you wish to target
---@param data any The data you wish to send along with this action
function NUI.SendMessage(action, data)
    DebugPrint("[^2SendNUIMessage^7]", action, json.encode(data))
    SendNUIMessage({
        action = action,
        data = data
    })
end

---@param shouldShow boolean
function NUI.ToggleNui(shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
    DebugPrint("[^2NUI:ToggleNui^7] Showing UI")
    NUI.SendMessage('setVisible', shouldShow)
end

return NUI