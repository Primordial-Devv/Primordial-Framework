--- Returns the index of a value in a table
---@param table table The table to search in
---@param value any The value to search for in the table
---@return number index The index of the value in the table
function PL.Table.IndexOf(table, value)
    for i = 1, #table, 1 do
        if table[i] == value then
            return i
        end
    end

    return -1
end

return PL.Table.IndexOf