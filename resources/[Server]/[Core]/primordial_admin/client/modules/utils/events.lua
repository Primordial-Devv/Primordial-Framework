RegisterNetEvent("primordial_admin:client:freezePlayer")
AddEventHandler("primordial_core:client:freezePlayer", function(input)
    PL.Print.Log(4, ('Freeze player: %s'):format(input))
    local player = PlayerId()
    if input == "freeze" then
        SetEntityCollision(PL.PlayerData.ped, false)
        FreezeEntityPosition(PL.PlayerData.ped, true)
        SetPlayerInvincible(player, true)
    elseif input == "unfreeze" then
        SetEntityCollision(PL.PlayerData.ped, true)
        FreezeEntityPosition(PL.PlayerData.ped, false)
        SetPlayerInvincible(player, false)
    end
end)