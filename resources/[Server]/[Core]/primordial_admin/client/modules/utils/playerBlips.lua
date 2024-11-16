local activeBlips = {}

RegisterNetEvent('primordial_admin:client:refreshPlayerBlips', function(blipData)
    if next(activeBlips) then
        for _, blip in ipairs(activeBlips) do
            RemoveBlip(blip)
        end
        activeBlips = {}
    end

    if not blipData or not next(blipData) then return end

    for _, blip in ipairs(blipData) do
        local id = #activeBlips + 1
        activeBlips[id] = CreateBlip(blip.coords, blip.inVehicle ~= 0  and 523 or 1, 0, (Translations.player_blip_id):format(blip.id), 0.7, false)
    end
end)