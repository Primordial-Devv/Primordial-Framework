---Load a texture dictionary. When called from a thread, it will yield until it has loaded.
---@param textureDict string The name of the streamed texture dictionary to load.
---@param timeout number? Approximate milliseconds to wait for the dictionary to load. Default is 10000.
---@return string textureDict
function PL.Streaming.RequestStreamedTextureDict(textureDict, timeout)
    if HasStreamedTextureDictLoaded(textureDict) then return textureDict end

    if type(textureDict) ~= 'string' then
        error(("expected textureDict to have type 'string' (received %s)"):format(type(textureDict)))
    end

    return PL.Streaming.Utils.StreamingRequest(RequestStreamedTextureDict, HasStreamedTextureDictLoaded, 'textureDict', textureDict, timeout)
end

return PL.Streaming.RequestStreamedTextureDict
