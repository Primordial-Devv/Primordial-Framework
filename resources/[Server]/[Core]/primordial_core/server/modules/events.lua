AddEventHandler("chatMessage", function(playerId, _, message)
    local sPlayer = PL.GetPlayerFromId(playerId)
    if message:sub(1, 1) == "/" and playerId > 0 then
        CancelEvent()
        local commandName = message:sub(1):gmatch("%w+")()
        TriggerClientEvent('ox_lib:notify', sPlayer.source, {
            titlle = Translations.commanderror_invalidcommand:format(commandName),
            type = 'error',
        })
    end
end)

AddEventHandler("playerDropped", function(reason)
    local playerId = source
    local sPlayer = PL.GetPlayerFromId(playerId)

    if sPlayer then
        TriggerEvent("primordial_core:playerDropped", playerId, reason)
        local job = sPlayer.getJob().name
        local currentJob = PL.JobsPlayerCount[job]
        PL.JobsPlayerCount[job] = ((currentJob and currentJob > 0) and currentJob or 1) - 1
        GlobalState[("%s:count"):format(job)] = PL.JobsPlayerCount[job]
        PL.playersByIdentifier[sPlayer.identifier] = nil
        PL.SavePlayer(sPlayer, function()
            PL.Players[playerId] = nil
        end)
    end
end)

AddEventHandler("primordial_core:playerLoaded", function(_, sPlayer)
    local job = sPlayer.getJob().name
    local jobKey = ("%s:count"):format(job)

    PL.JobsPlayerCount[job] = (PL.JobsPlayerCount[job] or 0) + 1
    GlobalState[jobKey] = PL.JobsPlayerCount[job]
end)

AddEventHandler("primordial_core:setJob", function(_, job, lastJob)
    local lastJobKey = ("%s:count"):format(lastJob.name)
    local jobKey = ("%s:count"):format(job.name)
    local currentLastJob = PL.JobsPlayerCount[lastJob.name]

    PL.JobsPlayerCount[lastJob.name] = ((currentLastJob and currentLastJob > 0) and currentLastJob or 1) - 1
    PL.JobsPlayerCount[job.name] = (PL.JobsPlayerCount[job.name] or 0) + 1

    GlobalState[lastJobKey] = PL.JobsPlayerCount[lastJob.name]
    GlobalState[jobKey] = PL.JobsPlayerCount[job.name]
end)

AddEventHandler("txAdmin:events:scheduledRestart", function(eventData)
    if eventData.secondsRemaining == 60 then
        CreateThread(function()
            Wait(50000)
            PL.SavePlayers()
        end)
    end
end)

AddEventHandler("txAdmin:events:serverShuttingDown", function()
    PL.SavePlayers()
end)

local usersStarted = {}
MySQL.ready(function()
    local p = promise.new()
    MySQL.query('SELECT * FROM users', function(result)
        usersStarted = result
        p:resolve(true)
    end)
    Citizen.Await(p)
    PL.Print.Info(('%s Users Loaded'):format(#usersStarted))
end)