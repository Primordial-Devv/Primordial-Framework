--- Return the closest player and his specific coords
---@param coords vector3 The coords to check from.
---@param maxDistance? number The max distance to check.
---@return number closestId The closest player's server ID.
---@return number closestPed The closest player's ped.
---@return vector3 closestCoords The coords of the closest player.
function PL.Player.GetClosestPlayer(coords, maxDistance)
    local players = GetActivePlayers()
    local closestId, closestPed, closestCoords
    maxDistance = maxDistance or 2.0

    for i = 1, #players do
        local playerId = players[i]
        local playerPed = GetPlayerPed(playerId)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(coords - playerCoords)

        if distance < maxDistance then
            maxDistance = distance
            closestId = playerId
            closestPed = playerPed
            closestCoords = playerCoords
        end
    end

    return closestId, closestPed, closestCoords
end

return PL.Player.GetServerClosestPlayer
