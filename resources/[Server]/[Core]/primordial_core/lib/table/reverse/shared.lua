--- Return a new table with all elements reversed
---@param tab table The table to reverse the elements of
---@return table newTable The reversed table
function PL.Table.Reverse(tab)
    local newTable = {}

    for i = #tab, 1, -1 do
        table.insert(newTable, tab[i])
    end

    return newTable
end

return PL.Table.Reverse