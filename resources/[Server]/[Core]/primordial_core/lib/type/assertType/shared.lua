--- Validate the type of a value against a list of expected types.
--- Supports all Lua types and custom validation functions.
--- @param value any The value to validate.
--- @param expectedTypes string|table|string[]|function The expected type(s) or custom validation function.
--- @return boolean success True if the value matches any of the expected types or passes the custom validation.
--- @return string message Confirmation or error message.
function PL.Type.AssertType(value, expectedTypes)
    local actualType <const> = type(value)

    local expectedList <const> = type(expectedTypes) == "string" and { expectedTypes } or expectedTypes

    if type(expectedList) == "function" then
        local success, errorMsg = expectedList(value)
        if success then
            return true, ("ok, value is valid: %s"):format(errorMsg or "validated by custom function")
        else
            error(("Validation failed: %s"):format(errorMsg or "value did not pass custom validation"), 2)
        end
    elseif type(expectedList) ~= "table" then
        error("Invalid expectedTypes parameter: must be a string, table, or function.", 2)
    end

    for _, expectedType in ipairs(expectedList) do
        if type(expectedType) == "string" and actualType == expectedType then
            return true, ("ok, value is of type '%s'"):format(actualType)
        elseif type(expectedType) == "function" then
            local success, errorMsg = expectedType(value)
            if success then
                return true, ("ok, value is valid: %s"):format(errorMsg or "validated by custom function")
            end
        end
    end

    local expectedTypesStr <const> = table.concat(expectedList, " or ")
    error(("Type mismatch: expected '%s', got '%s'. Value: %s"):format(expectedTypesStr, actualType, tostring(value)), 2)
end

return PL.Type.AssertType