--- Check if the vehicle is empty (no passengers and driver seat is free)
---@param vehicle string | number The vehicle to check
---@return boolean driverSeatFree Whether the driver seat is free
function PL.Vehicle.IsVehicleEmpty(vehicle)
    local passengers = GetVehicleNumberOfPassengers(vehicle)
    local driverSeatFree = IsVehicleSeatFree(vehicle, -1)

    return passengers == 0 and driverSeatFree
end

return PL.Vehicle.IsVehicleEmpty