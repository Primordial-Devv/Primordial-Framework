--- Delete a vehicle from the world
---@param vehicle string|number The vehicle entity or network ID to delete
function PL.Vehicle.DeleteVehicle(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
end

return PL.Vehicle.DeleteVehicle