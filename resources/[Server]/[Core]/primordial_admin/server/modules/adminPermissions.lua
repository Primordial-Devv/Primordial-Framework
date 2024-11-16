local function PlayerHasPermissions(source, group)
    local player = PL.GetPlayerFromId(source)
    if not player then return end
    if player.getGroup() ~= group then return false else return true end
end

function PrimordialAdminPermissions(source)
    local isPlayerAuthorized
    for group, perms in pairs(AdminPermissions.Groups) do
        if not isPlayerAuthorized then isPlayerAuthorized = {} end
        if PlayerHasPermissions(source, group) then
            isPlayerAuthorized = perms
            isPlayerAuthorized.open = true
            break
        end
    end
    if not isPlayerAuthorized?.allPermissions then
        if IsPlayerAceAllowed(source, AdminPermissions.AcePermissions.allPermissions) then
            if not isPlayerAuthorized then isPlayerAuthorized = {} end
            isPlayerAuthorized.allPermissions = true
            isPlayerAuthorized.open = true
        elseif not isPlayerAuthorized then
            isPlayerAuthorized = {}
            if IsPlayerAceAllowed(source, AdminPermissions.AcePermissions.allPermissions) then
                isPlayerAuthorized.allPermissions = true
                isPlayerAuthorized.open = true
            else
                for perms, aceExports in pairs(AdminPermissions.AcePermissions) do
                    if IsPlayerAceAllowed(source, aceExports) then
                        isPlayerAuthorized[perms] = true
                        if not isPlayerAuthorized.open then isPlayerAuthorized.open = true end
                    end
                end
            end
        elseif not isPlayerAuthorized?.allPermissions then
            for perms, aceExports in pairs(AdminPermissions.AcePermissions) do
                if IsPlayerAceAllowed(source, aceExports) then
                    isPlayerAuthorized[perms] = true
                    if not isPlayerAuthorized.open then isPlayerAuthorized.open = true end
                end
            end
        end
    end
    while not isPlayerAuthorized do
        PL.Print.Log(1, false, '^3Checking permissions...')
        Wait()
    end
    return isPlayerAuthorized
end