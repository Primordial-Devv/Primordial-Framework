local worBlips = {}

CreateThread(function()
    local isPublicBliCreated = false
    if not isPublicBliCreated then
        local blip = AddBlipForCoord(VigneronPublicBlip.Coords)
        SetBlipSprite(blip, VigneronPublicBlip.Sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, VigneronPublicBlip.Scale)
        SetBlipColour(blip, VigneronPublicBlip.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(VigneronPublicBlip.Name)
        EndTextCommandSetBlipName(blip)
        isPublicBliCreated = true
    end
end)

CreateThread(function()
    if PL.PlayerData.job and PL.PlayerData.job.name == 'vigneron' then
        for _, bliData in pairs(VigneronWorkBlip) do
            local blip = AddBlipForCoord(bliData.Coords)
            SetBlipSprite(blip, bliData.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, bliData.Scale)
            SetBlipColour(blip, bliData.Color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(bliData.Name)
            EndTextCommandSetBlipName(blip)
            table.insert(worBlips, {Blip = blip})
        end
    end
end)

local function ClearWorkBlips()
    for _, blip in ipairs(worBlips) do
        RemoveBlip(blip.Blip)
    end
    worBlips = {}
end

AddEventHandler('primordial_core:playerLoaded', function(sPlayer)
    PL.playerData = sPlayer
    PlayerLoaded = true
end)

AddEventHandler('primordial_core:setJob', function(job)
    PL.PlayerData.job = job
    ClearWorkBlips()
end)