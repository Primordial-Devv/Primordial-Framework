local dataStored = {}

PL.RegisterCommand('report', {'user', 'admin'}, function(sPlayer)
    TriggerClientEvent('primordial_admin:client:openingReportDialog', sPlayer.source)
end, false, {
    help = Translations.command_report_help,
})


lib.callback.register('primordial_admin:server:sendReportData', function(source, reportData)
    local allPlayers = GetPlayers()
    local authorLicense = GetPlayerIdentifier(source, 0)
    local authorDiscord = GetPlayerIdentifier(source, 1)
    reportData.date = os.date('%Y-%m-%d')
    reportData.time = os.date('%H:%M:%S', os.time())

    dataStored[#dataStored+1] = reportData

    lib.notify(source, {
        title = Translations.player_report_sent_title,
        type = 'success',
    })

    for _, players in pairs(allPlayers) do
        local playerAdmin = PrimordialAdminPermissions(players)
        if playerAdmin and playerAdmin?.open then
            lib.notify(players, {
                title = Translations.admin_received_report,
                type = 'info',
            })
        end
    end

    MySQL.insert('INSERT INTO primordial_reports (author, author_discord, author_license, reportType, reason_title, reason_message, report_time, report_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {GetPlayerName(source), authorDiscord or 'Unknown', authorLicense or 'Unknown', reportData.type, reportData.title, reportData.message, reportData.time, reportData.date})
    if not reportData then
        return false
    end
end)

lib.callback.register('primordial_admin:server:fetchReports', function(source)
    local adminName = GetPlayerName(source)
    local reports = MySQL.query.await('SELECT * FROM primordial_reports WHERE is_closed = FALSE AND (is_claimed = FALSE OR (is_claimed = TRUE AND claim_admin_name = ?)) AND reportType = "player" ORDER BY is_claimed DESC', {adminName})

    local function formatTimestamp(timestamp)
        local seconds = timestamp / 1000
        local timeTable = os.date('*t', seconds)
        local months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
        local formattedDate = string.format('%02d %s %d', timeTable.day, months[timeTable.month], timeTable.year)

        return formattedDate
    end

    for _, report in ipairs(reports) do
        local reportDate = formatTimestamp(report.report_date)
        report.report_date = reportDate
    end
    return reports
end)

lib.callback.register('primordial_admin:server:fetchRequests', function(source)
    local adminName = GetPlayerName(source)
    local requests = MySQL.query.await('SELECT * FROM primordial_reports WHERE is_closed = FALSE AND (is_claimed = FALSE OR (is_claimed = TRUE AND claim_admin_name = ?)) AND reportType = "staff" ORDER BY is_claimed DESC', {adminName})

    local function formatTimestamp(timestamp)
        local seconds = timestamp / 1000
        local timeTable = os.date('*t', seconds)
        local months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
        local formattedDate = string.format('%02d %s %d', timeTable.day, months[timeTable.month], timeTable.year)

        return formattedDate
    end

    for _, report in ipairs(requests) do
        local reportDate = formatTimestamp(report.report_date)
        report.report_date = reportDate
    end
    return requests
end)

lib.callback.register('primordial_admin:server:claimReport', function(source, reportId, adminName)
    local currentDate = os.date('%Y-%m-%d')
    local currentTime = os.date('%H:%M:%S', os.time())

    local successClaimed = MySQL.update.await('UPDATE primordial_reports SET is_claimed = TRUE, claim_admin_name = ?, claim_time = ?, claim_date = ? WHERE id = ?', {adminName, currentTime, currentDate, reportId})

    if successClaimed == 0 then
        return false
    end

    return true
end)

lib.callback.register('primordial_admin:server:closeReport', function(source, reportId)
    local currentDate = os.date('%Y-%m-%d')
    local currentTime = os.date('%H:%M:%S', os.time())

    local successClosed = MySQL.update.await('UPDATE primordial_reports SET is_closed = TRUE, close_time = ?, close_date = ? WHERE id = ?', {currentTime, currentDate, reportId})

    if successClosed == 0 then
        return false
    end

    return true
end)

lib.callback.register('primordial_admin:server:checkPlayerOnline', function(source, author)
    local playerId = nil
    
    for _, player in ipairs(GetPlayers()) do
        if GetPlayerName(player) == author then
            playerId = player
            break
        end
    end
    
    if playerId then
        return playerId
    else
        return nil
    end
end)

lib.callback.register('primordial_admin:server:sendMessageToPlayer', function(source, playerId, message)
    if GetPlayerName(playerId) then
        TriggerClientEvent('primordial_admin:client:showAdminMessage', playerId, message)
        return true
    else
        return false
    end
end)