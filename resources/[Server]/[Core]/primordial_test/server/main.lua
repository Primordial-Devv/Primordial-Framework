RegisterCommand('testserver', function(source, args, rawCommand)
    local source = source
    local player = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(player)
    local playerHeading = GetEntityHeading(player)
    local vehicleModel = 
    PL.Vehicle.SpawnServerVehicle('virtue', playerCoords, playerHeading, {}, function(vehicle)
        TaskWarpPedIntoVehicle(player, vehicle, -1)
    end)
end)

RegisterCommand('testserver2', function(source, args, rawCommand)
    local source = source
    local player = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(player)
    local playerHeading = GetEntityHeading(player)
    PL.Object.SpawnServerObject('tr_prop_tr_table_vault_01a', playerCoords + 0.5, playerHeading, function(object)
        FreezeEntityPosition(object, true)
    end)

    exports.ox_inventory:RegisterStash('stash_test', 'Test Stash', 30, 2000000, nil, {['ambulance'] = 1}, playerCoords)
    local stashInfo = {
        id = 'stash_test',
        coords = playerCoords,
    }
    TriggerClientEvent('test:event:test', source, stashInfo)
end)