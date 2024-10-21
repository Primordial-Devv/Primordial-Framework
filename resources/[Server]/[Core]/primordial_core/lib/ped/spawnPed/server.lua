--- Spawn a ped on the server side with a model, coords, heading, and a callback.
---@param model number|string The model of the ped to spawn.
---@param coords vector3 The coords to spawn the ped at (vector3).
---@param heading number The heading of the ped.
---@param cb function The callback function to return the network id of the ped.
function PL.Ped.SpawnPed(model, coords, heading, cb)
    if type(model) == "string" then
        model = joaat(model)
    end
    CreateThread(function()
        local entity = CreatePed(0, model, coords.x, coords.y, coords.z, heading, true, true)
        while not DoesEntityExist(entity) do
            Wait(50)
        end
        cb(NetworkGetNetworkIdFromEntity(entity))
    end)
end

return PL.Ped.SpawnPed