--- Server Callbck that start a resource on the server
---@param source number The source of the event
---@param resourceName string The name of the resource to start
---@return boolean success Returns true if the resource was started successfully
lib.callback.register('primordial_core:server:startResouces', function(_, resourceName)
    if not resourceName then return false end

    StartResource(resourceName)

    Wait(1000)
    if GetResourceState(resourceName) == "started" then
        return true
    else
        return false
    end
end)

--- Server Callbck that stop a resource on the server
---@param source number The source of the event
---@param resourceName string The name of the resource to stop
---@return boolean success Returns true if the resource was stopped successfully
lib.callback.register('primordial_core:server:stopResouces', function(_, resourceName)
    if not resourceName then return false end

    StopResource(resourceName)

    if GetResourceState(resourceName) == "stopped" then
        return true
    else
        return false
    end
end)

--- Server Callbck that restart a resource on the server
---@param source number The source of the event
---@param resourceName string The name of the resource to restart
---@return boolean success Returns true if the resource was restarted successfully
lib.callback.register('primordial_core:server:restartResouces', function(_, resourceName)
    if not resourceName then return false end

    StopResource(resourceName)

    if GetResourceState(resourceName) == "stopped" then
        Wait(1000)

        StartResource(resourceName)

        if GetResourceState(resourceName) == "started" then
            return true
        else
            return false
        end
    else
        return false
    end
end)