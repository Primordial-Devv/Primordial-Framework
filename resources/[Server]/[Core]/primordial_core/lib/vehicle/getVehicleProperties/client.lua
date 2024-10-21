---@class VehicleProperties
---@field model? number
---@field plate? string
---@field plateIndex? number
---@field bodyHealth? number
---@field engineHealth? number
---@field tankHealth? number
---@field fuelLevel? number
---@field oilLevel? number
---@field dirtLevel? number
---@field paintType1? number
---@field paintType2? number
---@field color1? number | number[]
---@field color2? number | number[]
---@field pearlescentColor? number
---@field interiorColor? number
---@field dashboardColor? number
---@field wheelColor? number
---@field wheelWidth? number
---@field wheelSize? number
---@field wheels? number
---@field windowTint? number
---@field xenonColor? number
---@field neonEnabled? boolean[]
---@field neonColor? number | number[]
---@field extras? table<number | string, 0 | 1>
---@field tyreSmokeColor? number | number[]
---@field modSpoilers? number
---@field modFrontBumper? number
---@field modRearBumper? number
---@field modSideSkirt? number
---@field modExhaust? number
---@field modFrame? number
---@field modGrille? number
---@field modHood? number
---@field modFender? number
---@field modRightFender? number
---@field modRoof? number
---@field modEngine? number
---@field modBrakes? number
---@field modTransmission? number
---@field modHorns? number
---@field modSuspension? number
---@field modArmor? number
---@field modNitrous? number
---@field modTurbo? boolean
---@field modSubwoofer? boolean
---@field modSmokeEnabled? boolean
---@field modHydraulics? boolean
---@field modXenon? boolean
---@field modFrontWheels? number
---@field modBackWheels? number
---@field modCustomTiresF? boolean
---@field modCustomTiresR? boolean
---@field modPlateHolder? number
---@field modVanityPlate? number
---@field modTrimA? number
---@field modOrnaments? number
---@field modDashboard? number
---@field modDial? number
---@field modDoorSpeaker? number
---@field modSeats? number
---@field modSteeringWheel? number
---@field modShifterLeavers? number
---@field modAPlate? number
---@field modSpeakers? number
---@field modTrunk? number
---@field modHydrolic? number
---@field modEngineBlock? number
---@field modAirFilter? number
---@field modStruts? number
---@field modArchCover? number
---@field modAerials? number
---@field modTrimB? number
---@field modTank? number
---@field modWindows? number
---@field modDoorR? number
---@field modLivery? number
---@field modRoofLivery? number
---@field modLightbar? number
---@field windows? number[]
---@field doors? number[]
---@field tyres? table<number | string, 1 | 2>
---@field bulletProofTyres? boolean
---@field driftTyres? boolean

local gameBuild = GetGameBuildNumber()

---@param vehicle number
---@return VehicleProperties?
function PL.Vehicle.GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        ---@type number | number[], number | number[]
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        local paintType1 = GetVehicleModColor_1(vehicle)
        local paintType2 = GetVehicleModColor_2(vehicle)

        if GetIsVehiclePrimaryColourCustom(vehicle) then
            colorPrimary = { GetVehicleCustomPrimaryColour(vehicle) }
        end

        if GetIsVehicleSecondaryColourCustom(vehicle) then
            colorSecondary = { GetVehicleCustomSecondaryColour(vehicle) }
        end

        local extras = {}

        for i = 1, 15 do
            if DoesExtraExist(vehicle, i) then
                extras[i] = IsVehicleExtraTurnedOn(vehicle, i) and 0 or 1
            end
        end

        local modLiveryCount = GetVehicleLiveryCount(vehicle)
        local modLivery = GetVehicleLivery(vehicle)

        if modLiveryCount == -1 or modLivery == -1 then
            modLivery = GetVehicleMod(vehicle, 48)
        end

        local damage = {
            windows = {},
            doors = {},
            tyres = {},
        }

        local windows = 0

        for i = 0, 7 do
            RollUpWindow(vehicle, i)

            if not IsVehicleWindowIntact(vehicle, i) then
                windows += 1
                damage.windows[windows] = i
            end
        end

        local doors = 0

        for i = 0, 5 do
            if IsVehicleDoorDamaged(vehicle, i) then
                doors += 1
                damage.doors[doors] = i
            end
        end

        for i = 0, 7 do
            if IsVehicleTyreBurst(vehicle, i, false) then
                damage.tyres[i] = IsVehicleTyreBurst(vehicle, i, true) and 2 or 1
            end
        end

        local neons = {}

        for i = 0, 3 do
            neons[i + 1] = IsVehicleNeonLightEnabled(vehicle, i)
        end

        return {
            model = GetEntityModel(vehicle),
            plate = GetVehicleNumberPlateText(vehicle),
            plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
            bodyHealth = math.floor(GetVehicleBodyHealth(vehicle) + 0.5),
            engineHealth = math.floor(GetVehicleEngineHealth(vehicle) + 0.5),
            tankHealth = math.floor(GetVehiclePetrolTankHealth(vehicle) + 0.5),
            fuelLevel = math.floor(GetVehicleFuelLevel(vehicle) + 0.5),
            oilLevel = math.floor(GetVehicleOilLevel(vehicle) + 0.5),
            dirtLevel = math.floor(GetVehicleDirtLevel(vehicle) + 0.5),
            paintType1 = paintType1,
            paintType2 = paintType2,
            color1 = colorPrimary,
            color2 = colorSecondary,
            pearlescentColor = pearlescentColor,
            interiorColor = GetVehicleInteriorColor(vehicle),
            dashboardColor = GetVehicleDashboardColour(vehicle),
            wheelColor = wheelColor,
            wheelWidth = GetVehicleWheelWidth(vehicle),
            wheelSize = GetVehicleWheelSize(vehicle),
            wheels = GetVehicleWheelType(vehicle),
            windowTint = GetVehicleWindowTint(vehicle),
            xenonColor = GetVehicleXenonLightsColor(vehicle),
            neonEnabled = neons,
            neonColor = { GetVehicleNeonLightsColour(vehicle) },
            extras = extras,
            tyreSmokeColor = { GetVehicleTyreSmokeColor(vehicle) },
            modSpoilers = GetVehicleMod(vehicle, 0),
            modFrontBumper = GetVehicleMod(vehicle, 1),
            modRearBumper = GetVehicleMod(vehicle, 2),
            modSideSkirt = GetVehicleMod(vehicle, 3),
            modExhaust = GetVehicleMod(vehicle, 4),
            modFrame = GetVehicleMod(vehicle, 5),
            modGrille = GetVehicleMod(vehicle, 6),
            modHood = GetVehicleMod(vehicle, 7),
            modFender = GetVehicleMod(vehicle, 8),
            modRightFender = GetVehicleMod(vehicle, 9),
            modRoof = GetVehicleMod(vehicle, 10),
            modEngine = GetVehicleMod(vehicle, 11),
            modBrakes = GetVehicleMod(vehicle, 12),
            modTransmission = GetVehicleMod(vehicle, 13),
            modHorns = GetVehicleMod(vehicle, 14),
            modSuspension = GetVehicleMod(vehicle, 15),
            modArmor = GetVehicleMod(vehicle, 16),
            modNitrous = GetVehicleMod(vehicle, 17),
            modTurbo = IsToggleModOn(vehicle, 18),
            modSubwoofer = GetVehicleMod(vehicle, 19),
            modSmokeEnabled = IsToggleModOn(vehicle, 20),
            modHydraulics = IsToggleModOn(vehicle, 21),
            modXenon = IsToggleModOn(vehicle, 22),
            modFrontWheels = GetVehicleMod(vehicle, 23),
            modBackWheels = GetVehicleMod(vehicle, 24),
            modCustomTiresF = GetVehicleModVariation(vehicle, 23),
            modCustomTiresR = GetVehicleModVariation(vehicle, 24),
            modPlateHolder = GetVehicleMod(vehicle, 25),
            modVanityPlate = GetVehicleMod(vehicle, 26),
            modTrimA = GetVehicleMod(vehicle, 27),
            modOrnaments = GetVehicleMod(vehicle, 28),
            modDashboard = GetVehicleMod(vehicle, 29),
            modDial = GetVehicleMod(vehicle, 30),
            modDoorSpeaker = GetVehicleMod(vehicle, 31),
            modSeats = GetVehicleMod(vehicle, 32),
            modSteeringWheel = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate = GetVehicleMod(vehicle, 35),
            modSpeakers = GetVehicleMod(vehicle, 36),
            modTrunk = GetVehicleMod(vehicle, 37),
            modHydrolic = GetVehicleMod(vehicle, 38),
            modEngineBlock = GetVehicleMod(vehicle, 39),
            modAirFilter = GetVehicleMod(vehicle, 40),
            modStruts = GetVehicleMod(vehicle, 41),
            modArchCover = GetVehicleMod(vehicle, 42),
            modAerials = GetVehicleMod(vehicle, 43),
            modTrimB = GetVehicleMod(vehicle, 44),
            modTank = GetVehicleMod(vehicle, 45),
            modWindows = GetVehicleMod(vehicle, 46),
            modDoorR = GetVehicleMod(vehicle, 47),
            modLivery = modLivery,
            modRoofLivery = GetVehicleRoofLivery(vehicle),
            modLightbar = GetVehicleMod(vehicle, 49),
            windows = damage.windows,
            doors = damage.doors,
            tyres = damage.tyres,
            bulletProofTyres = GetVehicleTyresCanBurst(vehicle),
            driftTyres = gameBuild >= 2372 and GetDriftTyresEnabled(vehicle),
            -- no setters?
            -- leftHeadlight = GetIsLeftVehicleHeadlightDamaged(vehicle),
            -- rightHeadlight = GetIsRightVehicleHeadlightDamaged(vehicle),
            -- frontBumper = IsVehicleBumperBrokenOff(vehicle, true),
            -- rearBumper = IsVehicleBumperBrokenOff(vehicle, false),
        }
    end
end

return PL.Vehicle.GetVehicleProperties