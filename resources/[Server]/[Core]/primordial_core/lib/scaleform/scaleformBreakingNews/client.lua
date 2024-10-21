--- Show a scaleform breaking news on the screen for a certain amount of time
---@param title string The title of the breaking news
---@param msg string The message to display
---@param bottom string The bottom message to display
---@param sec number The amount of time to display the breaking news
function PL.Scaleform.ShowBreakingNews(title, msg, bottom, sec)
    if not sec then
        sec = 5
    end
    local scaleform = PL.Scaleform.Utils.RequestScaleformMovie("BREAKING_NEWS")

    BeginScaleformMovieMethod(scaleform, "SET_TEXT")
    ScaleformMovieMethodAddParamTextureNameString(msg)
    ScaleformMovieMethodAddParamTextureNameString(bottom)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_SCROLL_TEXT")
    ScaleformMovieMethodAddParamInt(0) -- top ticker
    ScaleformMovieMethodAddParamInt(0) -- Since this is the first string, start at 0
    ScaleformMovieMethodAddParamTextureNameString(title)

    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "DISPLAY_SCROLL_TEXT")
    ScaleformMovieMethodAddParamInt(0) -- Top ticker
    ScaleformMovieMethodAddParamInt(0) -- Index of string

    EndScaleformMovieMethod()

    while sec > 0 do
        Wait(0)
        sec = sec - 0.01

        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

return PL.Scaleform.ShowBreakingNews