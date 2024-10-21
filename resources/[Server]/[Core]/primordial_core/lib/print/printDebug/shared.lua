--- Print a debug message to the console.
---@param message string The message to print.
function PL.Print.Debug(message)
    local resourceName = GetCurrentResourceName():upper()
    print(('[^5%s] ^6[DEBUG] ^5: %s^7'):format(resourceName, message))
end

return PL.Print.Debug