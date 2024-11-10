--[[
    Hi dear customer or developer, here you can fully configure your server's
    framework or you could even duplicate this file to create your own framework.

    If you do not have much experience, we recommend you download the base version
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= 'primordial' then
    return
end

PL = exports["primordial_core"]:getSharedObject()

RegisterNetEvent('primordial_core:playerLoaded', function()
    CreateBlips()
    CreatePeds()
    TriggerServerEvent('shops:server:SetShopList')
end)

function GetPlayerData()
    return PL.GetPlayerData()
end

RegisterNetEvent('primordial_core:setSociety', function(jobInfo)
    PlayerData = GetPlayerData()
    PlayerData.society = jobInfo
end)

function GetPlayerIdentifier()
    return GetPlayerData()?.identifier
end

function GetJobName()
    return GetPlayerData()?.society?.name
end

function GetJobGrade()
    return GetPlayerData()?.society?.grade
end

function TriggerServerCallback(name, delay, ...)
    lib.callback.await(name, delay, ...)
end

function SendTextMessage(msg, type)
    if not type then type = 'inform' end
    if type == 'inform' then
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0, 1)
    end
    if type == 'error' then
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0, 1)
    end
    if type == 'success' then
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(0, 1)
    end
end

function DrawText3D(x, y, z, text)
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

RegisterNetEvent('qb-shops:client:SpawnVehicle', function()
    local coords = Config.DeliveryLocations['vehicleWithdraw']
    PL.Vehicle.SpawnClientVehicle('boxville2', vec3(coords.x, coords.y, coords.z), coords.w,function(vehicle)
        SetVehicleNumberPlateText(vehicle, 'TRUK' .. tostring(math.random(1000, 9999)))
        SetVehicleLivery(vehicle, 1)
        SetVehicleColours(vehicle, 122, 122)
        exports[Config.Fuel]:SetFuel(vehicle, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        SetEntityAsMissionEntity(vehicle, true, true)
        TriggerEvent('vehiclekeys:client:SetOwner', GetPlate(vehicle))
        SetVehicleEngineOn(vehicle, true, true, false)
        CurrentPlate = GetPlate(vehicle)
        GetNewLocation()
    end, true)
end)

function GetPlate(veh)
    return PL.String.Trim(GetVehicleNumberPlateText(veh))
end
