--- Check if the player has admin permissions or not
---@param source number The player's server ID
---@return true|false boolean If the player has admin permissions or not
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