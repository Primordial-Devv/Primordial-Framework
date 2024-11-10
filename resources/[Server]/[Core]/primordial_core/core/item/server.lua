function PL.RegisterUsableItem(item, cb)
    PL.UsableItemsCallbacks[item] = cb
    exports['qs-inventory']:CreateUsableItem(item, cb)
end

exports('GetUsableItems', function()
    return PL.UsableItemsCallbacks
end)

function PL.UseItem(source, item, ...)
    if PL.Items[item] then
        -- local itemCallback = PL.UsableItemsCallbacks[item]

        return exports['qs-inventory']:UseItem(item, source, ...)

        -- if itemCallback then
        --     local success, result = pcall(itemCallback, source, item, ...)

        --     if not success then
        --         return result and print(result) or print(('[^3WARNING^7] An error occured when using item ^5"%s"^7! This was not caused by PL.'):format(item))
        --     end
        -- end
    else
        print(('[^3WARNING^7] Item ^5"%s"^7 was used but does not exist!'):format(item))
    end
end

function PL.GetItemLabel(item)
    return exports['qs-inventory']:GetItemLabel(item)
    -- item = exports.ox_inventory:Items(item)
    -- if item then
    --     return item.label
    -- end

    -- if PL.Items[item] then
    --     return PL.Items[item].label
    -- else
    --     print(("[^3WARNING^7] Attemting to get invalid Item -> ^5%s^7"):format(item))
    -- end
end

function PL.GetUsableItems()
    local Usables = {}
    for k in pairs(PL.UsableItemsCallbacks) do
        Usables[k] = true
    end
    return Usables
end