local _GetPlayerPed = GetPlayerPed
local _GetEntityCoords = GetEntityCoords
local _GetEntityHeading = GetEntityHeading
local _ExecuteCommand = ExecuteCommand
local _SetEntityCoords = SetEntityCoords
local _SetEntityHeading = SetEntityHeading
local _TriggerClientEvent = TriggerClientEvent
local _DropPlayer = DropPlayer
local _TriggerEvent = TriggerEvent
local _assert = assert
-- local Inventory

-- AddEventHandler("ox_inventory:loadInventory", function(module)
--     Inventory = module
-- end)

---@param playerId number
---@param identifier string
---@param group string
---@param accounts table
---@param inventory table
---@param weight number
---@param society table
---@param loadout table
---@param name string
---@param coords table | vector4
---@param metadata table
---@return sPlayer
function CreateStudioPlayer(playerId, identifier, group, accounts, inventory, weight, society, loadout, name, coords, metadata)

    ---@class sPlayer
    local self = {}

    self.accounts = accounts
    self.coords = coords
    self.group = group
    self.identifier = identifier
    self.inventory = inventory
    self.society = society
    self.loadout = loadout
    self.name = name
    self.playerId = playerId
    self.source = playerId
    self.variables = {}
    self.weight = weight
    self.maxWeight = 30
    self.metadata = metadata
    self.license = "license:" .. identifier

    _ExecuteCommand(("add_principal identifier.%s group.%s"):format(self.license, self.group))

    _TriggerClientEvent("primordial_core:client:receivePlayerData", self.source, {
        identifier = self.identifier,
        license = self.license,
        society = self.society,
        group = self.group,
        name = self.name,
        metadata = self.metadata
    })

    ---@param eventName string
    ---@param ... any
    ---@return void
    function self.triggerEvent(eventName, ...)
        _assert(type(eventName) == "string", "eventName should be string!")
        _TriggerClientEvent(eventName, self.source, ...)
    end

    ---@param coordinates vector4 | vector3 | table
    ---@return void
    function self.setCoords(coordinates)
        local ped <const> = _GetPlayerPed(self.source)
        local vector = type(coordinates) == "vector4" and coordinates or type(coordinates) == "vector3" and vector4(coordinates, 0.0) or vec(coordinates.x, coordinates.y, coordinates.z, coordinates.heading or 0.0)
        _SetEntityCoords(ped, vector.xyz, false, false, false, false)
        _SetEntityHeading(ped, vector.w)
    end

    ---@param vector boolean
    ---@return vector3 | table
    function self.getCoords(vector)
        local ped <const> = _GetPlayerPed(self.source)
        local coordinates <const> = _GetEntityCoords(ped)
        local heading <const> = _GetEntityHeading(ped)

        return vector and vector4(coordinates.xyz, heading) or { x = coordinates.x, y = coordinates.y, z = coordinates.z, heading = heading }
    end

    ---@param reason string
    ---@return void
    function self.kick(reason)
        _DropPlayer(self.source, reason)
    end

    ---@param money number
    ---@return void
    function self.setMoney(money)
        _assert(type(money) == "number", "money should be number!")
        money = PL.Math.Round(money)
        self.setAccountMoney("money", money)
    end

    ---@return number
    function self.getMoney()
        return self.getAccount("money").money
    end

    ---@param money number
    ---@param reason string
    ---@return void
    function self.addMoney(money, reason)
        money = PL.Math.Round(money)
        self.addAccountMoney("money", money, reason)
    end

    ---@param money number
    ---@param reason string
    ---@return void
    function self.removeMoney(money, reason)
        money = PL.Math.Round(money)
        self.removeAccountMoney("money", money, reason)
    end

    ---@return string
    function self.getIdentifier()
        return self.identifier
    end

    ---@param newGroup string
    ---@return void
    function self.setGroup(newGroup)
        local lastGroup = self.group

        _ExecuteCommand(("remove_principal identifier.%s group.%s"):format(self.license, self.group))

        self.group = newGroup

        _TriggerEvent("primordial_core:setGroup", self.source, self.group, lastGroup)
        self.triggerEvent("primordial_core:setGroup", self.group, lastGroup)
        _TriggerClientEvent("primordial_core:client:updateGroup", self.source, self.group)

        _ExecuteCommand(("add_principal identifier.%s group.%s"):format(self.license, self.group))
    end

    ---@return string
    function self.getGroup()
        return self.group
    end

    ---@param k string
    ---@param v any
    ---@return void
    function self.set(k, v)
        self.variables[k] = v
        _TriggerClientEvent("primordial_core:client:updateVariable", self.source, k, v)
    end

    ---@param k string
    ---@return any
    function self.get(k)
        return self.variables[k]
    end

    ---@param minimal boolean
    ---@return table
    function self.getAccounts(minimal)
        if not minimal then
            return self.accounts
        end

        local minimalAccounts = {}

        for i = 1, #self.accounts do
            minimalAccounts[self.accounts[i].name] = self.accounts[i].money
        end

        return minimalAccounts
    end

    ---@param account string
    ---@return table | nil
    function self.getAccount(account)
        -- for i = 1, #self.accounts do
        --     if self.accounts[i].name == account then
        --         return self.accounts[i]
        --     end
        -- end
        -- return nil
        for i = 1, #self.accounts do
            if self.accounts[i].name == account then
                local accounts = exports['qs-inventory']:GetAccounts()
                if accounts[account] then
                    self.accounts[i].money = exports['qs-inventory']:GetItemTotalAmount(self.source, account)
                end
                return self.accounts[i]
            end
        end
    end

    ---@param minimal boolean
    ---@return table
    function self.getInventory(minimal)
        -- if minimal then
        --     local minimalInventory = {}

        --     for k, v in pairs(self.inventory) do
        --         if v.count and v.count > 0 then
        --             local metadata = v.metadata

        --             if v.metadata and next(v.metadata) == nil then
        --                 metadata = nil
        --             end

        --             minimalInventory[#minimalInventory + 1] = {
        --                 name = v.name,
        --                 count = v.count,
        --                 slot = k,
        --                 metadata = metadata,
        --             }
        --         end
        --     end

        --     return minimalInventory
        -- end

        -- return self.inventory
        local inventory = exports['qs-inventory']:GetInventory(self.source)
            if not inventory then return {} end
            for k, v in pairs(inventory) do
                v.count = v.amount
            end
            return inventory
    end

    ---@return table
    function self.getSociety()
        return self.society
    end

    ---@param minimal boolean
    ---@return table
    function self.getLoadout()
        return {}
    end

    ---@return string
    function self.getName()
        return self.name
    end

    ---@param newName string
    ---@return void
    function self.setName(newName)
        self.name = newName
        _TriggerClientEvent("primordial_core:client:updatePlayerName", self.source, self.name)
    end

    ---@param accountName string
    ---@param money number
    ---@param reason string
    ---@return void
    function self.setAccountMoney(accountName, money, reason)
        -- reason = reason or "unknown"
        -- if money >= 0 then
        --     local account = self.getAccount(accountName)

        --     if account then
        --         money = account.round and PL.Math.Round(money) or money
        --         self.accounts[account.index].money = money

        --         self.triggerEvent("primordial_core:setAccountMoney", account)
        --         TriggerEvent("primordial_core:setAccountMoney", self.source, accountName, money, reason)
        --         if Inventory.accounts[accountName] then
        --             Inventory.SetItem(self.source, accountName, money)
        --         end
        --     end
        -- end
        reason = reason or 'unknown'
            if money >= 0 then
                local account = self.getAccount(accountName)
                if account then
                    money = account.round and PL.Math.Round(money) or money
                    self.accounts[account.index].money = money
                    self.triggerEvent('primordial_core:setAccountMoney', account)
                    TriggerEvent('primordial_core:setAccountMoney', self.source, accountName, money, reason)
                    local accounts = exports['qs-inventory']:GetAccounts()
                    if accounts[accountName] and reason ~= 'dropped' then
                        exports['qs-inventory']:SetInventoryItems(self.source, accountName, money)
                    end
                end
            end
    end

    ---@param accountName string
    ---@param money number
    ---@param reason string
    ---@return void
    function self.addAccountMoney(accountName, money, reason)
        -- reason = reason or "unknown"
        -- if money > 0 then
        --     local account = self.getAccount(accountName)

        --     if account then
        --         money = account.round and PL.Math.Round(money) or money
        --         self.accounts[account.index].money = self.accounts[account.index].money + money
        --         self.triggerEvent("primordial_core:setAccountMoney", account)
        --         TriggerEvent("primordial_core:addAccountMoney", self.source, accountName, money, reason)
        --         if Inventory.accounts[accountName] then
        --             Inventory.AddItem(self.source, accountName, money)
        --         end
        --     end
        -- end
        reason = reason or 'unknown'
            if money > 0 then
                local account = self.getAccount(accountName)
                if account then
                    money = account.round and PL.Math.Round(money) or money
                    self.accounts[account.index].money += money
                    self.triggerEvent('primordial_core:setAccountMoney', account)
                    TriggerEvent('primordial_core:addAccountMoney', self.source, accountName, money, reason)
                    local accounts = exports['qs-inventory']:GetAccounts()
                    if accounts[accountName] then
                        exports['qs-inventory']:AddItem(self.source, accountName, money)
                    end
                end
            end
    end

    ---@param accountName string
    ---@param money number
    ---@param reason string
    ---@return void
    function self.removeAccountMoney(accountName, money, reason)
        -- reason = reason or "unknown"
        -- if money > 0 then
        --     local account = self.getAccount(accountName)

        --     if account then
        --         money = account.round and PL.Math.Round(money) or money
        --         self.accounts[account.index].money = self.accounts[account.index].money - money
        --         self.triggerEvent("primordial_core:setAccountMoney", account)
        --         TriggerEvent("primordial_core:removeAccountMoney", self.source, accountName, money, reason)
        --         if Inventory.accounts[accountName] then
        --             Inventory.RemoveItem(self.source, accountName, money)
        --         end
        --     end
        -- end
        reason = reason or 'unknown'
        if money > 0 then
            local account = self.getAccount(accountName)
            if account then
                money = account.round and PL.Math.Round(money) or money
                self.accounts[account.index].money -= money
                self.triggerEvent('primordial_core:setAccountMoney', account)
                TriggerEvent('primordial_core:removeAccountMoney', self.source, accountName, money, reason)
                local accounts = exports['qs-inventory']:GetAccounts()
                if accounts[accountName] then
                    exports['qs-inventory']:RemoveItem(self.source, accountName, money)
                end
            end
        end
    end

    ---@param itemName string
    ---@return table | nil
    function self.getInventoryItem(name, metadata)
        -- return Inventory.GetItem(self.source, name, metadata)
        local item = exports['qs-inventory']:GetItemByName(self.source, name)
            if not item then
                return {
                    count = 0,
                }
            end
            item.count = item.amount
            return item
    end

    ---@param itemName string
    ---@param count number
    ---@return void
    function self.addInventoryItem(name, count, metadata, slot)
        -- return Inventory.AddItem(self.source, name, count or 1, metadata, slot)
        return exports['qs-inventory']:AddItem(self.source, name, count or 1, slot, metadata)
    end

    ---@param itemName string
    ---@param count number
    ---@return void
    function self.removeInventoryItem(name, count, metadata, slot)
        -- return Inventory.RemoveItem(self.source, name, count or 1, metadata, slot)
        return exports['qs-inventory']:RemoveItem(self.source, name, count or 1, slot, metadata)
    end

    ---@param itemName string
    ---@param count number
    ---@return void
    function self.setInventoryItem(name, count, metadata)
        -- return Inventory.SetItem(self.source, name, count, metadata)
        return exports['qs-inventory']:SetInventoryItem(self.source, name, count, metadata)
    end

    ---@return number
    function self.getWeight()
        return self.weight
    end

    ---@return number
    function self.getMaxWeight()
        return self.maxWeight
    end

    ---@param itemName string
    ---@param count number
    ---@return boolean
    function self.canCarryItem(name, count, metadata)
        -- return Inventory.CanCarryItem(self.source, name, count, metadata)
        return exports['qs-inventory']:CanCarryItem(self.source, name, count)
    end

    ---@param firstItem string
    ---@param firstItemCount number
    ---@param testItem string
    ---@param testItemCount number
    ---@return boolean
    function self.canSwapItem(firstItem, firstItemCount, testItem, testItemCount)
        -- return Inventory.CanSwapItem(self.source, firstItem, firstItemCount, testItem, testItemCount)
        return true
    end

    ---@param newWeight number
    ---@return void
    function self.setMaxWeight(newWeight)
        self.maxWeight = newWeight
        self.triggerEvent("primordial_core:client:setMaxWeight", self.maxWeight)
        return Inventory.SetMaxWeight(self.source, newWeight)
    end

    ---@param newSociety string
    ---@param societyGrade string
    ---@return void
    function self.setSociety(newSociety, societyGrade)
        societyGrade = tostring(societyGrade)
        local lastSociety = self.society

        if not PL.DoesSocietyExist(newSociety, societyGrade) then
            return PL.Print.Warning(("Ignoring invalid ^1.setSociety()^5 usage for ID: ^1%s^5, Society: ^1%s^5"):format(self.source, newSociety))
        end

        local societyObject, societyGradeObject = PL.Jobs[newSociety], PL.Jobs[newSociety].grades[societyGrade]

        self.society = {
            id = societyObject.id,
            name = societyObject.name,
            label = societyObject.label,

            grade = tonumber(societyGrade),
            grade_name = societyGradeObject.name,
            grade_label = societyGradeObject.label,
            grade_salary = societyGradeObject.salary,
        }

        _TriggerEvent("primordial_core:setSociety", self.source, self.society, lastSociety)
        self.triggerEvent("primordial_core:setSociety", self.society, lastSociety)
        _TriggerClientEvent("primordial_core:client:updateSociety", self.source, self.society)
    end

    ---@param weaponName string
    ---@param ammo number
    ---@return void
    function self.addWeapon(weaponName, ammo)
        -- return
        return exports['qs-inventory']:GiveWeaponToPlayer(self.source, weaponName, ammo)
    end

    ---@param weaponName string
    ---@param weaponComponent string
    ---@return void
    function self.addWeaponComponent()
        -- return
    end

    ---@param weaponName string
    ---@param ammoCount number
    ---@return void
    function self.addWeaponAmmo()
        -- return
    end

    ---@param weaponName string
    ---@param ammoCount number
    ---@return void
    function self.updateWeaponAmmo()
        -- return
    end

    ---@param weaponName string
    ---@param weaponTintIndex number
    ---@return void
    function self.setWeaponTint()
        -- return
    end

    ---@param weaponName string
    ---@return number
    function self.getWeaponTint()
        -- return
    end

    ---@param weaponName string
    ---@return void
    function self.removeWeapon()
        -- return
    end

    ---@param weaponName string
    ---@param weaponComponent string
    ---@return void
    function self.removeWeaponComponent()
        -- return
    end

    ---@param weaponName string
    ---@param ammoCount number
    ---@return void
    function self.removeWeaponAmmo()
        -- return
    end

    ---@param weaponName string
    ---@param weaponComponent string
    ---@return boolean
    function self.hasWeaponComponent()
        return false
    end

    ---@param weaponName string
    ---@return boolean
    function self.hasWeapon()
        return false
    end

    ---@param item string
    ---@return table, number | false
    function self.hasItem(name, metadata)
        -- return Inventory.GetItem(self.source, name, metadata)
        return exports['qs-inventory']:GetItemByName(self.source, name)
    end

    ---@param weaponName string
    ---@return number, table | nil
    function self.getWeapon()
        -- return
    end

    function self.syncInventory(weight, maxWeight, items, money)
        self.weight, self.maxWeight = weight, maxWeight
        self.inventory = items

        if money then
            for accountName, amount in pairs(money) do
                local account = self.getAccount(accountName)

                if account and PL.Math.Round(account.money) ~= amount then
                    account.money = amount
                    self.triggerEvent("primordial_core:setAccountMoney", account)
                    TriggerEvent("primordial_core:setAccountMoney", self.source, accountName, amount, "Sync account with item")
                end
            end
        end
    end

    ---@param msg string
    ---@param type string
    ---@param length number
    ---@return void
    function self.showNotification(msg, notifyType, length)
        lib.notify(self, {
            title = msg,
            type = notifyType,
        })
    end

    ---@param title string
    ---@param subtitle string
    ---@param msg string
    ---@param hudColorIndex number
    ---@param flash boolean
    ---@param saveToBrief boolean
    ---@param textureDict string
    ---@param textureName string
    ---@param iconType number
    ---@return void
    function self.showAdvancedNotification(title, subtitle, msg, hudColorIndex, flash, saveToBrief, textureDict, textureName, iconType)
        self.triggerEvent("primordial_core:client:showAdvancedNotification", title, subtitle, msg, hudColorIndex, flash, saveToBrief, textureDict, textureName, iconType)
    end

    ---@param msg string
    ---@param thisFrame boolean
    ---@param beep boolean
    ---@param duration number
    ---@return void
    function self.showHelpNotification(msg, thisFrame, beep, duration)
        self.triggerEvent("primordial_core:client:showHelpNotification", msg, thisFrame, beep, duration)
    end

    ---@param index any
    ---@param subIndex any
    ---@return table
    function self.getMeta(index, subIndex)
        if not index then
            return self.metadata
        end

        if type(index) ~= "string" then
            return PL.Print.Error("sPlayer.getMeta ^1index^5 should be ^1string^5!")
        end

        local metaData = self.metadata[index]
        if metaData == nil then
            return EnableDebug and PL.Print.Error('sPlayer.getMeta ^1%s^5 not exist!'):format(index) or nil
        end

        if subIndex and type(metaData) == "table" then
            local _type = type(subIndex)

            if _type == "string" then
                local value = metaData[subIndex]
                return value
            end

            if _type == "table" then
                local returnValues = {}

                for i = 1, #subIndex do
                    local key = subIndex[i]
                    if type(key) == "string" then
                        returnValues[key] = self.getMeta(index, key)
                    else
                        print(("[^1ERROR^7] sPlayer.getMeta subIndex should be ^5string^7 or ^5table^7! that contains ^5string^7, received ^5%s^7!, skipping..."):format(type(key)))
                    end
                end

                return returnValues
            end

            return print(("[^1ERROR^7] sPlayer.getMeta subIndex should be ^5string^7 or ^5table^7!, received ^5%s^7!"):format(_type))
        end

        return metaData
    end

    ---@param index any
    ---@param value any
    ---@param subValue any
    ---@return void
    function self.setMeta(index, value, subValue)
        if not index then
            return print("[^1ERROR^7] sPlayer.setMeta ^5index^7 is Missing!")
        end

        if type(index) ~= "string" then
            return print("[^1ERROR^7] sPlayer.setMeta ^5index^7 should be ^5string^7!")
        end

        if value == nil then
            return print("[^1ERROR^7] sPlayer.setMeta value is missing!")
        end

        local _type = type(value)

        if not subValue then
            if _type ~= "number" and _type ~= "string" and _type ~= "table" then
                return print(("[^1ERROR^7] sPlayer.setMeta ^5%s^7 should be ^5number^7 or ^5string^7 or ^5table^7!"):format(value))
            end

            self.metadata[index] = value
        else
            if _type ~= "string" then
                return print(("[^1ERROR^7] sPlayer.setMeta ^5value^7 should be ^5string^7 as a subIndex!"):format(value))
            end

            if not self.metadata[index] or type(self.metadata[index]) ~= "table" then
                self.metadata[index] = {}
            end

            self.metadata[index] = type(self.metadata[index]) == "table" and self.metadata[index] or {}
            self.metadata[index][value] = subValue
        end

        _TriggerClientEvent("primordial_core:client:updateMetadata", self.source, self.metadata)
    end

    function self.clearMeta(index, subValues)
        if not index then
            return print("[^1ERROR^7] sPlayer.clearMeta ^5index^7 is Missing!")
        end

        if type(index) ~= "string" then
            return print("[^1ERROR^7] sPlayer.clearMeta ^5index^7 should be ^5string^7!")
        end

        local metaData = self.metadata[index]
        if metaData == nil then
            return EnableDebug and print(("[^1ERROR^7] sPlayer.clearMeta ^5%s^7 does not exist!"):format(index)) or nil
        end

        if not subValues then
            -- If no subValues is provided, we will clear the entire value in the metaData table
            self.metadata[index] = nil
        elseif type(subValues) == "string" then
            -- If subValues is a string, we will clear the specific subValue within the table
            if type(metaData) == "table" then
                metaData[subValues] = nil
            else
                return print(("[^1ERROR^7] sPlayer.clearMeta ^5%s^7 is not a table! Cannot clear subValue ^5%s^7."):format(index, subValues))
            end
        elseif type(subValues) == "table" then
            -- If subValues is a table, we will clear multiple subValues within the table
            for i = 1, #subValues do
                local subValue = subValues[i]
                if type(subValue) == "string" then
                    if type(metaData) == "table" then
                        metaData[subValue] = nil
                    else
                        print(("[^1ERROR^7] sPlayer.clearMeta ^5%s^7 is not a table! Cannot clear subValue ^5%s^7."):format(index, subValue))
                    end
                else
                    print(("[^1ERROR^7] sPlayer.clearMeta subValues should contain ^5string^7, received ^5%s^7, skipping..."):format(type(subValue)))
                end
            end
        else
            return print(("[^1ERROR^7] sPlayer.clearMeta ^5subValues^7 should be ^5string^7 or ^5table^7, received ^5%s^7!"):format(type(subValues)))
        end

        _TriggerClientEvent("primordial_core:client:updateMetadata", self.source, self.metadata)
    end

    return self
end
