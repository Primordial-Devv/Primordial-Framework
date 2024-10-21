RegisterServerEvent("primordial_core:playerPedChanged")
RegisterServerEvent("primordial_core:enteringVehicle")
RegisterServerEvent("primordial_core:enteringVehicleAborted")
RegisterServerEvent("primordial_core:enteredVehicle")
RegisterServerEvent("primordial_core:exitedVehicle")

if EnableDebug then
    AddEventHandler("primordial_core:playerPedChanged", function(netId)
        PL.Print.Debug("primordial_core:playerPedChanged", source, netId)
    end)

    AddEventHandler("primordial_core:enteringVehicle", function(plate, seat, netId)
        PL.Print.Debug("primordial_core:enteringVehicle", "source", source, "plate", plate, "seat", seat, "netId", netId)
    end)

    AddEventHandler("primordial_core:enteringVehicleAborted", function()
        PL.Print.Debug("primordial_core:enteringVehicleAborted", source)
    end)

    AddEventHandler("primordial_core:enteredVehicle", function(plate, seat, displayName, netId)
        PL.Print.Debug("primordial_core:enteredVehicle", "source", source, "plate", plate, "seat", seat, "displayName", displayName, "netId", netId)
    end)

    AddEventHandler("primordial_core:exitedVehicle", function(plate, seat, displayName, netId)
        PL.Print.Debug("primordial_core:exitedVehicle", "source", source, "plate", plate, "seat", seat, "displayName", displayName, "netId", netId)
    end)
end
