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
        local job = sPlayer.getSociety().name
        local currentJob = PL.JobsPlayerCount[job]
        PL.JobsPlayerCount[job] = ((currentJob and currentJob > 0) and currentJob or 1) - 1

        PL.playersByIdentifier[sPlayer.identifier] = nil
        PL.SavePlayer(sPlayer, function()
            PL.Players[playerId] = nil
        end)
    end
end)

AddEventHandler("primordial_core:playerLoaded", function(_, sPlayer)
    local job = sPlayer.getSociety().name

    PL.JobsPlayerCount[job] = (PL.JobsPlayerCount[job] or 0) + 1
end)

AddEventHandler("primordial_core:setSociety", function(_, job, lastJob)
    local currentLastJob = PL.JobsPlayerCount[lastJob.name]

    PL.JobsPlayerCount[lastJob.name] = ((currentLastJob and currentLastJob > 0) and currentLastJob or 1) - 1
    PL.JobsPlayerCount[job.name] = (PL.JobsPlayerCount[job.name] or 0) + 1
end)

RegisterNetEvent('primordial_core:requestJobCount', function(jobName)
    local source = source
    local count = PL.JobsPlayerCount[jobName] or 0
    TriggerClientEvent('primordial_core:receiveJobCount', source, jobName, count)
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