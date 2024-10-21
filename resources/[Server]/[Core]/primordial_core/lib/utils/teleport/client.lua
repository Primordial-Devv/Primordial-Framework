--- Teleport an entity to the specified coordinates and heading.
---@param entity string | number The entity to teleport.
---@param coords vector4 The coordinates to teleport to.
---@param cb function The callback to execute after teleporting.
function PL.Utils.Teleport(entity, coords, cb)
    local vector = type(coords) == "vector4" and coords

    if DoesEntityExist(entity) then
        RequestCollisionAtCoord(vector.xyz)
        while not HasCollisionLoadedAroundEntity(entity) do
            Wait(0)
        end

        SetEntityCoords(entity, vector.xyz, false, false, false, false)
        SetEntityHeading(entity, vector.w)
    end

    if cb then
        cb()
    end
end

return PL.Utils.Teleport