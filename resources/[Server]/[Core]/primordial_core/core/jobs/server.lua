function PL.RefreshJobs()
    local Jobs = {}
    local jobs = MySQL.query.await("SELECT * FROM jobs")

    for _, v in ipairs(jobs) do
        Jobs[v.name] = v
        Jobs[v.name].grades = {}
    end

    local jobGrades = MySQL.query.await("SELECT * FROM job_grades")

    for _, v in ipairs(jobGrades) do
        if Jobs[v.job_name] then
            Jobs[v.job_name].grades[tostring(v.grade)] = v
        else
            print(('[^3WARNING^7] Ignoring job grades for ^5"%s"^0 due to missing job'):format(v.job_name))
        end
    end

    for _, v in pairs(Jobs) do
        if PL.Table.SizeOf(v.grades) == 0 then
            Jobs[v.name] = nil
            print(('[^3WARNING^7] Ignoring job ^5"%s"^0 due to no job grades found'):format(v.name))
        end
    end

    if not Jobs then
        -- Fallback data, if no jobs exist
        PL.Jobs["unemployed"] = { label = "Unemployed", grades = { ["0"] = { grade = 0, label = "Unemployed", salary = 200 } } }
    else
        PL.Jobs = Jobs
    end
end

function PL.GetJobs()
    return PL.Jobs
end

function PL.DoesJobExist(job, grade)
    return (PL.Jobs[job] and PL.Jobs[job].grades[tostring(grade)] ~= nil) or false
end