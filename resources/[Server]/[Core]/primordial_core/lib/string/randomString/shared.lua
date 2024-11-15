--- Generates a random string with the specified length and complexity level.
--- Complexity levels:
--- 1 = Only numbers (0-9).
--- 2 = Numbers (0-9) and lowercase letters (a-z).
--- 3 = Numbers (0-9), lowercase (a-z), and uppercase letters (A-Z).
--- 4 = Adds special characters (!@#$%^&*).
--- 5 = Fully random with all ASCII printable characters.
--- @param length number The length of the string to generate (must be >= 1).
--- @param complexity number The complexity level (1 to 5).
--- @return string|nil randomString The generated random string, or nil if parameters are invalid.
function PL.String.GetRandomString(length, complexity)
    PL.Type.AssertType(length, {"number"})
    PL.Type.AssertType(complexity, {"number"})

    if length < 1 then
        PL.Print.Error("Invalid length parameter. Must be >= 1.")
        return nil
    end

    if complexity < 1 or complexity > 5 then
        PL.Print.Error("Invalid complexity parameter. Must be between 1 and 5.")
        return nil
    end

    local Charset <const> = {}
    if complexity >= 1 then
        for i = 48, 57 do -- Numbers (0-9)
            Charset[#Charset + 1] = string.char(i)
        end
    end
    if complexity >= 2 then
        for i = 97, 122 do -- Lowercase letters (a-z)
            Charset[#Charset + 1] = string.char(i)
        end
    end
    if complexity >= 3 then
        for i = 65, 90 do -- Uppercase letters (A-Z)
            Charset[#Charset + 1] = string.char(i)
        end
    end
    if complexity >= 4 then
        for _, char in ipairs({"!", "@", "#", "$", "%", "^", "&", "*"}) do -- Special characters
            Charset[#Charset + 1] = char
        end
    end
    if complexity == 5 then
        for i = 32, 126 do -- All printable ASCII characters
            Charset[#Charset + 1] = string.char(i)
        end
    end

    local seed = GetGameTimer() + (os.time() or 0)
    math.randomseed(seed)

    local randomString = ""
    for _ = 1, length do
        randomString = randomString .. Charset[math.random(1, #Charset)]
    end

    return randomString
end

return PL.String.GetRandomString