--- Round a number to a specified number of decimal places.
---@param value number The number to round
---@param numDecimalPlaces number The number of decimal places to round to
---@return number rounded The rounded number
function PL.Math.Round(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10 ^ numDecimalPlaces
        return math.floor((value * power) + 0.5) / power
    else
        return math.floor(value + 0.5)
    end
end

return PL.Math.Round