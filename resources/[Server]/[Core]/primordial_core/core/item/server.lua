--- Register an item to be usable by a player
---@param item string The item name to register
---@param cb function The callback function to be called when the item is used
function PL.RegisterUsableItem(item, cb)
    PL.UsableItemsCallbacks[item] = cb
end

--- Register an item to be used by a player
---@param source number The player server ID
---@param item string The item name to use
---@param ... any The arguments to pass to the item callback
function PL.UseItem(source, item, ...)
    if PL.Items[item] then
        local itemCallback = PL.UsableItemsCallbacks[item]

        if itemCallback then
            local success, result = pcall(itemCallback, source, item, ...)

            if not success then
                return result and print(result) or print(('[^3WARNING^7] An error occured when using item ^5"%s"^7! This was not caused by Primordial Core.'):format(item))
            end
        end
    else
        print(('[^3WARNING^7] Item ^5"%s"^7 was used but does not exist!'):format(item))
    end
end

--- Get the label of an item
---@param item string The item name
---@return string itemLabel The item label
function PL.GetItemLabel(item)
    item = exports.ox_inventory:Items(item)
    if item then
        return item.label
    end

    if PL.Items[item] then
        return PL.Items[item].label
    else
        print(("[^3WARNING^7] Attemting to get invalid Item -> ^5%s^7"):format(item))
    end
end

--- Get all usable items registered
---@return table Usables The usable items
function PL.GetUsableItems()
    local Usables = {}
    for k in pairs(PL.UsableItemsCallbacks) do
        Usables[k] = true
    end
    return Usables
end