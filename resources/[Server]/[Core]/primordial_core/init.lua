if not _VERSION:find('5.4') then
    error('Lua 5.4 must be enabled in the resource manifest!', 2)
end

local resourceName = GetCurrentResourceName()
local primordial_core = 'primordial_core'

if resourceName == primordial_core then return end

if GetResourceState(primordial_core) ~= 'started' then
    error('^primordial_core must be started before this resource.^0', 0)
end

PL = exports["primordial_core"]:getSharedObject()

OnPlayerData = function (key, val, last) end

if not IsDuplicityVersion() then -- Only register this event for the client
    AddEventHandler("primordial_core:setPlayerData", function(key, val, last)
        if GetInvokingResource() == "primordial_core" then
            PL.PlayerData[key] = val
            if OnPlayerData then
                OnPlayerData(key, val, last)
            end
        end
    end)

    RegisterNetEvent("primordial_core:playerLoaded", function(sPlayer)
        PL.PlayerData = sPlayer
        PL.PlayerLoaded = true
    end)

    RegisterNetEvent("primordial_core:onPlayerLogout", function()
        PL.PlayerLoaded = false
        PL.PlayerData = {}
    end)
end
