--- Return the index of the first element in the table that satisfies the callback function
---@param table table The table to search in
---@param cb function The callback function to search the table
---@return number index The index of the element that satisfies the callback function
function PL.Table.FindIndex(table, cb)
    for i = 1, #table, 1 do
        if cb(table[i]) then
            return i
        end
    end

    return -1
end

return PL.Table.FindIndex