---Load an animation dictionary. When called from a thread, it will yield until it has loaded.
---@param animDict string The name of the animation dictionary to load.
---@param timeout number? Approximate milliseconds to wait for the dictionary to load. Default is 10000.
---@return string animDict
function PL.Streaming.RequestAnimDict(animDict, timeout)
    if HasAnimDictLoaded(animDict) then return animDict end

    if type(animDict) ~= 'string' then
        error(("expected animDict to have type 'string' (received %s)"):format(type(animDict)))
    end

    if not DoesAnimDictExist(animDict) then
        error(("attempted to load invalid animDict '%s'"):format(animDict))
    end

    return PL.Streaming.Utils.StreamingRequest(RequestAnimDict, HasAnimDictLoaded, 'animDict', animDict, timeout)
end

return PL.Streaming.RequestAnimDict