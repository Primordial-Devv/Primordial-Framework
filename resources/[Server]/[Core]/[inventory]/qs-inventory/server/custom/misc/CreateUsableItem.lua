--[[ 
    Usable items that you can edit; do not add more items here as it’s unnecessary with this method. 
    These are the core and essential items in the inventory, each carrying critical information.

    Please avoid adding additional items here. Instead, add them in your other scripts 
    using the conventional RegisterUsableItem system.
]]

if not ItemList or not WeaponList then return end

-- Documents
CreateUsableItem('driver_license', function(source, item)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local players = FrameworkGetPlayers()
    for _, v in pairs(players) do
        v = tonumber(v)
        local targetPed = GetPlayerPed(v)
        local dist = #(playerCoords - GetEntityCoords(targetPed))
        if dist < 3.0 then
            TriggerClientEvent('chat:addMessage', v, {
                template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>First Name:</strong> {1} <br><strong>Last Name:</strong> {2} <br><strong>Birth Date:</strong> {3} <br><strong>Licenses:</strong> {4}</div></div>',
                args = {
                    'Drivers License',
                    item.info.firstname,
                    item.info.lastname,
                    item.info.birthdate,
                    item.info.type
                }
            }
            )
        end
    end
end)

CreateUsableItem('id_card', function(source, item)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local players = FrameworkGetPlayers()
    for _, v in pairs(players) do
        v = tonumber(v)
        local targetPed = GetPlayerPed(v)
        local dist = #(playerCoords - GetEntityCoords(targetPed))
        if dist < 3.0 then
            TriggerClientEvent('chat:addMessage', v, {
                template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}:</strong><br><br><strong>CBN:</strong> {1} <br><strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>Birthdate:</strong> {4} <br><strong>Gender:</strong> {5} <br><strong>Nationality:</strong> {6}</div></div>',
                args = {
                    'ID Card',
                    item.info.citizenid or 'ID-Card ' .. math.random(11111, 99999),
                    item.info.firstname,
                    item.info.lastname,
                    item.info.birthdate,
                    item.info.gender or 'AH-64 Apache Helicopter',
                    item.info.nationality or 'No information',
                }
            }
            )
        end
    end
end)

-- AMMO
CreateUsableItem('pistol_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_PISTOL', 12, item)
end)

CreateUsableItem('rifle_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_RIFLE', 30, item)
end)

CreateUsableItem('smg_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_SMG', 20, item)
end)

CreateUsableItem('shotgun_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_SHOTGUN', 10, item)
end)

CreateUsableItem('mg_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_MG', 30, item)
end)

CreateUsableItem('emp_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_EMPLAUNCHER', 10, item)
end)

CreateUsableItem('rpg_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_RPG', 1, item)
end)

CreateUsableItem('grenadelauncher_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_GRENADELAUNCHER', 1, item)
end)

CreateUsableItem('snp_ammo', function(source, item)
    TriggerClientEvent('weapons:client:AddAmmo', source, 'AMMO_SNIPER', 1, item)
end)

CreateUsableItem('master_ammo', function(source, item)
    TriggerClientEvent('weapons:client:masterAmmo', source, 1, item)
end)

for k, v in pairs(Config.WeaponAttachmentItems) do
    CreateUsableItem(v.item, function(source, item)
        if v.isUrlTint then
            if not item.info.urltint then
                TriggerClientEvent('weapons:client:ConfigureTint', source, item)
            else
                TriggerClientEvent('weapons:client:EquipAttachment', source, item, v.item)
            end
        else
            TriggerClientEvent('weapons:client:EquipAttachment', source, item, v.attachment)
        end
    end)
end


--[[
    -- Snippet when using an item and it is spent

    CreateUsableItem('firstaid', function(source)
        local item = GetItemByName(source, 'firstaid')
        if item.info.quality >= 10 then
            item.info.quality = item.info.quality - 10
            print("Item:", item.name, "Slot:", item.slot, "Info:", json.encode(item.info))
            SetItemMetadata(source, item.slot, item.info)

            print("You used the item. Remaining durability:", item.info.quality)
        else
            print("The item is broken, you can't use it")
        end
    end)
]]
