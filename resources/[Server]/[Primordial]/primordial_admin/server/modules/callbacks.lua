lib.callback.register('primordial_admin:server:checkAdminPerms', function(source)
    if not PL.GetPlayerFromId(source) then return end
    return PrimordialAdminPermissions(source)
end)

lib.callback.register('primordial_admin:server:onlinePlayers', function(source)
    return { SentPlayers = ActivePlayers, PlayerCount = #ActivePlayers }
end)

lib.callback.register('primordial_admin:server:getServerSlotsCount', function()
    return GetConvarInt('sv_maxclients', 48)
end)

lib.callback.register('primordial_admin:server:freezeSelectedPlayer', function (source, targetId, freeze)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end
    FreezeEntityPosition(targetId, freeze)
end)

lib.callback.register('primordial_admin:server:give_noclip_to_player', function(source, targetId, noclip)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end
    TriggerClientEvent('primordial_admin:client:toggleNoclip', targetId, noclip)
end)

lib.callback.register('primordial_admin:server_spectate_screenshot_player_webhook', function(source)
    return {webhooksConfig['screenshot'].isEnable, webhooksConfig['screenshot'].webhookURL}
end)

lib.callback.register('primordial_core:server:GetPlayerState', function(source, targetId)
    local sPlayer = PL.GetPlayerFromId(targetId)
    if sPlayer then
        return sPlayer.get("isDead") or false -- Renvoie l'état "mort" du joueur (ou false par défaut)
    else
        return false
    end
end)


lib.callback.register('primordial_admin:server:dropPlayer', function(source, targetId, reason)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end
    local targetInfos = GetPlayerInfo(source)
    DropPlayer(targetId, reason)
    return targetInfos.name
end)

local function GetName(source)
    local player = PL.GetPlayerFromId(source)
    if not player then return false end
    return player.getName()
end

local function GetPlayerAccountFunds(source, type)
    if type == 'cash' then type = 'money' end
    local player = PL.GetPlayerFromId(source)
    if not player then return end
    return player.getAccount(type).money
end

lib.callback.register('primordial_admin:server:getPlayerData', function(source, targetId)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end
        local playerData = {
            identifier = GetPlayerIdentifier(targetId, 0),
            xbl = GetPlayerIdentifier(targetId, 1),
            live = GetPlayerIdentifier(targetId, 2),
            igname = GetName(targetId),
            steamname = GetPlayerName(targetId),
            cash = GetPlayerAccountFunds(targetId, 'cash'),
            bank = GetPlayerAccountFunds(targetId, 'bank'),
            blackMoney = GetPlayerAccountFunds(targetId, 'black_money')
        }
    return playerData
end)

lib.callback.register('primordial_admin:server:giveMoneyToPlayer', function(source, target, targetAccount, amount)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end

    local player = PL.GetPlayerFromId(target)
    if not player then return end
    player.addAccountMoney(targetAccount, amount)
    return true
end)

lib.callback.register('primordial_admin:server:giveItemToPlayer', function(source, target, item, amount)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end

    local player = PL.GetPlayerFromId(target)
    if not player then return end
    player.addInventoryItem(item, amount)
    return true
end)

lib.callback.register('primordial_admin:server:clearPlayerInventory', function(source, targetId, targetName)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end

    local target = PL.GetPlayerFromId(targetId)
    if not target then return end
    target.setAccountMoney('money', 0)
    target.setAccountMoney('black_money', 0)
    exports.ox_inventory:ClearInventory(targetId)
    lib.notify(source, {
        title = Translations.clear_player_inv_notify:format(targetName),
        type = 'success'
    })
    lib.notify(targetId, {
        title = Translations.clear_inv_by_admin_notify,
        type = 'info'
    })
    return true
end)

lib.callback.register('primordial_admin:serer:warnPlayer', function(source, targetId, targetName, reason)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end

    return WarnPlayer(targetId, reason, source)
end)

lib.callback.register('primordial_admin:server:kickPlayer', function(source, targetId, reason)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end

    local tIds = GetPlayerInfo(targetId)
    DropPlayer(targetId, 'You have been kicked from the server for the reason : ' .. reason)
    return tIds.name
end)

lib.callback.register('primordial_admin:server:banPlayer', function(source, targetId, banDuration, banReason)
    local adminPermissions = PrimordialAdminPermissions(source)
    if not adminPermissions or not adminPermissions?.open then return false end

    return BanPlayer(targetId, banDuration, banReason, source)
end)

lib.callback.register('primordial_admin:server:sendAnnounce', function(source, message, job)
    if job then
        local playersWithJob = PL.GetExtendedPlayers('job', job)

        if #playersWithJob > 0 then
            for _, player in ipairs(playersWithJob) do
                TriggerClientEvent('primordial_admin:client:receiveAnnounce', player.source, message)
            end
            lib.notify(source, {
                title = Translations.announce_sent_to_job:format(job),
                type = 'success'
            })
            return true
        else
            lib.notify(source, {
                title = Translations.no_player_with_job:format(job),
                type = 'error'
            })
            return false
        end
    else
        for _, playerId in ipairs(GetPlayers()) do
            TriggerClientEvent('primordial_admin:client:receiveAnnounce', playerId, message)
        end
        lib.notify(source, {
            title = Translations.announce_sent_to_all,
            type = 'success'
        })
        return true
    end
end)

lib.callback.register('primordial_admin:server:fetchAllReorts', function(source)
    local reports = MySQL.query.await('SELECT * FROM primordial_reports')

    local function formatTimestamp(timestamp)
        if timestamp and type(timestamp) == "number" and timestamp > 0 then
            local seconds = timestamp / 1000
            local timeTable = os.date('*t', seconds)
            local months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
            local formattedDate = string.format('%02d %s %d', timeTable.day, months[timeTable.month], timeTable.year)
            return formattedDate
        end
        return nil
    end

    for _, report in ipairs(reports) do
        report.report_date = formatTimestamp(report.report_date)
        report.claim_date = formatTimestamp(report.claim_date)
        report.close_date = formatTimestamp(report.close_date)
    end

    return reports
end)

lib.callback.register('primordial_admin:server:fetchAllWarnings', function(source)
    local warnings = MySQL.query.await('SELECT * FROM primordial_warns')
    return warnings
end)

lib.callback.register('primordial_admin:server:removeWarning', function(source, warnId)
    local warnDeleted = MySQL.query.await('DELETE FROM primordial_warns WHERE id = ?', {warnId})
    if warnDeleted == 0 then
        return false
    end
    return true
end)

lib.callback.register('primordial_admin:server:fetchAllBans', function(source)
    local bans = MySQL.query.await('SELECT * FROM primordial_bans')
    return bans
end)