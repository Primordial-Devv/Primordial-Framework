--- Show a scaleform freemode message on the screen for a certain amount of time
---@param title string The title of the message
---@param msg string The message to display
---@param sec number The amount of time to display the message
function PL.Scaleform.ShowFreemodeMessage(title, msg, sec)
    if not sec then
        sec = 5
    end
    local scaleform = PL.Scaleform.Utils.RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

    BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    ScaleformMovieMethodAddParamTextureNameString(title)
    ScaleformMovieMethodAddParamTextureNameString(msg)
    EndScaleformMovieMethod()

    while sec > 0 do
        Wait(0)
        sec = sec - 0.01

        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

return PL.Scaleform.ShowFreemodeMessage