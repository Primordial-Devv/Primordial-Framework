---Converts input number into grouped digits
---@param number number The numbers to group
---@param seperator? string The seperator to use
---@return string grouped The grouped number
function PL.Math.GroupDigits(number, seperator)
    local left, num, right = string.match(number, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. (seperator or ',')):reverse()) .. right
end

return PL.Math.GroupDigits