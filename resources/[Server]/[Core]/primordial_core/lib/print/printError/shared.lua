--- Print an error message to the console.
---@param message string The message to print.
function PL.Print.Error(message)
    local resourceName = GetCurrentResourceName():upper()
    print(('[^5%s] ^1[ERROR] ^5: %s^7'):format(resourceName, message))
end

return PL.Print.Error
