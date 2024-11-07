if not Framework.PL() then return end

local PL = exports["primordial_core"]:getSharedObject()
Framework.PlayerData = nil

RegisterNetEvent("primordial_core:playerLoaded", function(sPlayer)
    Framework.PlayerData = sPlayer
    client.job = Framework.PlayerData.society
    client.gang = Framework.PlayerData.gang
    client.citizenid = Framework.PlayerData.identifier
    InitAppearance()
end)

RegisterNetEvent("primordial_core:onPlayerLogout", function()
    Framework.PlayerData = nil
end)

RegisterNetEvent("primordial_core:setJob", function(job)
	Framework.PlayerData.society = job
    client.job = Framework.PlayerData.society
    client.gang = Framework.PlayerData.society
end)

local function getRankInputValues(rankList)
    local rankValues = {}
    for k, v in pairs(rankList) do
        rankValues[#rankValues + 1] = {
            label = v.label,
            value = v.grade
        }
    end
    return rankValues
end

function Framework.GetPlayerGender()
    Framework.PlayerData = PL.GetPlayerData()
    if Framework.PlayerData.sex == "f" then
        return "Female"
    end
    return "Male"
end

function Framework.UpdatePlayerData()
    local data = PL.GetPlayerData()
    if data.job then
        Framework.PlayerData = data
        client.job = Framework.PlayerData.society
        client.gang = Framework.PlayerData.society
    end
    client.citizenid = Framework.PlayerData.identifier
end

function Framework.HasTracker()
    return false
end

function Framework.CheckPlayerMeta()
    Framework.PlayerData = PL.GetPlayerData()
    return Framework.PlayerData.dead or IsPedCuffed(Framework.PlayerData.ped)
end

function Framework.IsPlayerAllowed(citizenid)
    return citizenid == Framework.PlayerData.identifier
end

function Framework.GetRankInputValues(type)
    local jobGrades = lib.callback.await("illenium-appearance:server:primordial_core:getGradesForJob", false, client[type].name)
    return getRankInputValues(jobGrades)
end

function Framework.GetJobGrade()
    return client.job.grade
end

function Framework.GetGangGrade()
    return client.gang.grade
end

function Framework.CachePed()
    PL.SetPlayerData("ped", cache.ped)
end

function Framework.RestorePlayerArmour()
    return nil
end
