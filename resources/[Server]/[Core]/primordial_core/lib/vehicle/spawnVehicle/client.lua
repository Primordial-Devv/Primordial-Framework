--- Spawn a vehicle on the client side
---@param vehicleModel string|number The model name or hash of the vehicle to spawn
---@param coords vector3 The coordinates to spawn the vehicle at
---@param heading number The heading of the vehicle
---@param cb function A callback function to be called after the vehicle has been spawned
---@param networked boolean Whether the vehicle should be networked or not
function PL.Vehicle.SpawnClientVehicle(vehicleModel, coords, heading, cb, networked)
    local model = type(vehicleModel) == "number" and vehicleModel or joaat(vehicleModel)
    local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
    networked = networked == nil and true or networked

    local playerCoords = GetEntityCoords(PL.PlayerData.ped)
    if not vector or not playerCoords then
        return
    end

    local dist = #(playerCoords - vector)
    if dist > 424 then -- Onesync infinity Range (https://docs.fivem.net/docs/scripting-reference/onesync/)
        local executingResource = GetInvokingResource() or "Unknown"
        return PL.Print.Log(3, ("Resource ^1%s^5 Tried to spawn vehicle on the client but the position is too far away (Out of onesync range)."):format(executingResource))
    end

    CreateThread(function()
        PL.Streaming.RequestModel(model)

        local vehicle = CreateVehicle(model, vector.xyz, heading, networked, true)

        if networked then
            local id = NetworkGetNetworkIdFromEntity(vehicle)
            SetNetworkIdCanMigrate(id, true)
            SetEntityAsMissionEntity(vehicle, true, true)
        end
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetModelAsNoLongerNeeded(model)
        SetVehRadioStation(vehicle, "OFF")

        RequestCollisionAtCoord(vector.xyz)
        while not HasCollisionLoadedAroundEntity(vehicle) do
            Wait(0)
        end

        if cb then
            cb(vehicle)
        end
    end)
end

return PL.Vehicle.SpawnClientVehicle