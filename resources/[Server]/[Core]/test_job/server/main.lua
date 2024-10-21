TriggerEvent('primordial_core:server:registerSociety', "ambulance", "EMS", "society_ambulance", "society_ambulance", "society_ambulance", {type = 'private'})

local PlayersHarvesting = {}










local function RecupCoton(source)
    if PlayersHarvesting[source] == true then
        local sPlayer = PL.GetPlayerFromId(source)
        local itemQuantity = exports['qs-inventory']:GetItemTotalAmount(source, "coton")

        if itemQuantity >= FarmPharmacy["Coton"].MaxItemToFarm then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'ERREUR',
                description = "Vous ne pouvez pas récupérer plus de coton",
                position = "top",
                type = 'error',
                duration = 4000,
            })
            return
        end

        SetTimeout(FarmPharmacy["Coton"].TimeToGiveItem, function()
            sPlayer.addInventoryItem(FarmPharmacy["Coton"].ItemToFarm, 1)
            TriggerClientEvent('ox_lib:notify',  source, {
                title = 'EMS',
                description = "Vous avez récupéré 1 " .. FarmPharmacy["Coton"].ItemToFarm,
                position = "top",
                type = 'inform',
                duration = 5500,
            })
            RecupCoton(source)
        end)
    end
end

RegisterServerEvent('Lys_EMS:Server:startRecupCoton')
AddEventHandler('Lys_EMS:Server:startRecupCoton', function()
    local _source = source
    PlayersHarvesting[_source] = true

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous commencez à récupérer du coton",
        position = "top",
        type = 'inform',
        duration = 3500,
    })

    RecupCoton(source)
end)

RegisterServerEvent('Lys_EMS:Server:stopRecupCoton')
AddEventHandler('Lys_EMS:Server:stopRecupCoton', function()
    local _source = source
    PlayersHarvesting[_source] = false

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous arrêtez de récupérer du coton",
        position = "top",
        type = 'inform',
        duration = 3500,
    })
end)

RegisterCommand('stashtest', function(source, args, rawCommand)
    local source = source
    local player GetPlayerPed(source)
    local playerCoords = GetEntityCoords(player)
    local playerHeading = GetEntityHeading(player)
    PL.Object.SpawnServerObject('tr_prop_tr_table_vault_01a', playerCoords, playerHeading, function(object)
        FreezeEntityPosition(object, true)
    end)

    exports.ox_inventory:RegisterStash('stash_test', 'Test Stash', 30, 2000000, nil, {'ambulance'}, playerCoords)
end)









local function RecupAlcool(source)
    if PlayersHarvesting[source] == true then
        local sPlayer = PL.GetPlayerFromId(source)
        local itemQuantity = exports['qs-inventory']:GetItemTotalAmount(source, "alcool")

        if itemQuantity >= FarmPharmacy["Alcool"].MaxItemToFarm then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'ERREUR',
                description = "Vous ne pouvez pas récupérer plus d'alcool",
                position = "top",
                type = 'error',
                duration = 4000,
            })
            return
        end

        SetTimeout(FarmPharmacy["Alcool"].TimeToGiveItem, function()
            sPlayer.addInventoryItem(FarmPharmacy["Alcool"].ItemToFarm, 1)
            TriggerClientEvent('ox_lib:notify',  source, {
                title = 'EMS',
                description = "Vous avez récupéré 1 " .. FarmPharmacy["Alcool"].ItemToFarm,
                position = "top",
                type = 'inform',
                duration = 5500,
            })
            RecupAlcool(source)
        end)
    end
end

RegisterServerEvent('Lys_EMS:Server:startRecupAlcool')
AddEventHandler('Lys_EMS:Server:startRecupAlcool', function()
    local _source = source
    PlayersHarvesting[_source] = true

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous commencez à récupérer de l'alcool",
        position = "top",
        type = 'inform',
        duration = 3500,
    })

    RecupAlcool(source)
end)

RegisterServerEvent('Lys_EMS:Server:stopRecupAlcool')
AddEventHandler('Lys_EMS:Server:stopRecupAlcool', function()
    local _source = source
    PlayersHarvesting[_source] = false

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous arrêtez de récupérer de l'alcool",
        position = "top",
        type = 'inform',
        duration = 3500,
    })
end)










local function RecupSparadarap(source)
    if PlayersHarvesting[source] == true then
        local sPlayer = PL.GetPlayerFromId(source)
        local itemQuantity = exports['qs-inventory']:GetItemTotalAmount(source, "sparadrap")

        if itemQuantity >= FarmPharmacy["Sparadrap"].MaxItemToFarm then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'ERREUR',
                description = "Vous ne pouvez pas récupérer plus de sparadrap",
                position = "top",
                type = 'error',
                duration = 4000,
            })
            return
        end

        SetTimeout(FarmPharmacy["Sparadrap"].TimeToGiveItem, function()
            sPlayer.addInventoryItem(FarmPharmacy["Sparadrap"].ItemToFarm, 1)
            TriggerClientEvent('ox_lib:notify',  source, {
                title = 'EMS',
                description = "Vous avez récupéré 1 " .. FarmPharmacy["Sparadrap"].ItemToFarm,
                position = "top",
                type = 'inform',
                duration = 5500,
            })
            RecupSparadarap(source)
        end)
    end
end

RegisterServerEvent('Lys_EMS:Server:startRecupSparadrap')
AddEventHandler('Lys_EMS:Server:startRecupSparadrap', function()
    local _source = source
    PlayersHarvesting[_source] = true

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous commencez à récupérer du sparadrap",
        position = "top",
        type = 'inform',
        duration = 3500,
    })

    RecupSparadarap(source)
end)

RegisterServerEvent('Lys_EMS:Server:stopRecupSparadrap')
AddEventHandler('Lys_EMS:Server:stopRecupSparadrap', function()
    local _source = source
    PlayersHarvesting[_source] = false

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous arrêtez de récupérer du sparadrap",
        position = "top",
        type = 'inform',
        duration = 3500,
    })
end)










local function RecupPlastique(source)
    if PlayersHarvesting[source] == true then
        local sPlayer = PL.GetPlayerFromId(source)
        local itemQuantity = exports['qs-inventory']:GetItemTotalAmount(source, "plastic")

        if itemQuantity >= FarmPharmacy["Plastique"].MaxItemToFarm then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'ERREUR',
                description = "Vous ne pouvez pas récupérer plus de Plastique",
                position = "top",
                type = 'error',
                duration = 4000,
            })
            return
        end

        SetTimeout(FarmPharmacy["Plastique"].TimeToGiveItem, function()
            sPlayer.addInventoryItem(FarmPharmacy["Plastique"].ItemToFarm, 1)
            TriggerClientEvent('ox_lib:notify',  source, {
                title = 'EMS',
                description = "Vous avez récupéré 1 " .. FarmPharmacy["Plastique"].ItemToFarm,
                position = "top",
                type = 'inform',
                duration = 5500,
            })
            RecupPlastique(source)
        end)
    end
end

RegisterServerEvent('Lys_EMS:Server:startRecupPlastique')
AddEventHandler('Lys_EMS:Server:startRecupPlastique', function()
    local _source = source
    PlayersHarvesting[_source] = true

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous commencez à récupérer du Plastique",
        position = "top",
        type = 'inform',
        duration = 3500,
    })

    RecupPlastique(source)
end)

RegisterServerEvent('Lys_EMS:Server:stopRecupPlastique')
AddEventHandler('Lys_EMS:Server:stopRecupPlastique', function()
    local _source = source
    PlayersHarvesting[_source] = false

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous arrêtez de récupérer du Plastique",
        position = "top",
        type = 'inform',
        duration = 3500,
    })
end)










local function RecupMedicalMask(source)
    if PlayersHarvesting[source] == true then
        local sPlayer = PL.GetPlayerFromId(source)
        local itemQuantity = exports['qs-inventory']:GetItemTotalAmount(source, "medi_mask")

        if itemQuantity >= FarmPharmacy["MedicalMask"].MaxItemToFarm then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'ERREUR',
                description = "Vous ne pouvez pas récupérer plus de masque médicale",
                position = "top",
                type = 'error',
                duration = 4000,
            })
            return
        end

        SetTimeout(FarmPharmacy["MedicalMask"].TimeToGiveItem, function()
            sPlayer.addInventoryItem(FarmPharmacy["MedicalMask"].ItemToFarm, 1)
            TriggerClientEvent('ox_lib:notify',  source, {
                title = 'EMS',
                description = "Vous avez récupéré 1 " .. FarmPharmacy["MedicalMask"].ItemToFarm,
                position = "top",
                type = 'inform',
                duration = 5500,
            })
            RecupMedicalMask(source)
        end)
    end
end

RegisterServerEvent('Lys_EMS:Server:startRecupMedicalMask')
AddEventHandler('Lys_EMS:Server:startRecupMedicalMask', function()
    local _source = source
    PlayersHarvesting[_source] = true

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous commencez à récupérer un masque médicale",
        position = "top",
        type = 'inform',
        duration = 3500,
    })

    RecupMedicalMask(source)
end)

RegisterServerEvent('Lys_EMS:Server:stopRecupMedicalMask')
AddEventHandler('Lys_EMS:Server:stopRecupMedicalMask', function()
    local _source = source
    PlayersHarvesting[_source] = false

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous arrêtez de récupérer un masque médicale",
        position = "top",
        type = 'inform',
        duration = 3500,
    })
end)










local function RecupOxygene(source)
    if PlayersHarvesting[source] == true then
        local sPlayer = PL.GetPlayerFromId(source)
        local itemQuantity = exports['qs-inventory']:GetItemTotalAmount(source, "oxygen")

        if itemQuantity >= FarmPharmacy["Oxygene"].MaxItemToFarm then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'ERREUR',
                description = "Vous ne pouvez pas récupérer plus de capsule d'oxygène",
                position = "top",
                type = 'error',
                duration = 4000,
            })
            return
        end

        SetTimeout(FarmPharmacy["Oxygene"].TimeToGiveItem, function()
            sPlayer.addInventoryItem(FarmPharmacy["Oxygene"].ItemToFarm, 1)
            TriggerClientEvent('ox_lib:notify',  source, {
                title = 'EMS',
                description = "Vous avez récupéré 1 " .. FarmPharmacy["Oxygene"].ItemToFarm,
                position = "top",
                type = 'inform',
                duration = 5500,
            })
            RecupOxygene(source)
        end)
    end
end

RegisterServerEvent('Lys_EMS:Server:startRecupOxygene')
AddEventHandler('Lys_EMS:Server:startRecupOxygene', function()
    local _source = source
    PlayersHarvesting[_source] = true

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous commencez à récupérer une capsule d'oxygène",
        position = "top",
        type = 'inform',
        duration = 3500,
    })

    RecupOxygene(source)
end)

RegisterServerEvent('Lys_EMS:Server:stopRecupOxygene')
AddEventHandler('Lys_EMS:Server:stopRecupOxygene', function()
    local _source = source
    PlayersHarvesting[_source] = false

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous arrêtez de récupérer une capsule d'oxygène",
        position = "top",
        type = 'inform',
        duration = 3500,
    })
end)










local function RecupDefibrilateur(source)
    if PlayersHarvesting[source] == true then
        local sPlayer = PL.GetPlayerFromId(source)
        local itemQuantity = exports['qs-inventory']:GetItemTotalAmount(source, "defib")

        if itemQuantity >= FarmPharmacy["Defibrilateur"].MaxItemToFarm then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'ERREUR',
                description = "Vous ne pouvez pas récupérer plus de Defibrilateur",
                position = "top",
                type = 'error',
                duration = 4000,
            })
            return
        end

        SetTimeout(FarmPharmacy["Defibrilateur"].TimeToGiveItem, function()
            sPlayer.addInventoryItem(FarmPharmacy["Defibrilateur"].ItemToFarm, 1)
            TriggerClientEvent('ox_lib:notify',  source, {
                title = 'EMS',
                description = "Vous avez récupéré 1 " .. FarmPharmacy["Defibrilateur"].ItemToFarm,
                position = "top",
                type = 'inform',
                duration = 5500,
            })
            RecupDefibrilateur(source)
        end)
    end
end

RegisterServerEvent('Lys_EMS:Server:startRecupDefibrilateur')
AddEventHandler('Lys_EMS:Server:startRecupDefibrilateur', function()
    local _source = source
    PlayersHarvesting[_source] = true

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous commencez à récupérer un Defibrilateur",
        position = "top",
        type = 'inform',
        duration = 3500,
    })

    RecupDefibrilateur(source)
end)

RegisterServerEvent('Lys_EMS:Server:stopRecupDefibrilateur')
AddEventHandler('Lys_EMS:Server:stopRecupDefibrilateur', function()
    local _source = source
    PlayersHarvesting[_source] = false

    TriggerClientEvent('ox_lib:notify', _source, {
        title = 'EMS',
        description = "Vous arrêtez de récupérer un Defibrilateur",
        position = "top",
        type = 'inform',
        duration = 3500,
    })
end)

RegisterServerEvent("Lys_EMS:Server!CallDoc")
AddEventHandler("Lys_EMS:Server!CallDoc", function()
    local medics = PL.GetExtendedPlayers("job", "ambulance")
    local _source = source
    if #medics > 0 then
        for _, medic in pairs (medics) do
            TriggerClientEvent("Lys_EMS:Client!ReceiveCall", medic.source)
            TriggerClientEvent('ox_lib:notify', _source, {
                title = 'EMS',
                description = "Votre appel a été envoyé à un medecin en ville",
                position = 'top',
                type = 'info',
                duration = 5000,
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', _source, {
            title = 'EMS',
            description = "Aucun Médecin en ville actuellement ",
            position = "top",
            type = 'inform',
            duration = 3500,
        })
    end
end)






RegisterServerEvent("Lys_EMS:Server:SendWebhooksPPA")
AddEventHandler("Lys_EMS:Server:SendWebhooksPPA", function(payload)
    local webhookUrl = "https://discord.com/api/webhooks/1146051699757301871/K35A1Art3iqnCQnuS-dgM1D7sNd2UXi-ko1SDAkp5psjOeH7RPYmrHEvUeD1YPO-VtPg"
    PerformHttpRequest(webhookUrl, function(statusCode, text, headers)
        if statusCode == 200 then
            print("Message envoyé sur Discord avec succès.")
        else
            print("Erreur lors de l'envoi du message sur Discord. Code de statut :", statusCode)
        end
    end, "POST", json.encode(payload), {["Content-Type"] = "application/json"})
end)

RegisterServerEvent("Lys_EMS:Server:SendWebhooksCheckup")
AddEventHandler("Lys_EMS:Server:SendWebhooksCheckup", function(payload)
    local webhookUrl = "https://discord.com/api/webhooks/1146051699757301871/K35A1Art3iqnCQnuS-dgM1D7sNd2UXi-ko1SDAkp5psjOeH7RPYmrHEvUeD1YPO-VtPg"
    PerformHttpRequest(webhookUrl, function(statusCode, text, headers)
        if statusCode == 200 then
            print("Message envoyé sur Discord avec succès.")
        else
            print("Erreur lors de l'envoi du message sur Discord. Code de statut :", statusCode)
        end
    end, "POST", json.encode(payload), {["Content-Type"] = "application/json"})
end)

RegisterServerEvent("Lys_EMS:Server:SendWebhooksRecruit")
AddEventHandler("Lys_EMS:Server:SendWebhooksRecruit", function(payload)
    local webhookUrl = "https://discord.com/api/webhooks/1146051699757301871/K35A1Art3iqnCQnuS-dgM1D7sNd2UXi-ko1SDAkp5psjOeH7RPYmrHEvUeD1YPO-VtPg"
    PerformHttpRequest(webhookUrl, function(statusCode, text, headers)
        if statusCode == 200 then
            print("Message envoyé sur Discord avec succès.")
        else
            print("Erreur lors de l'envoi du message sur Discord. Code de statut :", statusCode)
        end
    end, "POST", json.encode(payload), {["Content-Type"] = "application/json"})
end)