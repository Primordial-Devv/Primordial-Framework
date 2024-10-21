--- Check if the spawn point is clear of vehicles
---@param coords vector3 The coordinates to check from
---@param maxDistance number The maximum distance to check for vehicles
---@return boolean isFree Whether the spawn point is clear
function PL.Vehicle.IsSpawnpointClear(coords, maxDistance)
    return #PL.Vehicle.GetClientNearbyVehicles(coords, maxDistance, true) == 0
end

return PL.Vehicle.IsSpawnpointClear