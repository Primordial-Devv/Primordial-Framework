Locales = {}

function _L(key)
    local lang = GetConvar("illenium-appearance:locale", "en")
    if not Locales[lang] then
        lang = "en"
    end
    local value = Locales[lang]
    for k in key:gmatch("[^.]+") do
        value = value[k]
        if not value then
            PL.Print.Log(3, false, "Missing locale for: " .. key)
            return ""
        end
    end
    return value
end
