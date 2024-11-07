--- Get the closest vehicle from a set of coords within a certain distance range.
---@param coords vector3 The coords to check from.
---@param maxDistance? number The max distance to check.
---@return number closestVehicle The closest vehicle entity.
---@return vector3 closestCoords The coords of the closest vehicle entity
function PL.Vehicle.GetClosestVehicle(coords, maxDistance)
    local vehicles = GetGamePool('CVehicle')
    local closestVehicle, closestCoords
    maxDistance = maxDistance or 2.0

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(coords - vehicleCoords)

        if distance < maxDistance then
            maxDistance = distance
            closestVehicle = vehicle
            closestCoords = vehicleCoords
        end
    end

    return closestVehicle, closestCoords
end

return PL.Vehicle.GetClosestVehicle