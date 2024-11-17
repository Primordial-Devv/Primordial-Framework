--- Spawn a vehicle on the server side with a specific model, coords, heading, properties, and callback.
---@param model number|string The model of the vehicle to spawn.
---@param coords vector3 The coords to spawn the vehicle at.
---@param heading number The heading of the vehicle.
---@param properties table The properties of the vehicle.
---@param cb function The callback function to return the network id of the vehicle.
function PL.Vehicle.SpawnServerVehicle(model, coords, heading, properties, cb)
    local vehicleModel = joaat(model)
    local vehicleProperties = properties

    CreateThread(function()
        local closestId = PL.Player.GetClosestPlayer(coords, 300)
        if closestId then
            PL.Vehicle.GetVehicleType(vehicleModel, closestId, function(vehicleType)
                if vehicleType then
                    local createdVehicle = CreateVehicleServerSetter(vehicleModel, vehicleType, coords, heading)
                    if not DoesEntityExist(createdVehicle) then
                        PL.Print.Log(3, "Unfortunately, this vehicle has not spawned")
                    end

                    local networkId = NetworkGetNetworkIdFromEntity(createdVehicle)
                    TriggerClientEvent("primordial_core:client:SetVehicleProperties", -1, networkId, vehicleProperties)
                    cb(networkId)
                else
                    PL.Print.Log(3, ("Tried to spawn invalid vehicle - %s!"):format(model))
                end
            end)
        else
            PL.Print.Log(3, "No players found nearby to spawn the vehicle")
        end
    end)
end

return PL.Vehicle.SpawnServerVehicle