local TimeoutCount = 0
local CancelledTimeouts = {}

--- Return a new timeout with the given milliseconds and callback
---@param msec number The milliseconds to wait before calling the callback
---@param cb function The callback function to call after the milliseconds
---@return number id The id of the timeout
PL.Utils.SetTimeout = function(msec, cb)
    local id <const> = TimeoutCount + 1

    SetTimeout(msec, function()
        if CancelledTimeouts[id] then
            CancelledTimeouts[id] = nil
            return
        end

        cb()
    end)

    TimeoutCount = id

    return id
end

--- Clear the timeout with the given id
---@param id number The id of the timeout to clear
PL.Utils.ClearTimeout = function(id)
    CancelledTimeouts[id] = true
end

return {
    SetTimeout = PL.Utils.SetTimeout,
    ClearTimeout = PL.Utils.ClearTimeout
}