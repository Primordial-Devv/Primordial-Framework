local isInVehicle, isEnteringVehicle = false, false
local playerPed = PlayerPedId()
local current = {}

--- Get the seat of the ped in a vehicle
---@param ped number The ped to check
---@param vehicle number The vehicle to check
---@return number The seat the ped is in
local function GetPedVehicleSeat(ped, vehicle)
    for i = -1, 16 do
        if GetPedInVehicleSeat(vehicle, i) == ped then
            return i
        end
    end
    return -1
end
 --- Get the data of a vehicle
 ---@param vehicle number The vehicle to get the data of
 ---@return string|nil displayName, number|nil netId The display name and network ID of the vehicle
local function GetData(vehicle)
    if not DoesEntityExist(vehicle) then
        return
    end
    local model = GetEntityModel(vehicle)
    local displayName = GetDisplayNameFromVehicleModel(model)
    local netId = vehicle
    if NetworkGetEntityIsNetworked(vehicle) then
        netId = VehToNet(vehicle)
    end
    return displayName, netId
end

--- Toggle the vehicle status of the player
---@param inVehicle boolean Whether the player is in a vehicle
---@param seat number The seat the player is in
local function ToggleVehicleStatus(inVehicle, seat)
    PL.SetPlayerData("vehicle", inVehicle)
    PL.SetPlayerData("seat", seat)
end

CreateThread(function()
    while not PL.PlayerLoaded do Wait(200) end
    while true do
        PL.SetPlayerData("coords", GetEntityCoords(playerPed))
        if playerPed ~= PlayerPedId() then
            playerPed = PlayerPedId()
            PL.SetPlayerData("ped", playerPed)
            TriggerEvent("primordial_core:playerPedChanged", playerPed)
            TriggerServerEvent("primordial_core:playerPedChanged", PedToNet(playerPed))
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
        end

        if not isInVehicle and not IsPlayerDead(PlayerId()) then
            if DoesEntityExist(GetVehiclePedIsTryingToEnter(playerPed)) and not isEnteringVehicle then
                -- trying to enter a vehicle!
                local vehicle = GetVehiclePedIsTryingToEnter(playerPed)
                local plate = GetVehicleNumberPlateText(vehicle)
                local seat = GetSeatPedIsTryingToEnter(playerPed)
                local _, netId = GetData(vehicle)
                isEnteringVehicle = true
                TriggerEvent("primordial_core:enteringVehicle", vehicle, plate, seat, netId)
                TriggerServerEvent("primordial_core:enteringVehicle", plate, seat, netId)
                ToggleVehicleStatus(vehicle, seat)
            elseif not DoesEntityExist(GetVehiclePedIsTryingToEnter(playerPed)) and not IsPedInAnyVehicle(playerPed, true) and isEnteringVehicle then
                -- vehicle entering aborted
                TriggerEvent("primordial_core:enteringVehicleAborted")
                TriggerServerEvent("primordial_core:enteringVehicleAborted")
                isEnteringVehicle = false
                ToggleVehicleStatus(false, false)
            elseif IsPedInAnyVehicle(playerPed, false) then
                -- suddenly appeared in a vehicle, possible teleport
                isEnteringVehicle = false
                isInVehicle = true
                current.vehicle = GetVehiclePedIsUsing(playerPed)
                current.seat = GetPedVehicleSeat(playerPed, current.vehicle)
                current.plate = GetVehicleNumberPlateText(current.vehicle)
                current.displayName, current.netId = GetData(current.vehicle)
                TriggerEvent("primordial_core:enteredVehicle", current.vehicle, current.plate, current.seat, current.displayName, current.netId)
                TriggerServerEvent("primordial_core:enteredVehicle", current.plate, current.seat, current.displayName, current.netId)
                ToggleVehicleStatus(current.vehicle, current.seat)
            end
        elseif isInVehicle then
            if not IsPedInAnyVehicle(playerPed, false) or IsPlayerDead(PlayerId()) then
                -- bye, vehicle
                TriggerEvent("primordial_core:exitedVehicle", current.vehicle, current.plate, current.seat, current.displayName, current.netId)
                TriggerServerEvent("primordial_core:exitedVehicle", current.plate, current.seat, current.displayName, current.netId)
                isInVehicle = false
                current = {}
                ToggleVehicleStatus(false,false)
            end
        end
        Wait(200)
    end
end)

if EnableDebug then
    AddEventHandler("primordial_core:playerPedChanged", function(netId)
        PL.Print.Debug("primordial_core:playerPedChanged", netId)
    end)

    AddEventHandler("primordial_core:enteringVehicle", function(vehicle, plate, seat, netId)
        PL.Print.Debug("primordial_core:enteringVehicle", "vehicle", vehicle, "plate", plate, "seat", seat, "netId", netId)
    end)

    AddEventHandler("primordial_core:enteringVehicleAborted", function()
        PL.Print.Debug("primordial_core:enteringVehicleAborted")
    end)

    AddEventHandler("primordial_core:enteredVehicle", function(vehicle, plate, seat, displayName, netId)
        PL.Print.Debug("primordial_core:enteredVehicle", "vehicle", vehicle, "plate", plate, "seat", seat, "displayName", displayName, "netId", netId)
    end)

    AddEventHandler("primordial_core:exitedVehicle", function(vehicle, plate, seat, displayName, netId)
        PL.Print.Debug("primordial_core:exitedVehicle", "vehicle", vehicle, "plate", plate, "seat", seat, "displayName", displayName, "netId", netId)
    end)
end
