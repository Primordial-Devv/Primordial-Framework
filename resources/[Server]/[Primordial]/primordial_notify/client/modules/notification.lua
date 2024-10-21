function PL.Notification(params)
    if not params.message then
        PL.Print.Error('Notification message is required')
        return
    end

    local message = params.message
    local image = params.image or nil
    local color = params.color or "#000000"
    local duration = params.duration or 5000

    if image then
        PL.Print.Debug('Notification with image')

        SendNUIMessage({
            action = 'showNotification',
            message = message,
            image = image,
            color = color,
            duration = duration,
            hasImage = true
        })
    else
        PL.Print.Debug('Notification without image')

        SendNUIMessage({
            action = 'showNotification',
            message = message,
            image = image,
            color = color,
            duration = duration,
            hasImage = false
        })
    end
end