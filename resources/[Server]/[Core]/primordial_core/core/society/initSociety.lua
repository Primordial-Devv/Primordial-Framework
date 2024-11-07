function PL.InitSociety()
    local Jobs = {}

    local query = [[
        SELECT s.*, g.society_grade, g.grade_name, g.grade_label, g.grade_salary, g.isGradeWhitelisted
        FROM society s
        LEFT JOIN society_grades g ON s.name = g.society_name
    ]]

    local result = MySQL.query.await(query)

    if not result then
        PL.Print.Error('Failed to load societies and grades from the database')
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
                PL.Print.Warning(('Ignoring society grade for "%s" due to invalid salary value : %s'):format(row.name, row.grade_salary))
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
            PL.Print.Warning(('Ignoring society "%s" due to no society grades found'):format(society.name))
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
    PL.Print.Info('Societies have been loaded successfully.')
    return true
end

---@param source number
local function sendSocietyToPlayer(source)
    local player = PL.GetPlayerFromId(source);
    if (not player) then return end;
    local society <const> = player.getSociety();
    if (type(society) == "table") then
        player.triggerEvent('primordial_core:sendPlayerSociety', PL.Jobs[society.name]);
    end
end

AddEventHandler('primordial_core:playerLoaded', sendSocietyToPlayer);
AddEventHandler('primordial_core:setSociety', sendSocietyToPlayer);

function PL.RefreshSociety()
    if PL.InitSociety() then
        PL.Print.Info('Societies have been refreshed successfully.')
    else
        PL.Print.Error('Failed to refresh societies.')
    end
end

function PL.GetSocieties()
    return PL.Jobs
end

function PL.DoesSocietyExist(job, grade)
    return (PL.Jobs[job] and PL.Jobs[job].grades[tostring(grade)] ~= nil) or false
end