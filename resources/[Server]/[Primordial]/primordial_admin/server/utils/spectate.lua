local spectateData = {}

local function handleSpectatePlayer(targetId)
    local src = source
    if type(targetId) ~= 'string' and type(targetId) ~= 'number' then return end
    targetId = tonumber(targetId)
    local targetPed = GetPlayerPed(targetId)
    -- Lets exit if the target doesn't exist
    if not targetPed then
        return
    end
    -- checking if spectator and target are on the same routing bucket
    local targetBucket = GetPlayerRoutingBucket(targetId)
    local srcBucket = GetPlayerRoutingBucket(src)

    if not spectateData[src] then
        spectateData[src] = { returnBucket = nil }
    end
    if srcBucket ~= targetBucket then
        -- if there was a routing bucket set, we shouldn't overwrite it due to the cycle feature
        if not spectateData[src].returnBucket then
            spectateData[src].returnBucket = srcBucket
        end
        SetPlayerRoutingBucket(src, targetBucket)
    end
    TriggerClientEvent('primordial_admin:client:spectateStart', src, targetId, GetEntityCoords(targetPed))
end

RegisterNetEvent('primordial_admin:server:spectatePlayer', handleSpectatePlayer)

--- @param currentTargetId number The current target id.
--- @param isNextPlayer boolean If we should cycle to the next player or not.
RegisterNetEvent('primordial_admin:server:cycle', function(currentTargetId, isNextPlayer)
    local src = source

    local onlinePlayers = GetPlayers()
    -- We don't allow cycling if there are less than two players online.
    if #onlinePlayers <= 2 then
        return TriggerClientEvent('primordial_admin:client:cycleFailed', src)
    end

    -- Filter out the current src from the online players list
    local sourceIndex = tableIndexOf(onlinePlayers, tostring(src))
    table.remove(onlinePlayers, sourceIndex)

    -- Find next target
    local nextTargetId
    local currentTargetServerIndex = tableIndexOf(onlinePlayers, tostring(currentTargetId))
    if currentTargetServerIndex < 0 then
        nextTargetId = onlinePlayers[1]
    else
        if isNextPlayer then
            nextTargetId = onlinePlayers[currentTargetServerIndex + 1] or onlinePlayers[1]
        else
            nextTargetId = onlinePlayers[currentTargetServerIndex - 1] or onlinePlayers[#onlinePlayers]
        end
    end
    handleSpectatePlayer(nextTargetId)
end)

RegisterNetEvent('primordial_admin:server:cycleEnd', function()
    local src = source
    local playerSpectateData = spectateData[src]

    if playerSpectateData and playerSpectateData.returnBucket then
        SetPlayerRoutingBucket(src, playerSpectateData.returnBucket)
        spectateData[src].returnBucket = nil
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    spectateData[src] = nil
end)