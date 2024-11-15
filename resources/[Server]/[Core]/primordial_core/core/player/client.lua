PL.PlayerLoaded = false

--- Check if the player is loaded into the server
---@return boolean IsPlayerLoaded Whether the player is loaded
function PL.IsPlayerLoaded()
    return PL.PlayerLoaded
end

--- Get the player's data
---@return table PlayerData The player's data
function PL.GetPlayerData()
    return PL.PlayerData
end

--- Check if the player is in a society and optionally check the grade
---@param societyName string
---@param societyGrade? string | string[]
---@return boolean IsInSociety Whether the player is in the society
function PL.PlayerIsInSociety(societyName, societyGrade)
    local data <const> = PL.PlayerData;
    local society <const> = data.society;
    if (society and society.name == societyName) then
        if (societyGrade) then
            if (type(societyGrade) == "table") then
                for i = 1, #societyGrade do
                    if society.grade_name == societyGrade[i] then
                        return true;
                    end
                end
                return false;
            end
            return society.grade_name == societyGrade
        end
        return true;
    end
    return false;
end

--- Set the player's data
---@param key string The key to set
---@param val any The value to set
function PL.SetPlayerData(key, val)
    local current = PL.PlayerData[key]
    PL.PlayerData[key] = val
    if key ~= "inventory" and key ~= "loadout" and key ~= "coords" then
        if type(val) == "table" or val ~= current then
            TriggerEvent("primordial_core:setPlayerData", key, val, current)
        end
    end
end

RegisterNetEvent("primordial_core:client:updateMetadata")
AddEventHandler("primordial_core:client:updateMetadata", function(metadata)
    for key, val in pairs(metadata) do
        PL.SetPlayerData(key, val)
    end
end)

RegisterNetEvent("primordial_core:playerLoaded")
AddEventHandler("primordial_core:playerLoaded", function(sPlayer, _, skin)
    PL.PlayerData = sPlayer

    PL.SpawnPlayer(skin, PL.PlayerData.coords, function()
        TriggerEvent("primordial_core:onPlayerSpawn")
        TriggerEvent("primordial_core:client:restoreLoadout")
        TriggerServerEvent("primordial_core:onPlayerSpawn")
        TriggerEvent("primordial_core:client:loadingScreenOff")
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    end)

    while not DoesEntityExist(PL.PlayerData.ped) do
        Wait(20)
    end

    PL.PlayerLoaded = true

    local metadata = PL.PlayerData.metadata

    if metadata.health then
        SetEntityHealth(PL.PlayerData.ped, metadata.health)
    end

    if metadata.armor and metadata.armor > 0 then
        SetPedArmour(PL.PlayerData.ped, metadata.armor)
    end

    local timer = GetGameTimer()
    while not HaveAllStreamingRequestsCompleted(PL.PlayerData.ped) and (GetGameTimer() - timer) < 2000 do
        Wait(0)
    end

    -- Enable PVP between players
    SetCanAttackFriendly(PL.PlayerData.ped, true, false)
    NetworkSetFriendlyFireOption(true)

    local playerId = PlayerId()

    -- Disable NPC Drops
    local weaponPickups = { `PICKUP_WEAPON_CARBINERIFLE`, `PICKUP_WEAPON_PISTOL`, `PICKUP_WEAPON_PUMPSHOTGUN` }
    for i = 1, #weaponPickups do
        ToggleUsePickupsForPlayer(playerId, weaponPickups[i], false)
    end

    SetPlayerHealthRechargeMultiplier(playerId, 0.0)

    -- Disable Dispatch services
    for i = 1, 15 do
        EnableDispatchService(i, false)
    end

    -- Disable Scenarios
    local scenarios = {
        "WORLD_VEHICLE_ATTRACTOR",
        "WORLD_VEHICLE_AMBULANCE",
        "WORLD_VEHICLE_BICYCLE_BMX",
        "WORLD_VEHICLE_BICYCLE_BMX_BALLAS",
        "WORLD_VEHICLE_BICYCLE_BMX_FAMILY",
        "WORLD_VEHICLE_BICYCLE_BMX_HARMONY",
        "WORLD_VEHICLE_BICYCLE_BMX_VAGOS",
        "WORLD_VEHICLE_BICYCLE_MOUNTAIN",
        "WORLD_VEHICLE_BICYCLE_ROAD",
        "WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",
        "WORLD_VEHICLE_BIKER",
        "WORLD_VEHICLE_BOAT_IDLE",
        "WORLD_VEHICLE_BOAT_IDLE_ALAMO",
        "WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
        "WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
        "WORLD_VEHICLE_BROKEN_DOWN",
        "WORLD_VEHICLE_BUSINESSMEN",
        "WORLD_VEHICLE_HELI_LIFEGUARD",
        "WORLD_VEHICLE_CLUCKIN_BELL_TRAILER",
        "WORLD_VEHICLE_CONSTRUCTION_SOLO",
        "WORLD_VEHICLE_CONSTRUCTION_PASSENGERS",
        "WORLD_VEHICLE_DRIVE_PASSENGERS",
        "WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED",
        "WORLD_VEHICLE_DRIVE_SOLO",
        "WORLD_VEHICLE_FIRE_TRUCK",
        "WORLD_VEHICLE_EMPTY",
        "WORLD_VEHICLE_MARIACHI",
        "WORLD_VEHICLE_MECHANIC",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_PARK_PARALLEL",
        "WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN",
        "WORLD_VEHICLE_PASSENGER_EXIT",
        "WORLD_VEHICLE_POLICE_BIKE",
        "WORLD_VEHICLE_POLICE_CAR",
        "WORLD_VEHICLE_POLICE",
        "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
        "WORLD_VEHICLE_QUARRY",
        "WORLD_VEHICLE_SALTON",
        "WORLD_VEHICLE_SALTON_DIRT_BIKE",
        "WORLD_VEHICLE_SECURITY_CAR",
        "WORLD_VEHICLE_STREETRACE",
        "WORLD_VEHICLE_TOURBUS",
        "WORLD_VEHICLE_TOURIST",
        "WORLD_VEHICLE_TANDL",
        "WORLD_VEHICLE_TRACTOR",
        "WORLD_VEHICLE_TRACTOR_BEACH",
        "WORLD_VEHICLE_TRUCK_LOGS",
        "WORLD_VEHICLE_TRUCKS_TRAILERS",
        "WORLD_VEHICLE_DISTANT_EMPTY_GROUND",
        "WORLD_HUMAN_PAPARAZZI",
    }

    for _, v in pairs(scenarios) do
        SetScenarioTypeEnabled(v, false)
    end

    if IsScreenFadedOut() then
        DoScreenFadeIn(500)
    end

    SetDefaultVehicleNumberPlateTextPattern(-1, "........")
end)

RegisterNetEvent("primordial_core:onPlayerLogout")
AddEventHandler("primordial_core:onPlayerLogout", function()
    PL.PlayerLoaded = false
end)