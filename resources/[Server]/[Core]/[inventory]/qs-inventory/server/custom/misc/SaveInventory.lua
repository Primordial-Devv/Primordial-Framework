local function getFirstItemInDrop(dropId)
	local drop = Drops[dropId]
	if drop and drop.items then
		for k, v in pairs(drop.items) do
			return v
		end
	end
	return nil
end

function HandleSaveSecondInventories(src, type, id)
	local IsVehicleOwned = IsVehicleOwned(id)
	if type == 'trunk' then
		if not Trunks[id] then return end
		if IsVehicleOwned then
			SaveOwnedVehicleItems(id, Trunks[id].items)
		else
			Trunks[id].isOpen = false
		end
	elseif type == 'glovebox' then
		if not Gloveboxes[id] then return end
		if IsVehicleOwned then
			SaveOwnedGloveboxItems(id, Gloveboxes[id].items)
		else
			Gloveboxes[id].isOpen = false
		end
	elseif type == 'stash' then
		SaveStashItems(id, Stashes[id].items)
	elseif type == 'drop' then
		if Drops[id] then
			Drops[id].isOpen = false
			if Drops[id].items == nil or next(Drops[id].items) == nil then
				Drops[id] = nil
				TriggerClientEvent(Config.InventoryPrefix .. ':client:RemoveDropItem', -1, id)
			else
				local dropItemsCount = table.length(Drops[id].items)
				local firstItem = getFirstItemInDrop(id)
				local dropObject = Config.ItemDropObject
				if firstItem then
					dropObject = dropItemsCount == 1 and ItemList[firstItem.name:lower()].object or Config.ItemDropObject
				end
				TriggerClientEvent(Config.InventoryPrefix .. ':updateDropItems', -1, id, dropObject, dropItemsCount == 1 and firstItem or nil)
			end
		end
	elseif type == 'clothing' then
		local identifier = GetPlayerIdentifier(src)
		if not ClotheItems[identifier] then return end
		SaveClotheItems(identifier, ClotheItems[identifier].items)
	end
end

RegisterNetEvent(Config.InventoryPrefix .. ':server:SaveInventory', function(type, id)
	local src = source
	Wait(500)
	HandleSaveSecondInventories(src, type, id)
end)
