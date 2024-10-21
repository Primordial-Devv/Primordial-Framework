---Load an animation clipset. When called from a thread, it will yield until it has loaded.
---@param animSet string The name of the clipset to load.
---@param timeout number? Approximate milliseconds to wait for the clipset to load. Default is 10000.
---@return string animSet
function PL.Streaming.RequestAnimSet(animSet, timeout)
    if HasAnimSetLoaded(animSet) then return animSet end

    if type(animSet) ~= 'string' then
        error(("expected animSet to have type 'string' (received %s)"):format(type(animSet)))
    end

    return PL.Streaming.Utils.StreamingRequest(RequestAnimSet, HasAnimSetLoaded, 'animSet', animSet, timeout)
end

return PL.Streaming.RequestAnimSet
