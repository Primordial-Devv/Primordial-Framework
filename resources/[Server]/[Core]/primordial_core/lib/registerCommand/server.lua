local function PlayerHasPermissions(source, group)
    local player = PL.GetPlayerFromId(source)
    if not player then return end
    if player.getGroup() ~= group then
        return false
    else
        return true
    end
end

-- Register a command server-side
---@param commandName string | string[] The name of the command
---@param groups string[] The groups that can use the command
---@param callbackFunction function  The function that will be called when the command is executed
---@param allowConsole boolean Whether the command can be executed from the console
---@param suggestion table The suggestion for the command
function PL.RegisterCommand(commandName, groups, callbackFunction, allowConsole, suggestion)
    if type(commandName) == "table" then
        for _, v in ipairs(commandName) do
            PL.RegisterCommand(v, groups, callbackFunction, allowConsole, suggestion)
        end
        return
    end

    if PL.RegisteredCommands[commandName] then
        PL.Print.Warning(('Command "%s" already registered, overriding command'):format(commandName))
        if PL.RegisteredCommands[commandName].suggestion then
            TriggerClientEvent("chat:removeSuggestion", -1, ("/%s"):format(commandName))
        end
    end

    if suggestion then
        suggestion.arguments = suggestion.arguments or {}
        suggestion.help = suggestion.help or ""
        TriggerClientEvent("chat:addSuggestion", -1, ("/%s"):format(commandName), suggestion.help, suggestion.arguments)
    end

    PL.RegisteredCommands[commandName] = {
        groups = groups,
        callbackFunction = callbackFunction,
        allowConsole = allowConsole,
        suggestion = suggestion
    }

    RegisterCommand(commandName, function(source, args)
        local command = PL.RegisteredCommands[commandName]

        local function handleError(msg)
            if source == 0 then
                PL.Print.Error(msg)
            else
                lib.notify(source, {
                    title = msg;
                    type = "error";
                })
            end
        end

        if not command.allowConsole and source == 0 then
            handleError(('The command "%s" cannot be used from the console'):format(commandName))
            return
        end

        local hasGroupPermissions = false
        if source == 0 then
            hasGroupPermissions = command.allowConsole
        elseif command.groups then
            for _, groups in ipairs(command.groups) do
                if PlayerHasPermissions(source, groups) then
                    hasGroupPermissions = true
                    break
                end
            end
        end

        if not hasGroupPermissions then
            handleError(('Player "%s" does not have permission to use the command "%s"'):format(source, commandName))
            return
        end
        -- if not PL.AdminPermissions(source) then
        --     PL.Print.Error(('Player "%s" does not have permission to use the command "%s"'):format(source, commandName))
        --     return
        -- end

        local sPlayer = PL.Players[source]

        if command.suggestion then
            if command.suggestion.validate then
                if #args ~= #command.suggestion.arguments then
                    handleError((Translations.commanderror_argumentmismatch):format(#args, #command.suggestion.arguments))
                end
            end

            if command.suggestion.arguments then
                local newArgs = {}

                for k, v in ipairs(command.suggestion.arguments) do
                    local arg = args[k]
                    if v.type then
                        if v.type == "number" then
                            local newArg = tonumber(arg)

                            if newArg then
                                newArgs[v.name] = newArg
                            else
                                handleError((Translations.commanderror_argumentmismatch_number):format(k))
                                return
                            end
                        elseif v.type == "player" or v.type == "playerId" then
                            local targetPlayer = tonumber(arg) or (arg == "me" and source)

                            -- if arg == "me" then
                            --     targetPlayer = source
                            -- end

                            if targetPlayer then
                                local xTargetPlayer = PL.GetPlayerFromId(targetPlayer)

                                if xTargetPlayer then
                                    newArgs[v.name] = (v.type == 'player') and xTargetPlayer or targetPlayer
                                else
                                    handleError(Translations.commanderror_invalidplayerid)
                                    return
                                end
                            else
                                handleError((Translations.commanderror_argumentmismatch_number):format(k))
                                return
                            end
                        elseif v.type == "string" then
                            local newArg = tonumber(arg)
                            if not newArg then
                                newArgs[v.name] = arg
                            else
                                handleError((Translations.commanderror_argumentmismatch_string):format(k))
                                return
                            end
                        elseif v.type == "item" then
                            if PL.Items[arg] then
                                newArgs[v.name] = arg
                            else
                                handleError(Translations.commanderror_invaliditem)
                                return
                            end
                        elseif v.type == "any" then
                            newArgs[v.name] = arg
                        elseif v.type == "merge" then
                            -- local length = 0
                            -- for i = 1, k - 1 do
                            --     length = length + string.len(args[i]) + 1
                            -- end
                            -- local merge = table.concat(args, " ")

                            -- newArgs[v.name] = string.sub(merge, length)
                            newArgs[v.name] = table.concat(args, " ", k)
                            break
                        elseif v.type == "coordinate" then
                            local coord = tonumber(arg:match("(-?%d+%.?%d*)"))
                            if not coord then
                                handleError((Translations.commanderror_argumentmismatch_number):format(k))
                                return
                            else
                                newArgs[v.name] = coord
                            end
                        end
                    end
                end
                args = newArgs
            end
        end

        callbackFunction(sPlayer or false, args, function(msg)
            if source == 0 then
                PL.Print.Warning(msg)
            else
                lib.notify(sPlayer.source, {
                    title = msg;
                    type = "info";
                })
            end
        end)
    end, true)
end

return PL.RegisterCommand