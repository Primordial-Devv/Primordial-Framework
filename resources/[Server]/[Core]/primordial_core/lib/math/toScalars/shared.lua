--- Convert a string input into a series of scalar values.
--- @param input string The input string to parse.
--- @param min number|nil The minimum allowed value for each scalar (optional).
--- @param max number|nil The maximum allowed value for each scalar (optional).
--- @param round number|boolean|nil If true, rounds all values; if a number, rounds up to that number of decimals (optional).
--- @return number|nil ... A series of scalar values, or nil if parsing fails.
function PL.Math.ToScalars(input, min, max, round)
    PL.Type.AssertType(input, "string")

    local scalars = {}
    local index = 0

    --- Parse a number and apply bounds and rounding.
    --- @param str string The string representation of the number.
    --- @param min number|nil The minimum value.
    --- @param max number|nil The maximum value.
    --- @param shouldRound boolean Whether to round the number.
    --- @return number|nil The parsed and validated number, or nil if invalid.
    local function parseNumber(str, min, max, shouldRound)
        local num = tonumber(str)
        if not num then
            return nil -- Return nil if conversion fails.
        end

        -- Clamp the number to the specified range.
        if min and num < min then num = min end
        if max and num > max then num = max end

        -- Round the number if required.
        if shouldRound then
            local factor = 10 ^ (type(shouldRound) == "number" and shouldRound or 0)
            num = math.floor(num * factor + 0.5) / factor
        end

        return num
    end

    for scalar in input:gsub("[%w]+%w?%(", ""):gmatch("(-?[%d%.]+)") do
        local shouldRound = round and (round == true or index < round)
        local num = parseNumber(scalar, min, max, shouldRound)

        if not num then
            PL.Print.Log(3, false, ("Failed to parse scalar at position %d in input: %s"):format(index + 1, scalar))
            return nil -- Return nil if any scalar is invalid.
        end

        index = index + 1
        scalars[index] = num
    end

    if index == 0 then
        PL.Print.Log(3,false, "No valid scalars found in the input string.")
        return nil -- Return nil if no scalars are found.
    end

    return table.unpack(scalars)
end

return PL.Math.ToScalars