local togglePlayerId, togglePlayerBlip

local function ServerAnnounce()
    local jobsOptions = {}

    for i = 1, #Jobs do
        jobsOptions[#jobsOptions+1] = {
            label = Jobs[i].Label,
            value = Jobs[i].Name
        }
    end

    local announceDialog = lib.inputDialog(Translations.server_announce_title, {
        {
            type = 'textarea',
            label = Translations.server_announce_message,
            placeholder = Translations.server_announce_message_placeholder,
            required = true,
            autosize = true
        },
        {
            type = 'select',
            label = Translations.server_announce_job,
            options = jobsOptions,
            searchable = true,
        }
    })

    if not announceDialog then return end

    local announceSent = lib.callback.await('primordial_admin:server:sendAnnounce', 2000, announceDialog[1], announceDialog[2])

    if not announceSent then
        lib.notify({
            title = Translations.server_announce_failed,
            type = 'error'
        })
    end
end

local function AccessReportList(permissions)
    lib.registerContext({
        id = 'primordial_admin_server_report_list',
        title = Translations.server_report_list_options_title,
        menu = 'primordial_admin_server_options',
        options = {
            {
                title = Translations.admin_wait_report_fetch,
                icon = 'fa-solid fa-spinner',
                iconAnimation = 'spin',
                readOnly = true
            }
        }
    })

    lib.showContext('primordial_admin_server_report_list')

    Wait(500)

    local listReports = lib.callback.await('primordial_admin:server:fetchAllReorts', 2000)

    if not listReports then
        return lib.notify({
            title = Translations.admin_report_fetch_error,
            type = 'error'
        })
    end

    local listReportsOptions = {}

    for _, report in ipairs(listReports) do
        local claimedStatus = report.is_claimed and Translations.admin_report_claimed_yes or Translations.admin_report_claimed_no
        local closedStatus = report.is_closed and Translations.admin_report_closed_yes or Translations.admin_report_closed_no
        local description = string.format(
            "Description: %s\nReported by: %s\nReport Type: %s\nReported Date: %s\nReported Time: %s\nClaimed: %s\nClaimed by: %s\nClaimed Date: %s\nClaimed Time: %s\nClosed: %s\nClosed Date: %s\nClosed Time: %s",
            report.reason_message,
            report.author,
            report.reportType,
            report.report_date or 'N/A',
            report.report_time or 'N/A',
            claimedStatus,
            report.claim_admin_name or 'N/A',
            report.claim_date or 'N/A',
            report.claim_time or 'N/A',
            closedStatus,
            report.close_date or 'N/A',
            report.close_time or 'N/A'
        )

        table.insert(listReportsOptions, {
            title = report.reason_title,
            description = description,
            icon = 'fas fa-flag',
            onSelect = function()
                ReportOptionsInterface(permissions)
            end
        })
    end

    if #listReportsOptions == 0 then
        listReportsOptions[#listReportsOptions+1] = {
            title = Translations.admin_no_reports_found,
            readOnly = true
        }
    end

    lib.registerContext({
        id = 'primordial_admin_server_report_list_fetched',
        title = Translations.server_report_list_options_title,
        menu = 'primordial_admin_server_options',
        options = listReportsOptions
    })

    lib.hideContext('primordial_admin_server_report_list')
    Wait(500)
    lib.showContext('primordial_admin_server_report_list_fetched')
end

local function AccessWarningList()
    lib.registerContext({
        id = 'primordial_admin_server_warning_list',
        title = Translations.server_warn_list_options_title,
        menu = 'primordial_admin_server_options',
        options = {
            {
                title = Translations.admin_wait_warning_fetch,
                icon = 'fa-solid fa-spinner',
                iconAnimation = 'spin',
                readOnly = true
            }
        }
    })

    lib.showContext('primordial_admin_server_warning_list')

    Wait(500)

    local listWarning = lib.callback.await('primordial_admin:server:fetchAllWarnings', 2000)

    if not listWarning then
        return lib.notify({
            title = Translations.admin_warning_fetch_error,
            type = 'error'
        })
    end

    local listWarningOptions = {}
    local warnCount = 0

    for _, warn in ipairs(listWarning) do
        warnCount += 1
        table.insert(listWarningOptions, {
            title = Translations.warn_title:format(warnCount),
            description = 'Admin Author : ' .. warn.author .. ' \n Player Warned : ' .. warn.player .. '\n Reason : ' .. warn.reason,
            icon = 'fa-solid fa-triangle-exclamation',
            onSelect = function()
                local warnDeleted = lib.callback.await('primordial_admin:server:removeWarning', 2000, warn.id)

                if warnDeleted then
                    lib.notify({
                        title = Translations.warn_removed,
                        type = 'success'
                    })
                else
                    lib.notify({
                        title = Translations.warn_remove_error,
                        type = 'error'
                    })
                end
            end
        })
    end

    if #listWarningOptions == 0 then
        listWarningOptions[#listWarningOptions+1] = {
            title = Translations.admin_no_warns_found,
            readOnly = true
        }
    end

    lib.registerContext({
        id = 'primordial_admin_server_warning_list_fetched',
        title = Translations.server_warn_list_options_title,
        menu = 'primordial_admin_server_options',
        options = listWarningOptions
    })

    lib.hideContext('primordial_admin_server_warning_list')
    Wait(500)
    lib.showContext('primordial_admin_server_warning_list_fetched')
end

local function SplitTime(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return 0, 0
    else
        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)

        local formatHours = string.format('%02.f', hours)
        local formatMinutes = string.format('%02.f', minutes)

        return formatHours, formatMinutes
    end
end

local function BanListHandle(name, license, author, reason, time_left)
    local hours, minutes = SplitTime(time_left)
    lib.registerContext({
        id = 'primordial_admin_ban_list_handle',
        title = Translations.ban_list_handle_title,
        menu = 'primordial_admin_ban_list',
        options = {
            {
                title = Translations.ban_list_name:format(name),
                readOnly = true
            },
            {
                title = Translations.ban_list_license .. ' ' .. string.sub(license, 9, -20) .. '...',
                readOnly = true
            },
            {
                title = Translations.ban_list_by:format(author),
                readOnly = true
            },
            {
                title = Translations.ban_list_reason:format(reason),
                readOnly = true
            },
            {
                title = Translations.ban_list_time_left:format(hours, minutes),
                readOnly = true
            },
            {
                title = Translations.ban_list_unban,
                icon = 'fas fa-user-slash',
                onSelect = function()
                    local confirmunban = lib.alertDialog({
                        header = Translations.ban_list_unban_confirm_title,
                        content = Translations.ban_list_unban_confirm_content:format(name),
                        centered = true,
                        cancel = true
                    })
                    if confirmunban == 'confirm' then
                        local unban = lib.callback.await('primordial_admin:server:unbanPlayer', 2000, license)
                        if unban then
                            lib.notify({
                                title = Translations.ban_list_unban_success_title,
                                type = 'success'
                            })
                        else
                            lib.notify({
                                title = Translations.ban_list_unban_error_title,
                                type = 'error'
                            })
                        end
                    end
                end
            }
        }
    })

    lib.showContext('primordial_admin_ban_list_handle')
end

local function AccessBanList()
    local banData = lib.callback.await('primordial_admin:server:fetchBanList', 2000)
    if not banData or #banData < 1 then
        lib.notify({
            title = Translations.admin_no_bans_data,
            type = 'error'
        })
    else
        local banList = {}

        for i= 1, #banData do
            banList[#banList+1] = {
                title = banData[i].name,
                description = banData[i].reason,
                icon = 'fa-solid fa-user-slash',
                onSelect = function()
                    BanListHandle(banData[i].name, banData[i].license, banData[i].author, banData[i].reason, banData[i].time_left)
                end
            }
        end

        lib.registerContext({
            id = 'primordial_admin_ban_list',
            title = Translations.server_ban_list_options_title,
            menu = 'primordial_admin_server_options',
            options = banList
        })

        lib.showContext('primordial_admin_ban_list')
    end
end

local function Draw3dText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px, py, pz) - vector3(x, y, z))
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

local function TogglePlayerId()
    togglePlayerId = not togglePlayerId
    CreateThread(function()
        while togglePlayerId do
            local sleep = 1000
            local players = GetActivePlayers()
            for i = 1, #players do
                local ped = GetPlayerPed(players[i])
                local playerCoords = GetEntityCoords(ped)
                local x, y, z = table.unpack(playerCoords)
                local distance  = #(GetEntityCoords(PlayerPedId()) - playerCoords)
                if distance < 15 then
                    sleep = 0
                    Draw3dText(x, y, z + 1.0, ('~r~[~w~%s~r~]~w~ - %s ~r~ / ~s~%s  ~r~ / ~s~%s'):format(GetPlayerServerId(players[i]), GetPlayerName(players[i]), PL.PlayerData.job.name, PL.PlayerData.job.grade_label))
                end
            end
            Wait(sleep)
        end
    end)
end

local function TogglePlayerBlips()
    togglePlayerBlip = not togglePlayerBlip
    TriggerServerEvent('primordial_admin:server:togglePlayerBlips', togglePlayerBlip)
end

local function DelObject()
    local objectsPool = GetGamePool('Objects')
    for i = 1, #objectsPool do
        if DoesEntityExist(objectsPool[i]) then
            DeleteEntity(objectsPool[i])
        end
    end
    lib.notify({
        title = Translations.entity_delete_success,
        type = 'success'
    })
end

local function DelCars()
    local vehiclesPool = GetGamePool('CVehicle')
    for i = 1, #vehiclesPool do
        if GetPedInVehicleSeat(vehiclesPool[i], -1) == 0 then
            DeleteEntity(vehiclesPool[i])
        end
    end

    lib.notify({
        title = Translations.entity_delete_success,
        type = 'success'
    })
end

local function DelPeds()
    local pedsPool = GetGamePool('CPed')
    for i = 1, #pedsPool do
        if DoesEntityExist(pedsPool[i])then
            DeleteEntity(pedsPool[i])
        end
    end

    lib.notify({
        title = Translations.entity_delete_success,
        type = 'success'
    })
end

local function DeleteEntityHandler()
    local handlerOptions = {}

    handlerOptions[#handlerOptions+1] = {
        type = 'select',
        label = Translations.entity_delete_type,
        options = {
            {
                value = 'objects',
                label = Translations.entity_delete_objects
            },
            {
                value = 'vehicles',
                label = Translations.entity_delete_vehicles
            },
            {
                value = 'peds',
                label = Translations.entity_delete_peds
            }
        }
    }

    local handlerDialog = lib.inputDialog(Translations.entity_delete_title, handlerOptions)
    if not handlerDialog then return end
    if handlerDialog[1] == 'objects' then
        DelObject()
    elseif handlerDialog[1] == 'vehicles' then
        DelCars()
    elseif handlerDialog[1] == 'peds' then
        DelPeds()
    end
end

local function AccessWeather()
    local weatherOptions = {}
    for i = 1, #Weathers do
        weatherOptions[#weatherOptions+1] = {
            title = Weathers[i].label,
            icon = "fas fa-cloud-sun",
            onSelect = function()
                TriggerServerEvent('primordial_admin:server:weatherSync', Weathers[i].value)
            end
        }
    end

    lib.registerContext({
        id = 'primordial_admin_weather_sync',
        title = Translations.server_weather_options_title,
        menu = 'primordial_admin_server_options',
        options = weatherOptions
    })

    lib.showContext('primordial_admin_weather_sync')
end

local function ChangeWeather(type)
    ClearOverrideWeather()
    ClearWeatherTypePersist()

    local transitionTime = 15.0
    SetWeatherTypeOverTime(type, transitionTime)

    Wait(transitionTime * 1000)

    SetWeatherTypeNow(type)
    SetWeatherTypeNowPersist(type)

    if type == 'XMAS' then
        SetForceVehicleTrails(true)
        SetForcePedFootstepsTracks(true)
    else
        SetForceVehicleTrails(false)
        SetForcePedFootstepsTracks(false)
    end
end


local function AccessTime()
    local timeDialog = lib.inputDialog(Translations.server_time_options_title, {
        {
            type = 'number',
            label = Translations.server_time_hour_label,
            placeholder = 'Heure (0-23)',
            required = true,
            min = 0,
            max = 23,
            step = 1
        },
        {
            type = 'number',
            label = Translations.server_time_minute_label,
            placeholder = 'Minute (0-59)',
            required = true,
            min = 0,
            max = 59,
            step = 5
        }
    })

    if not timeDialog then return end

    local hour = tonumber(timeDialog[1])
    local minute = tonumber(timeDialog[2])

    TriggerServerEvent('primordial_admin:server:syncTime', hour, minute)
end

function ServerOptionsInterface(permissions)
    if not permissions then return end

    local serverOptions = {}

    if permissions.server_announce_options or permissions.allPermissions then
        serverOptions[#serverOptions+1] = {
            title = Translations.server_announce_title,
            description = Translations.server_announce_description,
            icon = 'fa-solid fa-bullhorn',
            onSelect = function()
                ServerAnnounce()
            end
        }
    end

    if permissions.server_reviveall_options or permissions.allPermissions then
        serverOptions[#serverOptions+1] = {
            title = Translations.server_reviveall_options_title,
            description = Translations.server_reviveall_options_description,
            icon = 'fa-solid fa-shield-heart',
            onSelect = function()
                TriggerServerEvent('primordial_admin:server:reviveAllPlayers')
            end
        }
    end

    if permissions.server_report_list_options or permissions.allPermissions then
        serverOptions[#serverOptions+1] = {
            title = Translations.server_report_list_options_title,
            description = Translations.server_report_list_options_description,
            icon = 'fa-solid fa-list',
            onSelect = function()
                AccessReportList(permissions)
            end
        }
    end

    if permissions.server_warn_list_options or permissions.allPermissions then
        serverOptions[#serverOptions+1] = {
            title = Translations.server_warn_list_options_title,
            description = Translations.server_warn_list_options_description,
            icon = 'fa-solid fa-list',
            onSelect = function()
                AccessWarningList()
            end
        }
    end

    if permissions.server_ban_list_options or permissions.allPermissions then
        serverOptions[#serverOptions+1] = {
            title = Translations.server_ban_list_options_title,
            description = Translations.server_ban_list_options_description,
            icon = 'fa-solid fa-list',
            onSelect = function()
                AccessBanList()
            end
        }
    end

    if permissions.server_toggle_player_id_options or permissions.allPermissions then
        serverOptions[#serverOptions+1] = {
            title = Translations.server_toggle_player_id_options_title,
            description = Translations.server_toggle_player_id_options_description,
            icon = 'fa-solid fa-circle-user',
            onSelect = function()
                TogglePlayerId()
            end
        }
    end

    if permissions.server_toggle_player_blips_options or permissions.allPermissions then
        serverOptions[#serverOptions+1] = {
            title = Translations.server_toggle_player_blip_options_title,
            description = Translations.server_toggle_player_blip_options_description,
            icon = 'fa-solid fa-circle-user',
            onSelect = function()
                TogglePlayerBlips()
            end
        }
    end

    if permissions.server_delete_objects_options or permissions.allPermissions then
        serverOptions[#serverOptions+1] = {
            title = Translations.server_delete_objects_options_title,
            description = Translations.server_delete_objects_options_description,
            icon = 'fa-solid fa-trash',
            onSelect = function()
                DeleteEntityHandler()
            end
        }
    end

    if permissions.server_weather_options or permissions.allPermissions then
        serverOptions[#serverOptions+1] = {
            title = Translations.server_weather_options_title,
            description = Translations.server_weather_options_description,
            icon = 'fa-solid fa-cloud',
            onSelect = function()
                AccessWeather()
            end
        }
    end

    if permissions.server_time_options or permissions.allPermissions then
        serverOptions[#serverOptions+1] = {
            title = Translations.server_time_options_title,
            description = Translations.server_time_options_description,
            icon = 'fa-solid fa-clock',
            onSelect = function()
                AccessTime()
            end
        }
    end

    lib.registerContext({
        id = 'primordial_admin_server_options',
        title = Translations.server_options_title,
        menu = 'primordial_admin_homepage',
        options = serverOptions
    })

    lib.showContext('primordial_admin_server_options')
end

RegisterNetEvent('primordial_admin:client:receiveAnnounce', function(message)
    local textureDict = 'custom_char_picture'
    local textureName = 'custom_admin_char_500'

    PL.Streaming.RequestStreamedTextureDict(textureDict, 5000)

    PL.Notification.ShowAdvancedNotification('ANNOUNCE', 'Admin message', message, 12, false, true, textureDict, textureName, 1)

    SetStreamedTextureDictAsNoLongerNeeded(textureDict)
end)

RegisterNetEvent('primordial_admin:client:weathersync', function(type)
    ChangeWeather(type)
end)

RegisterNetEvent('primordial_admin:client:syncTime', function(hour, minute)
    NetworkOverrideClockTime(hour, minute, 0)
end)