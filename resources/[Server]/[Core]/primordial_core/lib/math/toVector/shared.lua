--- Convert an input into a vector of the appropriate type (vector2, vector3, vector4).
--- @param input string|table The input to convert into a vector.
--- @param min number|nil The minimum allowed value for each component (optional).
--- @param max number|nil The maximum allowed value for each component (optional).
--- @param round number|boolean|nil If true, rounds all components; if a number, rounds to that many decimals (optional).
--- @return vector2|vector3|vector4|number The converted vector or scalar value.
function PL.Math.Tovector(input, min, max, round)
    PL.Type.AssertType(input, { "string", "table" })

    --- Helper to parse and validate numeric values.
    --- @param value number The value to parse.
    --- @return number The parsed value, clamped and optionally rounded.
    local function parseNumber(value, min, max, round)
        local num = tonumber(value)
        if not num then
            error(("Invalid value '%s' cannot be converted to a number."):format(tostring(value)), 2)
        end

        if min and num < min then num = min end
        if max and num > max then num = max end

        if round then
            local factor = 10 ^ (type(round) == "number" and round or 0)
            num = math.floor(num * factor + 0.5) / factor
        end

        return num
    end

    if type(input) == "string" then
        local scalars = { PL.Math.ToScalars(input, min, max, round) }
        if #scalars == 0 then
            error("No valid components found in the input string.", 2)
        end

        return #scalars == 4 and vector4(table.unpack(scalars))
            or #scalars == 3 and vector3(table.unpack(scalars))
            or #scalars == 2 and vector2(table.unpack(scalars))
            or scalars[1] + 0.0
    end

    if type(input) == "table" then
        local components = {}

        for _, v in ipairs(input) do
            components[#components + 1] = parseNumber(v, min, max, round)
        end

        return #components == 4 and vector4(table.unpack(components))
            or #components == 3 and vector3(table.unpack(components))
            or #components == 2 and vector2(table.unpack(components))
            or components[1] + 0.0 
    end

    error(("Cannot convert '%s' to a vector value."):format(type(input)), 2)
end

return PL.Math.Tovector