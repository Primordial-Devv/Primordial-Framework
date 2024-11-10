if Config.Framework ~= 'primordial' then
    return
end

PL = exports["primordial_core"]:getSharedObject()

function GetPlayerData()
    return PL.GetPlayerData()
end

function TriggerServerCallback(name, delay, cb, ...)
    lib.callback.await(name, delay, cb, ...)
end

RegisterNetEvent('primordial_core:playerLoaded', function(sPlayer)
    PlayerData = sPlayer
    LocalPlayer.state:set('inv_busy', false, true)
    Wait(1250)
    for k, data in pairs(Config.WeaponRepairPoints) do
        Config.WeaponRepairPoints[k].IsRepairing = data.IsRepairing
        Config.WeaponRepairPoints[k].RepairingData = data.RepairingData
    end
    TriggerServerCallback(Config.InventoryPrefix .. ':server:GetCurrentDrops', function(theDrops)
        Drops = theDrops
    end)
    if Config.Crafting then
        CreateBlips()
    end
end)

RegisterNetEvent('primordial_core:onPlayerLogout')
AddEventHandler('primordial_core:onPlayerLogout', function()
    PlayerData = {}
    LocalPlayer.state:set('inv_busy', true, true)
    RemoveAllNearbyDrops()
    for k in pairs(Config.WeaponRepairPoints) do
        Config.WeaponRepairPoints[k].IsRepairing = false
        Config.WeaponRepairPoints[k].RepairingData = {}
    end
end)

RegisterNetEvent('primordial_core:setSociety', function()
    PlayerData = GetPlayerData()
    if Config.Crafting then
        CreateBlips()
    end
end)

AddEventHandler('primordial_lifeEssentials:client:onTick', function(status)
    TriggerEvent('primordial_lifeEssentials:client:getStatus', 'hunger', function(status)
        hunger = status.val / 10000
    end)
    TriggerEvent('primordial_lifeEssentials:client:getStatus', 'thirst', function(status)
        thirst = status.val / 10000
    end)
end)

function GetPlayerIdentifier()
    return GetPlayerData().identifier
end

function GetPlayersInArea()
    local playerPed = PlayerPedId()
    return PL.Player.GetNearbyPlayers(GetEntityCoords(playerPed), 3.0, false)
end

function GetJobName()
    return GetPlayerData()?.society?.name
end

function GetJobGrade()
    return GetPlayerData().society.grade
end

function GetGang()
    return false
end

function GetGangLevel()
    return false
end

function SendTextMessage(msg, type)
    if type == 'inform' then
        lib.notify({
            title = 'Inventory',
            description = msg,
            type = 'inform'
        })
    end
    if type == 'error' then
        lib.notify({
            title = 'Inventory',
            description = msg,
            type = 'error'
        })
    end
    if type == 'success' then
        lib.notify({
            title = 'Inventory',
            description = msg,
            type = 'success'
        })
    end
end

function ShowHelpNotification(msg)
    AddTextEntry('helpNotification', msg)
    BeginTextCommandDisplayHelp('helpNotification')
    EndTextCommandDisplayHelp(0, true, true, -1)
end

function DrawText3Ds(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = string.len(text) / 370
    DrawRect(0.0, 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function ProgressBar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    if lib.progressCircle({
            duration = duration,
            label = label,
            position = 'bottom',
            useWhileDead = useWhileDead,
            canCancel = canCancel,
            disable = disableControls,
            anim = {
                dict = animation.animDict,
                clip = animation.anim,
                flag = animation?.flags
            },
            prop = prop
        }) then
        onFinish()
    else
        onCancel()
    end
end

function ProgressBarSync(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop)
    return lib.progressBar({
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        disable = disableControls,
        anim = animation,
        prop = prop
    })
end

function SetPlayerStatus(values)
    for name, value in pairs(values) do
        if value > 0 then
            TriggerEvent('primordial_lifeEssentials:client:add', name, value)
        else
            TriggerEvent('primordial_lifeEssentials:client:remove', name, -value)
        end
    end
end

function ToggleHud(bool)
    if bool then
        Debug('Event to show the hud [client/custom/framework/primordial.lua line 121]')
        DisplayRadar(false)
    else
        Debug('Event to hide the hud [client/custom/framework/primordial.lua line 124]')
        DisplayRadar(true)
    end
end

function DropMarker(coords)
    DrawMarker(20, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 120, 10, 20, 155, false, false, false, 1, false, false, false)
end

function IsPlayerDead()
    local check = false
    local ped = PlayerPedId()
    local wasabiHas = GetResourceState('wasabi_ambulance') == 'started'
    local inLastStand = LocalPlayer.state.dead
    if wasabiHas and inLastStand then
        return check
    end
    if GetEntityHealth(ped) >= 1 then
        check = true
    end
    return check
end

function checkEntityDead(id, entity)
    local check = false
    if GetEntityHealth(entity) <= 1 then
        check = true
    end
    return check
end

function reputationCrafing(rep)
    --- @param rep Name of reputation
    return 99999
end

RegisterNetEvent('qs-inventory:client:updateItem', function(item, data)
    if not ItemList[item] then
        return
    end
    ItemList[item] = data
end)
