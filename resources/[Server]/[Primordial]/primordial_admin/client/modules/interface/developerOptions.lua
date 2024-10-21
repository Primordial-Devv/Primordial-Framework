local toggleDebug

local function RotationToDirection(rotation)
    local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local function RaycastGameplayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, -1, 1))
	return b, c, e
end

local function RoundInt(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function AdminDeleteEntity(entity)
    if not DoesEntityExist(entity) then return end
    if IsEntityAPed(entity) and IsPedAPlayer(entity) then
        lib.notify({
            title = Translations.notify_cant_delete_player,
            type = 'error',
        })
        return
    end
    local netId = NetworkGetNetworkIdFromEntity(entity)
    local entCheck = NetworkGetEntityFromNetworkId(netId)
    if entCheck == 0 then
        lib.notify({
            title = Translations.notify_cant_delete_entity,
            type = 'error',
        })
        return
    end
    TriggerServerEvent('primordial_admin:server:deleteEntity', netId)
end

local function ToggleDebugThread()
    CreateThread(function()
        local textUI
        local outLined
        while true do
            if toggleDebug then
                local position = GetEntityCoords(cache.ped)
                local hit, coords, entity = RaycastGameplayCamera(1000.0)
                if hit then
                    DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, 255, 0, 0, 255)
                    DrawMarker(28, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.135, 0.25, 0.25, 255, 0, 0, 50, false, true, 2, true, false, false, false)
                    if entity then
                        if DoesEntityExist(entity) then    
                            local eCoords = GetEntityCoords(entity)
                            if eCoords ~= vector3(0.0,0.0,0.0) then
                                local modelHash = GetEntityModel(entity)
                                local heading = GetEntityHeading(entity)
                                local entOwner = NetworkGetEntityOwner(entity)
                                local playerName = GetPlayerName(entOwner)
                                if not textUI then
                                    if entOwner and playerName then
                                        lib.showTextUI((Translations.debug_textui_name):format(modelHash, RoundInt(eCoords.x, 2), RoundInt(eCoords.y, 2), RoundInt(eCoords.z, 2), RoundInt(heading, 2),GetPlayerServerId(entOwner), playerName))
                                    else
                                        lib.showTextUI((Translations.debug_textui_noname):format(modelHash, RoundInt(eCoords.x, 2), RoundInt(eCoords.y, 2), RoundInt(eCoords.z, 2), RoundInt(heading, 2)))
                                    end
                                    textUI = true
                                end
                                if not outLined and not IsEntityAPed(entity) then
                                    outLined = entity
                                    SetEntityDrawOutline(outLined, true)
                                    SetEntityDrawOutlineColor(255, 0, 0, 255)
                                end
                                if IsControlJustReleased(0, 38) then
                                    AdminDeleteEntity(entity)
                                    if textUI then
                                        lib.hideTextUI()
                                        textUI = false
                                    end
                                end
                            else
                                if textUI then
                                    textUI = nil
                                    lib.hideTextUI()
                                end
                                if outLined then
                                    SetEntityDrawOutline(outLined, false)
                                    outLined = nil
                                end
                            end
                        else
                            if textUI then
                                lib.hideTextUI()
                                textUI = nil
                            end
                            if outLined then
                                SetEntityDrawOutline(outLined, false)
                                outLined = nil
                            end

                        end
                    end
                else
                    if textUI then
                        lib.hideTextUI()
                        textUI = false
                    end
                    if outLined then
                        SetEntityDrawOutline(outLined, false)
                        outLined = nil
                    end
                end
            else
                if textUI then
                    textUI = false
                    lib.hideTextUI()
                end
                if outLined then
                    SetEntityDrawOutline(outLined, false)
                    outLined = nil
                end
                break
            end
            Wait(0)
        end
    end)
end

local function ToggleDebugMode()
    toggleDebug = not toggleDebug

    if toggleDebug then
        ToggleDebugThread()
    end
end

local function CopyVec3Coords()
    local coords = GetEntityCoords(cache.ped)
    lib.setClipboard('vector3('..RoundInt(coords.x, 2)..', '..RoundInt(coords.y, 2)..', '..RoundInt(coords.z - 1, 2)..')')
    lib.notify({
        title = Translations.notify_copied_vec3,
        type = 'success'
    })
end

local function CopyVec4Coords()
    local coords, heading = GetEntityCoords(cache.ped), GetEntityHeading(cache.ped)
    lib.setClipboard('vector4('..RoundInt(coords.x, 2)..', '..RoundInt(coords.y, 2)..', '..RoundInt(coords.z - 1, 2).. ', ' .. RoundInt(heading, 2).. ')')
    lib.notify({
        title = Translations.notify_copied_vec4,
        type = 'success'
    })
end

local function CopyHeading()
    local heading = GetEntityHeading(cache.ped)
    lib.setClipboard(RoundInt(heading, 2))
    lib.notify({
        title = Translations.notify_copied_heading,
        type = 'success'
    })
end

function DeveloperOptionsInterface(permissions)
    if not permissions then return end

    local developerOptions = {}

    if permissions.developer_debug_options or permissions.allPermissions then
        developerOptions[#developerOptions+1] = {
            title = Translations.developer_debug_options_title,
            description = Translations.developer_debug_options_description,
            icon = 'fa-solid fa-clipboard-check',
            onSelect = function()
                ToggleDebugMode()
            end
        }
    end

    if permissions.developer_copy_coords_options or permissions.allPermissions then
        developerOptions[#developerOptions+1] = {
            title = Translations.developer_copy_vec3_options_title,
            description = Translations.developer_copy_vec3_options_description,
            icon = 'fa-solid fa-copy',
            onSelect = function()
                CopyVec3Coords()
            end
        }
        
        developerOptions[#developerOptions+1] = {
            title = Translations.developer_copy_vec4_options_title,
            description = Translations.developer_copy_vec4_options_description,
            icon = 'fa-solid fa-copy',
            onSelect = function()
                CopyVec4Coords()
            end
        }

        developerOptions[#developerOptions+1] = {
            title = Translations.developer_copy_heading_options_title,
            description = Translations.developer_copy_heading_options_description,
            icon = 'fa-solid fa-copy',
            onSelect = function()
                CopyHeading()
            end
        }
    end

    lib.registerContext({
        id = 'primordial_admin_developer_options',
        title = Translations.developer_options_title,
        menu = 'primordial_admin_homepage',
        options = developerOptions
    })

    lib.showContext('primordial_admin_developer_options')
end