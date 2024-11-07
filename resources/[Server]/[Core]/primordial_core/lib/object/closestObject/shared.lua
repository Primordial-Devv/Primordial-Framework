--- Get the closest object to a set of coords within a certain distance range.
---@param coords vector3 The coords to check from.
---@param maxDistance? number The max distance to check.
---@return number? closestObject The closest object entity.
---@return vector3? closestCoords The coords of the closest object entity
function PL.Object.GetClosestObject(coords, maxDistance)
    local objects = GetGamePool('CObject')
    local closestObject, closestCoords
    maxDistance = maxDistance or 2.0

    for i = 1, #objects do
        local object = objects[i]
        local objectCoords = GetEntityCoords(object)
        local distance = #(coords - objectCoords)

        if distance < maxDistance then
            maxDistance = distance
            closestObject = object
            closestCoords = objectCoords
        end
    end

    return closestObject, closestCoords
end

return PL.Object.GetClosestObject