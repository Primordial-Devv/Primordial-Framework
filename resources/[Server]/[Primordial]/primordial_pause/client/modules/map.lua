RegisterNUICallback('openMap', function(data,cb)
    TriggerScreenblurFadeOut(1000)
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), 0, -1)
    Wait(100)
    PauseMenuceptionGoDeeper(0)
    SetNuiFocus(false,false)
    SendNUIMessage({action = 'close'})
    cb('ok')

    while true do
        Wait(10)
        if IsControlJustPressed(0, 200) or IsControlJustPressed(0, 177) then -- 200 = ESCAPE, 177 = BACKSPACE
            DisplayRadar(true)
            SetFrontendActive(0)
            Wait(10)
            break
        end
    end
end)