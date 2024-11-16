function PedMenu()
    local pedOptions = {}
    for _, v in pairs(PedSelection) do
        pedOptions[#pedOptions + 1] = {
            title = v.Name,
            description = ('Change your character\'s ped to %s'):format(v.Name),
            icon = 'fa-solid fa-user',
            onSelect = function()
                if v.Model == 'restore' then
                    TriggerEvent('skinchanger:loadDefaultModel')
                    local skin = lib.callback.await('esx_skin:getPlayerSkin', 2000)
                    if skin then
                        TriggerEvent('skinchanger:loadSkin', skin)
                    else
                        PL.Print.Log(3, false, 'Failed to load skin')
                    end
                else
                    PL.Streaming.RequestModel(v.Model)
                    SetPlayerModel(PlayerId(), v.Model)
                    SetModelAsNoLongerNeeded(v.Model)
                end
            end
        }
    end
    lib.registerContext({
        id = 'primordial_admin_ped_menu',
        title = Translations.ped_title,
        menu = 'primordial_admin_self_options',
        options = pedOptions
    })

    lib.showContext('primordial_admin_ped_menu')
end