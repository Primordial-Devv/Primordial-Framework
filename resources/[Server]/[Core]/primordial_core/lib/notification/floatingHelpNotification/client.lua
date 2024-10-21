--- Show a floating help notification on the screen with the specified message and coordinates.
---@param msg string The message to display.
---@param coords vector3 The coordinates to display the notification at.
function PL.Notification.ShowFloatingHelpNotification(msg, coords)
    AddTextEntry("plFloatingHelpNotification", msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp("plFloatingHelpNotification")
    EndTextCommandDisplayHelp(2, false, false, -1)
end

return PL.Notification.ShowFloatingHelpNotification