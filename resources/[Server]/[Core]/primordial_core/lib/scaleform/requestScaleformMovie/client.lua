---Load a scaleform movie. When called from a thread, it will yield until it has loaded.
---@param scaleformName string The name of the scaleform movie to load.
---@param timeout number? Approximate milliseconds to wait for the scaleform movie to load. Default is 1000.
---@return number scaleform The scaleform movie handle.
function PL.Scaleform.Utils.RequestScaleformMovie(scaleformName, timeout)
    if type(scaleformName) ~= 'string' then
        error(("expected scaleformName to have type 'string' (received %s)"):format(type(scaleformName)))
    end

    local scaleform = RequestScaleformMovie(scaleformName)

    return PL.Utils.WaitFor(function()
        if HasScaleformMovieLoaded(scaleform) then return scaleform end
    end, ("failed to load scaleformMovie '%s'"):format(scaleformName), timeout)
end

return PL.Scaleform.Utils.RequestScaleformMovie