--- Get the closest vehicle to a set of coords within a certain distance range and optionally include the player's current vehicle.
---@param coords vector3 The coords to check from.
---@param maxDistance? number The max distance to check.
---@param includePlayerVehicle? boolean Whether or not to include the player's current vehicle.
---@return number closestVehicle The closest vehicle entity.
---@return vector3 closestCoords The coords of the closest vehicle entity
function PL.Vehicle.GetClosestVehicle(coords, maxDistance, includePlayerVehicle)
    local vehicles = GetGamePool('CVehicle')
    local closestVehicle, closestCoords
    maxDistance = maxDistance or 2.0
    local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    for i = 1, #vehicles do
        local vehicle = vehicles[i]

        if vehicle ~= playerVehicle or includePlayerVehicle then
            local vehicleCoords = GetEntityCoords(vehicle)
            local distance = #(coords - vehicleCoords)

            if distance < maxDistance then
                maxDistance = distance
                closestVehicle = vehicle
                closestCoords = vehicleCoords
            end
        end
    end

    return closestVehicle, closestCoords
end

return PL.Vehicle.GetClosestVehicle