function DebugPrint(...)
    if not Config.Debug then return end
    local args, newArgs = { ... }, {}

    for k, v in ipairs(args) do
        if type(v) == "table" then
            newArgs[k] = json.encode(
                v,
                {
                    indent=4, sort_keys=true
                }
            )
        elseif type(v) ~= "string" then
            newArgs[k] = json.encode(v) or 'nil'
        else
            newArgs[k] = v or 'nil'
        end
    end

    print("[^3DEBUG^7]", table.concat(newArgs, '\t'))
end

function IsResourceStarting(resource)
    local state = GetResourceState(resource)
    return state == "started" or state == "starting"
end

function GetFramework()
    if IsResourceStarting('es_extended') then return 'esx' end
    if IsResourceStarting('ox_core') then return 'ox' end
    if IsResourceStarting('qbx_core') then return 'qbox' end
    return 'standalone'
end

function CanResourceBeUsed(print_err)
    if not LoadResourceFile(GetCurrentResourceName(), 'web/build/index.html') then
        if print_err then lib.print.error('The resource cannot be used, the UI is not built.\n   Please download a release version or build the UI: ^4https://github.com/Maximus7474/mps-elevator/releases^7') end
        return false
    end
    return true
end