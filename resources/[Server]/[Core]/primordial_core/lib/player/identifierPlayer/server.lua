--- Define constants for identifier types.
local IDENTIFIER_TYPES <const> = {
    STEAM = "steam",
    DISCORD = "discord",
    LICENSE = "license",
    LICENSE2 = "license2",
    IP = "ip",
    XBL = "xbl",
    LIVE = "live",
    FIVEM = "fivem",
}

--- Retrieves all relevant identifiers for a player based on their server ID.
--- @class PlayerIdentifiers
--- @field name string The player's name.
--- @field identifier string The player's unique server identifier.
--- @field steam string|nil The player's Steam identifier.
--- @field discord string|nil The player's Discord identifier.
--- @field license string|nil The player's primary license identifier.
--- @field license2 string|nil The player's secondary license identifier (if applicable).
--- @field ip string|nil The player's IP address.
--- @field xbl string|nil The player's Xbox Live identifier.
--- @field live string|nil The player's Microsoft Live identifier.
--- @field fivem string|nil The player's FiveM identifier.

--- Retrieve the identifiers for a player.
--- @param source number The player's server ID.
--- @return PlayerIdentifiers|nil playerIdentifiers Table containing all player identifiers, or nil if player is not found.
function PL.Player.GetPlayerIdentifier(source)
    local playerData <const> = PL.GetPlayerFromId(source)
    if not playerData then return nil end

    --- @type PlayerIdentifiers
    local playerIdentifiers <const> = {
        name = GetPlayerName(source),
        identifier = playerData.identifier,
        steam = nil,
        discord = nil,
        license = nil,
        license2 = nil,
        ip = nil,
        xbl = nil,
        live = nil,
        fivem = nil,
    }

    -- Populate identifiers based on known types using pattern matching.
    for index = 0, GetNumPlayerIdentifiers(source) - 1 do
        local identifier <const> = GetPlayerIdentifier(source, index)

        -- Assign values to the identifiers if they match a known type.
        playerIdentifiers.steam = playerIdentifiers.steam or identifier:match('^' .. IDENTIFIER_TYPES.STEAM .. ':(.+)$')
        playerIdentifiers.discord = playerIdentifiers.discord or identifier:match('^' .. IDENTIFIER_TYPES.DISCORD .. ':(.+)$')
        playerIdentifiers.license = playerIdentifiers.license or identifier:match('^' .. IDENTIFIER_TYPES.LICENSE .. ':(.+)$')
        playerIdentifiers.license2 = playerIdentifiers.license2 or identifier:match('^' .. IDENTIFIER_TYPES.LICENSE2 .. ':(.+)$')
        playerIdentifiers.ip = playerIdentifiers.ip or identifier:match('^' .. IDENTIFIER_TYPES.IP .. ':(.+)$')
        playerIdentifiers.xbl = playerIdentifiers.xbl or identifier:match('^' .. IDENTIFIER_TYPES.XBL .. ':(.+)$')
        playerIdentifiers.live = playerIdentifiers.live or identifier:match('^' .. IDENTIFIER_TYPES.LIVE .. ':(.+)$')
        playerIdentifiers.fivem = playerIdentifiers.fivem or identifier:match('^' .. IDENTIFIER_TYPES.FIVEM .. ':(.+)$')
    end

    return playerIdentifiers
end

return PL.Player.GetPlayerIdentifier