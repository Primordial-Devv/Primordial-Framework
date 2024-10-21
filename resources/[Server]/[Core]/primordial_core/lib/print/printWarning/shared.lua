--- Print a warning message to the console.
---@param message string The message to print.
function PL.Print.Warning(message)
    local resourceName = GetCurrentResourceName():upper()
    print(('[^5%s] ^3[WARN] ^5: %s^7'):format(resourceName, message))
end

return PL.Print.Warning