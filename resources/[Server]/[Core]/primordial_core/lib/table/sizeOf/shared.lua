--- Returns the size of a table
---@param table table The table to get the size of
---@return number size The size of the table
function PL.Table.SizeOf(table)
    local count = 0

    for _, _ in pairs(table) do
        count = count + 1
    end

    return count
end

return PL.Table.SizeOf