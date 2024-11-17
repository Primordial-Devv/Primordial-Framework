local loadingScreenFinished = false
local ready = false
local guiEnabled = false
local timecycleModifier = "hud_def_blur"

RegisterNetEvent("esx_identity:alreadyRegistered", function()
    while not loadingScreenFinished do
        Wait(100)
    end
    TriggerEvent("esx_skin:playerRegistered")
end)

RegisterNetEvent("esx_identity:setPlayerData", function(data)
    SetTimeout(1, function()
        PL.SetPlayerData("name", ("%s %s"):format(data.firstName, data.lastName))
        PL.SetPlayerData("firstName", data.firstName)
        PL.SetPlayerData("lastName", data.lastName)
        PL.SetPlayerData("dateofbirth", data.dateOfBirth)
        PL.SetPlayerData("sex", data.sex)
        PL.SetPlayerData("height", data.height)
    end)
end)

AddEventHandler("primordial_core:client:loadingScreenOff", function()
    loadingScreenFinished = true
end)

RegisterNUICallback("ready", function(_, cb)
    ready = true
    cb(1)
end)

function setGuiState(state)
    SetNuiFocus(state, state)
    guiEnabled = state

    if state then
        SetTimecycleModifier(timecycleModifier)
    else
        ClearTimecycleModifier()
    end

    SendNUIMessage({ type = "enableui", enable = state })
end

RegisterNetEvent("esx_identity:showRegisterIdentity", function()
    TriggerEvent("esx_skin:resetFirstSpawn")
    while not (ready and loadingScreenFinished) do
        PL.Print.Log(1, "Waiting for esx_identity NUI...")
        Wait(100)
    end
    if not PL.PlayerData.dead then
        setGuiState(true)
    end
end)

RegisterNUICallback("register", function(data, cb)
    if not guiEnabled then
        return
    end

    local success = lib.callback.await('esx_identity:registerIdentity', false, data)
    if success then
        lib.notify({
            title = Translations.thank_you_for_registering,
            type = "success",
        })
        setGuiState(false)

        TriggerEvent("esx_skin:playerRegistered")
    else
        return PL.Print.Log(3, "Failed to register identity")
    end
    cb(1)
end)