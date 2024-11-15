--- Show the society's registration number.
--- @param Job table The society data.
local function ShowSocietyRegistrationNumber(Job)
    lib.registerContext({
        id = 'primordial_core_society_registration_number',
        title = ('%s Registration Number'):format(Job.label),
        menu = 'primordial_core_society_manage',
        options = {
            {
                title = Job.registration_number,
                icon = 'https://zupimages.net/up/24/44/s4vl.png',
                readOnly = true
            }
        }
    })

    lib.showContext('primordial_core_society_registration_number')
end

--- Show the society's IBAN.
--- @param Job table The society data.
local function ShowSocietyIBAN(Job)
    lib.registerContext({
        id = 'primordial_core_society_iban',
        title = ('%s IBAN'):format(Job.label),
        menu = 'primordial_core_society_manage',
        options = {
            {
                title = Job.iban,
                icon = 'https://zupimages.net/up/24/44/s4vl.png',
                readOnly = true
            }
        }
    })

    lib.showContext('primordial_core_society_iban')
end

--- Handle property transfer of the society to another player.
--- @param Job table The society data.
local function PropertyTransfer(Job)
    local firstConfirmTransfer <const> = lib.alertDialog({
        header = ('Transfer property of %s'):format(Job.label),
        content = 'Are you sure you want to transfer the property of the company to another player?',
        centered = true,
        cancel = true,
        size = 'md',
        labels = {
            confirm = 'Transfer',
        }
    })

    if firstConfirmTransfer ~= "confirm" then return end

    local authorTransfer <const> = cache.ped
    local authorCoords <const> = GetEntityCoords(authorTransfer)
    local nearbyPlayers <const> = PL.Player.GetNearbyPlayers(authorCoords, 10.0, true)

    if #nearbyPlayers == 0 then
        PL.Print.Error('No nearby players for property transfer.')
        return
    end

    local nearbyOptions = {}
    for i=1, #nearbyPlayers do
        local playerName <const> = nearbyPlayers[i].name or "Unknown Name"
        nearbyOptions[#nearbyOptions + 1] = { value = nearbyPlayers[i].id, label = playerName }
    end

    local transferDialog <const> = lib.inputDialog(('Transfer property of %s'):format(Job.label), {
        {
            type = 'select',
            label = 'Choose a player to transfer the property to',
            options = nearbyOptions,
            clearable = true,
            searchable = true
        }
    })

    if not transferDialog or not transferDialog[1] then return end

    local selectedPlayerId <const> = transferDialog[1]
    local selectedPlayerName = "Unknown Name"

    for i=1, #nearbyPlayers do
        if nearbyPlayers[i].id == selectedPlayerId then
            selectedPlayerName = nearbyPlayers[i].name
            break
        end
    end

    local secondConfirmTransfer <const> = lib.alertDialog({
        header = ('Transfer property of %s'):format(Job.label),
        content = ('Are you sure you want to transfer the property of the company to %s?'):format(selectedPlayerName),
        centered = true,
        cancel = true,
        size = 'md',
        labels = {
            confirm = 'Transfer',
        }
    })

    if secondConfirmTransfer == "confirm" then
        -- Trigger server callback to process the transfer.
        local success <const> = lib.callback.await("primordial_core:server:transferSocietyOwner", 1200, Job.name, selectedPlayerId)

        if success then
            lib.notify({
                title = ("Property Transferred Successfully"),
                description = ("The property of %s has been transferred to %s."):format(Job.label, selectedPlayerName),
                type = "success"
            })
        else
            lib.notify({
                title = "Transfer Failed",
                description = "An error occurred during the transfer process.",
                type = "error"
            })
        end
    end
end


--- Manage the society actions (view registration, IBAN, or transfer ownership).
--- @param Job table The society data.
function ManageSociety(Job)
    local manageSocietyOptions = {}

    manageSocietyOptions[#manageSocietyOptions+1] = {
        title = ('View %s registration number'):format(Job.label),
        description = 'View the registration number of the company',
        icon = 'https://zupimages.net/up/24/44/s4vl.png',
        onSelect = function()
            ShowSocietyRegistrationNumber(Job)
        end
    }

    manageSocietyOptions[#manageSocietyOptions+1] = {
        title = ('View %s iban'):format(Job.label),
        description = 'View the IBAN of the company',
        icon = 'https://zupimages.net/up/24/44/s4vl.png',
        onSelect = function()
            ShowSocietyIBAN(Job)
        end
    }

    manageSocietyOptions[#manageSocietyOptions+1] = {
        title = ('Tranfer property of %s'):format(Job.label),
        description = 'Transfer the property of the company to another player',
        icon = 'https://zupimages.net/up/24/44/ktio.png',
        onSelect = function()
            PropertyTransfer(Job)
        end
    }

    lib.registerContext({
        id = 'primordial_core_society_manage',
        title = ('Manage %s'):format(Job.label),
        menu = 'primordial_core_society_boss_menu',
        options = manageSocietyOptions
    })

    lib.showContext('primordial_core_society_manage')
end