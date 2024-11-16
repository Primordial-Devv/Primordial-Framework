local function ExtractIdentifier(source)
    local identifiers = { ip = '', discord = '', license = '' }
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        if string.find(id, 'ip') then
            identifiers.ip = id
        elseif string.find(id, 'discord') then
            identifiers.discord = id
        elseif string.find(id, 'license') then
            identifiers.license = id
        end
    end
    return identifiers
end

function WarnPlayer(targetId, reason, source)

    local identifier = ExtractIdentifier(targetId)
    local authorOfWarn = GetPlayerName(source)
    local playerWarn = GetPlayerName(targetId)
    local playerLicense = identifier.license
    local playerIp = identifier.ip
    local playerDiscord = identifier.discord
    local reason = reason or 'No reason provided'
    MySQL.insert('INSERT INTO primordial_warns (author, player, license, ip, discord, reason) VALUES (?, ?, ?, ?, ?, ?)', {authorOfWarn, playerWarn, playerLicense, playerIp, playerDiscord, reason})
    return true
end