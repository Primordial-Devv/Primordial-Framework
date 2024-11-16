 ActivePlayers = {}
local savedCoords = {}

RegisterNetEvent('primordial_admin:server:checkNotPassed', function(source, feature)
    local source = source
    local sourrceOfCheckFailed = PL.GetPlayerFromId(source)
    PL.Print.Log(3, false, ('^3Player ^1%s ^3tried to use the ^5%s ^3feature without permission.'):format(sourrceOfCheckFailed['name'], feature))
end)

RegisterNetEvent('primordial_admin:server:initializePlayers', function()
    local source = source
    if ActivePlayers and next(ActivePlayers) then
        for playerIndex, playerData in ipairs(ActivePlayers) do
            if playerData.id == source then
                table.remove(ActivePlayers, playerIndex)
                break
            end
        end
    end
    ActivePlayers[#ActivePlayers + 1] = {
        name = GetPlayerName(source),
        identifier = PL.GetPlayerFromId(source),
        id = source
    }
end)

RegisterNetEvent('playerDropped', function()
    local source = source
    for playerIndex, playerData in ipairs(ActivePlayers) do
        if playerData.id == source then
            table.remove(ActivePlayers, playerIndex)
            break
        end
    end
end)

RegisterNetEvent('primordial_admin:server:teleportToPlayer', function(targetId)
    local source = source
    local targetCoords = GetEntityCoords(GetPlayerPed(targetId))
    if not targetCoords then
        return PL.Print.Log(3, false, ('Staff member try to teleport to a player but the coords of the player are not found.'))
    end
    SetEntityCoords(source, targetCoords)
end)

RegisterNetEvent('primordial_admin:server:teleportPlayerTo', function(targetId, targetName)
    local source = source
    local sourceCoords = GetEntityCoords(GetPlayerPed(source))
    local targetCoords = GetEntityCoords(GetPlayerPed(targetId))
    if not sourceCoords then
        return PL.Print.Log(3, false, ('Staff member try to teleport a player to him but his coords are not found.'))
    end
    savedCoords[targetId] = {
        id = targetId,
        name = targetName,
        coords = targetCoords
    }
    SetEntityCoords(targetId, sourceCoords)
end)

RegisterNetEvent('primordial_admin:server:teleportBackPlayer', function(targetId)
    local targetCoords = savedCoords[targetId].coords
    if not targetCoords then
        return PL.Print.Log(3, false, ('Staff member try to teleport a player back to his previous location but the coords are not found.'))
    end
    SetEntityCoords(targetId, targetCoords)
    savedCoords[targetId] = nil
end)


RegisterNetEvent('primordial_admin:server:revivePlayer', function(targetId, checked)
    local source = source
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end
    TriggerClientEvent('primordial_admin:client:revivePlayer', targetId, checked)
end)

RegisterNetEvent('primordial_admin:server:healPlayer', function(targetId)
    local source = source
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end

    TriggerClientEvent('primordial_lifeEssentials:client:healPlayer', targetId)
end)

RegisterNetEvent('primordial_admin:server:reviveAllPlayers', function()
    for _, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('primordial_admin:client:revivePlayer', playerId, true)
        lib.notify(source, {
            title = Translations.all_players_revived,
            type = 'success'
        })

        lib.notify(playerId, {
            title = Translations.you_have_been_revived,
            type = 'success'
        })
    end
end)

RegisterNetEvent('primordial_admin:server:weatherSync', function(type)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end

    Weather = type
    TriggerClientEvent('primordial_admin:client:weathersync', -1, type)

    lib.notify(source, {
        title = Translations.notify_weather:format(string.lower(type)),
        type = 'success'
    })
end)

RegisterNetEvent('primordial_admin:server:syncTime', function(hour, minute)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end

    TriggerClientEvent('primordial_admin:client:syncTime', -1, hour, minute)

    lib.notify(source, {
        title = Translations.notify_time_sync:format(hour, minute),
        type = 'success'
    })
end)

RegisterNetEvent('primordial_admin:server:deleteEntity', function(netId)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
end)

PL.RegisterCommand('pl', {'admin'}, function(sPlayer)
    PL.Print.Log(4, true, sPlayer)
end, false, {
    help = 'Player',
})