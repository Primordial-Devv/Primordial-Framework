-- Disable GTA Online wanted level ( 0 stars - 5 stars )
ClearPlayerWantedLevel(PlayerId())
SetMaxWantedLevel(0)

lib.callback.register('primordial_core:client:GetVehicleType', function(model)
    return PL.Vehicle.GetClientVehicleType(model)
end)