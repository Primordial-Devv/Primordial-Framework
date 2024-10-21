local hudPosX = 0.23
local hudPosY = 0.95
-- local hudPosY = 0.5
local hudWidth = 0.1
local hudHeight = 0.02
local hudBorderSize = 0.001
local textOffsetY = 0.05
local textOffsetX = 0.04

local function DrawHUDRectWithBorder(x, y, width, height, rectColor, borderColor, borderSize)
    DrawRect(x, y - (height / 2) - borderSize, width + 2 * borderSize, borderSize, borderColor[1], borderColor[2], borderColor[3], borderColor[4]) -- Bordure du haut
    DrawRect(x, y + (height / 2) + borderSize, width + 2 * borderSize, borderSize, borderColor[1], borderColor[2], borderColor[3], borderColor[4]) -- Bordure du bas
    DrawRect(x - (width / 2) - borderSize, y, borderSize, height, borderColor[1], borderColor[2], borderColor[3], borderColor[4]) -- Bordure de gauche
    DrawRect(x + (width / 2) + borderSize, y, borderSize, height, borderColor[1], borderColor[2], borderColor[3], borderColor[4]) -- Bordure de droite

    DrawRect(x, y, width, height, rectColor[1], rectColor[2], rectColor[3], rectColor[4])
end

local function DrawFuelLevel(x, y, width, height, fuelPercent)
    local fuelWidth = width * fuelPercent
    local adjustedX = x - (width / 2) + (fuelWidth / 2)
    DrawRect(adjustedX, y, fuelWidth, height, 255, 0, 0, 200)
end

CreateThread(function()
    while true do
        local player = cache.ped
        local isPlayerInVehicle = IsPedInAnyVehicle(player, false)

        if isPlayerInVehicle then
            DisplayRadar(true)

            local vehicle = GetVehiclePedIsIn(player, false)
            if DoesVehicleUseFuel(vehicle) then

                while IsPedInAnyVehicle(player, false) do
                    local fuelLevel = GetVehicleFuelLevel(vehicle)
                    local fuelPercent = fuelLevel / 100
                    local fuelText = string.format("Fuel %.2f %%", fuelLevel)

                    DrawHUDRectWithBorder(hudPosX, hudPosY, hudWidth, hudHeight, {255, 255, 255, 0}, {255, 255, 255, 255}, hudBorderSize)

                    DrawFuelLevel(hudPosX, hudPosY, hudWidth, hudHeight, fuelPercent)

                    PL.Utils.DrawText2D(hudPosX - textOffsetX, hudPosY - textOffsetY, fuelText, 0.35, 0)

                    Wait(0)
                end
            else
                break
            end
        else
            DisplayRadar(false)
        end

        Wait(500)
    end
end)