--- Print an info message to the console.
---@param message string The message to print.
function PL.Print.Info(message)
    local resourceName = GetCurrentResourceName():upper()
    print(('[^5%s] ^7[INFO] ^5: %s^7'):format(resourceName, message))
end

return PL.Print.Info