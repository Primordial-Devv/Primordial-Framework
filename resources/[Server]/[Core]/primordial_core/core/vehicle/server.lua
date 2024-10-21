---@param model string|number
---@param player number playerId
---@param cb function

function PL.GetVehicleType(model, player, cb)
    model = type(model) == "string" and joaat(model) or model

    if PL.vehicleTypesByModel[model] then
        return cb(PL.vehicleTypesByModel[model])
    end

    local vehicleType = lib.callback.await('primordial_core:client:GetVehicleType', player, model)
    PL.vehicleTypesByModel[model] = vehicleType
    cb(vehicleType)
end