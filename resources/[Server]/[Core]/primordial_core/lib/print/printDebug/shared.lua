-- --- Print a debug message to the console.
-- ---@param message string The message to print.
-- function PL.Print.Debug(message)
--     local resourceName = GetCurrentResourceName():upper()
--     print(('[^5%s] ^6[DEBUG] ^5: %s^7'):format(resourceName, message))
-- end

-- return PL.Print.Debug

--- Print a debug message to the console with support for multiple arguments and optional indentation for tables.
---@vararg any The message(s) or variable(s) to print.
---@param indent? boolean Whether to format tables with indentation (defaults to false).
function PL.Print.Debug(indent, ...)
    local invokingResource <const> = GetInvokingResource()
    local resourceName <const> = invokingResource and invokingResource:upper() or "UNKNOWN RESOURCE"
    local args = { ... }
    indent = type(indent) == "boolean" and indent or false

    -- Helper function to serialize values for printing.
    --- @param value any The value to serialize.
    --- @param level? number The current indentation level (used recursively).
    --- @return string The serialized string representation of the value.
    local function serialize(value, level)
        level = level or 0
        local valueType = type(value)
        local spacing = string.rep("  ", level)

        if valueType == "string" then
            return ('"%s"'):format(value)
        elseif valueType == "number" or valueType == "boolean" then
            return tostring(value)
        elseif valueType == "table" then
            local serializedTable = indent and "{\n" or "{ "
            for k, v in pairs(value) do
                local serializedKey = serialize(k)
                local serializedValue = serialize(v, level + 1)
                if indent then
                    serializedTable = serializedTable .. spacing .. "  [" .. serializedKey .. "] = " .. serializedValue .. ",\n"
                else
                    serializedTable = serializedTable .. "[" .. serializedKey .. "] = " .. serializedValue .. ", "
                end
            end
            serializedTable = indent and serializedTable:sub(1, -3) .. "\n" .. spacing .. "}" or serializedTable:sub(1, -3) .. " }"
            return serializedTable
        elseif valueType == "function" then
            return ("<function: %s>"):format(tostring(value))
        elseif valueType == "nil" then
            return "nil"
        else
            return ("<%s: %s>"):format(valueType, tostring(value))
        end
    end

    local debugMessage = ""
    for i, arg in ipairs(args) do
        debugMessage = debugMessage .. serialize(arg) .. (i < #args and ", " or "")
    end

    print(('[^5%s] ^6[DEBUG] ^5: %s^7'):format(resourceName, debugMessage))
end

return PL.Print.Debug