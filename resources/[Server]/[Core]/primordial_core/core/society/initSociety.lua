--- Initializes the societies and their grades from the database.
---@return boolean success True if the societies were loaded successfully, false otherwise.
function PL.InitSociety()
    local Jobs = {}

    local query <const> = [[
        SELECT s.*, g.society_grade, g.grade_name, g.grade_label, g.grade_salary, g.isGradeWhitelisted
        FROM society s
        LEFT JOIN society_grades g ON s.name = g.society_name
    ]]

    local result <const> = MySQL.query.await(query)

    if not result then
        PL.Print.Log(3, 'Failed to load societies and grades from the database')
        return false
    end

    for _, row in ipairs(result) do
        if not Jobs[row.name] then
            Jobs[row.name] = {
                id = row.id,
                name = row.name,
                label = row.label,
                registration_number = row.registration_number,
                money = row.money,
                iban = row.iban,
                isWhitelisted = row.isWhitelisted,
                grades = {}
            }
        end

        if row.society_grade then
            local salary = tonumber(row.grade_salary)
            if not salary or salary < 0 then
                PL.Print.Log(2, ('Ignoring society grade for "%s" due to invalid salary value : %s'):format(row.name, row.grade_salary))
            else
                Jobs[row.name].grades[tostring(row.society_grade)] = {
                    grade = row.society_grade,
                    name = row.grade_name,
                    label = row.grade_label,
                    salary = salary,
                    isWhitelisted = row.isGradeWhitelisted
                }
            end
        end
    end

    for name, society in pairs(Jobs) do
        if PL.Table.SizeOf(society.grades) == 0 then
            Jobs[name] = nil
            PL.Print.Log(2, ('Ignoring society "%s" due to no society grades found'):format(society.name))
        end
    end

    if next(Jobs) == nil then
        PL.Jobs['unemployed'] = {
            label = 'Unemployed',
            registration_number = '000000',
            money = 0,
            iban = '000000000',
            isWhitelisted = false,
            grades = {
                ['0'] = {
                    grade = 0,
                    name = 'unemployed',
                    label = 'Unemployed',
                    salary = 100,
                    isWhitelisted = false
                }
            }
        }
    else
        PL.Jobs = Jobs
    end

    TriggerEvent('primordial_core:server:societyLoaded', PL.Jobs)
    PL.Print.Log(1, 'Societies have been loaded successfully.')
    return true
end

--- Sends the society data to a specific player.
---@param source number The player ID to send the society data to.
local function sendSocietyToPlayer(source)
    local player <const> = PL.GetPlayerFromId(source)
    if (not player) then return end;

    local society <const> = player.getSociety();
    if (type(society) == "table") then
        player.triggerEvent('primordial_core:sendPlayerSociety', PL.Jobs[society.name]);
    end
end

AddEventHandler('primordial_core:playerLoaded', sendSocietyToPlayer);
AddEventHandler('primordial_core:setSociety', sendSocietyToPlayer);

--- Refreshes the societies and their grades from the database.
---@return boolean success True if the societies were refreshed successfully, false otherwise.
function PL.RefreshSociety()
    if PL.InitSociety() then
        PL.Print.Log(1, 'Societies have been refreshed successfully.')
        return true
    else
        PL.Print.Log(3, 'Failed to refresh societies.')
        return false
    end
end

--- Get all societies and grades.
--- @return table societies A table containing all societies and their grades.
function PL.GetSocieties()
    return PL.Jobs
end

--- Check if a society and grade exist.
--- @param job string The society's name.
--- @param grade number The grade level.
--- @return boolean exists True if the society and grade exist, false otherwise.
function PL.DoesSocietyExist(job, grade)
    return (PL.Jobs[job] and PL.Jobs[job].grades[tostring(grade)] ~= nil) or false
end