--- Spawn a specified ped model in a vehicle at a specified seat.
---@param model number|string The model of the ped to spawn.
---@param vehicle number The vehicle to spawn the ped in.
---@param seat number The seat to spawn the ped in.
---@param cb function The callback function to return the network id of the ped.
function PL.Ped.SpawnPedInVehicle(model, vehicle, seat, cb)
    if type(model) == "string" then
        model = joaat(model)
    end
    CreateThread(function()
        local entity = CreatePedInsideVehicle(vehicle, 1, model, seat, true, true)
        while not DoesEntityExist(entity) do
            Wait(50)
        end
        cb(NetworkGetNetworkIdFromEntity(entity))
    end)
end

return PL.Ped.SpawnPedInVehicle