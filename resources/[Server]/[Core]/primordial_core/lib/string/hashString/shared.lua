-- Hash a string to a control strings
---@param str string The string to hash
---@return string formattedHash The formatted hash string
PL.String.HashString = function(str)
    local hash = joaat(str)
    local formattedHash = string.format("~INPUT_%s~", string.upper(string.format("%x", hash)))

    if string.find(formattedHash, "FFFFFFFF") then
        formattedHash = string.gsub(formattedHash, "FFFFFFFF", "")
    end

    return formattedHash
end

return PL.String.HashString