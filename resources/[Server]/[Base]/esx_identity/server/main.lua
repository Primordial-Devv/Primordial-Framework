local playerIdentity = {}
local alreadyRegistered = {}

local function deleteIdentityFromDatabase(sPlayer)
    MySQL.query.await("UPDATE users SET firstname = ?, lastname = ?, dateofbirth = ?, sex = ?, height = ?, skin = ? WHERE identifier = ?", { nil, nil, nil, nil, nil, nil, sPlayer.identifier })
end

local function deleteIdentity(sPlayer)
    if not alreadyRegistered[sPlayer.identifier] then
        return
    end

    sPlayer.setName(("%s %s"):format(nil, nil))
    sPlayer.set("firstName", nil)
    sPlayer.set("lastName", nil)
    sPlayer.set("dateofbirth", nil)
    sPlayer.set("sex", nil)
    sPlayer.set("height", nil)
    deleteIdentityFromDatabase(sPlayer)
end

local function saveIdentityToDatabase(identifier, identity)
    MySQL.update.await("UPDATE users SET firstname = ?, lastname = ?, dateofbirth = ?, sex = ?, height = ? WHERE identifier = ?", { identity.firstName, identity.lastName, identity.dateOfBirth, identity.sex, identity.height, identifier })
end

local function checkDOBFormat(str)
    str = tostring(str)
    if not string.match(str, "(%d%d)/(%d%d)/(%d%d%d%d)") then
        return false
    end

    local d, m, y = string.match(str, "(%d+)/(%d+)/(%d+)")

    m = tonumber(m)
    d = tonumber(d)
    y = tonumber(y)

    if ((d <= 0) or (d > 31)) or ((m <= 0) or (m > 12)) or ((y <= 1900) or (y > 2005)) then
        return false
    elseif m == 4 or m == 6 or m == 9 or m == 11 then
        return d <= 30
    elseif m == 2 then
        if y % 400 == 0 or (y % 100 ~= 0 and y % 4 == 0) then
            return d <= 29
        else
            return d <= 28
        end
    else
        return d <= 31
    end
end

local function formatDate(str)
    local d, m, y = string.match(str, "(%d+)/(%d+)/(%d+)")
    local date = str

    if DateFormat == "MM/DD/YYYY" then
        date = m .. "/" .. d .. "/" .. y
    elseif DateFormat == "YYYY/MM/DD" then
        date = y .. "/" .. m .. "/" .. d
    end

    return date
end

local function checkAlphanumeric(str)
    return (string.match(str, "%W"))
end

local function checkForNumbers(str)
    return (string.match(str, "%d"))
end

local function checkNameFormat(name)
    if not checkAlphanumeric(name) and not checkForNumbers(name) then
        local stringLength = string.len(name)
        return stringLength > 0 and stringLength < 20
    end

    return false
end

local function checkSexFormat(sex)
    if not sex then
        return false
    end
    return sex == "m" or sex == "M" or sex == "f" or sex == "F"
end

local function checkHeightFormat(height)
    local numHeight = tonumber(height) or 0
    return numHeight >= 120 and numHeight <= 220
end

local function convertToLowerCase(str)
    return string.lower(str)
end

local function convertFirstLetterToUpper(str)
    return str:gsub("^%l", string.upper)
end

local function formatName(name)
    local loweredName = convertToLowerCase(name)
    return convertFirstLetterToUpper(loweredName)
end

local function setIdentity(sPlayer)
    if not alreadyRegistered[sPlayer.identifier] then
        return
    end
    local currentIdentity = playerIdentity[sPlayer.identifier]

    sPlayer.setName(("%s %s"):format(currentIdentity.firstName, currentIdentity.lastName))
    sPlayer.set("firstName", currentIdentity.firstName)
    sPlayer.set("lastName", currentIdentity.lastName)
    sPlayer.set("dateofbirth", currentIdentity.dateOfBirth)
    sPlayer.set("sex", currentIdentity.sex)
    sPlayer.set("height", currentIdentity.height)
    TriggerClientEvent("esx_identity:setPlayerData", sPlayer.source, currentIdentity)
    if currentIdentity.saveToDatabase then
        saveIdentityToDatabase(sPlayer.identifier, currentIdentity)
    end

    playerIdentity[sPlayer.identifier] = nil
end

local function checkIdentity(sPlayer)
    MySQL.single("SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = ?", { sPlayer.identifier }, function(result)
        if not result then
            return TriggerClientEvent("esx_identity:showRegisterIdentity", sPlayer.source)
        end
        if not result.firstname then
            playerIdentity[sPlayer.identifier] = nil
            alreadyRegistered[sPlayer.identifier] = false
            return TriggerClientEvent("esx_identity:showRegisterIdentity", sPlayer.source)
        end

        playerIdentity[sPlayer.identifier] = {
            firstName = result.firstname,
            lastName = result.lastname,
            dateOfBirth = result.dateofbirth,
            sex = result.sex,
            height = result.height,
        }

        alreadyRegistered[sPlayer.identifier] = true
        setIdentity(sPlayer)
    end)
end

AddEventHandler("playerConnecting", function(_, _, deferrals)
    deferrals.defer()
    local _, identifier = source, PL.GetIdentifier(source)
    Wait(40)

    if not identifier then
        return deferrals.done(Translations.no_identifier)
    end
    MySQL.single("SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = ?", { identifier }, function(result)
        if not result then
            playerIdentity[identifier] = nil
            alreadyRegistered[identifier] = false
            return deferrals.done()
        end
        if not result.firstname then
            playerIdentity[identifier] = nil
            alreadyRegistered[identifier] = false
            return deferrals.done()
        end

        playerIdentity[identifier] = {
            firstName = result.firstname,
            lastName = result.lastname,
            dateOfBirth = result.dateofbirth,
            sex = result.sex,
            height = result.height,
        }

        alreadyRegistered[identifier] = true

        deferrals.done()
    end)
end)

AddEventHandler("onResourceStart", function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end
    Wait(300)

    while not PL do
        Wait(0)
    end

    local sPlayers = PL.GetExtendedPlayers()

    for i = 1, #sPlayers do
        if sPlayers[i] then
            checkIdentity(sPlayers[i])
        end
    end
end)

RegisterNetEvent("primordial_core:playerLoaded", function(_, sPlayer)
    local currentIdentity = playerIdentity[sPlayer.identifier]

    if currentIdentity and alreadyRegistered[sPlayer.identifier] then
        sPlayer.setName(("%s %s"):format(currentIdentity.firstName, currentIdentity.lastName))
        sPlayer.set("firstName", currentIdentity.firstName)
        sPlayer.set("lastName", currentIdentity.lastName)
        sPlayer.set("dateofbirth", currentIdentity.dateOfBirth)
        sPlayer.set("sex", currentIdentity.sex)
        sPlayer.set("height", currentIdentity.height)
        TriggerClientEvent("esx_identity:setPlayerData", sPlayer.source, currentIdentity)
        if currentIdentity.saveToDatabase then
            saveIdentityToDatabase(sPlayer.identifier, currentIdentity)
        end

        Wait(0)

        TriggerClientEvent("esx_identity:alreadyRegistered", sPlayer.source)

        playerIdentity[sPlayer.identifier] = nil
    else
        TriggerClientEvent("esx_identity:showRegisterIdentity", sPlayer.source)
    end
end)

lib.callback.register('esx_identity:registerIdentity', function(source, data)
    local sPlayer = PL.GetPlayerFromId(source)
    if not checkNameFormat(data.firstname) then
        lib.notify(source, {
            title = Translations.invalid_firstname_format,
            type = "error",
        })
        return false
    end
    if not checkNameFormat(data.lastname) then
        lib.notify(source, {
            title = Translations.invalid_lastname_format,
            type = "error",
        })
        return false
    end
    if not checkSexFormat(data.sex) then
        lib.notify(source, {
            title = Translations.invalid_sex_format,
            type = "error",
        })
        return false
    end
    if not checkDOBFormat(data.dateofbirth) then
        lib.notify(source, {
            title = Translations.invalid_dob_format,
            type = "error",
        })
        return false
    end
    if not checkHeightFormat(data.height) then
        lib.notify(source, {
            title = Translations.invalid_height_format,
            type = "error",
        })
        return false
    end
    if sPlayer then
        if alreadyRegistered[sPlayer.identifier] then
            lib.notify(sPlayer.source, {
                title = Translations.already_registered,
                type = "error",
            })
            return false
        end

        playerIdentity[sPlayer.identifier] = {
            firstName = formatName(data.firstname),
            lastName = formatName(data.lastname),
            dateOfBirth = formatDate(data.dateofbirth),
            sex = data.sex,
            height = data.height,
        }

        local currentIdentity = playerIdentity[sPlayer.identifier]

        sPlayer.setName(("%s %s"):format(currentIdentity.firstName, currentIdentity.lastName))
        sPlayer.set("firstName", currentIdentity.firstName)
        sPlayer.set("lastName", currentIdentity.lastName)
        sPlayer.set("dateofbirth", currentIdentity.dateOfBirth)
        sPlayer.set("sex", currentIdentity.sex)
        sPlayer.set("height", currentIdentity.height)
        TriggerClientEvent("esx_identity:setPlayerData", sPlayer.source, currentIdentity)
        saveIdentityToDatabase(sPlayer.identifier, currentIdentity)
        alreadyRegistered[sPlayer.identifier] = true
        playerIdentity[sPlayer.identifier] = nil
        return true
    end

    if not multichar then
        lib.notify(source, {
            title = Translations.data_incorrect,
            type = "error",
        })
        return false
    end

    local formattedFirstName = formatName(data.firstname)
    local formattedLastName = formatName(data.lastname)
    local formattedDate = formatDate(data.dateofbirth)

    data.firstname = formattedFirstName
    data.lastname = formattedLastName
    data.dateofbirth = formattedDate
    local Identity = {
        firstName = formattedFirstName,
        lastName = formattedLastName,
        dateOfBirth = formattedDate,
        sex = data.sex,
        height = data.height,
    }

    TriggerEvent("esx_identity:completedRegistration", source, data)
    TriggerClientEvent("esx_identity:setPlayerData", source, Identity)
end)

if EnableCommands then
    PL.RegisterCommand("char", "user", function(sPlayer)
        if sPlayer and sPlayer.getName() then
            lib.notify(sPlayer.source, {
                title = Translations.active_character:format(sPlayer.getName()),
                type = "info",
            })
        else
            lib.notify(sPlayer.source, {
                title = Translations.error_active_character,
                type = "error",
            })
        end
    end, false, { help = Translations.show_active_character })

    PL.RegisterCommand("chardel", "user", function(sPlayer)
        if sPlayer and sPlayer.getName() then
            deleteIdentity(sPlayer)
            lib.notify(sPlayer.source, {
                title = Translations.deleted_character,
                type = "info",
            })
            playerIdentity[sPlayer.identifier] = nil
            alreadyRegistered[sPlayer.identifier] = false
            TriggerClientEvent("esx_identity:showRegisterIdentity", sPlayer.source)
        else
            lib.notify(sPlayer.source, {
                title = Translations.error_delete_character,
                type = "error",
            })
        end
    end, false, { help = Translations.delete_character })
end

if EnableDebugging then
    PL.RegisterCommand("sPlayerGetFirstName", "user", function(sPlayer)
        if sPlayer and sPlayer.get("firstName") then
            lib.notify(sPlayer.source, {
                title = Translations.return_debug_sPlayer_get_first_name:format(sPlayer.get("firstName")),
                type = "info",
            })
        else
            lib.notify(sPlayer.source, {
                title = Translations.error_debug_sPlayer_get_first_name,
                type = "error",
            })
        end
    end, false, { help = Translations.debug_sPlayer_get_first_name })

    PL.RegisterCommand("sPlayerGetLastName", "user", function(sPlayer)
        if sPlayer and sPlayer.get("lastName") then
            lib.notify(sPlayer.source, {
                title = Translations.return_debug_sPlayer_get_last_name:format(sPlayer.get("lastName")),
                type = "info",
            })
        else
            lib.notify(sPlayer.source, {
                title = Translations.error_debug_sPlayer_get_last_name,
                type = "error",
            })
        end
    end, false, { help = Translations.debug_sPlayer_get_last_name })

    PL.RegisterCommand("sPlayerGetFullName", "user", function(sPlayer)
        if sPlayer and sPlayer.getName() then
            lib.notify(sPlayer.source, {
                title = Translations.return_debug_sPlayer_get_full_name:format(sPlayer.getName()),
                type = "info",
            })
        else
            lib.notify(sPlayer.source, {
                title = Translations.error_debug_sPlayer_get_full_name,
                type = "error",
            })
        end
    end, false, { help = Translations.debug_sPlayer_get_full_name })

    PL.RegisterCommand("sPlayerGetSex", "user", function(sPlayer)
        if sPlayer and sPlayer.get("sex") then
            lib.notify(sPlayer.source, {
                title = Translations.return_debug_sPlayer_get_sex:format(sPlayer.get("sex")),
                type = "info",
            })
        else
            lib.notify(sPlayer.source, {
                title = Translations.error_debug_sPlayer_get_sex,
                type = "error",
            })
        end
    end, false, { help = Translations.debug_sPlayer_get_sex })

    PL.RegisterCommand("sPlayerGetDOB", "user", function(sPlayer)
        if sPlayer and sPlayer.get("dateofbirth") then
            lib.notify(sPlayer.source, {
                title = Translations.return_debug_sPlayer_get_dob:format(sPlayer.get("dateofbirth")),
                type = "info",
            })
        else
            lib.notify(sPlayer.source, {
                title = Translations.error_debug_sPlayer_get_dob,
                type = "error",
            })
        end
    end, false, { help = Translations.debug_sPlayer_get_dob })

    PL.RegisterCommand("sPlayerGetHeight", "user", function(sPlayer)
        if sPlayer and sPlayer.get("height") then
            lib.notify(sPlayer.source, {
                title = Translations.return_debug_sPlayer_get_height:format(sPlayer.get("height")),
                type = "info",
            })
        else
            lib.notify(sPlayer.source, {
                title = Translations.error_debug_sPlayer_get_height,
                type = "error",
            })
        end
    end, false, { help = Translations.debug_sPlayer_get_height })
end
