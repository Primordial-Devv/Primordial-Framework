function AdminInterface(permissions)
    if not permissions then return end

    local homeppageOptions = {}

    homeppageOptions[#homeppageOptions+1] = {
        title = Translations.self_options_title,
        description = Translations.self_options_description,
        icon = 'fa-solid fa-user',
        onSelect = function()
            SelfOptionsInterface(permissions)
        end
    }

    homeppageOptions[#homeppageOptions+1] = {
        title = Translations.player_options_title,
        description = Translations.player_options_description,
        icon = 'fa-solid fa-user-group',
        onSelect = function()
            PlayerOptionsInterface(permissions)
        end
    }

    homeppageOptions[#homeppageOptions+1] = {
        title = Translations.vehicle_options_title,
        description = Translations.vehicle_options_description,
        icon = 'fa-solid fa-car-side',
        onSelect = function()
            VehicleOptionsInterface(permissions)
        end
    }

    homeppageOptions[#homeppageOptions+1] = {
        title = Translations.zones_options_title,
        description = Translations.zones_options_description,
        icon = 'fa-solid fa-vector-square',
        onSelect = function()
            AdminZoneOptions(permissions)
        end
    }

    if permissions.report_view_options then
        homeppageOptions[#homeppageOptions+1] = {
            title = Translations.report_options_title,
            description = Translations.report_options_description,
            icon = 'fa-regular fa-comment',
            onSelect = function()
                ReportOptionsInterface(permissions)
            end
        }
    end

    homeppageOptions[#homeppageOptions+1] = {
        title = Translations.server_options_title,
        description = Translations.server_options_description,
        icon = 'fa-solid fa-server',
        onSelect = function()
            ServerOptionsInterface(permissions)
        end
    }

    homeppageOptions[#homeppageOptions+1] = {
        title = Translations.developer_options_title,
        description = Translations.developer_options_description,
        icon = 'fa-solid fa-laptop-code',
        onSelect = function()
            print('^1[^5Primordial Admin^1] ^3Opening Developer Options')
            DeveloperOptionsInterface(permissions)
        end
    }

    lib.registerContext({
        id = 'primordial_admin_homepage',
        title = Translations.homepage_title,
        options = homeppageOptions
    })

    lib.showContext('primordial_admin_homepage')
end