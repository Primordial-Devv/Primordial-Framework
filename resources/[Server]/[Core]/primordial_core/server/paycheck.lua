function StartPayCheck()
    CreateThread(function()
        while true do
            Wait(1500000) -- 25 minutes
            for player, sPlayer in pairs(PL.Players) do
                local jobLabel = sPlayer.job.label
                local job = sPlayer.job.grade_name
                local salary = sPlayer.job.grade_salary

                if salary > 0 then
                    if job == "unemployed" then -- unemployed
                        sPlayer.addAccountMoney("bank", salary, "Welfare Check")
                        TriggerClientEvent("primordial_core:client:showAdvancedNotification", player, Translations.bank, Translations.received_paycheck, Translations.received_help:format(salary), 3, false, true, "CHAR_BANK_MAZE")

                        PL.Discord.DiscordLogFields("Paycheck", "Paycheck - Unemployment Benefits", "green", {
                            { name = "Player", value = sPlayer.name, inline = true },
                            { name = "ID", value = sPlayer.source, inline = true },
                            { name = "Amount", value = salary, inline = true },
                        })
                        
                    else -- possibly a society
                        TriggerEvent("primordial_core:server:getSociety", sPlayer.job.name, function(society)
                            if society ~= nil then -- verified society
                                TriggerEvent("primordial_core:server:society:getSocietyAccount", society.account, function(account)
                                    if account.money >= salary then -- does the society money to pay its employees?
                                        sPlayer.addAccountMoney("bank", salary, "Paycheck")
                                        account.removeMoney(salary)

                                        PL.Discord.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
                                            { name = "Player", value = sPlayer.name, inline = true },
                                            { name = "ID", value = sPlayer.source, inline = true },
                                            { name = "Amount", value = salary, inline = true },
                                        })

                                        TriggerClientEvent("primordial_core:client:showAdvancedNotification", player, Translations.bank, Translations.received_paycheck, Translations.received_salary:format(salary), 3, false, true, "CHAR_BANK_MAZE")
                                    else
                                        TriggerClientEvent("primordial_core:client:showAdvancedNotification", player, Translations.bank, "", Translations.company_nomoney, 3, false, true, "CHAR_BANK_MAZE")
                                    end
                                end)
                            else -- not a society
                                sPlayer.addAccountMoney("bank", salary, "Paycheck")

                                PL.Discord.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
                                    { name = "Player", value = sPlayer.name, inline = true },
                                    { name = "ID", value = sPlayer.source, inline = true },
                                    { name = "Amount", value = salary, inline = true },
                                })

                                TriggerClientEvent("primordial_core:client:showAdvancedNotification", player, Translations.bank, Translations.received_paycheck, Translations.received_salary:format(salary),  3, false, true, "CHAR_BANK_MAZE")
                            end
                        end)
                    -- else -- generic job
                    --     sPlayer.addAccountMoney("bank", salary, "Paycheck")

                    --     PL.Discord.DiscordLogFields("Paycheck", "Paycheck - Generic", "green", {
                    --         { name = "Player", value = sPlayer.name, inline = true },
                    --         { name = "ID", value = sPlayer.source, inline = true },
                    --         { name = "Amount", value = salary, inline = true },
                    --     })

                    --     TriggerClientEvent("primordial_core:client:showAdvancedNotification", player, Translations.bank, Translations.received_paycheck, Translations.received_salary:format(salary), "CHAR_BANK_MAZE", 9)
                    end
                end
            end
        end
    end)
end
