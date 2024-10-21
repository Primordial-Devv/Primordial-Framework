--- Show a help notification on the screen with the specified message and duration (in milliseconds)
---@param msg string The message to display
---@param thisFrame boolean? Display the notification this frame
---@param beep boolean? Beep sound when displaying the notification
---@param duration number? The duration of the notification
function PL.Notification.ShowHelpNotification(msg, thisFrame, beep, duration)
    AddTextEntry("plHelpNotification", msg)

    if thisFrame then
        DisplayHelpTextThisFrame("plHelpNotification", false)
    else
        if beep == nil then
            beep = true
        end
        BeginTextCommandDisplayHelp("plHelpNotification")
        EndTextCommandDisplayHelp(0, false, beep, duration or -1)
    end
end

return PL.Notification.ShowHelpNotification