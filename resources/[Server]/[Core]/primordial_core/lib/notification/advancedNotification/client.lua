--- Show a notification with char image and icon and optional custom texture dictionary on the screen
---@param title string The title of the notification
---@param subtitle string The subtitle of the notification
---@param msg string The message to display
---@param hudColorIndex number? The HUD color index (optional)
---@param flash boolean? Flash the notification (optional, defaults to false)
---@param saveToBrief boolean? Save the notification to the brief (optional, defaults to true)
---@param textureDict string? The texture dictionary (CHAR image to show, optional)
---@param textureName string? The name of the texture in the dictionary (optional, defaults to textureDict if nil)
---@param iconType string The icon type (defaults to 0)
function PL.Notification.ShowAdvancedNotification(title, subtitle, msg, hudColorIndex, flash, saveToBrief, textureDict, textureName, iconType)
    if saveToBrief == nil then
        saveToBrief = true
    end

    AddTextEntry("plAdvancedNotification", msg)
    BeginTextCommandThefeedPost("plAdvancedNotification")

    if hudColorIndex then
        ThefeedSetNextPostBackgroundColor(hudColorIndex)
    end

    EndTextCommandThefeedPostMessagetext(textureDict or "CHAR_DEFAULT", textureName or textureDict or "CHAR_DEFAULT", false, iconType or 0, title, subtitle)

    EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end

return PL.Notification.ShowAdvancedNotification
