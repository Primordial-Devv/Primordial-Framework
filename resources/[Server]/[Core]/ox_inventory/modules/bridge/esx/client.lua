local PL = setmetatable({}, {
	__index = function(self, index)
		local obj = exports.primordial_core:getSharedObject()
		self.SetPlayerData = obj.SetPlayerData
		self.PlayerLoaded = obj.PlayerLoaded
		return self[index]
	end
})

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerData(key, value)
	PlayerData[key] = value
	PL.SetPlayerData(key, value)
end

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
	for name, value in pairs(values) do
		if value > 0 then TriggerEvent('primordial_lifeEssentials:client:add', name, value) else TriggerEvent('primordial_lifeEssentials:client:remove', name, -value) end
	end
end

RegisterNetEvent('primordial_core:onPlayerLogout', client.onLogout)

AddEventHandler('primordial_core:setPlayerData', function(key, value)
	if not PlayerData.loaded or GetInvokingResource() ~= 'primordial_core' then return end

	if key == 'job' then
		key = 'groups'
		value = { [value.name] = value.grade }
	end

	PlayerData[key] = value
	OnPlayerData(key, value)
end)

local Weapon = require 'modules.weapon.client'

RegisterNetEvent('esx_policejob:handcuff', function()
	PlayerData.cuffed = not PlayerData.cuffed
	LocalPlayer.state:set('invBusy', PlayerData.cuffed, false)

	if not PlayerData.cuffed then return end

	Weapon.Disarm()
end)

RegisterNetEvent('esx_policejob:unrestrain', function()
	PlayerData.cuffed = false
	LocalPlayer.state:set('invBusy', PlayerData.cuffed, false)
end)
