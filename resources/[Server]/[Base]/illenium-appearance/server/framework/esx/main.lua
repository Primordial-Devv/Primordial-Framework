if not Framework.PL() then return end

local PL = exports["primordial_core"]:getSharedObject()

function Framework.GetPlayerID(src)
    local Player = PL.GetPlayerFromId(src)
    if Player then
        return Player.identifier
    end
end

function Framework.HasMoney(src, type, money)
    if type == "cash" then
        type = "money"
    end
    local Player = PL.GetPlayerFromId(src)
    return Player.getAccount(type).money >= money
end

function Framework.RemoveMoney(src, type, money)
    if type == "cash" then
        type = "money"
    end
    local Player = PL.GetPlayerFromId(src)
    if Player.getAccount(type).money >= money then
        Player.removeAccountMoney(type, money)
        return true
    end
    return false
end

function normalizeGrade(job)
    job.grade = {
        level = job.grade
    }
    return job
end

function Framework.GetJob(src)
    local Player = PL.GetPlayerFromId(src)
    return normalizeGrade(Player.getJob())
end

function Framework.GetGang(src)
    local Player = PL.GetPlayerFromId(src)
    return normalizeGrade(Player.getJob())
end

function Framework.SaveAppearance(appearance, citizenID)
    Database.Users.UpdateSkinForUser(citizenID, json.encode(appearance))
end

function Framework.GetAppearance(citizenID)
    local user = Database.Users.GetSkinByCitizenID(citizenID)
    if user then
        local skin = json.decode(user.skin)
        if skin then
            skin.sex = skin.model == "mp_m_freemode_01" and 0 or 1
            return skin
        end
    end
    return nil
end
