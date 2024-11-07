function getPriceItemForSelling(name)
	for k, v in pairs(Config.SellItems) do
		for s, x in pairs(v.items) do
			if x.name == name then
				return x.price, v.blip.account
			end
		end
	end
	return false
end

RegisterNetEvent(Config.InventoryPrefix .. ':server:RemoveItem', function(itemName, count)
	local src = source
	RemoveItem(src, itemName, count)
end)

function SetupSellingItems(shop, shopItems)
	local items = {}
	if shopItems ~= nil and next(shopItems) ~= nil then
		for k, item in pairs(shopItems) do
			local itemInfo = ItemInfo(item)
			if not itemInfo then return Error('There is an item that does not exist in this selling store!') end
			itemInfo.price = item.price
			items[item.slot] = itemInfo
		end
	end
	return items
end
