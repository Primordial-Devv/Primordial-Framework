--[[
    Hi dear customer or developer, here you can fully configure your server's
    framework or you could even duplicate this file to create your own framework.

    If you do not have much experience, we recommend you download the base version
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= 'qb' then
    return
end

ESX = exports['qb-core']:GetCoreObject()
Config.Table = 'players'
Config.Identifier = 'citizenid'
WeaponList = ESX.Shared.Weapons
ItemList = ESX.Shared.Items

function RegisterServerCallback(name, cb)
    ESX.Functions.CreateCallback(name, cb)
end

function GetPlayerFromId(source)
    return ESX.Functions.GetPlayer(source)
end

function GetPlayerIdentifier(source)
    local player = GetPlayerFromId(source)
    return player?.PlayerData?.citizenid
end

function AddAccountMoney(source, account, amount)
    local player = GetPlayerFromId(source)
    return player.Functions.AddMoney(account, amount)
end

function RemoveAccountMoney(source, account, amount)
    local player = GetPlayerFromId(source)
    if account == 'money' then account = 'cash' end
    return player.Functions.RemoveMoney(account, amount)
end

function GetJobName(source)
    local player = GetPlayerFromId(source)
    return player.PlayerData.job.name
end

function GetJobGrade(source)
    local player = GetPlayerFromId(source)
    return player.PlayerData.job.grade.level
end

function GetLicenses(source)
    local player = GetPlayerFromId(source)
    return player.PlayerData.metadata['licences']
end

function GetGangName(source)
    local player = GetPlayerFromId(source)
    return player.PlayerData.gang.name
end
