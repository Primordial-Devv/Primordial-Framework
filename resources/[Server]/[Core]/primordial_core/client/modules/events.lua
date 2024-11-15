RegisterNetEvent("primordial_core:client:showAdvancedNotification")
AddEventHandler("primordial_core:client:showAdvancedNotification", function(title, subtitle, msg, hudColorIndex, flash, saveToBrief, textureDict, textureName, iconType)
    PL.Notification.ShowAdvancedNotification(title, subtitle, msg, hudColorIndex, flash, saveToBrief, textureDict, textureName, iconType)
end)

RegisterNetEvent("primordial_core:client:showHelpNotification")
AddEventHandler("primordial_core:client:showHelpNotification", function(msg, thisFrame, beep, duration)
    PL.Notification.ShowHelpNotification(msg, thisFrame, beep, duration)
end)

RegisterNetEvent("primordial_core:client:setMaxWeight")
AddEventHandler("primordial_core:client:setMaxWeight", function(newMaxWeight)
    PL.SetPlayerData("maxWeight", newMaxWeight)
end)

--- Do something when the player spawns
local function onPlayerSpawn()
    PL.SetPlayerData("ped", PlayerPedId())
    PL.SetPlayerData("dead", false)
end

AddEventHandler("playerSpawned", onPlayerSpawn)
AddEventHandler("primordial_core:onPlayerSpawn", onPlayerSpawn)

AddEventHandler("primordial_core:onPlayerDeath", function()
    PL.SetPlayerData("ped", PlayerPedId())
    PL.SetPlayerData("dead", true)
end)

AddEventHandler("skinchanger:modelLoaded", function()
    while not PL.PlayerLoaded do
        Wait(100)
    end
    TriggerEvent("primordial_core:client:restoreLoadout")
end)

AddEventHandler("primordial_core:client:restoreLoadout", function()
    PL.SetPlayerData("ped", PlayerPedId())
end)

-- Client : Réception et application des propriétés du véhicule
RegisterNetEvent("primordial_core:client:SetVehicleProperties")
AddEventHandler("primordial_core:client:SetVehicleProperties", function(netId, properties)
    local vehicle = NetToVeh(netId)
    if vehicle and DoesEntityExist(vehicle) then
        PL.Vehicle.SetVehicleProperties(vehicle, properties)
    end
end)


RegisterNetEvent("primordial_core:setAccountMoney")
AddEventHandler("primordial_core:setAccountMoney", function(account)
    for i = 1, #PL.PlayerData.accounts do
        if PL.PlayerData.accounts[i].name == account.name then
            PL.PlayerData.accounts[i] = account
            break
        end
    end

    PL.SetPlayerData("accounts", PL.PlayerData.accounts)
end)

RegisterNetEvent("primordial_core:setSociety")
AddEventHandler("primordial_core:setSociety", function(Job)
    PL.SetPlayerData("society", Job)
end)

RegisterNetEvent("primordial_core:setGroup")
AddEventHandler("primordial_core:setGroup", function(group)
    PL.SetPlayerData("group", group)
end)

RegisterNetEvent("primordial_core:client:registerSuggestions")
AddEventHandler("primordial_core:client:registerSuggestions", function(registeredCommands)
    for name, command in pairs(registeredCommands) do
        if command.suggestion then
            TriggerEvent("chat:addSuggestion", ("/%s"):format(name), command.suggestion.help, command.suggestion.arguments)
        end
    end
end)

RegisterNetEvent("primordial_core:client:killPlayer")
AddEventHandler("primordial_core:client:killPlayer", function()
    SetEntityHealth(PL.PlayerData.ped, 0)
end)

RegisterNetEvent("primordial_core:client:repairPedVehicle")
AddEventHandler("primordial_core:client:repairPedVehicle", function()
    local ped = PL.PlayerData.ped
    local vehicle = GetVehiclePedIsIn(ped, false)
    SetVehicleEngineHealth(vehicle, 1000)
    SetVehicleEngineOn(vehicle, true, true)
    SetVehicleFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0)
end)

RegisterNetEvent("primordial_core:client:freezePlayer")
AddEventHandler("primordial_core:client:freezePlayer", function(input)
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