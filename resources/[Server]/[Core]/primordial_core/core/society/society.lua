local Societies = {}

--- Retrieve a society by name.
--- @param name string The name of the society.
--- @return table|nil society The society data or nil if not found.
local function GetSociety(name)
    return Societies[name]
end
exports("GetSociety", GetSociety)

--- Register a new society.
--- @param name string The name of the society.
--- @param label string The label of the society.
--- @param data table The additional data for the society (money, iban, inventory, etc.).
local function registerSociety(name, label, data)
    if Societies[name] then
        PL.Print.Log(2, false, ('Society already registered, name: ^5%s^7'):format(name))
        return
    end

    local society <const> = {
        name = name,
        label = label,
        money = data.money or 0,
        iban = data.iban or nil,
        inventory = data.inventory or {},
        data = data
    }

    Societies[name] = society
end

AddEventHandler('primordial_core:server:registerSociety', registerSociety)
exports("registerSociety", registerSociety)

--- Retrieve all societies via a callback.
--- @param cb function The callback function to handle societies data.
AddEventHandler('primordial_core:server:getSocieties', function(cb)
    cb(Societies)
end)

--- Retrieve a specific society via a callback.
--- @param name string The name of the society.
--- @param cb function The callback function to handle the society data.
AddEventHandler('primordial_core:server:getSociety', function(name, cb)
    cb(GetSociety(name))
end)

--- Handle society money withdrawal.
--- @param societyName string The name of the society.
--- @param amount number The amount to withdraw.
AddEventHandler('primordial_core:server:withdrawMoney', function(societyName, amount)
    local sPlayer <const> = PL.GetPlayerFromId(source)
    local society <const> = GetSociety(societyName)

    if not society then
        PL.Print.Log(2, false, ('Player ^5%s^7 attempted to withdraw from non-existing society - ^5%s^7!'):format(source, societyName))
        return
    end

    amount = PL.Math.Round(amount)
    if society.money >= amount then
        society.money = society.money - amount
        sPlayer.addMoney(amount, Translations.money_add_reason)
        lib.notify(sPlayer.source, { title = ('You have withdrawn %s'):format(PL.Math.GroupDigits(amount)), type = 'info' })
    else
        lib.notify(sPlayer.source, { title = 'Invalid amount', type = 'error' })
    end
end)

--- Handle society money deposit.
--- @param societyName string The name of the society.
--- @param amount number The amount to deposit.
AddEventHandler('primordial_core:server:depositMoney', function(societyName, amount)
    local sPlayer <const> = PL.GetPlayerFromId(source)
    local society <const> = GetSociety(societyName)

    if not society then
        PL.Print.Log(2, false, ('Player ^5%s^7 attempted to deposit to non-existing society - ^5%s^7!'):format(source, societyName))
        return
    end

    amount = PL.Math.Round(amount)
    if sPlayer.getMoney() >= amount then
        sPlayer.removeMoney(amount, Translations.money_remove_reason)
        society.money = society.money + amount
        lib.notify(sPlayer.source, { title = ('You have deposited %s'):format(PL.Math.GroupDigits(amount)), type = 'info' })
    else
        lib.notify(sPlayer.source, { title = 'Invalid amount', type = 'error' })
    end
end)

--- Retrieve the money of a society via a callback.
--- @param source number The player source.
--- @param societyName string The name of the society.
--- @return number money The amount of money the society has.
lib.callback.register('primordial_core:server:getSocietyMoney', function(source, societyName)
    local society = GetSociety(societyName)
    if society then
        return society.money
    end
    return 0
end)