local isFuelEmpty = false
local isAlertShown = false
local alertTimer = 0
local fuelConsumptionEnabled = true

CreateThread(function()
    while true do
        Wait(1000)

        local player = cache.ped

        if IsPedInAnyVehicle(player, false) and fuelConsumptionEnabled then
            local playervehicle = GetVehiclePedIsIn(player, false)

            if GetPedInVehicleSeat(playervehicle, -1) == player then
                if DoesVehicleUseFuel(playervehicle) then
                    local vehicleClass = GetVehicleClass(playervehicle)
                    local tankMultiplier = VehicleClassFuelTankMultiplier[vehicleClass] or 1.0
                    local fuelTankCapacity = BasicFuelTankCapacity * tankMultiplier
                    local economyMultiplier = ClassFuelEconomy[vehicleClass] or 1.0

                    SetVehicleHandlingFloat(playervehicle, 'CHandlingData', 'fPetrolTankVolume', fuelTankCapacity)

                    local vehicleFuelLevel = GetVehicleFuelLevel(playervehicle)

                    if vehicleFuelLevel > 0 then
                        local vehicleSpeed = GetEntitySpeed(playervehicle) * 3.6
                        local fuelConsumptionRateMultiplier = vehicleSpeed / 100
                        local rpm = GetVehicleCurrentRpm(playervehicle)
                        local closestRpmKey = math.floor(rpm * 10) / 10
                        local rpmMultiplier = FuelUsagePerRPM[closestRpmKey] or 1.0
                        local adjustedFuelConsumptionRate = (FuelConsumptionLevelPerTick * fuelConsumptionRateMultiplier * economyMultiplier * rpmMultiplier) * (BasicFuelTankCapacity / fuelTankCapacity)
                        local newFuelLevel = vehicleFuelLevel - adjustedFuelConsumptionRate
                        local fuelPercentage = (newFuelLevel / fuelTankCapacity) * 100

                        if fuelPercentage < 15 and not isAlertShown then
                            alertTimer = alertTimer + 1

                            if alertTimer >= 10 then
                                local textureDict = 'custom_char_picture'
                                local textureName = 'custom_fuel_char_500'

                                PL.Streaming.RequestStreamedTextureDict(textureDict, 5000)
                                PL.Notification.ShowAdvancedNotification('WARNING', 'Low Fuel', string.format('Essence à %.2f%%', fuelPercentage), 41, false, true, textureDict, textureName, 1)
                                SetStreamedTextureDictAsNoLongerNeeded(textureDict)
                                alertTimer = 0
                                isAlertShown = true
                            end
                        elseif fuelPercentage >= 15 then
                            isAlertShown = false
                            alertTimer = 0
                        end

                        if newFuelLevel < 0 then
                            newFuelLevel = 0
                        end

                        SetVehicleFuelLevel(playervehicle, newFuelLevel)

                        if newFuelLevel <= 0 then
                            isFuelEmpty = true

                            if GetIsVehicleEngineRunning(playervehicle) then
                                SetVehicleEngineOn(playervehicle, false, true, true)
                            end
                        else
                            isFuelEmpty = false
                        end
                    else
                        isFuelEmpty = true

                        if GetIsVehicleEngineRunning(playervehicle) then
                            SetVehicleEngineOn(playervehicle, false, true, true)
                        end
                    end
                else
                    Wait(500)
                end
            end
        else
            Wait(1000)
        end

        if isFuelEmpty then
            local playerVehicle = GetVehiclePedIsIn(player, false)

            if GetVehicleFuelLevel(playerVehicle) == 0 and GetIsVehicleEngineRunning(playerVehicle) then
                SetVehicleEngineOn(playerVehicle, false, true, true)
            end
        end
    end
end)

function GetFuel(vehicle)
    if DoesEntityExist(vehicle) then
        return GetVehicleFuelLevel(vehicle)
    else
        return PL.Print.Log(3, false, 'Vehicle does not exist')
    end
end

function SetFuel(vehicle, fuelLevel)
    if DoesEntityExist(vehicle) then
        if fuelLevel < 0 then
            fuelLevel = 0
        end
        if fuelLevel > 100 then
            fuelLevel = 100
        end
        SetVehicleFuelLevel(vehicle, fuelLevel)
    else
        PL.Print.Log(3,false, 'Vehicle does not exist')
    end
end

function StopFuel()
    fuelConsumptionEnabled = false
    PL.Print.Log(1, false, 'Fuel consumption disabled.')
end

function StartFuel()
    fuelConsumptionEnabled = true
    PL.Print.Log(1, false, 'Fuel consumption enabled.')
end

function GetFuelConsumptionStatus()
    return fuelConsumptionEnabled
end

exports('GetFuel', GetFuel)
exports('SetFuel', SetFuel)
exports('StopFuel', StopFuel)
exports('StartFuel', StartFuel)
exports('GetFuelConsumptionStatus', GetFuelConsumptionStatus)