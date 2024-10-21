--- Spawn an object on the server side with a model, coords, heading, and a callback.
---@param model number|string The model of the object to spawn.
---@param coords vector3|table The coords to spawn the object at (vector3).
---@param heading number The heading of the object.
---@param cb function The callback function to return the network ID of the object.
function PL.Object.SpawnServerObject(model, coords, heading, cb)
    if type(model) == "string" then
        model = joaat(model)
    end
    local objectCoords = type(coords) == "vector3" and coords or vector3(coords.x, coords.y, coords.z)
    CreateThread(function()
        local entity = CreateObject(model, objectCoords, true, true)
        while not DoesEntityExist(entity) do
            Wait(50)
        end
        SetEntityHeading(entity, heading)
        cb(NetworkGetNetworkIdFromEntity(entity))
    end)
end

return PL.Object.SpawnServerObject