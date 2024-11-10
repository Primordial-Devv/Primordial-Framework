local oneSyncState = GetConvar("onesync", "off")
local newPlayer = "INSERT INTO `users` SET `accounts` = ?, `identifier` = ?, `group` = ?"
local loadPlayer = "SELECT `accounts`, `society_name`, `society_grade`, `group`, `position`, `inventory`, `skin`, `loadout`, `metadata`"

if StartingInventoryItems then
    newPlayer = newPlayer .. ", `inventory` = ?"
end

loadPlayer = loadPlayer .. ", `firstname`, `lastname`, `dateofbirth`, `sex`, `height`"
loadPlayer = loadPlayer .. " FROM `users` WHERE identifier = ?"

local function updateHealthAndArmorInMetadata(sPlayer)
    local ped = GetPlayerPed(sPlayer.source)
    sPlayer.setMeta("health", GetEntityHealth(ped))
    sPlayer.setMeta("armor", GetPedArmour(ped))
end

function PL.SavePlayer(sPlayer, cb)
    if not sPlayer.spawned then
        return cb and cb()
    end

    updateHealthAndArmorInMetadata(sPlayer)
    local parameters <const> = {
        json.encode(sPlayer.getAccounts(true)),
        sPlayer.society.name,
        sPlayer.society.grade,
        sPlayer.group,
        json.encode(sPlayer.getCoords()),
        json.encode(sPlayer.getInventory(true)),
        json.encode(sPlayer.getLoadout(true)),
        json.encode(sPlayer.getMeta()),
        sPlayer.identifier,
    }

    MySQL.prepare(
        "UPDATE `users` SET `accounts` = ?, `society_name` = ?, `society_grade` = ?, `group` = ?, `position` = ?, `inventory` = ?, `loadout` = ?, `metadata` = ? WHERE `identifier` = ?",
        parameters,
        function(affectedRows)
            if affectedRows == 1 then
                print(('[^2INFO^7] Saved player ^5"%s^7"'):format(sPlayer.name))
            end
            if cb then
                cb()
            end
        end
    )
end

function PL.SavePlayers(cb)
    local sPlayers <const> = PL.Players
    if not next(sPlayers) then
        return
    end

    local startTime <const> = os.time()
    local parameters = {}

    for _, sPlayer in pairs(PL.Players) do
        updateHealthAndArmorInMetadata(sPlayer)
        parameters[#parameters + 1] = {
            json.encode(sPlayer.getAccounts(true)),
            sPlayer.society.name,
            sPlayer.society.grade,
            sPlayer.group,
            json.encode(sPlayer.getCoords()),
            json.encode(sPlayer.getInventory(true)),
            json.encode(sPlayer.getLoadout(true)),
            json.encode(sPlayer.getMeta()),
            sPlayer.identifier,
        }
    end

    MySQL.prepare(
        "UPDATE `users` SET `accounts` = ?, `society_name` = ?, `society_grade` = ?, `group` = ?, `position` = ?, `inventory` = ?, `loadout` = ?, `metadata` = ? WHERE `identifier` = ?",
        parameters,
        function(results)
            if not results then
                return
            end

            if type(cb) == "function" then
                return cb()
            end

            print(("[^2INFO^7] Saved ^5%s^7 %s over ^5%s^7 ms"):format(#parameters, #parameters > 1 and "players" or "player", PL.Math.Round((os.time() - startTime) / 1000000, 2)))
        end
    )
end

PL.GetPlayers = GetPlayers

local function checkTable(key, val, player, sPlayers)
    for valIndex = 1, #val do
        local value = val[valIndex]
        if not sPlayers[value] then
            sPlayers[value] = {}
        end

        if (key == "job" and player.society.name == value) or player[key] == value then
            sPlayers[value][#sPlayers[value] + 1] = player
        end
    end
end

function PL.GetExtendedPlayers(key, val)
    local sPlayers = {}
    if type(val) == "table" then
        for _, v in pairs(PL.Players) do
            checkTable(key, val, v, sPlayers)
        end
    else
        for _, v in pairs(PL.Players) do
            if key then
                if (key == "job" and v.society.name == val) or v[key] == val then
                    sPlayers[#sPlayers + 1] = v
                end
            else
                sPlayers[#sPlayers + 1] = v
            end
        end
    end

    return sPlayers
end

function PL.GetNumPlayers(key, val)
    if not key then
        return #GetPlayers()
    end

    if type(val) == "table" then
        local numPlayers = {}
        if key == "job" then
            for _, v in ipairs(val) do
                numPlayers[v] = (PL.JobsPlayerCount[v] or 0)
            end
            return numPlayers
        end

        local filteredPlayers = PL.GetExtendedPlayers(key, val)
        for i, v in pairs(filteredPlayers) do
            numPlayers[i] = (#v or 0)
        end
        return numPlayers
    end

    if key == "job" then
        return (PL.JobsPlayerCount[val] or 0)
    end

    return #PL.GetExtendedPlayers(key, val)
end

---@param source number
---@return xPlayer
function PL.GetPlayerFromId(source)
    return PL.Players[tonumber(source)]
end

---@param identifier string
---@return xPlayer
function PL.GetPlayerFromIdentifier(identifier)
    return PL.playersByIdentifier[identifier]
end

function PL.GetIdentifier(playerId)
    local fxDk = GetConvarInt("sv_fxdkMode", 0)
    if fxDk == 1 then
        return "PL-DEBUG-LICENCE"
    end

    local identifier = GetPlayerIdentifierByType(playerId, "license")
    return identifier and identifier:gsub("license:", "")
end

RegisterNetEvent("primordial_core:server:onPlayerJoined")
AddEventHandler("primordial_core:server:onPlayerJoined", function()
    local _source = source
    while not next(PL.Jobs) do
        Wait(50)
    end

    if not PL.Players[_source] then
        onPlayerJoined(_source)
    end
end)

function onPlayerJoined(playerId)
    local identifier = PL.GetIdentifier(playerId)
    if identifier then
        if PL.GetPlayerFromIdentifier(identifier) then
            DropPlayer(
                playerId,
                ("there was an error loading your character!\nError code: identifier-active-ingame\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s"):format(
                    identifier
                )
            )
        else
            local result = MySQL.scalar.await("SELECT 1 FROM users WHERE identifier = ?", { identifier })
            if result then
                LoadPrimordialPlayer(identifier, playerId, false)
            else
                CreatePrimordialPlayer(identifier, playerId)
            end
        end
    else
        DropPlayer(playerId, "there was an error loading your character!\nError code: identifier-missing-ingame\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.")
    end
end

function CreatePrimordialPlayer(identifier, playerId, data)
    local accounts = {}

    for account, money in pairs(StartingAccountMoney) do
        accounts[account] = money
    end

    local defaultGroup = "user"
    if PL.AdminPermissions(playerId) then
        print(("[^2INFO^0] Player ^5%s^0 Has been granted admin permissions via ^5Ace Perms^7."):format(playerId))
        defaultGroup = "admin"
    end

    local parameters = false and { json.encode(accounts), identifier, defaultGroup, data.firstname, data.lastname, data.dateofbirth, data.sex, data.height } or { json.encode(accounts), identifier, defaultGroup }

    if StartingInventoryItems then
        table.insert(parameters, json.encode(StartingInventoryItems))
    end

    MySQL.prepare(newPlayer, parameters, function()
        LoadPrimordialPlayer(identifier, playerId, true)
    end)
end

AddEventHandler("playerConnecting", function(_, _, deferrals)
    deferrals.defer()
    local playerId = source
    local identifier = PL.GetIdentifier(playerId)

    if oneSyncState == "off" or oneSyncState == "legacy" then
        return deferrals.done(("[PL] Primordial Core Requires Onesync Infinity to work. This server currently has Onesync set to: %s"):format(oneSyncState))
    end

    if not PL.DatabaseConnected then
        return deferrals.done("[PL] OxMySQL Was Unable To Connect to your database. Please make sure it is turned on and correctly configured in your server.cfg")
    end

    if identifier then
        if PL.GetPlayerFromIdentifier(identifier) then
            return deferrals.done(
                ("[PL] There was an error loading your character!\nError code: identifier-active\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same account.\n\nYour identifier: %s"):format(identifier)
            )
        else
            return deferrals.done()
        end
    else
        return deferrals.done("[PL] There was an error loading your character!\nError code: identifier-missing\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.")
    end
end)

function LoadPrimordialPlayer(identifier, playerId, isNew)
    local userData = {
        accounts = {},
        inventory = {},
        loadout = {},
        weight = 0,
        identifier = identifier,
        firstName = "John",
        lastName = "Doe",
        dateofbirth = "01/01/2000",
        height = 120,
        dead = false,
    }

    local result = MySQL.prepare.await(loadPlayer, { identifier })

    -- Accounts
    local accounts = result.accounts
    accounts = (accounts and accounts ~= "") and json.decode(accounts) or {}

    for account, data in pairs(AccountsFramework) do
        data.round = data.round or data.round == nil

        local index = #userData.accounts + 1
        userData.accounts[index] = {
            name = account,
            money = accounts[account] or StartingAccountMoney[account] or 0,
            label = data.label,
            round = data.round,
            index = index,
        }
    end

    -- Job
    local job, grade = result.society_name, tostring(result.society_grade)

    if not PL.DoesSocietyExist(job, grade) then
        print(("[^3WARNING^7] Ignoring invalid job for ^5%s^7 [job: ^5%s^7, grade: ^5%s^7]"):format(identifier, job, grade))
        job, grade = "unemployed", "0"
    end

    local jobObject, gradeObject = PL.Jobs[job], PL.Jobs[job].grades[grade]

    userData.society = {
        id = jobObject.id,
        name = jobObject.name,
        label = jobObject.label,

        grade = tonumber(grade),
        grade_name = gradeObject.name,
        grade_label = gradeObject.label,
        grade_salary = gradeObject.salary,
    }

    -- Inventory
    if result.inventory and result.inventory ~= "" then
        userData.inventory = json.decode(result.inventory)
    end

    -- Group
    if result.group then
        if result.group == "superadmin" then
            userData.group = "admin"
            print("[^3WARNING^7] ^5Superadmin^7 detected, setting group to ^5admin^7")
        else
            userData.group = result.group
        end
    else
        userData.group = "user"
    end

    -- Position
    userData.coords = json.decode(result.position) or DefaultSpawnPosition[PL.Math.Random(1,#DefaultSpawnPosition)]

    -- Skin
    userData.skin = (result.skin and result.skin ~= "") and json.decode(result.skin) or { sex = userData.sex == "f" and 1 or 0 }

    -- Metadata
    userData.metadata = (result.metadata and result.metadata ~= "") and json.decode(result.metadata) or {}

    -- sPlayer Creation
    local sPlayer = CreateStudioPlayer(playerId, identifier, userData.group, userData.accounts, userData.inventory, userData.weight, userData.society, userData.loadout, GetPlayerName(playerId), userData.coords, userData.metadata)
    PL.Players[playerId] = sPlayer
    PL.playersByIdentifier[identifier] = sPlayer

    -- Identity
    if result.firstname and result.firstname ~= "" then
        userData.firstName = result.firstname
        userData.lastName = result.lastname

        sPlayer.set("firstName", result.firstname)
        sPlayer.set("lastName", result.lastname)
        sPlayer.setName(("%s %s"):format(result.firstname, result.lastname))

        if result.dateofbirth then
            userData.dateofbirth = result.dateofbirth
            sPlayer.set("dateofbirth", result.dateofbirth)
        end
        if result.sex then
            userData.sex = result.sex
            sPlayer.set("sex", result.sex)
        end
        if result.height then
            userData.height = result.height
            sPlayer.set("height", result.height)
        end
    end

    TriggerEvent("primordial_core:playerLoaded", playerId, sPlayer, isNew)
    userData.money = sPlayer.getMoney()
    userData.maxWeight = sPlayer.getMaxWeight()
    sPlayer.triggerEvent("primordial_core:playerLoaded", userData, isNew, userData.skin)

    sPlayer.triggerEvent("primordial_core:client:registerSuggestions", PL.RegisteredCommands)
    print(('[^2INFO^0] Player ^5"%s"^0 has connected to the server. ID: ^5%s^7'):format(sPlayer.getName(), playerId))
end