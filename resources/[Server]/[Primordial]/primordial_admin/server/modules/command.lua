local vehicleUpgrades = true and {
    plate = "ADMINCAR",
    modEngine = 3,
    modBrakes = 2,
    modTransmission = 2,
    modSuspension = 3,
    modArmor = true,
    windowTint = 1,
} or {}
local isAccepted = false
local Freeze

if AdminCommand.NoclipCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.NoclipCommand.CommandName, {'admin'}, function(sPlayer)
        TriggerClientEvent('primordial_admin:client:toggleNoclip', sPlayer.source)
    end, false, {
        help = 'Put yourself in noclip mode.'
    })
end

if AdminCommand.ReviveCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.ReviveCommand.CommandName, {'admin'}, function(_, args)
        isAccepted = true
        args.playerId.triggerEvent('primordial_admin:client:revivePlayer', isAccepted)
    end, true, {
        help = 'Revive a player.',
        validate = true,
        arguments = {
            { name = "playerId", help = 'The id of player to revive', type = "player" },
        }
    })
end

if AdminCommand.HealCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.HealCommand.CommandName, {'admin'}, function(_, args)
        args.playerId.triggerEvent('primordial_lifeEssentials:client:healPlayer')
    end, true, {
        help = 'Heal a player.',
        validate = true,
        arguments = {
            { name = "playerId", help = 'The id of player to heal', type = "player" },
        }
    })
end

if AdminCommand.TelportToCoordsCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.TelportToCoordsCommand.CommandName, {'admin'}, function(sPlayer, args)
        sPlayer.setCoords({ x = args.x, y = args.y, z = args.z })
    end, false, {
        help = 'Teleport to the specified coordinates.',
        validate = true,
        arguments = {
            { name = "x", help = 'The x coordinate', type = "coordinate" },
            { name = "y", help = 'The y coordinate', type = "coordinate" },
            { name = "z", help = 'The z coordinate', type = "coordinate" },
        }
    })
end

if AdminCommand.TeleportToMarkerCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.TeleportToMarkerCommand.CommandName, {'admin'}, function(sPlayer)
        TriggerClientEvent('primordial_admin:client:teleportToMarker', sPlayer.source)
    end, false, {
        help = 'Teleport to the marker.'
    })
end

if AdminCommand.KillCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.KillCommand.CommandName, {'admin'}, function(_, args)
        args.playerId.triggerEvent("primordial_core:client:killPlayer")

    end, true, {
        help = 'Kill a player.',
        validate = true,
        arguments = {
            { name = "playerId", help = 'Kill the selectec player', type = "player" },
        },
    })
end


if AdminCommand.ReviveAllCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.ReviveAllCommand.CommandName, {'admin'}, function(sPlayer, args)
        for _, playerId in ipairs(GetPlayers()) do
            TriggerClientEvent('primordial_admin:client:revivePlayer', playerId, true)
        end

        lib.notify(sPlayer.source, {
            title = 'All players have been revived.',
            type = 'success'
        })
    end, false, {
        help = 'Revive all players connected to the server.',
    })
end

if AdminCommand.SetJobCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.SetJobCommand.CommandName, {'admin'}, function(sPlayer, args)
        if not PL.DoesSocietyExist(args.job, args.grade) then
            return PL.Print.Error(Translations.command_setjob_invalid:format(args.job, args.grade))
        end

        args.playerId.setSociety(args.job, args.grade)

        PL.Discord.DiscordLogFields("UserActions", "Set Job /setjob Triggered!", "pink", {
            { name = "Player", value = sPlayer and sPlayer.name or "Server Console", inline = true },
            { name = "ID", value = sPlayer and sPlayer.source or "Unknown ID", inline = true },
            { name = "Target", value = args.playerId.name, inline = true },
            { name = "Job", value = args.job, inline = true },
            { name = "Grade", value = args.grade, inline = true },
        })
    end, true, {
        help = Translations.command_setjob,
        validate = true,
        arguments = {
            { name = "playerId", help = Translations.commandgeneric_playerid, type = "player" },
            { name = "job", help = Translations.command_setjob_job_name, type = "string" },
            { name = "grade", help = Translations.command_setjob_grade, type = "number" },
        }
    })
end

if AdminCommand.VehicleCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.VehicleCommand.CommandName, {'admin'}, function(sPlayer, args, _)
        if not sPlayer then
            return PL.Print.Error("The Player object is nil")
        end

        local playerPed = GetPlayerPed(sPlayer.source)
        local playerCoords = GetEntityCoords(playerPed)
        local playerHeading = GetEntityHeading(playerPed)
        local playerVehicle = GetVehiclePedIsIn(playerPed, false)

        if not args.vehicle then
            args.vehicle = "adder"
            PL.Print.Error('Car value undefined, set to Adder')
        end

        if playerVehicle then
            DeleteEntity(playerVehicle)
        end

        PL.Discord.DiscordLogFields("UserActions", "Spawn vehicle /vehicle Triggered!", "pink", {
            { name = "Player", value = sPlayer and sPlayer.name or "Server Console", inline = true },
            { name = "ID", value = sPlayer and sPlayer.source or "Unknown ID", inline = true },
            { name = "Vehicle", value = args.vehicle, inline = true },
        })

        PL.Vehicle.SpawnServerVehicle(args.vehicle, playerCoords, playerHeading, vehicleUpgrades, function(networkId)
            if networkId then
                local vehicle = NetworkGetEntityFromNetworkId(networkId)
                for _ = 1, 20 do
                    Wait(0)
                    SetPedIntoVehicle(playerPed, vehicle, -1)
    
                    if GetVehiclePedIsIn(playerPed, false) == vehicle then
                        break
                    end
                end
                if GetVehiclePedIsIn(playerPed, false) ~= vehicle then
                    PL.Print.Error("The player could not be seated in the vehicle")
                end
            end
        end)
    end, false, {
        help = Translations.command_vehicle,
        validate = true,
        arguments = {
            { name = "vehicle", validate = true, help = Translations.command_vehicle_name, type = "string" },
        },
    })
end

if AdminCommand.DeleteVehicleCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.DeleteVehicleCommand.CommandName, {'admin'}, function(sPlayer, args)
        local PedVehicle = GetVehiclePedIsIn(GetPlayerPed(sPlayer.source), false)
        if DoesEntityExist(PedVehicle) then
            DeleteEntity(PedVehicle)
        end
    
        local Vehicles = PL.Vehicle.GetNearbyVehicles(GetEntityCoords(GetPlayerPed(sPlayer.source)), tonumber(args.radius) or 5.0)
        for i = 1, #Vehicles do
            local vehicleId = Vehicles[i].vehicle
            local Vehicle = NetworkGetEntityFromNetworkId(vehicleId)
            if DoesEntityExist(Vehicle) then
                DeleteEntity(Vehicle)
            end
        end
    
        PL.Discord.DiscordLogFields("UserActions", "Delete Vehicle /dv Triggered!", "pink", {
            { name = "Player", value = sPlayer and sPlayer.name or "Server Console", inline = true },
            { name = "ID", value = sPlayer and sPlayer.source or "Unknown ID", inline = true },
        })
    
    end, false, {
        help = Translations.command_cardel,
        validate = false,
        arguments = {
            { name = "radius", validate = false, help = Translations.command_cardel_radius },
        },
    })
end

if AdminCommand.RepairVehicleCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.RepairVehicleCommand.CommandName, {'admin'}, function(sPlayer, args, _)
        local xTarget = args.playerId
        local ped = GetPlayerPed(xTarget.source)
        local pedVehicle = GetVehiclePedIsIn(ped, false)
        if not pedVehicle or GetPedInVehicleSeat(pedVehicle, -1) ~= ped then
            PL.Print.Error(Translations.not_in_vehicle)
            return
        end
        xTarget.triggerEvent("primordial_core:client:repairPedVehicle")
        TriggerClientEvent('ox_lib:notify', sPlayer.source, {
            tile = Translations.command_repair_success,
            type = 'success',
        })
        if sPlayer.source ~= xTarget.source then
            TriggerClientEvent('ox_lib:notify', xTarget.source, {
                tile = Translations.command_repair_success_target,
                type = 'success',
            })
        end
    
        PL.Discord.DiscordLogFields("UserActions", "Fix Vehicle /fix Triggered!", "pink", {
            { name = "Player", value = sPlayer and sPlayer.name or "Server Console", inline = true },
            { name = "ID", value = sPlayer and sPlayer.source or "Unknown ID", inline = true },
            { name = "Target", value = xTarget.name, inline = true },
        })
    
    end, true, {
        help = Translations.command_repair,
        validate = false,
        arguments = {
            { name = "playerId", help = Translations.commandgeneric_playerid, type = "player" },
        },
    })
end

if AdminCommand.SetAccountMoneyCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.SetAccountMoneyCommand.CommandName, {'admin'}, function(sPlayer, args)
        if not args.playerId.getAccount(args.account) then
            return PL.Print.Error(Translations.command_giveaccountmoney_invalid)
        end
        args.playerId.setAccountMoney(args.account, args.amount, "Government Grant")
    
        PL.Discord.DiscordLogFields("UserActions", "Set Account Money /setaccountmoney Triggered!", "pink", {
            { name = "Player", value = sPlayer and sPlayer.name or "Server Console", inline = true },
            { name = "ID", value = sPlayer and sPlayer.source or "Unknown ID", inline = true },
            { name = "Target", value = args.playerId.name, inline = true },
            { name = "Account", value = args.account, inline = true },
            { name = "Amount", value = args.amount, inline = true },
        })
    
    end, true, {
        help = Translations.command_setaccountmoney,
        validate = true,
        arguments = {
            { name = "playerId", help = Translations.commandgeneric_playerid, type = "player" },
            { name = "account", help = Translations.command_giveaccountmoney_account, type = "string" },
            { name = "amount", help = Translations.command_setaccountmoney_amount, type = "number" },
        },
    })
end

if AdminCommand.AddAccountMoneyCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.AddAccountMoneyCommand.CommandName, {'admin'}, function(sPlayer, args)
        if not args.playerId.getAccount(args.account) then
            return PL.Print.Error(Translations.command_giveaccountmoney_invalid)
        end
        args.playerId.addAccountMoney(args.account, args.amount, "Government Grant")
    
        PL.Discord.DiscordLogFields("UserActions", "Give Account Money /giveaccountmoney Triggered!", "pink", {
            { name = "Player", value = sPlayer and sPlayer.name or "Server Console", inline = true },
            { name = "ID", value = sPlayer and sPlayer.source or "Unknown ID", inline = true },
            { name = "Target", value = args.playerId.name, inline = true },
            { name = "Account", value = args.account, inline = true },
            { name = "Amount", value = args.amount, inline = true },
        })
    
    end, true, {
        help = Translations.command_giveaccountmoney,
        validate = true,
        arguments = {
            { name = "playerId", help = Translations.commandgeneric_playerid, type = "player" },
            { name = "account", help = Translations.command_giveaccountmoney_account, type = "string" },
            { name = "amount", help = Translations.command_giveaccountmoney_amount, type = "number" },
        },
    })
end

if  AdminCommand.RemoveAccountMoneyCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.RemoveAccountMoneyCommand.CommandName, {'admin'}, function(sPlayer, args)
        if not args.playerId.getAccount(args.account) then
            return PL.Print.Error(Translations.command_removeaccountmoney_invalid)
        end
        args.playerId.removeAccountMoney(args.account, args.amount, "Government Tax")
    
        PL.Discord.DiscordLogFields("UserActions", "Remove Account Money /removeaccountmoney Triggered!", "pink", {
            { name = "Player", value = sPlayer and sPlayer.name or "Server Console", inline = true },
            { name = "ID", value = sPlayer and sPlayer.source or "Unknown ID", inline = true },
            { name = "Target", value = args.playerId.name, inline = true },
            { name = "Account", value = args.account, inline = true },
            { name = "Amount", value = args.amount, inline = true },
        })
    
    end, true, {
        help = Translations.command_removeaccountmoney,
        validate = true,
        arguments = {
            { name = "playerId", help = Translations.commandgeneric_playerid, type = "player" },
            { name = "account", help = Translations.command_removeaccountmoney_account, type = "string" },
            { name = "amount", help = Translations.command_removeaccountmoney_amount, type = "number" },
        },
    })
end

if AdminCommand.ClearChatCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.ClearChatCommand.CommandName, {'user', 'admin'}, function(sPlayer)
        sPlayer.triggerEvent("chat:clear")
    end, false, {
        help = Translations.command_clear
    })
end

if AdminCommand.ClearAllChatCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.ClearAllChatCommand.CommandName, {'admin'}, function(sPlayer)
        TriggerClientEvent("chat:clear", -1)
    
        PL.Discord.DiscordLogFields("UserActions", "Clear Chat /clearall Triggered!", "pink", {
            { name = "Player", value = sPlayer and sPlayer.name or "Server Console", inline = true },
            { name = "ID", value = sPlayer and sPlayer.source or "Unknown ID", inline = true },
        })
    
    end, true, {
        help = Translations.command_clearall
    })
end

if AdminCommand.RefreshJobsCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.RefreshJobsCommand.CommandName, {'admin'}, function()
        PL.RefreshSociety()
    end, true, {
        help = Translations.command_refreshjobs
    })
end

if AdminCommand.SetGroupCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.SetGroupCommand.CommandName, {'admin'}, function(sPlayer, args)
        if not args.playerId then
            args.playerId = sPlayer.source
        end
    
        if args.group == "superadmin" then
            args.group = "admin"
            PL.Print.Warning("Superadmin^7 detected, setting group to ^5admin^7")
        end
        args.playerId.setGroup(args.group)
    
        PL.Discord.DiscordLogFields("UserActions", "/setgroup Triggered!", "pink", {
            { name = "Player", value = sPlayer and sPlayer.name or "Server Console", inline = true },
            { name = "ID", value = sPlayer and sPlayer.source or "Unknown ID", inline = true },
            { name = "Target", value = args.playerId.name, inline = true },
            { name = "Group", value = args.group, inline = true },
        })
    end, true, {
        help = Translations.command_setgroup,
        validate = true,
        arguments = {
            { name = "playerId", help = Translations.commandgeneric_playerid, type = "player" },
            { name = "group", help = Translations.command_setgroup_group, type = "string" },
        }
    })
end

if AdminCommand.SaveCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.SaveCommand.CommandName, {'admin'}, function(_, args)
        PL.SavePlayer(args.playerId)
        PL.Print.Info(("Saved Player - ^5%s^0"):format(args.playerId.source))
    end, true, {
        help = Translations.command_save,
        validate = true,
        arguments = {
            { name = "playerId", help = Translations.commandgeneric_playerid, type = "player" },
        },
    })
end

if AdminCommand.SaveAllCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.SaveAllCommand.CommandName, {'admin'}, function()
        PL.SavePlayers()
    end, true, {
        help = Translations.command_saveall
    }) 
end

if AdminCommand.GroupCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.GroupCommand.CommandName, {'user', 'admin'}, function(sPlayer, _, _)
        PL.Print.Info((('%s, you are currently : ^5%s^0'):format(sPlayer.getName(), sPlayer.getGroup())))
    end)
end


if AdminCommand.JobCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.JobCommand.CommandName, {'user', 'admin'}, function(sPlayer)
        PL.Print.Info(("^5%s^0, your job is: ^5%s^0 and you grade is : ^5%s^0"):format(sPlayer.getName(), sPlayer.getSociety().name, sPlayer.getSociety().grade_label))
    end, false)
end

if AdminCommand.InfoCommmad.EnableCommand then
    PL.RegisterCommand(AdminCommand.InfoCommmad.CommandName, {'user', 'admin'}, function(sPlayer)
        local job = sPlayer.getSociety().label
        PL.Print.Info(("ID: ^5%s^0 | Name: ^5%s^0 | Group: ^5%s^0 | Job: ^5%s^0"):format(sPlayer.source, sPlayer.getName(), sPlayer.getGroup(), job))
    end, false)
end

if AdminCommand.FreezeCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.FreezeCommand.CommandName, {'admin'}, function(_, args)
        Freeze = not Freeze
        if not args.playerId then
            return PL.Print.Error('You must specify a player to freeze.')
        end

        FreezeEntityPosition(args.playerId.source, Freeze)
    end, true, {
        help = 'Freeze a player.',
        validate = true,
        arguments = {
            { name = "playerId", help = 'The id of player to freeze', type = "player" },
        }
    })
end

if AdminCommand.CreateSocietyCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.CreateSocietyCommand.CommandName, {'admin'}, function(sPlayer, args)
        if PL.DoesSocietyExist(args.name) then
            PL.Print.Debug('The society already exists.')
            return
        end

        sPlayer.triggerEvent('primordial_core:client:createSociety', args.name)
    end, false, {
        help = 'Create a society.',
        validate = true,
        arguments = {
            { name = "name", help = 'The name of the society', type = "string" },
        }
    })
end

if AdminCommand.PlayersCommand.EnableCommand then
    PL.RegisterCommand(AdminCommand.PlayersCommand.CommandName, {'admin'}, function()
        local sPlayers = PL.GetExtendedPlayers()
        print(("^5%s^2 online player(s)^0"):format(#sPlayers))
        for i = 1, #sPlayers do
            local sPlayer = sPlayers[i]
            print(("^1[^2ID: ^5%s^0 | ^2Name : ^5%s^0 | ^2Group : ^5%s^0 | ^2Identifier : ^5%s^1]^0\n"):format(sPlayer.source, sPlayer.getName(), sPlayer.getGroup(), sPlayer.identifier))
        end
    end, true)
end

AddEventHandler('primordial_core:server:societyLoaded', function(jobs)
    PL.RegisterCommand('jobs', {'admin'}, function()
        PL.Print.Debug("Jobs: " .. json.encode(jobs, { indent = true }))
    end, false)

    PL.RegisterCommand('mysociety', {'user', 'admin'}, function(sPlayer)
        local society = sPlayer.getSociety()

        if society then
            local societyData = jobs[society.name]
            local gradeData = societyData.grades[tostring(society.grade)]

            local societyInfo = {
                ['Nom de la société'] = societyData.label,
                ['Identifiant de la société'] = societyData.name,
                ['Numéro d\'enregistrement'] = societyData.registration_number,
                ['Solde de la société'] = PL.Math.GroupDigits(societyData.money) .. ' $',
                ['IBAN'] = societyData.iban,
                ['Whitelisted'] = societyData.isWhitelisted and "Oui" or "Non",
                ['Grade'] = {
                    ['Nom du grade'] = gradeData.label,
                    ['Nom interne'] = gradeData.name,
                    ['Salaire'] = gradeData.salary .. ' $',
                    ['Whitelisted'] = gradeData.isWhitelisted and "Oui" or "Non"
                }
            }

            local formattedSocietyInfo = json.encode(societyInfo, { indent = true })
            print(("Informations sur la société et le grade de %s (ID: %s):\n%s"):format(sPlayer.getName(), sPlayer.source, formattedSocietyInfo))
        else
            print(('Erreur: Le joueur %s (ID: %s) n\'est pas assigné à une société.'):format(sPlayer.getName(), sPlayer.source))
        end
    end, false)
end)