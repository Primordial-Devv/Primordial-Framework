AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    lib.getOpenContextMenu()
    lib.hideContext()
end)