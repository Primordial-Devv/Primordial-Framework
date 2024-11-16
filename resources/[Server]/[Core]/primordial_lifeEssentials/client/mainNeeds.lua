local IsDead = false
local IsAnimated = false

AddEventHandler('primordial_lifeEssentials:client:resetStatus', function()
	TriggerEvent('primordial_lifeEssentials:client:set', 'hunger', 500000)
	TriggerEvent('primordial_lifeEssentials:client:set', 'thirst', 500000)
	TriggerEvent('primordial_lifeEssentials:client:set', 'drunk', 0)
end)

RegisterNetEvent('primordial_lifeEssentials:client:healPlayer')
AddEventHandler('primordial_lifeEssentials:client:healPlayer', function()

	TriggerEvent('primordial_lifeEssentials:client:set', 'hunger', 1000000)
	TriggerEvent('primordial_lifeEssentials:client:set', 'thirst', 1000000)
	TriggerEvent('primordial_lifeEssentials:client:set', 'drunk', 0)

	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('primordial_core:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('primordial_core:onPlayerSpawn', function(spawn)
	if IsDead then
		TriggerEvent('primordial_lifeEssentials:client:resetStatus')
	end

	IsDead = false
end)

AddEventHandler('primordial_lifeEssentials:client:loaded', function(status)
	TriggerEvent('primordial_core:client:registerStatus', 'hunger', 1000000, function(status)
		status.remove(100)
	end)

	TriggerEvent('primordial_core:client:registerStatus', 'thirst', 1000000, function(status)
		status.remove(75)
	end)
end)

AddEventHandler('primordial_lifeEssentials:client:onTick', function(data)
	local playerPed  = PlayerPedId()
	local prevHealth = GetEntityHealth(playerPed)
	local health     = prevHealth

	for _, v in pairs(data) do
		if v.name == 'hunger' and v.percent == 0 then
			if prevHealth <= 150 then
				health = health - 5
			else
				health = health - 1
			end
		elseif v.name == 'thirst' and v.percent == 0 then
			if prevHealth <= 150 then
				health = health - 5
			else
				health = health - 1
			end
		end
	end

	if health ~= prevHealth then SetEntityHealth(playerPed, health) end
end)

AddEventHandler('primordial_lifeEssentials:client:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('primordial_lifeEssentials:client:onUse')
AddEventHandler('primordial_lifeEssentials:client:onUse', function(type, prop_name, anim)
	if not IsAnimated then
		local anim = anim
		IsAnimated = true
		if type == 'food' then
			prop_name = prop_name or 'prop_cs_burger_01'
			anim = anim
		elseif type == 'drink' then
			prop_name = prop_name or 'prop_ld_flow_bottle'
			anim = anim
		end

		CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(joaat(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

            PL.Streaming.RequestAnimDict(anim.dict)
            TaskPlayAnim(playerPed, anim.dict, anim.name, anim.settings[1], anim.settings[2], anim.settings[3], anim.settings[4], anim.settings[5], anim.settings[6], anim.settings[7], anim.settings[8])
            RemoveAnimDict(anim.dict)

            Wait(3000)
            IsAnimated = false
            ClearPedSecondaryTask(playerPed)
            DeleteObject(prop)
		end)
	end
end)