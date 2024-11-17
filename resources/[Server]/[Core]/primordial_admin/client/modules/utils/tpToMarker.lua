function TeleportToMarker()
    if not IsWaypointActive() then
        return PL.Print.Log(3, 'No Waypoint Set, Please Set a Waypoint First')
    end

    local blipMarker = GetFirstBlipInfoId(8)
    if not DoesBlipExist(blipMarker) then
        lib.notify({ title = Translations.tpm_nowaypoint, type = "error" })
        return
    end

    DoScreenFadeOut(650)
    while not IsScreenFadedOut() do
        Wait()
    end

    local ped = PlayerPedId()
    local coords = GetBlipInfoIdCoord(blipMarker)
    local vehicle = GetVehiclePedIsIn(ped, false)
    local oldCoords = GetEntityCoords(ped)
    local x, y = coords.x, coords.y
    local groundZ, found = 850.0, false

    FreezeEntityPosition(vehicle > 0 and vehicle or ped, true)

    for i = 950.0, 0, -25.0 do
        local z = (i % 2) == 0 and i or 950.0 - i

        NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)
        local curTime = GetGameTimer()
        while IsNetworkLoadingScene() and (GetGameTimer() - curTime <= 1000) do
            Wait()
        end
        NewLoadSceneStop()

        SetPedCoordsKeepVehicle(ped, x, y, z)
        while not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - curTime <= 1000) do
            RequestCollisionAtCoord(x, y, z)
            Wait()
        end

        found, groundZ = GetGroundZFor_3dCoord(x, y, z, false)
        if found then
            SetPedCoordsKeepVehicle(ped, x, y, groundZ)
            break
        end
        Wait()
    end

    DoScreenFadeIn(650)
    FreezeEntityPosition(vehicle > 0 and vehicle or ped, false)

    if not found then
        SetPedCoordsKeepVehicle(ped, oldCoords.x, oldCoords.y, oldCoords.z - 1.0)
        lib.notify({ title = Translations.tpm_failure, type = "error" })
    else
        lib.notify({ title = Translations.tpm_success, type = "success" })
    end
end

RegisterNetEvent('primordial_admin:client:teleportToMarker', function()
    TeleportToMarker()
end)