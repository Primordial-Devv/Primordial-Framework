--- Print a log message to the console with support for multiple levels and arguments.
---@alias LogLevel number
---| 1 INFO
---| 2 WARN
---| 3 ERROR
---| 4 DEBUG

local LOG_LEVELS <const> = {
    [1] = { label = "INFO", color = "^7" },
    [2] = { label = "WARN", color = "^3" },
    [3] = { label = "ERROR", color = "^1" },
    [4] = { label = "DEBUG", color = "^6" },
}

--- Serialize a value into a string representation for printing.
---@param value any The value to serialize.
---@param level? number The current indentation level (used recursively).
---@return string The serialized string representation of the value.
local function serialize(value, level)
    level = level or 0
    local valueType = type(value)
    local spacing <const> = string.rep("  ", level)

    if valueType == "string" then
        return ('"%s"'):format(value)
    elseif valueType == "number" or valueType == "boolean" then
        return tostring(value)
    elseif valueType == "table" then
        local serializedTable = "{\n"
        for k, v in pairs(value) do
            local serializedKey = serialize(k)
            local serializedValue = serialize(v, level + 1)
            serializedTable = serializedTable .. spacing .. "  [" .. serializedKey .. "] = " .. serializedValue .. ",\n"
        end
        serializedTable = serializedTable:sub(1, -3) .. "\n" .. spacing .. "}"
        return serializedTable
    elseif valueType == "function" then
        return ("<function: %s>"):format(tostring(value))
    elseif valueType == "nil" then
        return "nil"
    else
        return ("<%s: %s>"):format(valueType, tostring(value))
    end
end

--- Print a log message to the console.
---@param level LogLevel The level of the log (1 = INFO, 2 = WARN, 3 = ERROR, 4 = DEBUG).
---@vararg any The message(s) or variable(s) to print.
function PL.Print.Log(level, ...)
    local invokingResource <const> = GetInvokingResource()
    local resourceName <const> = invokingResource and invokingResource:upper() or "UNKNOWN RESOURCE"
    local args = { ... }

    local levelDetails <const> = LOG_LEVELS[level] or LOG_LEVELS[1]

    local logMessage = ""
    for i, arg in ipairs(args) do
        logMessage = logMessage .. serialize(arg, 0) .. (i < #args and ", " or "")
    end

    print(('[^5%s] %s[%s] ^5: %s^7'):format(resourceName, levelDetails.color, levelDetails.label, logMessage))
end

return PL.Print.Log