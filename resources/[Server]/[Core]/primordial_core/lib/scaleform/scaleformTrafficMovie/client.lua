--- Show a scaleform traffic movie on the screen for a certain amount of time
---@param sec number The amount of time to display the traffic movie
function PL.Scaleform.ShowTrafficMovie(sec)
    if not sec then
        sec = 5
    end
    local scaleform = PL.Scaleform.Utils.RequestScaleformMovie("TRAFFIC_CAM")

    BeginScaleformMovieMethod(scaleform, "PLAY_CAM_MOVIE")

    EndScaleformMovieMethod()

    while sec > 0 do
        Wait(0)
        sec = sec - 0.01

        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end

    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

return PL.Scaleform.ShowTrafficMovie