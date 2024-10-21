--- Delete an object from the world
---@param object number The object to delete
function PL.Object.DeleteObject(object)
    SetEntityAsMissionEntity(object, false, true)
    DeleteObject(object)
end

return PL.Object.DeleteObject