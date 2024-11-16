local isAlreadyDrunk = false
local drunkLevel     = -1

function getDrunk(level, start)
    CreateThread(function()
        local playerPed = PlayerPedId()

        if start then
            DoScreenFadeOut(800)
            Wait(1000)
        end

        local animSet = ""
        if level == 0 then
            animSet = "move_m@drunk@slightlydrunk"
        elseif level == 1 then
            animSet = "move_m@drunk@moderatedrunk"
        elseif level == 2 then
            animSet = "move_m@drunk@verydrunk"
        end

        PL.Streaming.RequestAnimSet(animSet)
        SetPedMovementClipset(playerPed, animSet, true)

        SetTimecycleModifier("spectator5")
        SetPedMotionBlur(playerPed, true)
        SetPedIsDrunk(playerPed, true)

        if start then
            DoScreenFadeIn(800)
        end
    end)
end

function getSober()
    CreateThread(function()
        local playerPed = PlayerPedId()

        DoScreenFadeOut(800)
        Wait(1000)

        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        ResetPedMovementClipset(playerPed, 0)
        SetPedIsDrunk(playerPed, false)
        SetPedMotionBlur(playerPed, false)

        DoScreenFadeIn(800)
    end)
end

AddEventHandler('primordial_lifeEssentials:client:loaded', function(status)
    TriggerEvent('primordial_core:client:registerStatus', 'drunk', 0, function(status)
            status.remove(1500)
        end
    )

    CreateThread(function()
        while true do
            Wait(1000)

            TriggerEvent('primordial_lifeEssentials:client:getStatus', 'drunk', function(status)
                if status.val > 0 then
                    local start = not isAlreadyDrunk
                    local level = 0

                    if status.val <= 250000 then
                        level = 0
                    elseif status.val <= 500000 then
                        level = 1
                    else
                        level = 2
                    end

                    if level ~= drunkLevel then
                        getDrunk(level, start)
                    end

                    isAlreadyDrunk = true
                    drunkLevel     = level
                end

                if status.val == 0 and isAlreadyDrunk then
                    getSober()
                    isAlreadyDrunk = false
                    drunkLevel     = -1
                end
            end)
        end
    end)
end)