--[[
    Hi dear customer or developer, here you can fully configure your server's
    framework or you could even duplicate this file to create your own framework.

    If you do not have much experience, we recommend you download the base version
    of the framework that you use in its latest version and it will work perfectly.
]]

if Config.Framework ~= 'esx' then
    return
end

ESX = exports['es_extended']:getSharedObject()
Config.Table = 'users'
Config.Identifier = 'identifier'

function RegisterServerCallback(name, cb)
    ESX.RegisterServerCallback(name, cb)
end

function GetPlayerFromId(source)
    return ESX.GetPlayerFromId(source)
end

function GetPlayerIdentifier(source)
    local player = GetPlayerFromId(source)
    if not player then return Wait(100) end
    return player.identifier
end

function RemoveAccountMoney(source, account, amount)
    local player = GetPlayerFromId(source)
    if account == 'cash' then account = 'money' end
    local money = player.getAccount('money').money
    if money < amount then return false end
    player.removeAccountMoney(account, amount)
    return true
end

function AddAccountMoney(source, account, amount)
    if account == 'cash' then account = 'money' end
    local player = GetPlayerFromId(source)
    player.addAccountMoney(account, amount)
end

function GetJobName(source)
    local player = GetPlayerFromId(source)
    return player.job.name
end

function GetJobGrade(source)
    local player = GetPlayerFromId(source)
    return player.job.grade
end

-- IMPLEMENT THIS TO YOUR GANG
function GetGangName(source)
    return 'nogang'
end

function GetLicenses(source)
    local promise = promise.new()
    TriggerEvent('esx_license:getLicenses', source, function(licenses)
        local data = {}
        for k, v in pairs(licenses) do
            data[v.type] = true
        end
        promise:resolve(data)
    end)
    return Citizen.Await(promise)
end
