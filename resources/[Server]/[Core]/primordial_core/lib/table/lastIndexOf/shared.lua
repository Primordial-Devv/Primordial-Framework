--- Returns the last index of a value in a table
---@param table table The table to search in
---@param value any The value to search for in the table
---@return number index The last index of the value in the table
function PL.Table.LastIndexOf(table, value)
    for i = #table, 1, -1 do
        if table[i] == value then
            return i
        end
    end

    return -1
end

return PL.Table.LastIndexOf