---Load a named particle effect. When called from a thread, it will yield until it has loaded.
---@param ptFxName string The name of the particle effect to load.
---@param timeout number? Approximate milliseconds to wait for the particle effect to load. Default is 10000.
---@return string ptFxName
function PL.Streaming.RequestNamedPtfxAsset(ptFxName, timeout)
    if HasNamedPtfxAssetLoaded(ptFxName) then return ptFxName end

    if type(ptFxName) ~= 'string' then
        error(("expected ptFxName to have type 'string' (received %s)"):format(type(ptFxName)))
    end

    return PL.Streaming.Utils.StreamingRequest(RequestNamedPtfxAsset, HasNamedPtfxAssetLoaded, 'ptFxName', ptFxName, timeout)
end

return PL.Streaming.RequestNamedPtfxAsset