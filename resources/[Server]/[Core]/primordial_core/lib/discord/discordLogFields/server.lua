--- Send a log to a discord webhook with a custom name, title, color and fields.
---@param name string The name of the webhook to send the log to.
---@param title string The title of the log.
---@param color string The color of the log.
---@param fields table The fields of the log.
function PL.Discord.DiscordLogFields(name, title, color, fields)
    local webHook = DiscordLogs.Webhooks[name] or DiscordLogs.Webhooks.default
    local embedData = {
        {
            ["title"] = title,
            ["color"] = DiscordLogs.Colors[color] or DiscordLogs.Colors.default,
            ["footer"] = {
                ["text"] = "| PL Logs | " .. os.date(),
                ["icon_url"] = "https://cdn.discordapp.com/attachments/944789399852417096/1020099828266586193/blanc-800x800.png",
            },
            ["fields"] = fields,
            ["description"] = "",
            ["author"] = {
                ["name"] = "PL Framework",
                ["icon_url"] = "https://cdn.discordapp.com/emojis/939245183621558362.webp?size=128&quality=lossless",
            },
        },
    }
    PerformHttpRequest(webHook, nil, "POST", json.encode({
        username = "Logs",
        embeds = embedData,
    }),{["Content-Type"] = "application/json"})
end

return PL.Discord.DiscordLogFields