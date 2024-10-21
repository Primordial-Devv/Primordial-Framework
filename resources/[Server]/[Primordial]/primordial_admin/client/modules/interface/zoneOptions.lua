local zones, points, blips, currentZone, safetyLoop, loopActive, breakLoop, inAdminZone = {}, {}, nil, nil, nil, nil, nil, false

local function CreateBlipRadius(coords, radius, color)
    local blip = AddBlipForRadius(coords, radius)
    SetBlipColour(blip, color or 1)
    SetBlipAlpha(blip, 80)
    return blip
end

local function RefreshBlips()
    if blips and #blips > 0 then
        for i = 1, #blips do
            RemoveBlip(blips[i])
        end
    end
    blips = {}
    if zones and #zones > 0 then
        for i = 1, #zones do
            blips[#blips + 1] = CreateBlip(zones[i].coords, zones[i].blip.sprite, zones[i].blip.color, zones[i].name, 1.0, zones[i].blip.flashing)
            blips[#blips + 1] = CreateBlipRadius(zones[i].coords, zones[i].size, zones[i].blip.color)
        end
    end
end

local function EnterZoneLoop()
    if not currentZone then return end
    if loopActive then
        breakLoop = true
        while loopActive do Wait(500) end
    end
    CreateThread(function()
        loopActive = true
        local cacheZone = currentZone
        local speedSet
        while true do
            local sleep = 1500
            if breakLoop or not currentZone or currentZone ~= cacheZone then
                breakLoop = nil
                loopActive = nil
                if speedSet and cache.vehicle then
                    SetVehicleMaxSpeed(cache.vehicle, 1000.00)
                    speedSet = nil
                end
                break
            end
            if currentZone.disarm and (IsPedArmed(cache.ped, 1) or IsPedArmed(cache.ped, 2) or IsPedArmed(cache.ped, 4)) then
                lib.notify({
                    title = Translations.notify_zone_no_weapons,
                    type = 'error',
                })
                SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`)
            end
            if currentZone.revive and PL.PlayerData.dead then
                TriggerEvent('primordial_admin:client:revivePlayer', true)
            end
            if currentZone.speedLimit and (cache.vehicle and cache.seat == -1) then
                local units = { mph = 2.236936, kmh = 3.6 }
                SetVehicleMaxSpeed(cache.vehicle, (currentZone.speedLimit / units['Km/h']))
                speedSet = true
            end
            Wait(sleep)
        end
    end)
end

local function RefreshPoints()
    if points and #points > 0 then
        for i = 1, #points do
            local point = points[i]
            point:remove()
        end
    end
    if loopActive then
        breakLoop = true
        while loopActive do Wait(500) end
        safetyLoop = nil
    end
    points = {}
    if zones and #zones > 0 then
        for k, v in pairs(zones) do
            local i = #points + 1
            points[i] = lib.points.new({
                coords = v.coords,
                distance = v.size
            })
            local point = points[i]
            function point:nearby()
                if self.currentDistance > v.size then return end
                currentZone = zones[k]
                inAdminZone = zones[k]
                if not safetyLoop then
                    EnterZoneLoop()
                    safetyLoop = true
                end
            end

            function point:onExit()
                if currentZone then
                    currentZone = nil
                    inAdminZone = false
                end
                if safetyLoop then safetyLoop = nil end
            end
        end
    end
end

local function CreateAdminZone()
    local createZoneDialog = lib.inputDialog(Translations.zone_options_create_title, {
        {
            type = 'input',
            label = Translations.zone_create_name_title,
            default = Translations.zone_create_name_default,
            required = true
        },
        {
            type = 'slider',
            label = Translations.zone_create_size_title,
            default = 1,
            min = 1,
            max = 10,
            step = 1,
            required = true
        },
        {
            type = 'checkbox',
            label = Translations.zone_create_parameter_disarm,
            checked = false,
        },
        {
            type = 'checkbox',
            label = Translations.zone_create_parameter_revive,
            checked = false,
        },
        {
            type = 'slider',
            label = Translations.zone_create_speed_limit .. ' ( Km/h )',
            default = 15,
            min = 1,
            max = 100,
            step = 10,
            required = true
        },
        {
            type = 'number',
            label = Translations.zone_create_blip_id_number,
            default = 487,
            min = 0,
            max = 826,
            required = true
        },
        {
            type = 'number',
            label = Translations.zone_create_blip_color_number,
            default = 1,
            min = 0,
            max = 85,
            required = true
        },
        {
            type = 'checkbox',
            label = Translations.zone_create_blip_flashing,
            checked = false
        }
    })
    if not createZoneDialog then return end

    local player = cache.ped
    local playerCoords = GetEntityCoords(player)
    local ZoneAdminParam = {
        name = createZoneDialog[1] or Translations.zone_create_name_default,
        size = (createZoneDialog[2] or 5) * 5.0,
        coords = playerCoords,
        disarm = createZoneDialog[3] or false,
        revive = createZoneDialog[4] or false,
        speedLimit = createZoneDialog[5] or 15,
        blip = {
            sprite = createZoneDialog[6] or 487,
            color = createZoneDialog[7] or 1,
            flashing = createZoneDialog[8] or false
        }
    }
    local adminZone = lib.callback.await('primordial_admin:server:createAdminZone', 350, ZoneAdminParam)

    if adminZone then
        lib.notify({
            title = Translations.zone_admin_created:format(ZoneAdminParam.name),
            type = 'success',
        })
    else
        lib.notify({
            title = Translations.zone_admin_failed,
            type = 'error',
        })
    end
end

local function EditAdminZone(zone)
    local zone = zone or currentZone
    if not zone then return end
    local editOptionsDialog = {}
    editOptionsDialog[#editOptionsDialog+1] = {
        type = 'input',
        label = Translations.zone_options_create_title_dialog,
        default = zone.name,
        required = true
    }
    editOptionsDialog[#editOptionsDialog+1] = {
        type = 'slider',
        label = Translations.zone_create_size_title,
        default = (math.floor(zone.size / 5)),
        min = 1,
        max = 10,
        step = 1,
        required = true
    }
    editOptionsDialog[#editOptionsDialog+1] = {
        type = 'checkbox',
        label = Translations.zone_create_parameter_disarm,
        checked = zone.disarm
    }
    editOptionsDialog[#editOptionsDialog+1] = {
        type = 'checkbox',
        label = Translations.zone_create_parameter_revive,
        checked = zone.revive
    }
    editOptionsDialog[#editOptionsDialog+1] = {
        type = 'slider',
        label = Translations.zone_create_speed_limit .. ' ( Km/h )',
        default = zone.speedLimit,
        min = 1,
        max = 100,
        step = 10,
        required = true
    }
    editOptionsDialog[#editOptionsDialog+1] = {
        type = 'number',
        label = Translations.zone_create_blip_id_number,
        default = zone.blip.sprite,
        min = 0,
        max = 826,
        required = true
    }
    editOptionsDialog[#editOptionsDialog+1] = {
        type = 'number',
        label = Translations.zone_create_blip_color_number,
        default = zone.blip.color,
        min = 0,
        max = 85,
        required = true
    }
    editOptionsDialog[#editOptionsDialog+1] = {
        type = 'checkbox',
        label = Translations.zone_create_blip_flashing,
        checked = zone.blip.flashing
    }
    local zoneEditDialog = lib.inputDialog(Translations.zone_manage_edit_title:format(zone.name), editOptionsDialog)
    if not zoneEditDialog then return end
    local newZone = {
        name = zoneEditDialog[1] or Translations.zone_create_name_default,
        size = (zoneEditDialog[2] or 5) * 5.0,
        coords = zone.coords,
        disarm = zoneEditDialog[3] or false,
        revive = zoneEditDialog[4] or false,
        speedLimit = zoneEditDialog[5] or 15,
        blip = {
            sprite = zoneEditDialog[6] or 487,
            color = zoneEditDialog[7] or 1,
            flashing = zoneEditDialog[8] or false
        }
    }
    local zoneEdited = lib.callback.await('primordial_admin:server:editZone', 2000, zone, newZone)
    if zoneEdited then
        lib.notify({
            title = Translations.zone_manage_edit_success:format(zone.name),
            type = 'success'
        })
    else
        lib.notify({
            title = Translations.zone_manage_edit_error:format(zone.name),
            type = 'error'
        })
    end
end

local function DeleteAdminZone(zone)
    local zone = zone or currentZone
    if not zone then return end
    local deleteConfirm = lib.alertDialog({
        header = Translations.zone_manage_delete_confirm_title,
        content = Translations.zone_manage_delete_confirm_content:format(zone.name),
        centered = true,
        cancel = true
    })

    if deleteConfirm == 'confirm' then
        local zoneDeleted = lib.callback.await('primordial_admin:server:deleteZone', 2000, zone)
        if zoneDeleted then
            lib.notify({
                title = Translations.zone_manage_delete_success:format(zone.name),
                type = 'success'
            })
        else
            lib.notify({
                title = Translations.zone_manage_delete_error:format(zone.name),
                type = 'error'
            })
        end
    else
        lib.notify({
            title = Translations.zone_manage_delete_cancel:format(zone.name),
            type = 'info'
        })
    end
end

local function TeleportAdminZone(zone)
    local zoneCoords = zone.coords
    DoScreenFadeOut(1500)
    while not IsScreenFadedOut() do Wait() end
    RequestCollisionAtCoord(zoneCoords.x, zoneCoords.y, zoneCoords.z)
    while not HasCollisionLoadedAroundEntity(cache.ped) do Wait() end
    SetEntityCoords(cache.ped, zoneCoords.x, zoneCoords.y, zoneCoords.z, false, false, false, false)
    DoScreenFadeIn(1500)
    lib.notify({
        title = Translations.zone_manage_teleport_success:format(zone.name),
        type = 'success'
    })
end

local function ManageZoneOptions(zone, permissions)
    local manageAdminZonesOptions = {}

    if permissions.zone_edit_options or permissions.allPermissions then
        manageAdminZonesOptions[#manageAdminZonesOptions+1] = {
            title = Translations.zone_edit_title,
            description = Translations.zone_edit_description,
            icon = 'fa-solid fa-pen-to-square',
            onSelect = function()
                EditAdminZone(zone)
            end
        }
    end

    if permissions.zone_delete_options or permissions.allPermissions then
        manageAdminZonesOptions[#manageAdminZonesOptions+1] = {
            title = Translations.zone_delete_title,
            description = Translations.zone_delete_description,
            icon = 'fa-solid fa-trash',
            onSelect = function()
                DeleteAdminZone(zone)
            end
        }
    end
    manageAdminZonesOptions[#manageAdminZonesOptions+1] = {
        title = Translations.zone_teleport_title,
        description = Translations.zone_teleport_description,
        icon = 'fa-solid fa-paper-plane',
        onSelect = function()
            TeleportAdminZone(zone)
        end
    }

    lib.registerContext({
        id = 'primordial_admin_zones_admin_manage_zone',
        title = zone.name,
        menu = 'primordial_admin_admin_zone_manage',
        options = manageAdminZonesOptions
    })

    lib.showContext('primordial_admin_zones_admin_manage_zone')
end

local function ManageAdminZone(permissions)
    if not zones or #zones < 1 then
        return lib.notify({
            title = Translations.zone_manage_no_zones,
            type = 'error'
        })
    else
        local manageZoneOptions = {}
        for i = 1, #zones do
            manageZoneOptions[#manageZoneOptions+1] = {
                title = zones[i].name,
                icon = 'fa-solid fa-vector-square',
                onSelect = function()
                    ManageZoneOptions(zones[i], permissions)
                end
            }
        end
        lib.registerContext({
            id = 'primordial_admin_admin_zone_manage',
            title = Translations.zone_options_manage_title,
            menu = 'primordial_admin_zone_options',
            options = manageZoneOptions
        })

        lib.showContext('primordial_admin_admin_zone_manage')
    end
end

function AdminZoneOptions(permissions)
    if not permissions then return end

    local adminZoneOptions = {}

    if permissions.zone_create_options or permissions.allPermissions then
        adminZoneOptions[#adminZoneOptions + 1] = {
            title = Translations.zone_options_create_title,
            description = Translations.zone_options_create_description,
            icon = 'fa-solid fa-plus',
            onSelect = function()
                CreateAdminZone()
            end
        }
    end

    if permissions.zone_manage_options or permissions.allPermissions then
        adminZoneOptions[#adminZoneOptions + 1] = {
            title = Translations.zone_options_manage_title,
            description = Translations.zone_options_manage_description,
            icon = 'fa-solid fa-list-check',
            onSelect = function()
                ManageAdminZone(permissions)
            end
        }
    end

    lib.registerContext({
        id = 'primordial_admin_zone_options',
        title = Translations.zones_options_title,
        menu = 'primordial_admin_homepage',
        options = adminZoneOptions
    })

    lib.showContext('primordial_admin_zone_options')
end

AddEventHandler('primordial_core:playerLoaded', function()
    zones = lib.callback.await('primordial_admin:server:refreshZones', 2000)
    RefreshBlips()
    RefreshPoints()
    return true
end)

RegisterNetEvent('primordial_admin:client:refreshAdminZone', function(newZones)
    zones = newZones
    RefreshBlips()
    RefreshPoints()
end)

exports('isInAdminZone', function()
    return currentZone
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if safetyLoop and currentZone then
            if currentZone.invincible then
                SetEntityInvincible(cache.ped, false)
                invincible = nil
            end
            if currentZone.speed and cache.vehicle then
                SetVehicleMaxSpeed(cache.vehicle, 1000.00)
                speedSet = nil
            end
        end
    end
end)