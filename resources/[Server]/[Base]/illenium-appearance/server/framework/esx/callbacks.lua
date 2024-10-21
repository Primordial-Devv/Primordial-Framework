if not Framework.PL() then return end

local PL = exports["primordial_core"]:getSharedObject()

lib.callback.register('esx_skin:getPlayerSkin', function(source)
    local Player = PL.GetPlayerFromId(source)

    local appearance = Framework.GetAppearance(Player.identifier)

    return appearance
end)

lib.callback.register("illenium-appearance:server:primordial_core:getGradesForJob", function(_, jobName)
    return Database.JobGrades.GetByJobName(jobName)
end)
