local nearestStationBlip = nil
local pumpBlips = {}
local stationTransitionActive = false
local closestStation = nil

local function AddBlipForStation(coords)
    Debug("Adding blip for fuel station at coords", coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 361)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Fuel Station')
    EndTextCommandSetBlipName(blip)

    return blip
end

local function AddBlipForPump(coords)
    Debug("Adding blip for fuel pump at coords", coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 361)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.6)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Fuel Pump')
    EndTextCommandSetBlipName(blip)

    return blip
end

local function CreatePumpBlips(stationCoords)
    Debug("Creating pump blips for station", stationCoords)
    for _, blip in pairs(pumpBlips) do
        RemoveBlip(blip)
    end
    pumpBlips = {}

    for _, pumpCoords in ipairs(FuelStations[stationCoords]) do
        local blip = AddBlipForPump(pumpCoords)
        table.insert(pumpBlips, blip)
    end
end

local function RemovePumpBlips()
    Debug("Removing pump blips")
    for _, blip in pairs(pumpBlips) do
        RemoveBlip(blip)
    end
    pumpBlips = {}
end

local function ManageStationAndPumpBlips()
    Debug("Starting station and pump blip management")
    CreateThread(function()
        while stationTransitionActive do
            Wait(2000)

            local playerPed = cache.ped
            local playerCoords = GetEntityCoords(playerPed)

            if closestStation then
                local closestDistance = #(playerCoords - closestStation)
                Debug("Player distance from station", closestDistance)

                -- Transition logic
                if closestDistance <= 30.0 then
                    Debug("Player within 30.0 units, showing pump blips")
                    if nearestStationBlip then
                        RemoveBlip(nearestStationBlip)
                        nearestStationBlip = nil
                    end
                    CreatePumpBlips(closestStation) -- Appel à la fonction qui crée les blips des pompes
                elseif closestDistance <= BlipDisplayDistance then
                    Debug("Player within blip display distance, showing station blip")
                    RemovePumpBlips() -- On supprime les blips des pompes avant d'ajouter celui de la station
                    if not nearestStationBlip then
                        nearestStationBlip = AddBlipForStation(closestStation)
                    end
                else
                    Debug("Player too far from station, clearing blips")
                    if nearestStationBlip then
                        RemoveBlip(nearestStationBlip)
                        nearestStationBlip = nil
                    end

                    RemovePumpBlips()

                    stationTransitionActive = false
                end
            else
                stationTransitionActive = false
                Debug("No station found near player, stopping transition")
            end
        end
    end)
end

local function UpdateClosestStation()
    Debug("Starting closest station search")
    CreateThread(function()
        while true do
            Wait(5000)

            local playerPed = cache.ped
            local playerCoords = GetEntityCoords(playerPed)
            local closestDistance = math.huge
            local foundStation = false

            Debug("Checking distances to all stations")

            for stationCoords, _ in pairs(FuelStations) do
                local distance = #(playerCoords - stationCoords)
                Debug(("Distance to station at %s: %s"):format(tostring(stationCoords), distance))

                if distance < closestDistance then
                    closestDistance = distance
                    closestStation = stationCoords
                    foundStation = true
                end
            end

            if foundStation and closestDistance <= BlipDisplayDistance and not stationTransitionActive then
                Debug("Station found within display distance, starting transition management")
                stationTransitionActive = true
                ManageStationAndPumpBlips()
            end
        end
    end)
end

CreateThread(function()
    Debug("Fuel station script started")
    UpdateClosestStation()
end)