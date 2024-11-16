AddEventHandler('primordial_core:playerLoaded', function(sPlayer)
    PL.PlayerData = sPlayer
    PlayerLoaded = true
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    local getOpenMenu = lib.getOpenContextMenu()
    lib.hideContext(getOpenMenu)
end)

function CreateBlip(coords, sprite, color, text, scale, flash)
    local x, y, z = table.unpack(coords)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    if flash then
        SetBlipFlashes(blip, true)
    end
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

RegisterCommand('~=++openadmininterface', function()
    local permissions = lib.callback.await('primordial_admin:server:checkAdminPerms', 200)

    if not permissions or not permissions?.open then
        PL.Print.Log(3, false, 'You do not have the required permissions to use the admin interface.')
        return
    end

    PL.Print.Log(1, false, 'Opening the admin interface...')
    AdminInterface(permissions)
end)

TriggerEvent('chat:removeSuggestion', '~=++openadmininterface')

RegisterKeyMapping('~=++openadmininterface', Translations.admin_interface_key_mapping_description, 'keyboard', 'F5')