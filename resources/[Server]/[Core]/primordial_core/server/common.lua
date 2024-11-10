PL.Players = {}
---@class SocietyGrade
---@field grade number The grade level within the society
---@field name string The internal name of the grade
---@field label string The display label of the grade
---@field salary number The salary associated with this grade
---@field isWhitelisted boolean Whether the grade is whitelisted

---@class Society
---@field id number The unique ID of the society
---@field name string The unique name identifier of the society
---@field label string The display label of the society
---@field registration_number string The society's registration number (SIRET)
---@field money number The total funds of the society
---@field iban string The IBAN for the society's bank account
---@field isWhitelisted boolean Whether the society is whitelisted
---@field grades table <string, SocietyGrade> The set of grades within the society

--- The table holding all societies keyed by their unique names.
---@type table<string, Society>
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
    PL.Items = exports['qs-inventory']:GetItemList()
    
    -- TriggerEvent("__cfx_export_ox_inventory_Items", function(ref)
    --     if ref then
    --         PL.Items = ref()
    --     end
    -- end)

    -- AddEventHandler("ox_inventory:itemList", function(items)
    --     PL.Items = items
    -- end)

    -- while not next(PL.Items) do
    --     Wait(0)
    -- end

    PL.InitSociety()

    print(("^5[%s - %s] ^2Framework initialized!"):format(GetResourceMetadata(GetCurrentResourceName(), "version", 0), GetCurrentResourceName()))

    StartDBSync()
    StartPayCheck()
end)
