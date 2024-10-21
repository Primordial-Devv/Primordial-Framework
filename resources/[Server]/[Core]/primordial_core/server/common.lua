PL.Players = {}
PL.Jobs = {}
PL.JobsPlayerCount = {}
PL.Items = {}
PL.UsableItemsCallbacks = {}
PL.RegisteredCommands = {}
PL.DatabaseConnected = false
PL.playersByIdentifier = {}
PL.vehicleTypesByModel = {}

PL.Object = {}

PL.Ped = {}

PL.Player = {}

PL.Vehicle = {}

PL.Discord = {}

PL.Notification = {}

PL.Utils = {}

SetMapName("San Andreas")
SetGameType("Primordial Framework")

RegisterNetEvent("primordial_core:onPlayerSpawn", function()
    PL.Players[source].spawned = true
end)

local function StartDBSync()
    CreateThread(function()
        local interval <const> = 10 * 60 * 1000
        while true do
            Wait(interval)
            PL.SavePlayers()
        end
    end)
end

MySQL.ready(function()
    PL.DatabaseConnected = true
    TriggerEvent("__cfx_export_ox_inventory_Items", function(ref)
        if ref then
            PL.Items = ref()
        end
    end)

    AddEventHandler("ox_inventory:itemList", function(items)
        PL.Items = items
    end)

    while not next(PL.Items) do
        Wait(0)
    end

    PL.RefreshJobs()

    print(("^5[%s - %s] ^2Framework initialized!"):format(GetResourceMetadata(GetCurrentResourceName(), "version", 0), GetCurrentResourceName()))

    StartDBSync()
    StartPayCheck()
end)
