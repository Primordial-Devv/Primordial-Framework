local doorLocked = false
local torqueLoop, breakLoop

local function HexToRgb(hex)
    hex = hex:gsub("#", "")
    return {
        tonumber("0x" .. hex:sub(1, 2)),
        tonumber("0x" .. hex:sub(3, 4)),
        tonumber("0x" .. hex:sub(5, 6))
    }
end

local function SpawnVehicle()
    local vehicleDialog = lib.inputDialog(Translations.vehicle_options_spawn_title, {
        {
            type = 'input',
            label = Translations.vehicle_sapwn_name_label,
            placeholder = Translations.vehicle_sapwn_name_placeholder,
            required = true,
        },
        {
            type = 'input',
            label = Translations.vehicle_spawn_plate_name_label,
            placeholder = Translations.vehicle_spawn_plate_name_placeholder,
            default = 'ADMIN',
        },
        {
            type = 'color',
            label = Translations.vehicle_spawn_primary_color_label,
            default = '#ffffff',
        },
        {
            type = 'color',
            label = Translations.vehicle_spawn_secondary_color_label,
            default = '#ffffff',
        },
        {
            type = 'checkbox',
            label = Translations.vehicle_spawn_maxed_label,
            checked = false,
        },
    })

    if not vehicleDialog then return end    

    local primaryColor = HexToRgb(vehicleDialog[3])
    local secondaryColor = HexToRgb(vehicleDialog[4])
    local player = cache.ped
    local playerCoords = GetEntityCoords(player)
    local playerHeading = GetEntityHeading(player)

    PL.Streaming.RequestModel(vehicleDialog[1], 350)
    if IsPedInAnyVehicle(player, false) then
        local currentVehicle = GetVehiclePedIsIn(player, false)
        DeleteEntity(currentVehicle)
    end

    local vehicle = CreateVehicle(vehicleDialog[1], playerCoords.x, playerCoords.y, playerCoords.z, playerHeading, true, true)

    PL.Vehicle.SetVehicleProperties(vehicle, {
        plate = tostring(vehicleDialog[2]),
    })

    PL.Vehicle.SetVehicleProperties(vehicle, {
        color1 = {
            primaryColor[1],
            primaryColor[2],
            primaryColor[3],
        },
        color2 = {
            secondaryColor[1],
            secondaryColor[2],
            secondaryColor[3],
        },
        dirtLevel = 0.0,
    })

    if vehicleDialog[5] then
        PL.Vehicle.SetVehicleProperties(vehicle, {
            modTurbo = vehicleDialog[5],
        })
    end

    exports['primordial_fuel']:SetFuel(vehicle, 80.0)
    local plate = GetVehicleNumberPlateText(vehicle)

    TaskWarpPedIntoVehicle(player, vehicle, -1)
    PL.Print.Log(3, 'Need key system to be setup')
    SetModelAsNoLongerNeeded(vehicle)
end

local function RepairVehicle()
    local player = cache.ped
    if IsPedInAnyVehicle(player, false) then
        local currentVehicle = GetVehiclePedIsIn(player, false)
        SetVehicleUndriveable(currentVehicle, false)
        SetVehicleFixed(currentVehicle)
        SetVehicleEngineOn(currentVehicle, true, true, false)
        SetVehicleDirtLevel(currentVehicle, 0.0)
        exports['primordial_fuel']:SetFuel(currentVehicle, 70.0)
    else
        lib.notify({
            title = Translations.notfy_vehicle_repair_error,
            type = 'error',
        })
    end
end

local function DeleteVehicle()
    local player = cache.ped
    if IsPedInAnyVehicle(player, false) then
        local currentVehicle = GetVehiclePedIsIn(player, false)
        SetEntityAsMissionEntity(currentVehicle, true, true)
        DeleteEntity(currentVehicle)
    else
        lib.notify({
            title = Translations.notfy_vehicle_delete_error,
            type = 'error',
        })
    end
end

local function FlipVehicle()
    local player = cache.ped
    if IsPedInAnyVehicle(player, false) then
        local currentVehicle = GetVehiclePedIsIn(player, false)
        local vehicleAxis = GetEntityRoll(currentVehicle)

        if vehicleAxis ~= 0.0 then
            SetEntityRotation(currentVehicle, 0.0, 0.0, 0.0, 0, true)
        else
            lib.notify({
                title = Translations.notify_vehicle_already_upright,
                type = 'error',
            })
        end
    else
        lib.notify({
            title = Translations.notfy_vehicle_flip_error,
            type = 'error',
        })
    end
end

local function ChangePlate()
    local player = cache.ped
    if IsPedInAnyVehicle(player, false) then
        local currentVehicle = GetVehiclePedIsIn(player, false)
        local currentVehiclePlate = GetVehicleNumberPlateText(currentVehicle)
        local plateInput = lib.inputDialog(Translations.vehicle_options_change_plate_title, {
            {
                type ='input',
                label = Translations.vehicle_change_plate_name_label,
                default = currentVehiclePlate,
                required = true,
            }
        })
        if not plateInput then
            return PL.Print.Log(3, 'No plate input')
        end
        PL.Vehicle.SetVehicleProperties(currentVehicle, {
            plate = tostring(plateInput[1]),
        })
    else
        lib.notify({
            title = Translations.notfy_vehicle_change_plate_error,
            type = 'error',
        })
    end
end

local function RefuelVehicle()
    local player = cache.ped
    if IsPedInAnyVehicle(player, false) then
        local currentVehicle = GetVehiclePedIsIn(player, false)
        exports['primordial_fuel']:SetFuel(currentVehicle, 100.0)
    else
        lib.notify({
            title = Translations.notfy_vehicle_refuel_error,
            type = 'error',
        })
    end
end

local function LockDoors()
    local player = cache.ped
    local playerCoords = GetEntityCoords(player)
    local closestvehicle = PL.Vehicle.GetClientClosestVehicle(playerCoords, 5.0, true)

    if not closestvehicle or not DoesEntityExist(closestvehicle) then
        return lib.notify({
            title = Translations.notify_vehicle_doors_closest_error,
            type = 'error',
        })
    end

    doorLocked = not doorLocked
    if doorLocked then
        SetVehicleDoorsLocked(closestvehicle, 2)
        lib.notify({
            title = Translations.notify_vehicle_doors_locked,
            type = 'success',
        })
    else
        SetVehicleDoorsLocked(closestvehicle, 1)
        lib.notify({
            title = Translations.notify_vehicle_doors_unlocked,
            type = 'success',
        })
    end
end

local function BoostTorque(torqueValue)
    local player = cache.ped
    if not IsPedInAnyVehicle(player, true) then return end

    if torqueLoop then
        breakLoop = true
        return
    end

    CreateThread(function()
        torqueLoop = true
        while true do
            if breakLoop or not IsPedInAnyVehicle(player, true) or value == 1.0 then
                torqueLoop, breakLoop = nil, nil
                break
            end

            local currentVehicle = GetVehiclePedIsIn(player, false)
            SetVehicleCheatPowerIncrease(currentVehicle, torqueValue)
            Wait()
        end
    end)
end

local function BoostVehicle()
    local boostoptions = {}
    for _, v in pairs(TorqueMultiplier) do
        local torqueValue = v.Value
        boostoptions[#boostoptions+1] = {
            title = v.Name,
            icon = 'fa-solid fa-bolt',
            onSelect = function()
                BoostTorque(torqueValue)
            end
        }
    end

    lib.registerContext({
        id = 'primordial_admin_boost_menu',
        title = Translations.vehicle_options_boost_title,
        menu = 'primordial_admin_vehicle_menu',
        options = boostoptions,
    })

    lib.showContext('primordial_admin_boost_menu')
end

local function ChangeVehicleColor()
    local player = cache.ped

    if IsPedInAnyVehicle(player, false) then
        local currentVehicle = GetVehiclePedIsIn(player, false)
        local colorInput = lib.inputDialog(Translations.vehicle_options_change_color_title, {
            {
                type = 'color',
                label = Translations.vehicle_change_primary_color_label,
                default = '#ffffff',
            },
            {
                type = 'color',
                label = Translations.vehicle_change_secondary_color_label,
                default = '#ffffff',
            }
        })
        if not colorInput then
            return PL.Print.Log(3, 'No color input')
        end

        local newPrimaryColor = HexToRgb(colorInput[1])
        local newSecondaryColor = HexToRgb(colorInput[2])

        PL.Vehicle.SetVehicleProperties(currentVehicle, {
            color1 = {
                newPrimaryColor[1],
                newPrimaryColor[2],
                newPrimaryColor[3],
            },
            color2 = {
                newSecondaryColor[1],
                newSecondaryColor[2],
                newSecondaryColor[3],
            },
        })
    end
end

function VehicleOptionsInterface(permissions)
    if not permissions then return end
    local vehicleoptionsList = {}

    if permissions.vehicle_spawn_options or permissions.allPermissions then
        vehicleoptionsList[#vehicleoptionsList+1] = {
            title = Translations.vehicle_options_spawn_title,
            description = Translations.vehicle_options_spawn_description,
            icon = 'fa-solid fa-car',
            onSelect = function()
                SpawnVehicle()
            end
        }
    end

    if permissions.vehicle_repair_options or permissions.allPermissions then
        vehicleoptionsList[#vehicleoptionsList+1] = {
            title = Translations.vehicle_options_repair_title,
            description = Translations.vehicle_options_repair_description,
            icon = 'fa-solid fa-screwdriver-wrench',
            onSelect = function()
                RepairVehicle()
            end
        }
    end

    if permissions.vehicle_delete_options or permissions.allPermissions then
        vehicleoptionsList[#vehicleoptionsList+1] = {
            title = Translations.vehicle_options_delete_title,
            description = Translations.vehicle_options_delete_description,
            icon = 'fa-solid fa-trash',
            onSelect = function()
                DeleteVehicle()
            end
        }
    end

    if permissions.vehicle_flip_options or permissions.allPermissions then
        vehicleoptionsList[#vehicleoptionsList+1] = {
            title = Translations.vehicle_options_flip_title,
            description = Translations.vehicle_options_flip_description,
            icon = 'fa-solid fa-repeat',
            onSelect = function()
                FlipVehicle()
            end
        }
    end

    if permissions.vehicle_change_plate_options or permissions.allPermissions then
        vehicleoptionsList[#vehicleoptionsList+1] = {
            title = Translations.vehicle_options_change_plate_title,
            description = Translations.vehicle_options_change_plate_description,
            icon = 'fa-solid fa-feather',
            onSelect = function()
                ChangePlate()
            end
        }
    end

    if permissions.vehicle_refuel_options or permissions.allPermissions then
        vehicleoptionsList[#vehicleoptionsList+1] = {
            title = Translations.vehicle_options_refuel_title,
            description = Translations.vehicle_options_refuel_description,
            icon = 'fa-solid fa-gas-pump',
            onSelect = function()
                RefuelVehicle()
            end
        }
    end

    if permissions.vehicle_give_keys_options or permissions.allPermissions then
        vehicleoptionsList[#vehicleoptionsList+1] = {
            title = Translations.vehicle_options_give_keys_title,
            description = Translations.vehicle_options_give_keys_description,
            icon = 'fa-solid fa-key',
            onSelect = function()
                PL.Print.Log(3, 'Need key system to be setup')
            end
        }
    end

    if permissions.vehicle_doors_options or permissions.allPermissions then
        vehicleoptionsList[#vehicleoptionsList+1] = {
            title = Translations.vehicle_options_doors_title,
            description = Translations.vehicle_options_doors_description,
            icon = 'fa-solid fa-dungeon',
            onSelect = function()
                LockDoors()
            end
        }
    end

    if permissions.vehicle_boost_options or permissions.allPermissions then
        vehicleoptionsList[#vehicleoptionsList+1] = {
            title = Translations.vehicle_options_boost_title,
            description = Translations.vehicle_options_boost_description,
            icon = 'fa-solid fa-bolt',
            onSelect = function()
                BoostVehicle()
            end
        }
    end

    if permissions.vehicle_color_options or permissions.allPermissions then
        vehicleoptionsList[#vehicleoptionsList+1] = {
            title = Translations.vehicle_options_change_color_title,
            description = Translations.vehicle_options_change_color_description,
            icon = 'fa-solid fa-paint-roller',
            onSelect = function()
                ChangeVehicleColor()
            end
        }
    end

    lib.registerContext({
        id = 'primordial_admin_vehicle_menu',
        title = Translations.vehicle_options_title,
        menu = 'primordial_admin_homepage',
        options = vehicleoptionsList,
    })

    lib.showContext('primordial_admin_vehicle_menu')
end