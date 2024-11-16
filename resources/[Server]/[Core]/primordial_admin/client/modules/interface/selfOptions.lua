local isInvisible, isGodmode, superRun, superJump
local isAccepted = false

local function ToggleGodmode()
    isGodmode = not isGodmode
    SetEntityInvincible(PlayerPedId(), isGodmode)
end

local function ToggleInvisible()
    isInvisible = not isInvisible
    SetEntityVisible(PlayerPedId(), not isInvisible)
end

local function SuperRun()
    superRun = not superRun

    if superRun then
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
    else
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
    end
end

local function SuperJump()
    superJump = not superJump

    if superJump then
        CreateThread(function()
            while superJump do
                SetSuperJumpThisFrame(PlayerId())
                Wait()
            end
        end)
    end
end

local function TeleportToCoords(player, x, y, z)
    local destintionCoords = vector3(x, y, z)

    DoScreenFadeOut(1500)
    while not IsScreenFadedOut() do
        Wait()
    end

    SetEntityCoords(player, destintionCoords.x, destintionCoords.y, destintionCoords.z, true, 0, 0, true)
    while not HasCollisionLoadedAroundEntity(player) do
        Wait()
        RequestCollisionAtCoord(destintionCoords.x, destintionCoords.y, destintionCoords.z)
    end

    DoScreenFadeIn(1500)
end

local function TeleportToCoordsDialog()
    local coordsDialogOptions = {}
    local player = PlayerPedId()

    coordsDialogOptions[#coordsDialogOptions+1] = {
        type = 'number',
        label = Translations.coords_field_x,
        description = Translations.coords_field_x_description,
        required = true,
    }

    coordsDialogOptions[#coordsDialogOptions+1] = {
        type = 'number',
        label = Translations.coords_field_y,
        description = Translations.coords_field_y_description,
        required = true,
    }
    coordsDialogOptions[#coordsDialogOptions+1] = {
        type = 'number',
        label = Translations.coords_field_z,
        description = Translations.coords_field_z_description,
        required = true,
    }
    local teleport_coordinates = lib.inputDialog(Translations.coords_field_title, coordsDialogOptions)

    if not teleport_coordinates then
        return PL.Print.Log(3, false, 'Coordinates Selection Cancelled')
    end

    TeleportToCoords(player, tonumber(teleport_coordinates[1]), tonumber(teleport_coordinates[2]), tonumber(teleport_coordinates[3]))
end

function SelfOptionsInterface(permissions)
    if not permissions then return end

    local health = GetEntityHealth(cache.ped) / 2
    local selfOptions = {}

    selfOptions[#selfOptions+1] = {
        title = (Translations.health_title):format(PL.Math.Round(health, 2)),
        icon = 'fa-solid fa-heart-pulse',
        readOnly = true,
        progress = health,
        colorScheme = "green"
    }

    if permissions.noclip_permissions or permissions.allPermissions then
        selfOptions[#selfOptions+1] = {
            title = Translations.noclip_title,
            description = Translations.noclip_description,
            icon = 'fa-solid fa-user-slash',
            onSelect = function()
                ToggleNoclip()
            end
        }
    end

    if permissions.invisible_permissions or permissions.allPermissions then
        selfOptions[#selfOptions+1] = {
            title = Translations.invisible_title,
            description = Translations.invisible_description,
            icon = 'fa-solid fa-eye-slash',
            onSelect = function()
                ToggleInvisible()
            end
        }
    end

    if permissions.godmode_permissions or permissions.allPermissions then
        selfOptions[#selfOptions+1] = {
            title = Translations.godmode_title,
            description = Translations.godmode_description,
            icon = 'fa-solid fa-dumbbell',
            onSelect = function()
                ToggleGodmode()
            end
        }
    end

    if permissions.revive_permissions or permissions.allPermissions then
        selfOptions[#selfOptions+1] = {
            title = Translations.revive_title,
            description = Translations.revive_description,
            icon = 'fa-solid fa-heart',
            onSelect = function()
                isAccepted = true
                TriggerEvent('primordial_admin:client:revivePlayer', PlayerPedId(), isAccepted)
                isAccepted = false
            end
        }
    end

    if permissions.heal_permissions or permissions.allPermissions then
        selfOptions[#selfOptions+1] = {
            title = Translations.heal_title,
            description = Translations.heal_description,
            icon = 'fa-solid fa-star-of-life',
            onSelect = function()
                TriggerEvent('primordial_lifeEssentials:client:healPlayer')
            end
        }
    end

    if permissions.teleport_to_coords_permissions or permissions.allPermissions then
        selfOptions[#selfOptions + 1] = {
            title = Translations.teleport_to_coords_title,
            description = Translations.teleport_to_coords_description,
            icon = 'fa-solid fa-location-dot',
            onSelect = function()
                TeleportToCoordsDialog()
            end
        }
    end

    if permissions.teleport_to_marker_permissions or permissions.allPermissions then
        selfOptions[#selfOptions + 1] = {
            title = Translations.teleport_to_marker_title,
            description = Translations.teleport_to_marker_description,
            icon = 'fa-solid fa-location-dot',
            onSelect = function()
                TeleportToMarker()
            end
        }
    end

    if permissions.super_sprint_permissions or permissions.allPermissions then
        selfOptions[#selfOptions + 1] = {
            title = Translations.super_sprint_title,
            description = Translations.super_sprint_description,
            icon = 'fa-solid fa-person-running',
            onSelect = function()
                SuperRun()
            end
        }
    end

    if permissions.super_jump_permissions or permissions.allPermissions then
        selfOptions[#selfOptions + 1] = {
            title = Translations.super_jump_title,
            description = Translations.super_jump_description,
            icon = 'fa-solid fa-arrow-up',
            onSelect = function()
                SuperJump()
            end
        }
    end

    if permissions.skin_menu_permissions or permissions.allPermissions then
        selfOptions[#selfOptions + 1] = {
            title = Translations.skin_menu_title,
            description = Translations.skin_menu_description,
            icon = 'fa-solid fa-shirt',
            onSelect = function()
                TriggerEvent('esx_skin:openSaveableMenu')
            end
        }
    end

    if permissions.ped_permissions or permissions.allPermissions then
        selfOptions[#selfOptions + 1] = {
            title = Translations.ped_title,
            description = Translations.ped_description,
            icon = 'fa-solid fa-user',
            onSelect = function()
                PedMenu()
            end
        }
    end

    lib.registerContext({
        id = 'primordial_admin_self_options',
        title = Translations.self_options_title,
        menu = 'primordial_admin_homepage',
        options = selfOptions
    })

    lib.showContext('primordial_admin_self_options')
end