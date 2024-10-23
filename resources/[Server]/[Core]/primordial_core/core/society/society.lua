local Societies = {}

function GetSociety(name)
    return Societies[name]
end
exports("GetSociety", GetSociety)

function registerSociety(name, label, data)
    if Societies[name] then
        print(('[^3WARNING^7] society already registered, name: ^5%s^7'):format(name))
        return
    end

    local society = {
        name = name,
        label = label,
        money = data.money or 0,  -- Gestion des comptes intégrée
        iban = data.iban or nil,  -- IBAN intégré
        inventory = data.inventory or {},
        data = data
    }

    Societies[name] = society
end
AddEventHandler('primordial_core:server:registerSociety', registerSociety)
exports("registerSociety", registerSociety)

AddEventHandler('primordial_core:server:getSocieties', function(cb)
    cb(Societies)
end)

AddEventHandler('primordial_core:server:getSociety', function(name, cb)
    cb(GetSociety(name))
end)

-- Gestion du solde d'une société (Retrait)
RegisterServerEvent('primordial_core:server:withdrawMoney')
AddEventHandler('primordial_core:server:withdrawMoney', function(societyName, amount)
    local sPlayer = PL.GetPlayerFromId(source)
    local society = GetSociety(societyName)

    if not society then
        print(('[^3WARNING^7] Player ^5%s^7 attempted to withdraw from non-existing society - ^5%s^7!'):format(source, societyName))
        return
    end

    amount = PL.Math.Round(tonumber(amount))
    if society.money >= amount then
        society.money = society.money - amount
        sPlayer.addMoney(amount, Translations.money_add_reason)
        lib.notify(sPlayer.source, { title = ('You have withdrawn %s'):format(PL.Math.GroupDigits(amount)), type = 'info' })
    else
        lib.notify(sPlayer.source, { title = 'Invalid amount', type = 'error' })
    end
end)

-- Gestion du solde d'une société (Dépôt)
RegisterServerEvent('primordial_core:server:depositMoney')
AddEventHandler('primordial_core:server:depositMoney', function(societyName, amount)
    local sPlayer = PL.GetPlayerFromId(source)
    local society = GetSociety(societyName)

    if not society then
        print(('[^3WARNING^7] Player ^5%s^7 attempted to deposit to non-existing society - ^5%s^7!'):format(source, societyName))
        return
    end

    amount = PL.Math.Round(tonumber(amount))
    if sPlayer.getMoney() >= amount then
        sPlayer.removeMoney(amount, Translations.money_remove_reason)
        society.money = society.money + amount
        lib.notify(sPlayer.source, { title = ('You have deposited %s'):format(PL.Math.GroupDigits(amount)), type = 'info' })
    else
        lib.notify(sPlayer.source, { title = 'Invalid amount', type = 'error' })
    end
end)

-- Récupérer le solde d'une société
lib.callback.register('primordial_core:server:getSocietyMoney', function(source, societyName)
    local society = GetSociety(societyName)
    if society then
        return society.money
    end
    return 0
end)