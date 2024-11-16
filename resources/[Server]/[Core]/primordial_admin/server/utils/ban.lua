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

local function GetBanExpiration(currentTime, duration)
    local hour = 3600
    local time = hour * duration
    return currentTime + time
end

function BanPlayer(targetId, banDuration, banReason, source)
    local identifier = ExtractIdentifier(targetId)
    local authorOfBan = GetPlayerName(source)
    local playerBan = GetPlayerName(targetId)
    local playerLicense = identifier.license
    local playerIp = identifier.ip
    local playerDiscord = identifier.discord
    local reason = banReason or 'No reason provided'
    local currentTime = os.time()
    local expirationTime
    if banDuration == 'perm' then
        expirationTime = 'perm'
    else
        expirationTime = GetBanExpiration(currentTime, banDuration)
    end

    MySQL.insert('INSERT INTO primordial_bans (author, player, license, ip, discord, reason, ban_time, expiration_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {authorOfBan, playerBan, playerLicense, playerIp, playerDiscord, reason, currentTime, expirationTime})
    DropPlayer(targetId, 'You have been banned from the server for the reason : ' .. reason)
end

local function SplitTime(seconds)
    local seconds, hours, minutes, secs = tonumber(seconds), 0, 0, 0

    if seconds <= 0 then
        return 0, 0
    else
        local hours = string.format("%02.f", math.floor(seconds/3600))
        local minutes = string.format("%02.f", math.floor(seconds/60 - (hours*60)))
        local secs = string.format("%02.f", math.floor(seconds - hours*3600 - minutes *60))
        return hours, minutes, secs
    end
end

local function DisableConnect(playerName, _, deferrals)
    local player = source
    deferrals.defer()
    Wait()
    deferrals.update(Translations.deferrals_welcome:format(GetCurrentResourceName(), playerName))
    local info = ExtractIdentifier(player)
    local playerIdentifier = info.license
    MySQL.query('SELECT * FROM primordial_bans WHERE license = ?', {playerIdentifier}, function(result)
        if result[1] then
            local time = result[1].ban_time
            local expiration_time = result[1].expiration_time
            if expiration_time == 'perm' then
                deferrals.done((Translations.banned_player_perm):format(result[1].reason))
            end
            local timeLeftBeforeExpiration = math.floor(expiration_time - os.time())
            if timeLeftBeforeExpiration < 1 then
                MySQL.query('DELETE FROM primordial_bans WHERE license = ?', {playerIdentifier})
                deferrals.done()
            elseif timeLeftBeforeExpiration > 1 or timeLeftBeforeExpiration == 1 then
                local hours, minutes, secs = SplitTime(timeLeftBeforeExpiration)
                deferrals.done((Translations.deferral_banned):format(result[1].reason, hours, minutes, secs))
            end
        else
            deferrals.done()
        end
    end)
end

lib.callback.register('primordial_admin:server:fetchBanList', function(source)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end
    local data
    MySQL.query('SELECT * FROM primordial_bans', function(result)
        if result[1] then
            for i = 1, #result do
                local timeLeft
                if result[i].expiration_time == 'perm' then
                    timeLeft = 'perm'
                else
                    timeLeft = result[i].expiration_time - os.time()
                end
                if timeLeft == 'perm' or timeLeft > 0 then
                    if not data then data = {} end
                    data[#data+1] = {
                        name = result[i].player,
                        author = result[i].author,
                        license = result[i].license,
                        reason = result[i].reason,
                        ban_time = result[i].ban_time,
                        expiration_time = result[i].expiration_time,
                        time_left = timeLeft
                    }
                end
            end
        else
            data = {}
        end
    end)
    while not data do
        Wait()
    end
    return data
end)

lib.callback.register('primordial_admin:server:unbanPlayer', function(source, targetLicense)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end
    MySQL.query('DELETE FROM primordial_bans WHERE license = ?', {targetLicense})
    return true
end)

AddEventHandler('playerConnecting', DisableConnect)