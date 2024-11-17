CreateThread(function()
    for k,v in pairs(ItemsUseable) do
        PL.RegisterUsableItem(k, function(source)
            local sPlayer = PL.GetPlayerFromId(source)
            if v.remove then
                sPlayer.removeInventoryItem(k,1)
            end
            if v.type == "food" then
                TriggerClientEvent("primordial_lifeEssentials:client:add", source, "hunger", v.status)
                TriggerClientEvent('primordial_lifeEssentials:client:onUse', source, v.type, v.prop, v.anim)
                lib.notify(sPlayer.source, {
                    title = Translations.used_food:format(PL.GetItemLabel(k)),
                    type = 'info',
                })
            elseif v.type == "drink" then
                TriggerClientEvent("primordial_lifeEssentials:client:add", source, "thirst", v.status)
                TriggerClientEvent('primordial_lifeEssentials:client:onUse', source, v.type, v.prop, v.anim)
                lib.notify(sPlayer.source, {
                    title = Translations.used_drink:format(PL.GetItemLabel(k)),
                    type = 'info',
                })
            else
                PL.Print.Log(3, ('^3%s ^5 has no correct type defined.'):format(k))
            end
        end)
    end
end)



AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
    if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
        return
    end

    TriggerClientEvent('primordial_lifeEssentials:client:healPlayer', eventData.id)
end)