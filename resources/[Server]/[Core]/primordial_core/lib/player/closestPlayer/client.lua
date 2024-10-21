--- Get the closest player to the specified coords from the client with a max distance and whether or not to include the current player.
---@param coords vector3 The coords to check from.
---@param maxDistance? number The max distance to check.
---@param includePlayer? boolean Whether or not to include the current player.
---@return number closestId The closest player's server ID.
---@return number closestPed The closest player's ped.
---@return vector3 closestCoords The closest player's coords.
function PL.Player.GetClosestPlayer(coords, maxDistance, includePlayer)
	local players = GetActivePlayers()
	local closestId, closestPed, closestCoords
	maxDistance = maxDistance or 2.0

	for i = 1, #players do
		local playerId = players[i]

		if playerId ~= cache.playerId or includePlayer then
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
	end

	return closestId, closestPed, closestCoords
end

return PL.Player.GetClientClosestPlayer
