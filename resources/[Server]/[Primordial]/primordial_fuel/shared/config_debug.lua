FuelStationDebugMode = false -- Enable / Disable debug mode for fuel station

function Debug(message, data)
    if FuelStationDebugMode then
        if data then
            PL.Print.Log(4, false, ('%s: %s'):format(message, tostring(data)))
        else
            PL.Print.Log(4, false, message)
        end
    end
end