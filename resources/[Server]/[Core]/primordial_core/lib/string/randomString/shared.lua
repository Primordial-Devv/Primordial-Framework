--- Return a random string with the given length
---@param length number The length of the string to generate
---@return string randomString The random string generated
function PL.String.GetRandomString(length)
    local Charset = {}

    for i = 48, 57 do
        table.insert(Charset, string.char(i))
    end
    for i = 65, 90 do
        table.insert(Charset, string.char(i))
    end
    for i = 97, 122 do
        table.insert(Charset, string.char(i))
    end
    math.randomseed(GetGameTimer())

    return length > 0 and PL.Print.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)] or ""
end

return PL.Print.GetRandomString