function CreateSocietyAccount(accountName, initialMoney)
    local self = {}

    self.name = accountName
    self.money = initialMoney

    function self.addMoney(amountToAdd)
        self.money = self.money + amountToAdd
        self.save()
        TriggerEvent('primordial_core:society:class:addMoney', self.name, amountToAdd)
    end

    function self.removeMoney(amountToRemove)
        self.money = self.money - amountToRemove
        self.save()
        TriggerEvent('primordial_core:society:class:removeMoney', self.name, amountToRemove)
    end

    function self.setMoney(newAmount)
        self.money = newAmount
        self.save()
        TriggerEvent('primordial_core:society:class:setMoney', self.name, newAmount)
    end

    function self.save()
        MySQL.update('UPDATE society_account_data SET money = ? WHERE account_name = ?', {self.money, self.name})
        TriggerClientEvent('primordial_core:society:class:setMoney', -1, self.name, self.money)
    end

    return self
end