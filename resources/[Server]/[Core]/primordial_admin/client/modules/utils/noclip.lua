local isNoclipping, player, noclipEntity, noclipOpacity, camera, isPlayerInVehicle

local function CreateNoclipEffect()
    PL.Streaming.RequestNamedPtfxAsset(NoclipConfig.ParticleEffect.FxName, 200)
    local playerCoords = GetEntityCoords(noclipEntity)

    UseParticleFxAsset(NoclipConfig.ParticleEffect.FxName)
    SetParticleFxNonLoopedColour(1.0, 0.0, 0.0) -- Color Red
    StartNetworkedParticleFxNonLoopedAtCoord(NoclipConfig.ParticleEffect.EffactName, playerCoords.x, playerCoords.y, playerCoords.z, 0.0, 0.0, 0.0, 3.0, false, false, false)

    RemoveNamedPtfxAsset(NoclipConfig.ParticleEffect.FxName)
end

local function isPedDrivingvehicle(ped, vehicle)
    return ped == GetPedInVehicleSeat(vehicle, -1)
end

local function SetupCameraNoclip()
    local entityRotation = GetEntityRotation(noclipEntity)

    camera = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', GetEntityCoords(noclipEntity), vector3(0.0, 0.0, entityRotation.z), 75.0)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 1000, false, false)

    if isPlayerInVehicle then
        AttachCamToEntity(camera, noclipEntity, 0.0, NoclipConfig.FirstPersonWhileNoclip == true and 0.5 or -4.5, NoclipConfig.FirstPersonWhileNoclip == true and 1.0 or 2.0, true)
    else
        AttachCamToEntity(camera, noclipEntity, 0.0, NoclipConfig.FirstPersonWhileNoclip == true and 0.0 or -2.0, NoclipConfig.FirstPersonWhileNoclip == true and 1.0 or 0.5, true)
    end
end

local function getGroundCoords(coords)
    local raycast = StartShapeTestRay(coords.x, coords.y, coords.z, coords.x, coords.y, -10000.0, 1, 0)
    local _, hit, groundCoords = GetShapeTestResult(raycast)
    return (hit == 1 and groundCoords) or coords
end

local function DastroyNoclipCamera()
    SetGameplayCamRelativeHeading(0)
    RenderScriptCams(false, true, 1000, true, true)
    DetachEntity(noclipEntity, true, true)
    SetCamActive(camera, false)
    DestroyCam(camera, true)
end

local function CheckInputRotation()
    local rightAxisX = GetControlNormal(0, 220)
    local rightAxisY = GetControlNormal(0, 221)

    local rotation = GetCamRot(camera, 2)
    local yValue = rightAxisY * -5
    local newX
    local newZ = rotation.z + (rightAxisX * -10)
    if (rotation.x + yValue > -89.0) and (rotation.x + yValue < 89.0) then
        newX = rotation.x + yValue
    end
    if newX ~= nil and newZ ~= nil then
        SetCamRot(camera, vector3(newX, rotation.y, newZ), 2)
    end

    SetEntityHeading(noclipEntity, math.max(0, (rotation.z % 360)))
end

local function DisablePlayerControl()
    HudWeaponWheelIgnoreSelection()
    DisableAllControlActions(0)
    DisableAllControlActions(1)
    DisableAllControlActions(2)
    EnableControlAction(0, 220, true)
    EnableControlAction(0, 221, true)
    EnableControlAction(0, 245, true)
    EnableControlAction(0, 200, true)
end

local function IsControlAlwaysPressed(inputGroup, control)
    return IsControlPressed(inputGroup, control) or IsDisabledControlPressed(inputGroup, control)
end

local function StopNoclip()
    FreezeEntityPosition(noclipEntity, false)
    SetEntityCollision(noclipEntity, true, true)
    SetEntityVisible(noclipEntity, true, false)
    SetLocalPlayerVisibleLocally(true)
    ResetEntityAlpha(noclipEntity)
    ResetEntityAlpha(player)
    SetEveryoneIgnorePlayer(player, false)
    SetPoliceIgnorePlayer(player, false)
    ResetEntityAlpha(noclipEntity)
    SetPoliceIgnorePlayer(player, true)
    CreateNoclipEffect()

    if GetVehiclePedIsIn(player, false) then
        while (not IsVehicleOnAllWheels(noclipEntity)) and not isNoclipping do
            Wait()
        end
        while not isNoclipping do
            Wait()
            if IsVehicleOnAllWheels(noclipEntity) then
                return SetEntityInvincible(noclipEntity, false)
            end
        end
    else
        if (IsPedFalling(noclipEntity) and math.abs(1 - GetEntityHeightAboveGround(noclipEntity)) > 1.00) then
            while (IsPedStopped(noclipEntity) or not IsPedFalling(noclipEntity)) and not isNoclipping do
                Wait()
            end
        end
        while not isNoclipping do
            Wait()
            if (not IsPedFalling(noclipEntity)) and (not IsPedRagdoll(noclipEntity)) then
                return SetEntityInvincible(noclipEntity, false)
            end
        end
    end
end

local function RunNoclipThread()
    CreateThread(function()
        while isNoclipping do
            Wait()
            CheckInputRotation()
            DisablePlayerControl()

            if IsControlAlwaysPressed(2, NoclipConfig.Controls.DecreaseSpeed) then
                NoclipConfig.DefaultSpeed = NoclipConfig.DefaultSpeed - 0.5
                if NoclipConfig.DefaultSpeed < 0.5 then
                    NoclipConfig.DefaultSpeed = 0.5
                end
            elseif IsControlAlwaysPressed(2, NoclipConfig.Controls.IncreaseSpeed) then
                NoclipConfig.DefaultSpeed = NoclipConfig.DefaultSpeed + 0.5
                if NoclipConfig.DefaultSpeed > NoclipConfig.MaxSpeed then
                    NoclipConfig.DefaultSpeed = NoclipConfig.MaxSpeed
                end
            elseif IsDisabledControlJustReleased(0, 348) then
                NoclipConfig.DefaultSpeed = 1
            end

            local mulitplier = 1.0

            if IsControlAlwaysPressed(0, 21) then       -- LSHIFT
                mulitplier = 2.0
            elseif IsControlAlwaysPressed(0, 19) then   -- LALT
                mulitplier = 4.0
            elseif IsControlAlwaysPressed(0, 36) then   -- LEFT CTRL
                mulitplier = 0.25
            end

            if IsControlAlwaysPressed(0, NoclipConfig.Controls.MoveForward) then
                local pitch = GetCamRot(camera, 0)

                if pitch.x >= 0 then
                    SetEntityCoordsNoOffset(noclipEntity, GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, 0.5*(NoclipConfig.DefaultSpeed * mulitplier), (pitch.x*((NoclipConfig.DefaultSpeed/2) * mulitplier))/89))
                else
                    SetEntityCoordsNoOffset(noclipEntity, GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, 0.5*(NoclipConfig.DefaultSpeed * mulitplier), -1*((math.abs(pitch.x)*((NoclipConfig.DefaultSpeed/2) * mulitplier))/89)))
                end
            elseif IsControlAlwaysPressed(0, NoclipConfig.Controls.MoveBackward) then
                local pitch = GetCamRot(camera, 2)

                if pitch.x >= 0 then
                    SetEntityCoordsNoOffset(noclipEntity, GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, -0.5*(NoclipConfig.DefaultSpeed * mulitplier), -1*(pitch.x*((NoclipConfig.DefaultSpeed/2) * mulitplier))/89))
                else
                    SetEntityCoordsNoOffset(noclipEntity, GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, -0.5*(NoclipConfig.DefaultSpeed * mulitplier), ((math.abs(pitch.x)*((NoclipConfig.DefaultSpeed/2) * mulitplier))/89)))
                end
            end

            if IsControlAlwaysPressed(0, NoclipConfig.Controls.MoveLeft) then
                SetEntityCoordsNoOffset(noclipEntity, GetOffsetFromEntityInWorldCoords(noclipEntity, -0.5*(NoclipConfig.DefaultSpeed * mulitplier), 0.0, 0.0))
            elseif IsControlAlwaysPressed(0, NoclipConfig.Controls.MoveRight) then
                SetEntityCoordsNoOffset(noclipEntity, GetOffsetFromEntityInWorldCoords(noclipEntity, 0.5*(NoclipConfig.DefaultSpeed * mulitplier), 0.0, 0.0))
            end

            if IsControlAlwaysPressed(0, NoclipConfig.Controls.MoveUp) then
                SetEntityCoordsNoOffset(noclipEntity, GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, 0.0, 0.5*(NoclipConfig.DefaultSpeed * mulitplier)))
            elseif IsControlAlwaysPressed(0, NoclipConfig.Controls.MoveDown) then
                SetEntityCoordsNoOffset(noclipEntity, GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, 0.0, -0.5*(NoclipConfig.DefaultSpeed * mulitplier)))
            end

            local entityCoords = GetEntityCoords(noclipEntity)

            RequestCollisionAtCoord(entityCoords.x, entityCoords.y, entityCoords.z)
            FreezeEntityPosition(noclipEntity, true)
            SetEntityCollision(noclipEntity, false, false)
            SetEntityVisible(noclipEntity, false, false)
            SetEntityInvincible(noclipEntity, true)
            SetLocalPlayerVisibleLocally(true)
            SetEntityAlpha(noclipEntity, noclipOpacity, false)
            if isPlayerInVehicle then
                SetEntityAlpha(player, noclipOpacity, false)
            end
            SetEveryoneIgnorePlayer(player, true)
            SetPoliceIgnorePlayer(player, true)
        end
        StopNoclip()
    end)
end

function ToggleNoclip(state)
    isNoclipping = state or not isNoclipping
    player = cache.ped
    isPlayerInVehicle = IsPedInAnyVehicle(player, false)

    CreateNoclipEffect()

    if isPlayerInVehicle and isPedDrivingvehicle(player, GetVehiclePedIsIn(player, false)) then
        noclipEntity = GetVehiclePedIsIn(player, false)
        SetVehicleEngineOn(noclipEntity, not isNoclipping, true, isNoclipping)
        noclipOpacity = NoclipConfig.FirstPersonWhileNoclip == true and 0 or 51
    else
        noclipEntity = player
        noclipOpacity = NoclipConfig.FirstPersonWhileNoclip == true and 0 or 51
    end

    if isNoclipping then
        FreezeEntityPosition(player, true)
        SetupCameraNoclip()
        PlaySoundFromEntity(-1, 'SELECT', player, 'HUD_LIQUOR_STORE_SOUNDSET', 0, 0)

        if not isPlayerInVehicle then
            ClearPedTasksImmediately(player)
            if NoclipConfig.FirstPersonWhileNoclip then
                Wait(1000)
            end
        else
            if NoclipConfig.FirstPersonWhileNoclip then
                Wait(1000)
            end
        end

    else
        local groundCoords = getGroundCoords(GetEntityCoords(noclipEntity))
        SetEntityCoords(noclipEntity, groundCoords.x, groundCoords.y, groundCoords.z)
        Wait(50)
        DastroyNoclipCamera()
        PlaySoundFromEntity(-1, 'CANCEL', player, 'HUD_LIQUOR_STORE_SOUNDSET', 0, 0)
    end

    SetUserRadioControlEnabled(not isNoclipping)

    if isNoclipping then
        RunNoclipThread()
    end
end

RegisterNetEvent('primordial_admin:client:toggleNoclip', function()
    ToggleNoclip(not isNoclipping)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        FreezeEntityPosition(noclipEntity, false)
        FreezeEntityPosition(player, false)
        SetEntityCollision(noclipEntity, true, true)
        SetEntityVisible(noclipEntity, true, false)
        SetLocalPlayerVisibleLocally(true)
        ResetEntityAlpha(noclipEntity)
        ResetEntityAlpha(player)
        SetEveryoneIgnorePlayer(player, false)
        SetPoliceIgnorePlayer(player, false)
        ResetEntityAlpha(noclipEntity)
        SetPoliceIgnorePlayer(player, true)
        SetEntityInvincible(noclipEntity, false)
    end
end)