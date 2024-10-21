FuelStationDebugMode = false -- Enable / Disable debug mode for fuel station

function Debug(message, data)
    if FuelStationDebugMode then
        if data then
            PL.Print.Debug(('%s: %s'):format(message, tostring(data)))
        else
            PL.Print.Debug(message)
        end
    end
end