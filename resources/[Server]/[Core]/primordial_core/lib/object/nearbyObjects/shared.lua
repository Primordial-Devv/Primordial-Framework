--- Get nearby objects from the client at a specific location with a max distance.
---@param coords vector3 The coords to check from.
---@param maxDistance? number The max distance to check.
---@return { object: number, coords: vector3 }[] nearby A list of nearby objects.
function PL.Object.GetNearbyObjects(coords, maxDistance)
    local objects = GetGamePool('CObject')
	local nearby = {}
	local count = 0
    maxDistance = maxDistance or 2.0

    for i = 1, #objects do
		local object = objects[i]

        local objectCoords = GetEntityCoords(object)
        local distance = #(coords - objectCoords)

        if distance < maxDistance then
            count += 1
            nearby[count] = {
                object = object,
                coords = objectCoords
            }
        end
	end

    return nearby
end

return PL.Object.GetClientNearbyObjects