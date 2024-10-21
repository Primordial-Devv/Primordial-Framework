-- Credit: https://stackoverflow.com/a/15706820           
--- Return a new table with all elements sorted by the order function
---@param tab table The table to sort the elements of
---@param order function The order function to sort the elements with
---@return function iterator The iterator function to iterate over the sorted table
function PL.Table.Sort(tab, order)
    -- collect the keys
    local keys = {}

    for k, _ in pairs(tab) do
        keys[#keys + 1] = k
    end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a, b)
            return order(tab, a, b)
        end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0

    return function()
        i = i + 1
        if keys[i] then
            return keys[i], tab[keys[i]]
        end
    end
end

return PL.Table.Sort