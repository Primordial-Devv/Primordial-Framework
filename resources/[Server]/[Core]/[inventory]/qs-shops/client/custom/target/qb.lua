if not Config.UseTarget then
    return
end

local target_name = GetResourceState('ox_target'):find('started') and 'qtarget' or 'qb-target'

function InitializeTargetPed(k, v, ped)
    local defaultTargetIcon = 'fas fa-shopping-cart'
    local defaultTargetLabel = 'Open Shop'

    if ped then
        exports[target_name]:AddTargetEntity(ped, {
            options = {
                {
                    label = v.targetLabel or defaultTargetLabel,
                    icon = v.targetIcon or defaultTargetIcon,
                    item = v.requiredItem,
                    type = 'server',
                    event = 'qb-shops:server:openShop',
                    shop = k,
                    job = v.requiredJob,
                    gang = v.requiredGang
                }
            },
            distance = 2.0
        })
    else
        exports[target_name]:AddCircleZone(k, vector3(v.coords.x, v.coords.y, v.coords.z), 0.5, {
            name = k,
            debugPoly = Config.ZoneDebug,
            useZ = true
        }, {
            options = {
                {
                    label = v.targetLabel or defaultTargetLabel,
                    icon = v.targetIcon or defaultTargetIcon,
                    item = v.requiredItem,
                    type = 'server',
                    event = 'qb-shops:server:openShop',
                    shop = k,
                    job = v.requiredJob,
                    gang = v.requiredGang
                }
            },
            distance = 2.0
        })
    end
end

CreateThread(function()
    for k, v in pairs(Config.Stashes) do
        exports[target_name]:AddCircleZone(v.label .. k, vector3(v.coords.x, v.coords.y, v.coords.z), 0.5, {
            name = v.label .. k,
            debugPoly = false,
            useZ = true
        }, {
            options = {
                {
                    label = v.targetLabel,
                    icon = 'fas fa-shopping-cart',
                    event = 'shops:openStash',
                    stash = v
                }
            },
            distance = 2.0
        })
    end
end)
