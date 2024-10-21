--- @param t table The table to convert to a set
--- @return table set The set
function PL.Table.Set(t)
    local set = {}
    for _, v in ipairs(t) do
        set[v] = true
    end
    return set
end

return PL.Table.Set