CreateThread(function()
    for k,v in pairs(ItemsUseable) do
        PL.RegisterUsableItem(k, function(source)
            local sPlayer = PL.GetPlayerFromId(source)
            if v.remove then
                sPlayer.removeInventoryItem(k,1)
            end
            if v.type == "alcohol" then
                TriggerClientEvent("primordial_lifeEssentials:client:add", source, "drunk", v.status)
                TriggerClientEvent('primordial_lifeEssentials:client:onUse', source, v.type, v.prop, v.anim)
                lib.notify(sPlayer.source, {
                    title = Translations.used_drink:format(PL.GetItemLabel(k)),
                    type = 'info',
                })
            else
                PL.Print.Log(3, false, ('^0 %s has no correct type defined.'):format(k))
            end
        end)
    end
end)