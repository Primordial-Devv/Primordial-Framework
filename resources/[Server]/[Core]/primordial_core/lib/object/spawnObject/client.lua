--- Spawn an object in the world at the specified coordinates
---@param object string|number The object name or hash
---@param coords vector3 The coordinates to spawn the object at
---@param cb function The callback function to execute after the object has been spawned
---@param networked boolean Whether the object should be networked or not
function PL.Object.SpawnClientObject(object, coords, cb, networked)
    networked = networked == nil and true or networked

    local model = type(object) == "number" and object or joaat(object)
    local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
    CreateThread(function()
        PL.Streaming.RequestModel(model)

        local obj = CreateObject(model, vector.xyz, networked, false, true)
        if cb then
            cb(obj)
        end
    end)
end

return PL.Object.SpawnClientObject