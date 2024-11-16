local function ReportClaimed(reportData)
    local adminClaimed = GetPlayerName(PlayerId())
    local successClaimed = lib.callback.await('primordial_admin:server:claimReport', 2000, reportData.id, adminClaimed)

    if not successClaimed then
        return lib.notify({
            title = Translations.admin_claim_error,
            type = 'error',
        })
    end

    reportData.claim_admin_name = adminClaimed
    reportData.is_claimed = true

    ReportActionsOptions(reportData)

    lib.notify({
        title = Translations.admin_report_claim_success,
        type = 'success',
    })
end


local function ReportClosed(reportData)
    local successClosed = lib.callback.await('primordial_admin:server:closeReport', 2000, reportData.id)

    if not successClosed then
        return lib.notify({
            title = Translations.admin_close_error,
            type = 'error',
        })
    end

    reportData.is_closed = true

    lib.notify({
        title = Translations.admin_report_closed_success,
        type = 'success',
    })

    ReportOptionsInterface()
end

local function SendMessageToPlayer(reportData)
    local playerId = lib.callback.await('primordial_admin:server:checkPlayerOnline', 2000, reportData.author)

    if playerId then
        local messageDialog = lib.inputDialog(Translations.admin_send_priavte_message_report_dialog, {
            {
                type = 'textarea',
                label = Translations.admin_send_priavte_message_report_dialog_label,
                placeholder = Translations.admin_send_priavte_message_report_dialog_placeholder,
                required = true
            }
        })

        if not messageDialog then
            return lib.notify({
                title = Translations.admin_message_cancelled,
                type = 'error'
            })
        end

        local message = messageDialog[1]
        local messageSent = lib.callback.await('primordial_admin:server:sendMessageToPlayer', 2000, playerId, message)

        if messageSent then
            lib.notify({
                title = Translations.admin_message_sent_success,
                type = 'success'
            })
        else
            lib.notify({
                title = Translations.admin_message_sent_error,
                type = 'error'
            })
        end
    else
        lib.notify({
            title = Translations.admin_player_not_connected,
            type = 'error'
        })
    end
end

local function InteractWithPlayer(reportData, permissions)
    local playerId = lib.callback.await('primordial_admin:server:checkPlayerOnline', 2000, reportData.author)

    if playerId then
        PlayerOptionsInterface(permissions)
    else
        lib.notify({
            title = Translations.admin_player_not_connected,
            type = 'error'
        })
    end
end


function ReportActionsOptions(reportData, permissions)
    local options = {
        {
            title = reportData.reason_title,
            description = "Message : " .. reportData.reason_message .. "\n" .. "Reported by : " .. reportData.author .. "\n" .. "Date : " .. reportData.report_date .. "\n" .. "Time : " .. reportData.report_time,
        },
        {
            title = Translations.admin_close_report_actions,
            icon = 'fas fa-trash',
            onSelect = function()
                ReportClosed(reportData)
            end
        }
    }

    if reportData.is_claimed then
        table.insert(options, {
            title = Translations.admin_send_message_to_player,
            icon = 'fa-solid fa-envelope',
            onSelect = function()
                SendMessageToPlayer(reportData)
            end
        })

        table.insert(options, {
            title = Translations.admin_interact_with_player,
            icon = 'fa-solid fa-user-gear',
            onSelect = function()
                InteractWithPlayer(reportData, permissions)
            end
        })
    else
        table.insert(options, {
            title = Translations.admin_claim_reports_actions,
            icon = 'fa-solid fa-user-gear',
            onSelect = function()
                ReportClaimed(reportData)
            end
        })
    end

    lib.registerContext({
        id = 'primordial_admin:reportActions',
        title = Translations.admin_report_action_options_title,
        menu = 'primordial_admin:reportAdminOptions',
        options = options
    })

    lib.showContext('primordial_admin:reportActions')
end


local function PlayerReports(permissions)
    lib.registerContext({
        id = 'primordial_admin:playerReports',
        title = Translations.admin_report_options_title,
        menu = 'primordial_admin:reportAdminOptions',
        options = {
            {
                title = Translations.admin_wait_report_fetch,
                icon = 'fa-solid fa-spinner',
                iconAnimation = 'spin',
                readOnly = true
            }
        }
    })

    lib.showContext('primordial_admin:playerReports')
    Wait(500)

    local adminName = GetPlayerName(PlayerId())
    local reportFetched = lib.callback.await('primordial_admin:server:fetchReports', 2000)

    if not reportFetched then
        return lib.notify({
            title = Translations.admin_report_fetch_error,
            type = 'error'
        })
    end

    local playerReports = {}
    for _, report in ipairs(reportFetched) do
        local isClaimedByAdmin = (report.claim_admin_name == adminName)
        local claimStatus = 'none'
        local iconColor = nil
        local readOnly = false

        if report.claim_admin_name then
            if isClaimedByAdmin then
                claimStatus = 'You'
                iconColor = 'green'
            else
                claimStatus = report.claim_admin_name
                iconColor = 'red'
                readOnly = true
            end
        end

        local reportOption = {
            title = report.reason_title,
            description = "Message : " .. report.reason_message .. "\nReported by: " .. report.author .. "\nDate: " .. report.report_date .. "\nTime: " .. report.report_time .. "\nClaimed by: " .. claimStatus,
            icon = 'fas fa-flag',
            iconColor = iconColor,
            readOnly = readOnly,
        }

        if not readOnly then
            reportOption.onSelect = function()
                ReportActionsOptions(report, permissions)
            end
        end

        playerReports[#playerReports+1] = reportOption
    end

    lib.registerContext({
        id = 'primordial_admin:playerReportsFetched',
        title = Translations.admin_report_options_title,
        menu = 'primordial_admin:reportAdminOptions',
        options = playerReports
    })

    lib.hideContext('primordial_admin:playerReports')
    Wait(500)
    lib.showContext('primordial_admin:playerReportsFetched')
end

local function StaffRequests(permissions)
    lib.registerContext({
        id = 'primordial_admin:playerReports',
        title = Translations.admin_request_options_title,
        menu = 'primordial_admin:reportAdminOptions',
        options = {
            {
                title = Translations.admin_wait_report_fetch,
                icon = 'fa-solid fa-spinner',
                iconAnimation = 'spin',
                readOnly = true
            }
        }
    })

    lib.showContext('primordial_admin:playerReports')

    Wait(500)

    local adminName = GetPlayerName(PlayerId())
    local requestFetched = lib.callback.await('primordial_admin:server:fetchRequests', 2000)

    if not requestFetched then
        return lib.notify({
            title = Translations.admin_report_fetch_error,
            type = 'error'
        })
    end

    local playerReports = {}
    for _, report in ipairs(requestFetched) do
        local isClaimedByAdmin = (report.claim_admin_name == adminName)
        local claimStatus = 'none'
        local iconColor = nil
        local readOnly = false

        if report.claim_admin_name then
            if isClaimedByAdmin then
                claimStatus = 'You'
                iconColor = 'green'
            else
                claimStatus = report.claim_admin_name
                iconColor = 'red'
                readOnly = true
            end
        end

        local reportOption = {
            title = report.reason_title,
            description = "Message : " .. report.reason_message .. "\nReported by: " .. report.author .. "\nDate: " .. report.report_date .. "\nTime: " .. report.report_time .. "\nClaimed by: " .. claimStatus,
            icon = 'fas fa-flag',
            iconColor = iconColor,
            readOnly = readOnly,
        }

        if not readOnly then
            reportOption.onSelect = function()
                ReportActionsOptions(report, permissions)
            end
        end

        playerReports[#playerReports+1] = reportOption
    end

    lib.registerContext({
        id = 'primordial_admin:playerReportsFetched',
        title = Translations.admin_request_options_title,
        menu = 'primordial_admin:reportAdminOptions',
        options = playerReports
    })

    lib.hideContext('primordial_admin:playerReports')
    Wait(500)
    lib.showContext('primordial_admin:playerReportsFetched')
end

function ReportOptionsInterface(permissions)
    if not permissions then return end

    local reportOptions = {}

    reportOptions[#reportOptions+1] = {
        title = Translations.admin_report_options_title,
        description = Translations. admin_report_description,
        icon = 'fas fa-flag',
        onSelect = function()
            PlayerReports(permissions)
        end
    }

    reportOptions[#reportOptions+1] = {
        title = Translations.admin_contact_staff_options_title,
        description = Translations.admin_contact_staff_description,
        icon = 'fas fa-flag',
        onSelect = function()
            StaffRequests(permissions)
        end
    }

    lib.registerContext({
        id = 'primordial_admin:reportAdminOptions',
        title = Translations.report_options_title,
        menu = 'primordial_admin_homepage',
        options = reportOptions
    })

    lib.showContext('primordial_admin:reportAdminOptions')
end

local function ReportDialog()
    local reportDialog = lib.inputDialog(Translations.report_dialog_title, {
        {
            type = 'select',
            label = Translations.report_dialog_type_label,
            required = true,
            options = {
                {
                    label = Translations.report_dialog_type_option1,
                    value = 'player'
                },
                {
                    label = Translations.report_dialog_type_option2,
                    value = 'staff'
                },
            }
        },
        {
            type ='input',
            label = Translations.report_dialog_title_label,
            placeholder = Translations.report_dialog_title_placeholder,
            required = true,
        },
        {
            type = 'textarea',
            label = Translations.report_dialog_message_label,
            placeholder = Translations.report_dialog_message_placeholder,
            required = true,
            autosize = true,
        }
    })

    if not reportDialog then
        return lib.notify({
            title = Translations.report_dialog_cancelled,
            type = 'error'
        })
    end

    local player = cache.ped
    local playerCoords = GetEntityCoords(player)
    local reportData = {
        type = reportDialog[1],
        title = tostring(reportDialog[2]),
        message = tostring(reportDialog[3]),
        coords = {
            x = playerCoords.x,
            y = playerCoords.y,
            z = playerCoords.z
        }
    }

    local reportSended = lib.callback.await('primordial_admin:server:sendReportData', 350, reportData)
    if not reportSended then
        PL.Print.Error(Translations.report_dialog_error)
    end
end

RegisterNetEvent('primordial_admin:client:openingReportDialog', function()
    ReportDialog()
end)

RegisterNetEvent('primordial_admin:client:showAdminMessage', function(message)
    local textureDict = 'custom_char_picture'
    local textureName = 'custom_admin_char_500'

    PL.Streaming.RequestStreamedTextureDict(textureDict, 5000)

    PL.Notification.ShowAdvancedNotification("ADMIN MESSAGE", "From Report", message, 92, false, true, textureDict, textureName, 1)

    SetStreamedTextureDictAsNoLongerNeeded(textureDict)
end)
