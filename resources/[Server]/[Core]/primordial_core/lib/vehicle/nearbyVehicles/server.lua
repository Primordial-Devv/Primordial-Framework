--- Get nearby vehicles from the server side within a certain distance range from a set of coords.
---@param coords vector3 The coords to check from.
---@param maxDistance? number The max distance to check.
---@return { vehicle: number, coords: vector3 }[] nearby A list of nearby vehicles.
function PL.Vehicle.GetNearbyVehicles(coords, maxDistance)
    local vehicles = GetGamePool('CVehicle')
    local nearby = {}
    local count = 0
    maxDistance = maxDistance or 2.0

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(coords - vehicleCoords)

        if distance < maxDistance then
            count = count + 1
            nearby[count] = {
                vehicle = vehicle,
                coords = vehicleCoords
            }
        end
    end

    return nearby
end

return PL.Vehicle.GetServerNearbyVehicles