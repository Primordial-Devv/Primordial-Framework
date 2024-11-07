---@type Society
local Job;

RegisterNetEvent('primordial_core:sendPlayerSociety', function(jobData)
    local menu <const> = lib.getOpenContextMenu();
    if (menu == 'primordial_core_society_boss_menu') then
        lib.hideContext();
    end
    Job = jobData;
end);

local function ManageSocietyMoney()
    local societyMoneyOptions = {}

    societyMoneyOptions[#societyMoneyOptions+1] = {
        title = ('View %s balance'):format(Job.label),
        description = 'View the balance of the company',
        icon = 'https://zupimages.net/up/24/44/s4vl.png',
        onSelect = function()
            PL.Print.Debug('View balance')
        end
    }

    societyMoneyOptions[#societyMoneyOptions+1] = {
        title = ('View %s transactions'):format(Job.label),
        description = 'View the transactions of the company',
        icon = 'https://zupimages.net/up/24/44/s4vl.png',
        onSelect = function()
            PL.Print.Debug('View transactions')
        end
    }
end

---@param society string The society name to open the boss menu for
function SocietyBossMenu(society)
    if (not Job or Job.name ~= society) then
        return PL.Print.Error("Les données de Jobs ne sont pas encore chargées.")
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
                    PL.Print.Debug('Money Management')
                    ManageSocietyMoney()
                end
            },
            {
                title = 'Grades Management',
                description = 'Manages everything related to the company\'s grades',
                icon = 'https://zupimages.net/up/24/44/c1lm.png',
                onSelect = function()
                    PL.Print.Debug('Grades Management')
                end
            }
        }
    })

    lib.showContext('primordial_core_society_boss_menu')
end

RegisterNetEvent('primordial_core:client:openSocietyBossMenu', SocietyBossMenu)