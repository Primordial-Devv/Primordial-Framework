local function RespawnPed(player, coords, heading)
    SetEntityCoordsNoOffset(player, coords.x, coords.y, coords.z, false, false, false)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    SetPlayerInvincible(player, false)
    ClearPedBloodDamage(player)

    TriggerEvent('\'pl_needs:resetStatuss')
    TriggerServerEvent('primordial_core:onPlayerSpawn')
    TriggerEvent('primordial_core:onPlayerSpawn')
end

RegisterNetEvent('primordial_admin:client:revivePlayer', function(check)
    if check then
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)

        PL.SetPlayerData("dead", false)

        DoScreenFadeOut(1500)

        while not IsScreenFadedOut() do
            Wait()
        end

        local formattedCoords = {x = PL.Math.Round(playerCoords.x, 1), y = PL.Math.Round(playerCoords.y, 1), z = PL.Math.Round(playerCoords.z, 1)}

        RespawnPed(player, formattedCoords, 0.0)
        ClearTimecycleModifier()
        SetPedMotionBlur(player, false)
        ClearExtraTimecycleModifier()
        DoScreenFadeIn(800)
    else
        local player = GetPlayerServerId(PlayerId())
        TriggerServerEvent('primordial_admin:server:checkNotPassed', player, 'revive')
    end
end)