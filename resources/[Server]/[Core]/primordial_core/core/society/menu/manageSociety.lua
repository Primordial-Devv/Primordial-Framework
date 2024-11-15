---@param Job table
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

---@param Job table
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

---@param Job table
local function PropertyTransfer(Job)
    local firstConfirmTransfer = lib.alertDialog({
        header = ('Transfer property of %s'):format(Job.label),
        content = 'Are you sure you want to transfer the property of the company to another player?',
        centered = true,
        cancel = true,
        size = 'md',
        labels = {
            confirm = 'Transfer',
        }
    })

    if firstConfirmTransfer == 'confirm' then
        local authorTransfer = cache.ped
        local authorCoords = GetEntityCoords(authorTransfer)
        local nearbyPlayers = PL.Player.GetNearbyPlayers(authorCoords, 10.0, true)

        if #nearbyPlayers == 0 then
            PL.Print.Error('Aucun joueur à proximité pour effectuer le transfert de propriété.')
            return
        end

        local nearbyOptions = {}
        for i=1, #nearbyPlayers do
            local playerName = nearbyPlayers[i].name or 'Nom inconnu'
            nearbyOptions[#nearbyOptions+1] = {
                value = nearbyPlayers[i].id,
                label = playerName
            }
        end

        local transferDialog = lib.inputDialog(('Transfer property of %s'):format(Job.label), {
            {
                type = 'select',
                label = 'Choose a player to transfer the property to',
                options = nearbyOptions,
                clearable = true,
                searchable = true
            }
        })

        if not transferDialog or not transferDialog[1] then return end

        local selectedPlayerId = transferDialog[1]
        local selectedPlayerName = 'Nom inconnu'

        for i=1, #nearbyPlayers do
            if nearbyPlayers[i].id == selectedPlayerId then
                selectedPlayerName = nearbyPlayers[i].name
                break
            end
        end

        local secondConfirmTransfer = lib.alertDialog({
            header = ('Transfer property of %s'):format(Job.label),
            content = ('Are you sure you want to transfer the property of the company to %s?'):format(selectedPlayerName),
            centered = true,
            cancel = true,
            size = 'md',
            labels = {
                confirm = 'Transfer',
            }
        })

        if secondConfirmTransfer == 'confirm' then
            PL.Print.Debug('The property has been transferred successfully to ' .. selectedPlayerName)
        end
    end
end


---@param Job table
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