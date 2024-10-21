-- Credits to txAdmin for the list.
local mismatchedTypes = {
    [`airtug`] = "automobile", -- trailer
    [`avisa`] = "submarine", -- boat
    [`blimp`] = "heli", -- plane
    [`blimp2`] = "heli", -- plane
    [`blimp3`] = "heli", -- plane
    [`caddy`] = "automobile", -- trailer
    [`caddy2`] = "automobile", -- trailer
    [`caddy3`] = "automobile", -- trailer
    [`chimera`] = "automobile", -- bike
    [`docktug`] = "automobile", -- trailer
    [`forklift`] = "automobile", -- trailer
    [`kosatka`] = "submarine", -- boat
    [`mower`] = "automobile", -- trailer
    [`policeb`] = "bike", -- automobile
    [`ripley`] = "automobile", -- trailer
    [`rrocket`] = "automobile", -- bike
    [`sadler`] = "automobile", -- trailer
    [`sadler2`] = "automobile", -- trailer
    [`scrap`] = "automobile", -- trailer
    [`slamtruck`] = "automobile", -- trailer
    [`Stryder`] = "automobile", -- bike
    [`submersible`] = "submarine", -- boat
    [`submersible2`] = "submarine", -- boat
    [`thruster`] = "heli", -- automobile
    [`towtruck`] = "automobile", -- trailer
    [`towtruck2`] = "automobile", -- trailer
    [`tractor`] = "automobile", -- trailer
    [`tractor2`] = "automobile", -- trailer
    [`tractor3`] = "automobile", -- trailer
    [`trailersmall2`] = "trailer", -- automobile
    [`utillitruck`] = "automobile", -- trailer
    [`utillitruck2`] = "automobile", -- trailer
    [`utillitruck3`] = "automobile", -- trailer
}

--- Get the client vehicle type from the model.
---@param model number|string The model to get the vehicle type from.
---@return string type The vehicle type.
function PL.Vehicle.GetClientVehicleType(model)
    model = type(model) == "string" and joaat(model) or model
    if not IsModelInCdimage(model) then
        return
    end
    if mismatchedTypes[model] then
        return mismatchedTypes[model]
    end

    local vehicleType = GetVehicleClassFromName(model)
    local types = {
        [8] = "bike",
        [11] = "trailer",
        [13] = "bike",
        [14] = "boat",
        [15] = "heli",
        [16] = "plane",
        [21] = "train",
    }

    return types[vehicleType] or "automobile"
end


return PL.Vehicle.GetClientVehicleType