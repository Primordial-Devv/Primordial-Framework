--- Show a scaleform popup warning on the screen for a certain amount of time
---@param title string The title of the warning
---@param msg string The message to display
---@param bottom string The bottom message to display
---@param sec number The amount of time to display the warning
function PL.Scaleform.ShowPopupWarning(title, msg, bottom, sec)
    if not sec then
        sec = 5
    end
    local scaleform = PL.Scaleform.Utils.RequestScaleformMovie("POPUP_WARNING")

    BeginScaleformMovieMethod(scaleform, "SHOW_POPUP_WARNING")

    ScaleformMovieMethodAddParamFloat(500.0) -- black background
    ScaleformMovieMethodAddParamTextureNameString(title)
    ScaleformMovieMethodAddParamTextureNameString(msg)
    ScaleformMovieMethodAddParamTextureNameString(bottom)
    ScaleformMovieMethodAddParamBool(true)

    EndScaleformMovieMethod()

    while sec > 0 do
        Wait(0)
        sec = sec - 0.01

        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

return PL.Scaleform.ShowPopupWarning