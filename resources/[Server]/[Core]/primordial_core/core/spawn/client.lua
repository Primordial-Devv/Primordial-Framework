CreateThread(function()
    while true do
        Wait(100)

        if NetworkIsPlayerActive(PlayerId()) then
            DoScreenFadeOut(0)
            Wait(500)
            TriggerServerEvent("primordial_core:server:onPlayerJoined")
            break
        end
    end
end)

function PL.SpawnPlayer(skin, coords, cb)
    local p = promise.new()
    TriggerEvent("skinchanger:loadSkin", skin, function()
        p:resolve()
    end)
    Citizen.Await(p)

    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)
    SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    SetEntityHeading(playerPed, coords.heading)
    while not HasCollisionLoadedAroundEntity(playerPed) do
        Wait(0)
    end
    FreezeEntityPosition(playerPed, false)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, true, false)
    TriggerEvent('playerSpawned', coords)
    cb()
end