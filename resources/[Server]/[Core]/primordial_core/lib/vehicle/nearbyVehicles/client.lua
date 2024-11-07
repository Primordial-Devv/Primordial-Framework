--- Get the nearby vehicles to a set of coords within a certain distance range and optionally include the player's current vehicle.
---@param coords vector3 The coords to check from.
---@param maxDistance? number The max distance to check.
---@param includePlayerVehicle? boolean Whether or not to include the player's current vehicle.
---@return { vehicle: number, coords: vector3 }[] nearby A list of nearby vehicles.
function PL.Vehicle.GetNearbyVehicles(coords, maxDistance, includePlayerVehicle)
    local vehicles = GetGamePool('CVehicle')
    local nearby = {}
    local count = 0
    maxDistance = maxDistance or 2.0
    local playerVehicle = includePlayerVehicle and 0 or GetVehiclePedIsIn(PlayerPedId(), false)

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        if vehicle ~= playerVehicle then
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
    end

    return nearby
end

return PL.Vehicle.GetNearbyVehicles