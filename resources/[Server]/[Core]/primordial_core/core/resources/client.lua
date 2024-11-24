--- Add an event handler to close the opens context menu when the resource stops
--- @param resourceName string The name of the resource that is stopping
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    local openMenu <const> = lib.getOpenContextMenu()
    if openMenu then
        lib.hideContext()
    end
end)

RegisterCommand('~==++openResourceInterface', function()
    ResourcesInterface()
end)

TriggerEvent('chat:removeSuggestion', '~==++openResourceInterface')

RegisterKeyMapping('~==++openResourceInterface', 'Open Ressource Manager', 'keyboard', 'F3')