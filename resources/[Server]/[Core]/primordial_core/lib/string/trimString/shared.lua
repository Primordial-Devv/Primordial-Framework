--- Trim a string
---@param value string The string to trim
function PL.String.Trim(value)
    if value then
        return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
    else
        return nil
    end
end

return PL.Math.Trim