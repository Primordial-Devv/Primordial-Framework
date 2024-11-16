local zones = {}

lib.callback.register('primordial_admin:server:createAdminZone', function(source, adminZoneParam)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end

    zones[#zones+1] = adminZoneParam

    return TriggerClientEvent('primordial_admin:client:refreshAdminZone', -1, zones)
end)

lib.callback.register('primordial_admin:server:refreshZones', function(source)
    return zones
end)

lib.callback.register('primordial_admin:server:editZone', function(source, oldData, newData)
    local success

    for k, v in pairs(zones) do
        if (v.name == oldData.name) and (v.coords == oldData.coords) then
            zones[k] = newData
            success = true
            break
        end
    end

    if not success then return success end

    TriggerClientEvent('primordial_admin:client:refreshAdminZone', -1, zones)
    return success
end)

lib.callback.register('primordial_admin:server:deleteZone', function(source, zone)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end

    local success

    for k, v in pairs(zones) do
        if (v.name == zone.name and v.coords == zone.coords) then
            zones[k] = nil
            success = true
            break
        end
    end

    if not success then return success end

    local oldZones = zones
    zones = {}

    for k, v in pairs(oldZones) do
        if v and v?.name then
            zones[#zones + 1] = v
        end
    end

    TriggerClientEvent('primordial_admin:client:refreshAdminZone', -1, zones)
    return success
end)