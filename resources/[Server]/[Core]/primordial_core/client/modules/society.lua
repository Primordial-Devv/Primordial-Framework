function OpenBossMenu(society, options)
	options = options or {}
	local elements = {}

	local isBoss = lib.callback.await('primordial_core:server:isBoss', false, society)
	if isBoss then
		local defaultOptions = {
			checkBal = true,
			withdraw = true,
			deposit = true,
			employees = true,
			salary = true,
			grades = true
		}

		for k,v in pairs(defaultOptions) do
			if options[k] == nil then
				options[k] = v
			end
		end

		if options.checkBal then
			table.insert(elements, {
				title = Translations.check_society_balance,
				description = Translations.check_society_balance,
				icon = "fas fa-wallet",
				onSelect = function()
					TriggerServerEvent('primordial_core:server:checkSocietyBalance', society)
				end
			})
		end
		if options.withdraw then
			table.insert(elements, {
				title = Translations.withdraw_society_money,
				description = Translations.withdraw_society_money,
				icon = "fas fa-wallet",
				onSelect = function()
					local input = lib.inputDialog(Translations.withdraw_society_money, {
						{
							type = 'number',
							label = 'Amount',
							description = Translations.withdraw_society_money,
							icon = 'hashtag',
							required = true
						}
					})

					if input then
						local amount = tonumber(input[1])
						if amount == nil then
							lib.notify({
								title = Translations.invalid_amount,
								type = 'error'
							})
						else
							TriggerServerEvent('primordial_core:server:withdrawMoney', society, amount)
						end
					else
						lib.notify({
							title = "No input",
							type = 'error'
						})
					end
				end
			})
		end
		if options.deposit then
			table.insert(elements, {
				title = Translations.deposit_society_money,
				description = Translations.deposit_society_money,
				icon = "fas fa-wallet",
				onSelect = function()
					local input = lib.inputDialog(Translations.deposit_society_money, {
						{
							type = 'number',
							label = 'Amount',
							description = Translations.deposit_society_money,
							icon = 'hashtag',
							required = true
						}
					})

					if input then
						local amount = tonumber(input[1])
						if amount == nil then
							lib.notify({
								title = Translations.invalid_amount,
								type = 'error'
							})
						else
							TriggerServerEvent('primordial_core:server:depositMoney', society, amount)
						end
					else
						lib.notify({
							title = "No input",
							type = 'error'
						})
					end
				end
			})
		end
		if options.employees then
			table.insert(elements, {
				title = Translations.employee_management,
				description = Translations.employee_management,
				icon = "fas fa-users",
				onSelect = function()
					OpenManageEmployeesMenu(society, options)
				end
			})
		end
		if options.salary then
			table.insert(elements, {
				title = Translations.salary_management,
				description = Translations.salary_management,
				icon = "fas fa-wallet",
				onSelect = function()
					OpenManageSalaryMenu(society, options)
				end
			})
		end
		if options.grades then
			table.insert(elements, {
				title = Translations.grade_management,
				description = Translations.grade_management,
				icon = "fas fa-scroll",
				onSelect = function()
					OpenManageGradesMenu(society, options)
				end
			})
		end

		lib.registerContext({
			id = "boss_menu",
			title = Translations.boss_menu,
			description = "boss menu",
			options = elements
		})

		lib.showContext("boss_menu")

	end
end

function OpenManageEmployeesMenu(society, options)
	lib.registerContext({
		id = "employee_management",
		title = Translations.employee_management,
		description = Translations.employee_management,
		icon = "fas fa-users",
		menu = "boss_menu",
		options = {
			{
				title = Translations.employee_list,
				description = Translations.employee_list,
				icon = "fas fa-users",
				onSelect = function()
					OpenEmployeeList(society, options)
				end
			},
			{
				title = Translations.recruit,
				description = Translations.recruit,
				icon = "fas fa-users",
				onSelect = function()
					OpenRecruitMenu(society, options)
				end
			}
		}
	})

	lib.showContext("employee_management")
end

function OpenEmployeeList(society, options)
    local employees = lib.callback.await('primordial_core:server:getEmployees', false, society)

    local elements = {}

    for i = 1, #employees, 1 do
        local gradeLabel = (employees[i].society.grade_label == '' and employees[i].society.label or employees[i].society.grade_label)
        local data = employees[i]

        table.insert(elements, {
            title = employees[i].name .. " | " .. gradeLabel,
            icon = "fas fa-user",
            onSelect = function()
                local employee = data

                lib.registerContext({
                    id = "employees_action",
                    title = employees[i].name .. " | " .. gradeLabel,
                    icon = "fas fa-user",
                    menu = "employee_list",
                    options = {
                        {
                            title = Translations.promote,
                            icon = "fas fa-users",
                            onSelect = function()
                                OpenPromoteMenu(society, employee, options)
                            end
                        },
                        {
                            title = Translations.fire,
                            icon = "fas fa-users",
                            onSelect = function()
                                lib.notify({
                                    title = Translations.you_have_fired:format(employee.name),
                                    type = 'info'
                                })

								local success = lib.callback.await('primordial_core:server:setJob', false, employee.identifier, 'unemployed', 0, 'fire')
								if success then
									OpenEmployeeList(society, options)
								else
									PL.Print.Log(3, "Failed to fire employee.")
								end
                            end
                        }
                    }
                })

                lib.showContext("employees_action")
            end
        })
    end

    lib.registerContext({
        id = "employee_list",
        title = Translations.employees_title,
        icon = "fas fa-users",
        menu = "employee_management",
        options = elements
    })

    lib.showContext("employee_list")
end

function OpenRecruitMenu(society, options)
	local players = lib.callback.await('primordial_core:server:getOnlinePlayers', false)
	local elements = {}

	for i = 1, #players, 1 do
		if players[i].society.name ~= society then
			table.insert(elements, {
				title = players[i].name,
				icon = "fas fa-user",
				onSelect = function()
					lib.notify({
						title = Translations.you_have_hired:format(players[i].name),
						type = 'info'
					})

					local success = lib.callback.await('primordial_core:server:setJob', false, players[i].identifier, society, 0, 'society')
					if success then
						OpenRecruitMenu(society, options)
					else
						PL.Print.Log(3, "Failed to hire employee.")
					end
				end
			})
		end
	end

	lib.registerContext({
		id = "recruit_menu",
		title = Translations.recruiting,
		icon = "fas fa-users",
		menu = "employee_management",
		options = elements
	})

	lib.showContext("recruit_menu")
end

function OpenPromoteMenu(society, employee, options)
	local job = lib.callback.await('primordial_core:server:getJob', false, society)
	if not job then
		return
	end

	local elements = {}

	for i = 1, #job.grades, 1 do
		local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
		table.insert(elements, {
			title = gradeLabel,
			icon = "fas fa-user",
			onSelect = function()
				local success = lib.callback.await('primordial_core:server:setJob', false, employee.identifier, society, job.grades[i].grade, 'promote')
				if success then
					OpenEmployeeList(society, options)
				else
					PL.Print.Log(3, "Failed to promote employee.")
				end
			end
		})
	end

	lib.registerContext({
		id = "promote_menu",
		title = Translations.promote_employee:format(employee.name),
		icon = "fas fa-users",
		menu = "employee_list",
		options = elements
	})

	lib.showContext("promote_menu")
end

function OpenManageSalaryMenu(society, options)
	local job = lib.callback.await('primordial_core:server:getJob', false, society)
	if not job then
		return
	end

	local elements = {}

	for i=1, #job.grades, 1 do
		local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
		table.insert(elements, {
			title = gradeLabel .. " : ".. PL.Math.GroupDigits(job.grades[i].salary .. Translations.currency),
			icon = "fas fa-wallet",
			onSelect = function()
				local input = lib.inputDialog(Translations.amount_title, {
					{
						type = 'number',
						label = 'Amount',
						description = Translations.change_salary_description,
						icon = 'hashtag',
						required = true
					}
				})

				if input then
					local amount = tonumber(input[1])
					if amount == nil then
						lib.notify({
							title = Translations.invalid_value_nochanges,
							type = 'error'
						})
						OpenManageSalaryMenu(society, options)
					elseif amount > MaxEmployeeSalary then
						lib.notify({
							title = Translations.invalid_amount_max,
							type = 'error'
						})
						OpenManageSalaryMenu(society, options)
					else
						local success = lib.callback.await('primordial_core:server:setJobSalary', false, society, job.grades[i].grade, amount)
						if success then
							OpenManageSalaryMenu(society, options)
						else
							PL.Print.Log(3, "Failed to change job salary.")
						end
					end
				else
					lib.notify({
						title = "No input",
						type = 'error'
					})
				end
			end
		})
	end

	lib.registerContext({
		id = "manage_salary_menu",
		title = Translations.salary_management,
		icon = "fas fa-users",
		menu = "boss_menu",
		options = elements
	})

	lib.showContext("manage_salary_menu")
end

function OpenManageGradesMenu(society, options)
	local job = lib.callback.await('primordial_core:server:getJob', false, society)
	if not job then
		return
	end

	local elements = {}

	for i=1, #job.grades, 1 do
		local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

		table.insert(elements, {
			title = ('%s'):format(gradeLabel),
			icon = "fas fa-wallet",
			onSelect = function()
				local input = lib.inputDialog(Translations.change_label_title, {
					{
						type = 'input',
						label = 'Name',
						description = Translations.change_label_description,
						icon = 'hashtag',
						required = true
					}
				})

				if input then
					local label = tostring(input[1])
					local success = lib.callback.await('primordial_core:server:setJobLabel', false, society, job.grades[i].grade, label)
					if success then
						OpenManageGradesMenu(society, options)
					else
						PL.Print.Log(3, "Failed to change job label.")
					end
				else
					lib.notify({
						title = "No input",
						type = 'error'
					})
				end
			end
		})
	end

	lib.registerContext({
		id = "manage_grades_menu",
		title = Translations.grade_management,
		icon = "fas fa-wallet",
		menu = "boss_menu",
		options = elements
	})

	lib.showContext("manage_grades_menu")
end

AddEventHandler('primordial_core:client:openBossMenu', function(society, options)
	OpenBossMenu(society, options)
end)