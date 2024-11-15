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