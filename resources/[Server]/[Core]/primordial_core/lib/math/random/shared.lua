--- Generate a random number between a range
---@param minRange number The minimum range
---@param maxRange number The maximum range
---@return number random The random number
function PL.Math.Random(minRange, maxRange)
    math.randomseed(GetGameTimer())
    return math.random(minRange or 1, maxRange or 10)
end

return PL.Math.Random