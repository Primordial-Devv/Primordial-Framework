local function GetPlyrIdentifier(source)
    local player = PL.GetPlayerFromId(source)
    if not player then return false end
    return player.identifier
end

GetPlayerInfo = function(src)
    local playerOnline = PL.GetPlayerFromId(src)
    if not playerOnline then return end
    local identifiers = {
        name = GetPlayerName(src),
        identifier = GetPlyrIdentifier(src)
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, 'steam:') then
            identifiers['steam'] = id:gsub('steam:', '')
        elseif string.find(id, 'discord:') then
            identifiers['discord'] = id:gsub('discord:', '')
        elseif string.find(id, 'license:') then
            identifiers['license'] = id:gsub('license:', '')
        elseif string.find(id, 'license2:') then
            identifiers['license2'] = id:gsub('license2:', '')
        elseif string.find(id, 'xbl:') then
            identifiers['xbl'] = id:gsub('xbl:', '')
        elseif string.find(id, 'live:') then
            identifiers['live'] = id:gsub('live:', '')
        elseif string.find(id, 'fivem:') then
            identifiers['fivem'] = id:gsub('fivem:', '')
        end
    end
    if not identifiers.steam then
        identifiers.steam = Translations.unknown_value
    end
    if not identifiers.discord then
        identifiers.discord = Translations.unknown_value
    end
    if not identifiers.license then
        identifiers.license = Translations.unknown_value
    end
    if not identifiers.license2 then
        identifiers.license2 = Translations.unknown_value
    end
    if not identifiers.xbl then
        identifiers.xbl = Translations.unknown_value
    end
    if not identifiers.fivem then
        identifiers.fivem = Translations.unknown_value
    end
    return identifiers
end