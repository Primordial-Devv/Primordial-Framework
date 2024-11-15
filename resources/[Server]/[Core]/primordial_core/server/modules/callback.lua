--- Registers the callback for creating a society in the database.
--- @param societyOwnerId number The player ID of the society's owner.
--- @param societyName string The unique name of the society.
--- @param societyLabel string The display label for the society.
--- @param isWhitelisted string "yes" or "no", whether the society is whitelisted.
--- @return boolean success True if the society was created successfully, false otherwise.
lib.callback.register("primordial:server:createSocietyDB", function(societyOwnerId, societyName, societyLabel, isWhitelisted)
    PL.Type.AssertType(societyOwnerId, "number")
    PL.Type.AssertType(societyName, "string")
    PL.Type.AssertType(societyLabel, "string")
    PL.Type.AssertType(isWhitelisted, "string")

    local isWhitelistedBool <const> = isWhitelisted == "yes"

    local ownerIdentifier <const> = PL.Player.GetPlayerIdentifier(societyOwnerId)
    if not ownerIdentifier then
        PL.Print.Error("Failed to retrieve owner identifier for society creation.")
        return false
    end

    local prefix <const> = societyName:sub(1, 3):upper()
    local randomString <const> = PL.String.GetRandomString(15, 3)
    local registrationNumber <const> = prefix .. randomString

    local queryResult <const> = MySQL.prepare.await("INSERT INTO society (name, label, registration_number, owner, isWhitelisted) VALUES (?, ?, ?, ?, ?)",
        {
            societyName,
            societyLabel,
            registrationNumber,
            ownerIdentifier.license,
            isWhitelistedBool and 1 or 0,
        }
    )

    if not queryResult then
        PL.Print.Error("Failed to insert society into the database.")
        return false
    end

    PL.Print.Info("Society created successfully with owner license: " .. ownerIdentifier.license .. " and registration number: " .. registrationNumber)
    return true
end)


--- Handle society owner transfer.
--- @param societyName string The name of the society.
--- @param newOwnerId number The server ID of the new owner.
--- @return boolean success True if the transfer was successful, false otherwise.
lib.callback.register("primordial:server:transferSocietyOwner", function(source, societyName, newOwnerId)
    PL.Type.AssertType(societyName, "string")
    PL.Type.AssertType(newOwnerId, "number")

    local query <const> = "SELECT * FROM society WHERE name = ?"
    local society <const> = MySQL.prepare.await(query, { societyName })

    if not society then
        PL.Print.Error(("Society '%s' does not exist. Transfer aborted."):format(societyName))
        return false
    end

    local currentPlayer <const> = PL.GetPlayerFromId(source)
    if not currentPlayer or currentPlayer.identifier ~= society.owner then
        PL.Print.Error(("Player '%s' is not the current owner of society '%s'. Transfer aborted."):format(source, societyName))
        return false
    end

    local newOwner <const> = PL.GetPlayerFromId(newOwnerId)
    if not newOwner then
        PL.Print.Error(("New owner with ID '%s' does not exist. Transfer aborted."):format(newOwnerId))
        return false
    end

    local updateQuery <const> = "UPDATE society SET owner = ? WHERE name = ?"
    local result <const> = MySQL.prepare.await(updateQuery, { newOwner.identifier, societyName })

    if not result then
        PL.Print.Error(("Failed to update owner for society '%s'. Transfer aborted."):format(societyName))
        return false
    end

    PL.Print.Info(("Ownership of society '%s' has been transferred to '%s'."):format(societyName, newOwner.identifier))
    return true
end)
