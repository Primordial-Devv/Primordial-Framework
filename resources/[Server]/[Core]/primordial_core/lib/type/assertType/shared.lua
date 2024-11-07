-- Validate the type of a value against a list of expected types.
---@param value any The value to validate.
---@param expectedTypes string|table The expected type(s) of the value.
---@return true|false boolean Wether the value is of the expected type.
---@return string string The actual type of the value or an error message if not
---@usage PL.Utils.AssertType("hello", "string") -- true, "ok, value is of type 'string'"
function PL.Type.AssertType(value, expectedTypes)
    local actualType = type(value)

    if type(expectedTypes) == "string" then
        if actualType == expectedTypes then
            return true, ("ok, value is of type '%s'"):format(actualType)
        end
    end

    if type(expectedTypes) == "table" and #expectedTypes > 0 then
        for _, expectedType in ipairs(expectedTypes) do
            if actualType == expectedType then
                return true, ("ok, value is of type '%s'"):format(actualType)
            end
        end
    end

    if type(expectedTypes) == "table" and next(expectedTypes) ~= nil and #expectedTypes == 0 then
        if expectedTypes[actualType] then
            return true, ("ok, value is of type '%s'"):format(actualType)
        end
    end

    local expectedTypesStr = ""
    if type(expectedTypes) == "string" then
        expectedTypesStr = expectedTypes    
    elseif type(expectedTypes) == "table" then
        expectedTypesStr = table.concat(expectedTypes, " or ")
    end

    error(("Type mismatch: expected '%s', got '%s'. Value: %s"):format(expectedTypesStr, actualType, tostring(value)), 2)
end

return PL.Type.AssertType