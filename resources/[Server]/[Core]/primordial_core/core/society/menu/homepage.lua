---@type Society
local Job;

--- Receive and update the society data for the current player.
--- @param jobData table The data of the player's society.
RegisterNetEvent('primordial_core:sendPlayerSociety', function(jobData)
    local menu <const> = lib.getOpenContextMenu();
    if (menu == 'primordial_core_society_boss_menu') then
        lib.hideContext();
    end
    Job = jobData;
end);

--- Manage society money-related actions.
local function ManageSocietyMoney()
    local societyMoneyOptions = {}

    societyMoneyOptions[#societyMoneyOptions+1] = {
        title = ('View %s balance'):format(Job.label),
        description = 'View the balance of the company',
        icon = 'https://zupimages.net/up/24/44/s4vl.png',
        onSelect = function()
            PL.Print.Log(4, 'View balance')
        end
    }

    societyMoneyOptions[#societyMoneyOptions+1] = {
        title = ('View %s transactions'):format(Job.label),
        description = 'View the transactions of the company',
        icon = 'https://zupimages.net/up/24/44/s4vl.png',
        onSelect = function()
            PL.Print.Log(4, 'View transactions')
        end
    }

    lib.registerContext({
        id = 'primordial_core_society_money_manage',
        title = ('Manage %s Money'):format(Job.label),
        menu = 'primordial_core_society_boss_menu',
        options = societyMoneyOptions
    })

    lib.showContext('primordial_core_society_money_manage')
end

--- Open the boss menu for a specific society.
--- @param society string The name of the society to open the boss menu for.
function SocietyBossMenu(society)
    if (not Job or Job.name ~= society) then
        return PL.Print.Log(3, "Society data is not yet loaded.")
    end

    lib.registerContext({
        id = 'primordial_core_society_boss_menu',
        title = ('%s Boss Actions'):format(Job.label),
        options = {
            {
                title = 'Society Management',
                description = 'Manages everything related to the company',
                icon = 'https://zupimages.net/up/24/44/jov5.png',
                onSelect = function()
                    ManageSociety(Job)
                end
            },
            {
                title = 'Money Management',
                description = 'Manages everything related to the company\'s money',
                icon = 'https://zupimages.net/up/24/44/14v9.png',
                onSelect = function()
                    PL.Print.Log(4, 'Money Management')
                    ManageSocietyMoney()
                end
            },
            {
                title = 'Grades Management',
                description = 'Manages everything related to the company\'s grades',
                icon = 'https://zupimages.net/up/24/44/c1lm.png',
                onSelect = function()
                    PL.Print.Log(4, 'Grades Management')
                end
            },
            {
                title = 'Employees Management',
                description = 'Manages everything related to the company\'s employees',
                icon = 'https://zupimages.net/up/24/46/5osv.png',
                onSelect = function()
                    PL.Print.Log(4, 'Employees Management')
                end
            },
            {
                title = 'Inventory Management',
                description = 'Manages everything related to the company\'s inventory',
                icon = 'https://zupimages.net/up/24/46/z1r7.png',
                onSelect = function()
                    PL.Print.Log(4, 'Inventory Management')
                end
            },
            {
                title = 'Contract Management',
                description = 'Manages everything related to the company\'s contracts',
                icon = 'https://zupimages.net/up/24/46/vcp8.png',
                onSelect = function()
                    PL.Print.Log(4, 'Contract Management')
                end
            }
        }
    })

    lib.showContext('primordial_core_society_boss_menu')
end

--- Register an event to open the boss menu for a society.
RegisterNetEvent('primordial_core:client:openSocietyBossMenu', SocietyBossMenu)