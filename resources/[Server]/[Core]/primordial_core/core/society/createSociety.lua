--- Create a society menu to create a society with the given name
---@param societyName string The unique name that will be used to identify the society
local function CreateSocietyMenu(societyName)
    local authorCreation <const> = cache.ped
    local authorCoords <const> = GetEntityCoords(authorCreation)
    local nearbyPlayers <const> = PL.Player.GetNearbyPlayers(authorCoords, 10.0, true)

    if #nearbyPlayers == 0 then
        PL.Print.Log(3, false, 'No nearby players for ownership transfer.')
        return
    end

    local nearbyOptions <const> = {}
    for i=1, #nearbyPlayers do
        local playerName <const> = nearbyPlayers[i].name or 'Unknown Name'
        nearbyOptions[#nearbyOptions + 1] = { value = nearbyPlayers[i].id, label = playerName }
    end

    local createSocietyInfo <const> = lib.inputDialog('Create a society', {
        {
            type = 'input',
            label = 'Society name',
            description = 'Enter the unique name that will be used to identify the society',
            default = societyName,
            required = true
        },
        {
            type = 'input',
            label = 'Society label',
            description = 'Enter the label that will be displayed for the society',
            placeholder = 'Society label',
            required = true
        },
        {
            type = 'select',
            label = 'Society Owner',
            description = 'Select the owner of the society',
            placeholder = 'Society Owner',
            required = true,
            options = nearbyOptions
        },
        {
            type = "select",
            label = "Whitelist Company?",
            description = "Is this a whitelisted company?",
            placeholder = "Select Yes or No",
            required = true,
            options = {
                { value = "yes", label = "Yes" },
                { value = "no", label = "No" },
            }
        },
    })

    if not createSocietyInfo then return end

    local selectedSocietyName <const> = createSocietyInfo[1]
    local selectedSocietyLabel <const> = createSocietyInfo[2]
    local selectedPlayerId <const> = createSocietyInfo[3]
    local isWhitelisted <const> = createSocietyInfo[4]

    PL.Print.Log(4, false, 'isWhitelisted: ' .. isWhitelisted)
    local selectedPlayerName = "Unknown Name"

    for _, player in ipairs(nearbyPlayers) do
        if player.id == selectedPlayerId then
            selectedPlayerName = player.name
            break
        end
    end

    local success <const> = lib.callback.await('primordial:server:createSocietyDB', 500, selectedSocietyName, selectedSocietyLabel, isWhitelisted, selectedPlayerId)

    if not success then
        PL.Print.Log(3, false, 'An error occurred while creating the society.')
        return
    end

    PL.Print.Log(1, false, 'The society has been created successfully and the owner is ' .. selectedPlayerName)
end

--- Register an event to trigger the society creation menu.
--- @param societyName string The unique name for the society.
RegisterNetEvent('primordial_core:client:createSociety', function(societyName)
    CreateSocietyMenu(societyName)
end)