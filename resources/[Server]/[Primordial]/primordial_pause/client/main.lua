local pauseMenuActive = false

AddEventHandler('primordial_core:playerLoaded', function(sPlayer)
    PL.PlayerData = sPlayer
    PlayerLoaded = true
end)

CreateThread(function()
    while true do
        Wait(0)

        SetPauseMenuActive(false)
    end
end)

RegisterCommand('~=++pausemenu', function()
    if not pauseMenuActive then
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'open' })
        pauseMenuActive = true
    end

    PL.Print.Log(1, 'Pause Menu Opened')
end)

RegisterKeyMapping('~=++pausemenu', 'Open Pause menu', 'keyboard', 'F5')

RegisterNUICallback('open', function(data, cb)
    SetPauseMenuActive(false)
    SetNuiFocus(true, true)
    pauseMenuActive = true
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    pauseMenuActive = false
    cb('ok')
end)
