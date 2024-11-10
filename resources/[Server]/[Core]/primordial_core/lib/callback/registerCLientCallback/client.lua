local registeredCallbacks = {}

function PL.Callback.RegisterClientCallbck(callbackName, callback, delay, ...)
    if not callbackName then
        PL.Print.Error('Callback name is required to register a callback')
        return nil, 'Callback name missing'
    end

    if type(callback) ~= 'function' then
        PL.Print.Error('Callback must be a function to register a callback')
        return nil, 'Invalid callback function'
    end

    if registeredCallbacks[callbackName] then
        PL.Print.Error('Callback with name ' .. callbackName .. ' is already registered')
        return nil, 'Callback name already exists'
    end

    registeredCallbacks[callbackName] = {
        callback = callback,
        delay = delay or 0,
        args = {...}
    }

    return true
end

RegisterNetEvent('primordial_core:client:triggerCallback', function(callbackName, requestId, ...)
    local callbackData = registeredCallbacks[callbackName]
    if callbackData then
        local result = callbackData.callback(...)

        TriggerServerEvent('primordial_core:server:callbackResponse', requestId, result)
    else
        PL.Print.Error('Callback ' .. callbackName .. ' not found on the client')
        TriggerServerEvent('primordial_core:server:callbackResponse', requestId, nil)
    end
end)