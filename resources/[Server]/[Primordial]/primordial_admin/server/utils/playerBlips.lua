local UsingBlips, TrackedCoords = {}, {}

local function TableContains(table, value)
    for index, val in ipairs(table) do
        if val == value then
            return true
        end
    end
    return false
end 

RegisterNetEvent('primordial_admin:server:togglePlayerBlips', function(bool)
    local source = source

    if bool then
        if not TableContains(UsingBlips, source) then
            UsingBlips[#UsingBlips+1] = source
        end
    else
        for i, id in ipairs(UsingBlips) do
            if id == source then
                table.remove(UsingBlips, i)
                break
            end
        end
    end
end)

CreateThread(function()
    local cachedUsingBlips = {}

    while true do
        Wait(1500)

        for _, id in ipairs(cachedUsingBlips) do
            if not TableContains(UsingBlips, id) then
                TriggerClientEvent('primordial_admin:client:refreshPlayerBlips', id, {})
            end
        end

        cachedUsingBlips = table.pack(table.unpack(UsingBlips))

        if next(UsingBlips) then
            TrackedCoords = {}
            for _, data in ipairs(ActivePlayers) do
                local serverId = data.id
                local playerPed = GetPlayerPed(serverId)
                local playerCoords = GetEntityCoords(playerPed)
                local inVehicle = GetVehiclePedIsIn(playerPed, false)
                if playerCoords then
                    TrackedCoords[#TrackedCoords+1] = {
                        id = serverId,
                        coords = playerCoords,
                        inVehicle = inVehicle or false
                    }
                end
            end

            for _, id in ipairs(UsingBlips) do
                TriggerClientEvent('primordial_admin:client:refreshPlayerBlips', id, TrackedCoords)
            end
        end
    end
end)