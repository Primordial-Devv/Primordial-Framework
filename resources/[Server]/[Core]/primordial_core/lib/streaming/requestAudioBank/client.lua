--- Request an audio bank to be loaded on the client.
---@param audioBank string The name of the audio bank to load.
---@param timeout number? Approximate milliseconds to wait for the audio bank to load. Default is 10000.
---@return string audioBank The name of the audio bank that was loaded.
function PL.Streaming.RequestAudioBank(audioBank, timeout)
    PL.Type.AssertType(audioBank, "string")
    PL.Type.AssertType(timeout, { "number", "nil" })

    --- Request a script audio bank to be loaded.
    return PL.Utils.WaitFor(function()
        if RequestScriptAudioBank(audioBank, false) then return audioBank end
    end, ("failed to load audio bank '%s' - this may be caused by - too many loaded assets - oversized, invalid, or corrupted assets"):format(audioBank), timeout or 10000)
end

return PL.Streaming.RequestAudioBank