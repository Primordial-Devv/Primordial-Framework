local function setPlayerStatus(sPlayer, data)
	data = data and json.decode(data) or {}

	sPlayer.set('status', data)
	PL.Players[sPlayer.source] = data
	TriggerClientEvent('primordial_lifeEssentials:client:load', sPlayer.source, data)
end

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
		return
	end

	for _, sPlayer in pairs(PL.Players) do
		MySQL.scalar('SELECT status FROM users WHERE identifier = ?', { sPlayer.identifier }, function(result)
			setPlayerStatus(sPlayer, result)
		end)
	end
end)

AddEventHandler('primordial_core:playerLoaded', function(playerId, sPlayer)
	MySQL.scalar('SELECT status FROM users WHERE identifier = ?', { sPlayer.identifier }, function(result)
		setPlayerStatus(sPlayer, result)
	end)
end)

AddEventHandler('primordial_core:playerDropped', function(playerId, reason)
	local sPlayer = PL.GetPlayerFromId(playerId)
	local status = PL.Players[sPlayer.source]

	MySQL.update('UPDATE users SET status = ? WHERE identifier = ?', { json.encode(status), sPlayer.identifier })
	PL.Players[sPlayer.source] = nil
end)

AddEventHandler('primordial_lifeEssentials:client:getStatus', function(playerId, statusName, cb)
	local status = PL.Players[playerId]
	for i = 1, #status do
		if status[i].name == statusName then
			return cb(status[i])
		end
	end
end)

RegisterServerEvent('primordial_lifeEssentials:server:update')
AddEventHandler('primordial_lifeEssentials:server:update', function(status)
	local sPlayer = PL.GetPlayerFromId(source)
	if sPlayer then
		sPlayer.set('status', status)	-- save to sPlayer for compatibility
		PL.Players[sPlayer.source] = status	-- save locally for performance
	end
end)

CreateThread(function()
	while true do
		Wait(10 * 60 * 1000)
		local parameters = {}
		for _, sPlayer in pairs(PL.GetExtendedPlayers()) do
			local status = PL.Players[sPlayer.source]
			if status and next(status) then
				parameters[#parameters+1] = {json.encode(status), sPlayer.identifier}
			end
		end
		if #parameters > 0 then
			MySQL.prepare('UPDATE users SET status = ? WHERE identifier = ?', parameters)
		end
	end
end)
