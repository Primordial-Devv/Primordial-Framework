local OriginalStatus, Status = {}, {}

function GetStatusData(minimal)
	local status = {}

	for i=1, #Status, 1 do
		if minimal then
			table.insert(status, {
				name    = Status[i].name,
				val     = Status[i].val,
				percent = PL.Math.Round((Status[i].val / 1000000) * 100, 2)
			})
		else
			table.insert(status, {
				name    = Status[i].name,
				val     = Status[i].val,
				color   = Status[i].color,
				visible = Status[i].visible(Status[i]),
				percent = PL.Math.Round((Status[i].val / 1000000) * 100, 2)
			})
		end
	end

	return status
end

AddEventHandler('primordial_core:client:registerStatus', function(name, default, tickCallback)
	local status = CreateLifeEssentials(name, default, tickCallback)
	
	for i=1, #OriginalStatus, 1 do
		if status.name == OriginalStatus[i].name then
			status.set(OriginalStatus[i].val)
		end
	end

	table.insert(Status, status)
end)

AddEventHandler('primordial_lifeEssentials:client:unregisterStatus', function(name)
	for k,v in ipairs(Status) do
		if v.name == name then
			table.remove(Status, k)
			break
		end
	end
end)

RegisterNetEvent('primordial_core:onPlayerLogout')
AddEventHandler('primordial_core:onPlayerLogout', function()
	PL.PlayerLoaded = false
	Status = {}
end)

RegisterNetEvent('primordial_lifeEssentials:client:load')
AddEventHandler('primordial_lifeEssentials:client:load', function(status)
	OriginalStatus = status
	PL.PlayerLoaded = true
	TriggerEvent('primordial_lifeEssentials:client:loaded')

	CreateThread(function()
		local data = {}
		while PL.PlayerLoaded do
			for i=1, #Status do
				Status[i].onTick()
				table.insert(data, {
					name = Status[i].name,
					val = Status[i].val,
					percent = (Status[i].val / 1000000) * 100
				})
			end

			TriggerEvent('primordial_lifeEssentials:client:onTick', data)
			table.wipe(data)
			Wait(1000)
		end
	end)
end)

RegisterNetEvent('primordial_lifeEssentials:client:set')
AddEventHandler('primordial_lifeEssentials:client:set', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].set(val)
			break
		end
	end
end)

RegisterNetEvent('primordial_lifeEssentials:client:add')
AddEventHandler('primordial_lifeEssentials:client:add', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].add(val)
			break
		end
	end
end)

RegisterNetEvent('primordial_lifeEssentials:client:remove')
AddEventHandler('primordial_lifeEssentials:client:remove', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].remove(val)
			break
		end
	end
end)

AddEventHandler('primordial_lifeEssentials:client:getStatus', function(name, cb)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			cb(Status[i])
			return
		end
	end
end)

AddEventHandler('primordial_lifeEssentials:client:getAllStatus', function(cb)
	cb(Status)
end)

-- Update server
CreateThread(function()
	while true do
		Wait(30000)
		PL.Print.Log(1, true, ('Player status : %s'):format(GetStatusData(true)))
		if PL.PlayerLoaded then TriggerServerEvent('primordial_lifeEssentials:server:update', GetStatusData(true)) end
	end
end)
