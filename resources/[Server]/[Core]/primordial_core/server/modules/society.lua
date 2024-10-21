local Jobs = setmetatable({}, {__index = function(_, key)
	return PL.GetJobs()[key]
end
})
local RegisteredSocieties = {}
local SocietiesByName = {}

function GetSociety(name)
	return SocietiesByName[name]
end
exports("GetSociety", GetSociety)

function registerSociety(name, label, account, data)
	if SocietiesByName[name] then
		print(('[^3WARNING^7] society already registered, name: ^5%s^7'):format(name))
		return
	end

	local society = {
		name = name,
		label = label,
		account = account,
		inventory = inventory,
		data = data
	}

	SocietiesByName[name] = society
	table.insert(RegisteredSocieties, society)
end
AddEventHandler('primordial_core:server:registerSociety', registerSociety)
exports("registerSociety", registerSociety)

AddEventHandler('primordial_core:server:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('primordial_core:server:getSociety', function(name, cb)
	cb(GetSociety(name))
end)

RegisterServerEvent('primordial_core:server:checkSocietyBalance')
AddEventHandler('primordial_core:server:checkSocietyBalance', function(society)
	local sPlayer = PL.GetPlayerFromId(source)
	local society = GetSociety(society)

	if sPlayer.job.name ~= society.name then
		print(('primordial_core_society: %s attempted to call checkSocietyBalance!'):format(sPlayer.identifier))
		return
	end

	TriggerEvent('primordial_core:server:society:getSocietyAccount', society.account, function(account)
		lib.notify(sPlayer.source, {
			title = Translations.check_balance:format(PL.Math.GroupDigits(account.money)),
			type = 'info',
		})
	end)
end)

RegisterServerEvent('primordial_core:server:withdrawMoney')
AddEventHandler('primordial_core:server:withdrawMoney', function(societyName, amount)
	local source = source
	local society = GetSociety(societyName)
	if not society then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to withdraw from non-existing society - ^5%s^7!'):format(source, societyName))
		return
	end
	local sPlayer = PL.GetPlayerFromId(source)
	amount = PL.Math.Round(tonumber(amount))
	if sPlayer.job.name ~= society.name then
		return print(('[^3WARNING^7] Player ^5%s^7 attempted to withdraw from society - ^5%s^7!'):format(source, society.name))
	end

	TriggerEvent('primordial_core:server:society:getSocietyAccount', society.account, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			sPlayer.addMoney(amount, Translations.money_add_reason)
			lib.notify(sPlayer.source, {
				title = Translations.have_withdrawn:format(PL.Math.GroupDigits(amount)),
				type = 'info',
			})
		else
			lib.notify(sPlayer.source, {
				title = Translations.invalid_amount,
				type = 'error',
			})
		end
	end)
end)

RegisterServerEvent('primordial_core:server:depositMoney')
AddEventHandler('primordial_core:server:depositMoney', function(societyName, amount)
	local source = source
	local sPlayer = PL.GetPlayerFromId(source)
	local society = GetSociety(societyName)
	if not society then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to deposit to non-existing society - ^5%s^7!'):format(source, societyName))
		return
	end
	amount = PL.Math.Round(tonumber(amount))

	if sPlayer.job.name ~= society.name then
		return print(('[^3WARNING^7] Player ^5%s^7 attempted to deposit to society - ^5%s^7!'):format(source, society.name))
	end
	if amount > 0 and sPlayer.getMoney() >= amount then
		TriggerEvent('primordial_core:server:society:getSocietyAccount', society.account, function(account)
			sPlayer.removeMoney(amount, Translations.money_remove_reason)
			lib.notify(sPlayer.source, {
				title = Translations.have_deposited:format(PL.Math.GroupDigits(amount)),
				type = 'info',
			})
			account.addMoney(amount)
		end)
	else
		lib.notify(sPlayer.source, {
			title = Translations.invalid_amount,
			type = 'error',
		})
	end
end)

lib.callback.register('primordial_core:server:getSocietyMoney', function(source, societyName)
	local society = GetSociety(societyName)
	if not society then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to get money from non-existing society - ^5%s^7!'):format(source, societyName))
		return 0
	end
	if not society then
		return 0
	end
	TriggerEvent('primordial_core:server:society:getSocietyAccount', society.account, function(account)
		return account.money or 0
	end)
end)

lib.callback.register('primordial_core:server:getEmployees', function(source, society)
    local employees = {}
    -- print('[^2INFO^7] Callback triggered for society: ' .. society)

    local sPlayers = PL.GetExtendedPlayers('job', society)
    for i=1, #(sPlayers) do 
        local sPlayer = sPlayers[i]
        local name = sPlayer.name
        if name == GetPlayerName(sPlayer.source) then
            name = sPlayer.get('firstName') .. ' ' .. sPlayer.get('lastName')
        end

        table.insert(employees, {
            name = name,
            identifier = sPlayer.identifier,
            job = {
                name = society,
                label = sPlayer.job.label,
                grade = sPlayer.job.grade,
                grade_name = sPlayer.job.grade_name,
                grade_label = sPlayer.job.grade_label
            }
        })
    end

    local query = "SELECT identifier, job_grade, firstname, lastname FROM `users` WHERE `job`= ? ORDER BY job_grade DESC"
    print('[^2INFO^7] Executing SQL query: ' .. query)

    local promise = promise.new()
    MySQL.Async.fetchAll(query, {society}, function(result)
        for k, row in pairs(result) do
            local alreadyInTable = false
            local identifier = row.identifier

            for _, v in pairs(employees) do
                if v.identifier == identifier then
                    alreadyInTable = true
                    break
                end
            end

            if not alreadyInTable then
                local name = row.firstname .. ' ' .. row.lastname
                table.insert(employees, {
                    name = name,
                    identifier = identifier,
                    job = {
                        name = society,
                        label = Jobs[society].label,
                        grade = row.job_grade,
                        grade_name = Jobs[society].grades[tostring(row.job_grade)].name,
                        grade_label = Jobs[society].grades[tostring(row.job_grade)].label
                    }
                })
            end
        end

        -- print(('[^3INFO^7] %s has requested employees for society - ^5%s^7!'):format(PL.GetPlayerFromId(source).identifier, society))
        -- print(json.encode(employees, {indent = true}))

        promise:resolve(employees)
    end)

    local result = Citizen.Await(promise)
    return result
end)

lib.callback.register('primordial_core:server:getJob', function(source, society)
	if not Jobs[society] then
		return false
	end

	local job = json.decode(json.encode(Jobs[society]))
	local grades = {}

	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	return job
end)

lib.callback.register('primordial_core:server:setJob', function(source, identifier, job, grade, actionType)
	local sPlayer = PL.GetPlayerFromId(source)
	local isBoss = SocietyBossGrades[sPlayer.job.grade_name]
	local xTarget = PL.GetPlayerFromIdentifier(identifier)

	if sPlayer.identifier == identifier then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to change his own grade!'):format(source))
		return false
	end

	if not isBoss then
		print(('[^3WARNING^7] Player ^5%s^7 attempted to setJob for Player ^5%s^7!'):format(source, xTarget.source))
		return false
	end

	if not xTarget then
		MySQL.update('UPDATE users SET job = ?, job_grade = ? WHERE identifier = ?', {job, grade, identifier})
		return true
	end

	xTarget.setJob(job, grade)

	if actionType == 'hire' then
		lib.notify(xTarget.source, {
			title = Translations.you_have_been_hired:format(job),
			type = 'info',
		})
		lib.notify(sPlayer.source, {
			title = Translations.you_have_hired:format(xTarget.getName()),
			type = 'info',
		})
	elseif actionType == 'promote' then
		lib.notify(xTarget.source, {
			title = Translations.you_have_been_promoted,
			type = 'info',
		})
		lib.notify(sPlayer.source, {
			title = Translations.you_have_promoted:format(xTarget.getName(), xTarget.getJob().label),
			type = 'info',
		})
	elseif actionType == 'fire' then
		lib.notify(xTarget.source, {
			title = Translations.you_have_been_fired:format(xTarget.getJob().label),
			type = 'info',
		})
		lib.notify(sPlayer.source, {
			title = Translations.you_have_fired:format(xTarget.getName()),
			type = 'info',
		})
	end
	return true
end)

lib.callback.register('primordial_core:server:setJobSalary', function(source, job, grade, salary)
	local sPlayer = PL.GetPlayerFromId(source)

	if sPlayer.job.name == job and SocietyBossGrades[sPlayer.job.grade_name] then
		if salary <= MaxEmployeeSalary then
			MySQL.update('UPDATE job_grades SET salary = ? WHERE job_name = ? AND grade = ?', {salary, job, grade}, function(rowsChanged)
				Jobs[job].grades[tostring(grade)].salary = salary
				PL.RefreshJobs()
				Wait(1)
				local sPlayers = PL.GetExtendedPlayers('job', job)
				for _, xTarget in pairs(sPlayers) do

					if xTarget.job.grade == grade then
						xTarget.setJob(job, grade)
					end
				end
				return
			end)
			return true
		else
			print(('[^3WARNING^7] Player ^5%s^7 attempted to setJobSalary over the config limit for ^5%s^7!'):format(source, job))
			return false
		end
	else
		print(('[^3WARNING^7] Player ^5%s^7 attempted to setJobSalary for ^5%s^7!'):format(source, job))
		return false
	end
end)

lib.callback.register('primordial_core:server:setJobLabel', function(source, job, grade, label)
	local sPlayer = PL.GetPlayerFromId(source)

	if sPlayer.job.name == job and SocietyBossGrades[sPlayer.job.grade_name] then
		MySQL.update('UPDATE job_grades SET label = ? WHERE job_name = ? AND grade = ?', {label, job, grade}, function(rowsChanged)
			Jobs[job].grades[tostring(grade)].label = label
			PL.RefreshJobs()
			Wait(1)
			local sPlayers = PL.GetExtendedPlayers('job', job)
			for _, xTarget in pairs(sPlayers) do

				if xTarget.job.grade == grade then
					xTarget.setJob(job, grade)
				end
			end
			return
		end)
		return true
	else
		print(('[^3WARNING^7] Player ^5%s^7 attempted to setJobLabel for ^5%s^7!'):format(source, job))
		return false
	end
end)

local getOnlinePlayers, onlinePlayers = false, {}
lib.callback.register('primordial_core:server:getOnlinePlayers', function(source)
	if getOnlinePlayers == false and next(onlinePlayers) == nil then
		getOnlinePlayers = true
		onlinePlayers = {}

		local sPlayers = PL.GetExtendedPlayers()
		for i=1, #(sPlayers) do 
			local sPlayer = sPlayers[i]
			table.insert(onlinePlayers, {
				source = sPlayer.source,
				identifier = sPlayer.identifier,
				name = sPlayer.name,
				job = sPlayer.job
			})
		end

		print('[^2INFO^7] Retrieved online players list: ' .. json.encode(onlinePlayers, {indent = true}))
		local result = onlinePlayers
		getOnlinePlayers = false
		Wait(1000)
		onlinePlayers = {}
		return result
	end
	while getOnlinePlayers do Wait() end
	print('[^2INFO^7] Using cached online players list: ' .. json.encode(onlinePlayers, {indent = true}))
	return onlinePlayers
end)

lib.callback.register('primordial_core:server:isBoss', function(source, job)
	return isPlayerBoss(source, job)
end)

function isPlayerBoss(playerId, job)
	local sPlayer = PL.GetPlayerFromId(playerId)

	if sPlayer.job.name == job and SocietyBossGrades[sPlayer.job.grade_name] then
		return true
	else
		print(('primordial_core_society: %s attempted open a society boss menu!'):format(sPlayer.identifier))
		return false
	end
end