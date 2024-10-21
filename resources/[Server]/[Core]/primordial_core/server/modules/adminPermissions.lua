function PL.AdminPermissions(source)
    if source == 0 then
        return true
    end

    local player = PL.Players[source]
    if not player then
        return false
    end

    local playerGroup = player.getGroup()

    if PermissionsGroups[playerGroup] then
        return true
    else
        return false
    end
end