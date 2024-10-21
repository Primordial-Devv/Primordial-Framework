local slotsCount = 48
local isFreeze, isNoclip
local isAccepted = false

RegisterNetEvent('primordial_core:playerLoaded')
AddEventHandler('primordial_core:playerLoaded', function(sPlayer)
    PL.PlayerData = sPlayer
    PlayerLoaded = true
end)

CreateThread(function()
    local serverSlots = lib.callback.await('primordial_admin:server:getServerSlotsCount', 2000)
    if serverSlots then
        slotsCount = serverSlots
    end
    TriggerServerEvent('primordial_admin:server:initializePlayers')
end)

local function PlayerDataInfo(targetId, targetName)
    local targetData = lib.callback.await('primordial_admin:server:getPlayerData', 250, targetId)
    if not targetData then
        return PL.Print.Error('Player Data not found')
    end

    local playerData = {}

    playerData[#playerData+1] = {
        title = Translations.player_data_identifier:format(string.sub(targetData.identifier, 9, -20)),
        description = Translations.player_data_identifier_desc,
        icon = 'fa solid fa-id-card',
        onSelect = function()
            lib.setClipboard(targetData.identifier)
        end
    }

    playerData[#playerData+1] = {
        title = Translations.player_data_igname:format(targetData.igname),
        description = Translations.player_data_igname_desc,
        readOnly = true,
        icon = 'fa-solid fa-signature',
    }

    playerData[#playerData+1] = {
        title = Translations.player_data_steamname:format(targetData.steamname),
        description = Translations.player_data_steamname_desc,
        readOnly = true,
        icon = 'fa-brands fa-steam',
    }

    playerData[#playerData+1] = {
        title = Translations.player_data_cash:format(targetData.cash),
        description = Translations.player_data_cash_desc,
        readOnly = true,
        icon = 'fa-solid fa-money-bill',
    }

    playerData[#playerData+1] = {
        title = Translations.player_data_bank:format(targetData.bank),
        description = Translations.player_data_bank_desc,
        readOnly = true,
        icon = 'fa-solid fa-credit-card',
    }

    playerData[#playerData+1] = {
        title = Translations.player_data_black_money:format(targetData.blackMoney),
        description = Translations.player_data_black_money_desc,
        readOnly = true,
        icon = 'fa-solid fa-money-bill',
    }

    lib.registerContext({
        id = 'pl_admin_playerData_menu',
        title = Translations.player_data_title:format(targetName),
        menu = 'pl_admin_playerOptions_menu',
        options = playerData
    })

    lib.showContext('pl_admin_playerData_menu')
end

local function GiveMoneyToPLayer(targetId, targetName)
    local accountOptions = {}

    accountOptions[#accountOptions+1] = {
        value = 'money',
        label = Translations.player_give_money_cash
    }

    accountOptions[#accountOptions+1] = {
        value = 'bank',
        label = Translations.player_give_money_bank
    }

    accountOptions[#accountOptions+1] = {
        value = 'black_money',
        label = Translations.player_give_money_black_money
    }

    local inputMoney = lib.inputDialog(Translations.player_give_money_title, {
        {
            type = 'input',
            label = Translations.player_give_money_amount,
            required = true
        },
        {
            type = 'select',
            label = Translations.player_give_money_account,
            options = accountOptions,
            required = true
        }
    })
    if not inputMoney then
        return PL.Print.Error('Money Giving Cancelled')
    end

    local successGive = lib.callback.await('primordial_admin:server:giveMoneyToPlayer', 2000, targetId, inputMoney[2], tonumber(inputMoney[1]))
    if successGive then
        lib.notify({
            title = Translations.notify_give_money_success:format(tonumber(inputMoney[1]), inputMoney[2], targetName),
            type = 'success'
        })
    else
        lib.notify({
            title = Translations.notify_give_money_error,
            type = 'error'
        })
    end
end

local function GiveItemToPlayer(targetId, targetName)
    local itemInput = lib.inputDialog(Translations.player_give_item_title, {
        {
            type = 'input',
            label = Translations.give_player_tem_name,
            required = true
        },
        {
            type = 'input',
            label = Translations.give_player_item_amount,
            required = true
        }
    })
    if not itemInput then
        return PL.Print.Error('Item Giving Cancelled')
    end

    local suucessInput = lib.callback.await('primordial_admin:server:giveItemToPlayer', 2000, targetId, itemInput[1], tonumber(itemInput[2]))
    if suucessInput then
        lib.notify({
            title = Translations.notify_give_item_success:format(itemInput[1], tonumber(itemInput[2]), targetName),
            type = 'success'
        })
    else
        lib.notify({
            title = Translations.notify_give_item_error,
            type = 'error'
        })
    end
end

local function OpenPlayerInventory(targetId)
    exports.ox_inventory:openInventory('player', targetId)
end

local function WarnPlayer(targetId, targetName)
    local warnDialogOptions = {}
    warnDialogOptions[#warnDialogOptions+1] = {
        type = 'textarea',
        label = Translations.player_warn_reason_message,
        placeholder = Translations.player_warn_reason_placeholder_message,
        required = true,
        autosize = true
    }

    local warnDialog = lib.inputDialog(Translations.player_warn_title, warnDialogOptions)
    if not warnDialog then
        return PL.Print.Error('Warn Player Cancelled')
    end

    
    local warnCallback = lib.callback.await('primordial_admin:serer:warnPlayer', 250, targetId, targetName, warnDialog[1])
    if warnCallback then
        lib.notify({
            title = Translations.notify_warn_player_success:format(targetName),
            type = 'success'
        })
        PL.Scaleform.ShowFreemodeMessage('~y~WARNING', '~s~'.. warnDialog[1], 5)
    else
        lib.notify({
            title = Translations.notify_warn_player_error,
            type = 'error'
        })
    end
end

local function KickPlayer(targetId, targetName)
    local kickDialog = lib.inputDialog(Translations.player_kick_title, {
        {
            type = 'textarea',
            label = Translations.player_kick_label_dialog,
            placeholder = Translations.player_kick_placeholder_dialog,
            required = true,
            autosize = true
        }
    })
    if not kickDialog then
        return PL.Print.Error('Kick Player Cancelled')
    end
    local dropPlayer = lib.callback.await('primordial_admin:server:kickPlayer', 250, targetId, kickDialog[1] or Translations.kick_default_reason)
    if dropPlayer then
        lib.notify({
            title = Translations.notify_kick_player_success:format(targetName),
            type = 'success'
        })
    else
        lib.notify({
            title = Translations.notify_kick_player_error,
            type = 'error'
        })
    end
end

local function BanPlayer(targetId, targetName)
    local banDurationButton = {}

    for _, v in pairs(banDuration) do
        local banTime = v.Duration
        banDurationButton[#banDurationButton+1] = {
            title = v.Name,
            icon = 'fa-solid fa-clock',
            onSelect = function()
                local banReason = lib.inputDialog(Translations.player_ban_title, {
                    {
                        type = 'textarea',
                        label = Translations.ban_reason_label,
                        placeholder = Translations.ban_reason_placeholder,
                        required = true,
                        autosize = true
                    }
                })
                if not banReason then
                    return PL.Print.Error('Ban Player Cancelled')
                end

                local playerBanned = lib.callback.await('primordial_admin:server:banPlayer', 2000, targetId, banTime, banReason[1] or Translations.ban_reason_default)
                if playerBanned then
                    lib.notify({
                        title = Translations.notify_ban_player_success:format(targetName),
                        type = 'success'
                    })
                else
                    lib.notify({
                        title = Translations.notify_ban_player_error,
                        type = 'error'
                    })
                end
            end
        }
    end

    lib.registerContext({
        id = 'primordial_admin_ban_duration_menu',
        title = Translations.ban_duration_title,
        menu = 'primordial_admin_player_list_options',
        options = banDurationButton
    })

    lib.showContext('primordial_admin_ban_duration_menu')
end

local function PlayerOptionsList(id, name, permissions)
    if not permissions then return end

    local playerOptionsList = {}

    local targetId = GetPlayerFromServerId(id)
    local targetPed = GetPlayerPed(targetId)
    local targetHealth = GetEntityHealth(targetPed) / 2

    lib.callback.await('primordial_core:server:GetPlayerState', 2500, function(isDead)
        if isDead then
            targetHealth = 0
        end
    end, id)

    playerOptionsList[#playerOptionsList + 1] = {
        title = Translations.player_health_title:format(PL.Math.Round(targetHealth, 2)),
        icon = 'fa-solid fa-heart-pulse',
        progress = targetHealth,
        colorScheme = 'green',
        readOnly = true
    }

    if permissions.player_freeze_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_freeze_player_title,
            description = Translations.player_freeze_player_description,
            icon = 'fa-solid fa-snowflake',
            onSelect = function()
                isFreeze = not isFreeze
                lib.callback.await('primordial_admin:server:freezeSelectedPlayer', 250, id, isFreeze)
            end
        }
    end

    if permissions.player_goto_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_goto_title,
            description = Translations.player_goto_description,
            icon = 'fa-solid fa-arrow-right',
            onSelect = function()
                TriggerServerEvent('primordial_admin:server:teleportToPlayer', id)
            end
        }
    end

    if permissions.player_bring_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_bring_title,
            description = Translations.player_bring_description,
            icon = 'fa-solid fa-arrow-left',
            onSelect = function()
                TriggerServerEvent('primordial_admin:server:teleportPlayerTo', id, name)
            end
        }
    end

    if permissions.player_bring_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_bring_back_title,
            description = Translations.player_bring_back_description,
            icon = 'fa-solid fa-rotate',
            onSelect = function()
                TriggerServerEvent('primordial_admin:server:teleportBackPlayer', id)
            end
        }
    end

    if permissions.player_give_noclip_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_give_noclip_title,
            description = Translations.player_give_noclip_description,
            icon = 'fa-solid fa-ghost',
            onSelect = function()
                isNoclip = not isNoclip
                lib.callback.await('primordial_admin:server:give_noclip_to_player', 250, id, isNoclip)
            end
        }
    end

    if permissions.player_spectate_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_spectate_title,
            description = Translations.player_spectate_description,
            icon = 'fa-solid fa-eye',
            onSelect = function()
                TriggerServerEvent('primordial_admin:server:spectatePlayer', id)
            end
        }
    end

    if permissions.player_data_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_data_options_title,
            description = Translations.player_data_options_description,
            icon = 'fa-solid fa-scroll',
            onSelect = function()
                PlayerDataInfo(id, name)
            end
        }
    end

    if permissions.player_revive_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_revive_title,
            description = Translations.player_revive_description,
            icon = 'fa-solid fa-star-of-life',
            onSelect = function()
                isAccepted = true
                TriggerServerEvent('primordial_admin:server:revivePlayer', id, isAccepted)
                isAccepted = false
            end
        }
    end

    if permissions.player_heal_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_heal_title,
            description = Translations.player_heal_description,
            icon = 'fa-solid fa-heart',
            onSelect = function()
                TriggerServerEvent('primordial_admin:server:healPlayer', id)
            end
        }
    end

    if permissions.player_kill_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_kill_title,
            description = Translations.player_kill_description,
            icon = 'fa-solid fa-skull-crossbones',
            onSelect = function()
                TriggerEvent('primordial_core:client:killPlayer', id)
            end
        }
    end

    if permissions.player_give_skin_menu_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_give_skin_menu_title,
            description = Translations.player_give_skin_menu_description,
            icon = 'fa-solid fa-shirt',
            onSelect = function()
                TriggerEvent('esx_skin:openSaveableMenu', id)
            end
        }
    end

    if permissions.player_give_money_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_give_money_title,
            description = Translations.player_give_money_description,
            icon = 'fa-solid fa-money-bill',
            onSelect = function()
                GiveMoneyToPLayer(id, name)
            end
        }
    end

    if permissions.player_give_item_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_give_item_title,
            description = Translations.player_give_item_description,
            icon = 'fa-solid fa-box',
            onSelect = function()
                GiveItemToPlayer(id, name)
            end
        }
    end

    if permissions.player_open_inventory_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_open_inventory_title,
            description = Translations.player_open_inventory_description,
            icon = 'fa-solid fa-box-open',
            onSelect = function()
                OpenPlayerInventory(id)
            end
        }
    end

    if permissions.player_clear_inventory_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_clear_inventory_title,
            description = Translations.player_clear_inventory_description,
            icon = 'fa-solid fa-boxes',
            onSelect = function()
                lib.callback.await('primordial_admin:server:clearPlayerInventory', 250, id, name)
            end
        }
    end

    if permissions.player_warn_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_warn_title,
            description = Translations.player_warn_description,
            icon = 'fa-solid fa-triangle-exclamation',
            onSelect = function()
                WarnPlayer(id, name)
            end
        }
    end
    
    if permissions.player_kick_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_kick_title,
            description = Translations.player_kick_description,
            icon = 'fa-solid fa-user-slash',
            onSelect = function()
                KickPlayer(id, name)
            end
        }
    end

    if permissions.player_ban_options or permissions.allPermissions then
        playerOptionsList[#playerOptionsList+1] = {
            title = Translations.player_ban_title,
            description = Translations.player_ban_description,
            icon = 'fa-solid fa-ban',
            onSelect = function()
                BanPlayer(id, name)
            end
        }
    end

    if #playerOptionsList == 0 then
        return lib.notify({
            title = Translations.player_no_permissions_title,
            description = Translations.player_no_permissions_description,
            type = 'error'
        })
    end
    
    lib.registerContext({
        id = 'primordial_admin_player_list_options',
        title = ('[%s] %s'):format(id, name),
        menu = 'primordial_admin_player_options',
        options = playerOptionsList
    })

    lib.showContext('primordial_admin_player_list_options')
end

local function SearchPlayersId(players, permissions)
    local inputID = lib.inputDialog(Translations.search_player_dialog_title, {
        {
            type = 'number',
            label = Translations.search_player_dialog_label,
            description = Translations.search_player_dialog_description,
            required = true
        }
    })

    if not inputID then
        return PL.Print.Error('Players ID Search Cancelled')
    end

    local idPlayers = tonumber(inputID[1])
    local playerIdFound

    for _, playerSearched in pairs(players) do
        local id, name = playerSearched.title:match("%[(%d+)%] (.*)")
        id = tonumber(id)
        if id == idPlayers then
            PlayerOptionsList(id, name, permissions)
            playerIdFound = true
            break
        end
    end
    if playerIdFound then return end
    PL.Print.Error('Player ID: ' .. idPlayers .. ' not found')
end

function PlayerOptionsInterface(permissions)
    if not permissions then return end
    local playerListOptions = {}

    playerListOptions[#playerListOptions+1] = {
        title = Translations.refresh_player_list,
        icon = 'fa-solid fa-rotate',
        onSelect = function()
            lib.hideContext('primordial_admin_player_options')
            Wait(500)
            lib.showContext('primordial_admin_player_options')
        end
    }

    playerListOptions[#playerListOptions+1] = {
        title = Translations.player_list_options_search_by_id_title,
        icon = 'fa-magnifying-glass',
        onSelect = function()
            SearchPlayersId(playerListOptions, permissions)
        end
    }

    local players = lib.callback.await('primordial_admin:server:onlinePlayers', 2500)
    local SentPlayers, PlayerCount = players.SentPlayers, players.PlayerCount

    for i = 1, #SentPlayers do
        playerListOptions[#playerListOptions+1] = {
            title = ('[%s] %s'):format(SentPlayers[i].id, SentPlayers[i].name),
            icon = 'fa-user',
            onSelect = function()
                PlayerOptionsList(SentPlayers[i].id, SentPlayers[i].name, permissions)
            end
        }
    end

    lib.registerContext({
        id = 'primordial_admin_player_options',
        title = Translations.player_options_menu_title:format(PlayerCount, slotsCount),
        menu = 'primordial_admin_homepage',
        options = playerListOptions
    })

    lib.showContext('primordial_admin_player_options')
end