local SocietyAccounts = {}

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local accounts = MySQL.query.await('SELECT * FROM society_account LEFT JOIN society_account_data ON society_account.name = society_account_data.account_name UNION SELECT * FROM society_account RIGHT JOIN society_account_data ON society_account.name = society_account_data.account_name')

        local newAccounts = {}
        for i = 1, #accounts do
            local account = accounts[i]
            if account.money then
                SocietyAccounts[account.name] = CreateSocietyAccount(account.name, account.money)
            else
                newAccounts[#newAccounts + 1] = {account.name, 0}
            end
        end

        GlobalState.SharedAccounts = SocietyAccounts

        if next(newAccounts) then
            MySQL.prepare('INSERT INTO society_account_data (account_name, money) VALUES (?, ?)', newAccounts)
            for i = 1, #newAccounts do
                local newAccount = newAccounts[i]
                SocietyAccounts[newAccount[1]] = CreateSocietyAccount(newAccount[1], 0)
            end

            GlobalState.SharedAccounts = SocietyAccounts
        
        end
    end
end)

function GetSocietyAccount(accountName)
    return SocietyAccounts[accountName]
end

function AddSocietyAccount(society, initialAmount)
    if type(society) ~= 'table' or not society?.name or not society?.label then return end

    if SocietyAccounts[society.name] ~= nil then return SocietyAccounts[society.name] end

    local account = MySQL.insert.await('INSERT INTO `society_account` (name, label) VALUES (?, ?)', {
        society.name, society.label
    })
    if not account then return end

    local accountData = MySQL.insert.await('INSERT INTO `society_account_data` (account_name, money) VALUES (?, ?)', {
        society.name, (initialAmount or 0)
    })
    if not accountData then return end

    SocietyAccounts[society.name] = CreateSocietyAccount(society.name, (initialAmount or 0))

    return SocietyAccounts[society.name]
end

AddEventHandler('primordial_core:server:society:getSocietyAccount', function(accountName, callback)
    callback(GetSocietyAccount(accountName))
end)

RegisterNetEvent('primordial_core:server:society:refreshAccounts')
AddEventHandler('primordial_core:server:society:refreshAccounts', function()
    local result = MySQL.query.await('SELECT * FROM society_account')

    for i = 1, #result, 1 do
        local name = result[i].name

        local result2 = MySQL.query.await('SELECT * FROM society_account_data WHERE account_name = ?', { name })
        local money = nil

        if #result2 == 0 then
            MySQL.insert('INSERT INTO society_account_data (account_name, money) VALUES (?, ?)',
                { name, 0 })
            money = 0
        else
            money = result2[1].money
        end

        local societyAccount = CreateSocietyAccount(name, money)
        SocietyAccounts[name] = societyAccount
    end
end)