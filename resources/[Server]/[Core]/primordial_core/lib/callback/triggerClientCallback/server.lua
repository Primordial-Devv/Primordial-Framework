local callbackRequests = {}

function PL.Callback.TriggerClientCallback(playerId, callbackName, ...)
    local requestId = math.random(10000, 99999)
    local promise = promise.new()

    callbackRequests[requestId] = promise

    TriggerClientEvent('primordial_core:client:triggerCallback', playerId, callbackName, requestId, ...)

    return Citizen.Await(promise)
end

RegisterNetEvent('primordial_core:server:callbackResponse', function(requestId, result)
    local promise = callbackRequests[requestId]
    if promise then
        promise:resolve(result)
        callbackRequests[requestId] = nil
    end
end)