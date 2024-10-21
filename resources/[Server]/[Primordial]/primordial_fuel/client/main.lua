AddEventHandler('primordial_core:playerLoaded', function(sPlayer)
    PL.PlayerData = sPlayer
    PlayerLoaded = true
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    local getOpenMenu = lib.getOpenContextMenu()
    lib.hideContext(getOpenMenu)
end)