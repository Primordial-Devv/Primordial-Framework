--- Define constants for resource states.
local RESOURCE_STATES <const> = {
    STARTED = "started",
    STOPPED = "stopped",
}

--- Start a resource on the server
---@param resourceName string The name of the resource to start
local function StartResourceMonitored(resourceName)
    local resourceState <const> = lib.callback.await('primordial_core:server:startResouces', 200,  resourceName)

    if resourceState and GetResourceState(resourceName) == RESOURCE_STATES.STARTED then
        lib.notify({
            title = "Resource started",
            type = "success",
        })
    else
        lib.notify({
            title = "Resource failed to start",
            type = "error",
        })
    end
end

--- Restart a resource on the server
---@param resourceName string The name of the resource to restart
local function RestartResourceMonitored(resourceName)
    local resourceState <const> = lib.callback.await('primordial_core:server:restartResouces', 200,  resourceName)

    if resourceState then
        lib.notify({
            title = "Resource restarted",
            type = "success",
        })
    else
        lib.notify({
            title = "Resource failed to restart",
            type = "error",
        })
    end
end

--- Stop a resource on the server
---@param resourceName string The name of the resource to stop
local function StopResourceMonitored(resourceName)
    local resourceState <const> = lib.callback.await('primordial_core:server:stopResouces', 200,  resourceName)

    if resourceState then
        lib.notify({
            title = "Resource stopped",
            type = "success",
        })
    else
        lib.notify({
            title = "Resource failed to stop",
            type = "error",
        })
    end
end

--- Resources manager module interface
---@param resourceName string The name of the resource
local function ResourcesOptions(resourceName)
    local resourcesOptions <const> = {}

    if GetResourceState(resourceName) ~= RESOURCE_STATES.STARTED then
        resourcesOptions[#resourcesOptions + 1] = {
            title = "Start Resource",
            description = "Start the resource",
            icon = "https://zupimages.net/up/24/47/i0no.png",
            onSelect = function()
                StartResourceMonitored(resourceName)
            end
        }
    end

    if GetResourceState(resourceName) == RESOURCE_STATES.STARTED then
        resourcesOptions[#resourcesOptions + 1] = {
            title = "Stop Resource",
            description = "Stop the resource",
            icon = "https://zupimages.net/up/24/47/s2kt.png",
            onSelect = function()
                StopResourceMonitored(resourceName)
            end
        }
    
        resourcesOptions[#resourcesOptions + 1] = {
            title = "Restart Resource",
            description = "Restart the resource",
            icon = "https://zupimages.net/up/24/47/7hmj.png",
            onSelect = function()
                RestartResourceMonitored(resourceName)
            end
        }
    end

    lib.registerContext({
        id = "primordial_core_resources_manager_options",
        title = resourceName,
        description = "Manage the resource " .. resourceName,
        options = resourcesOptions
    })

    lib.showContext("primordial_core_resources_manager_options")
end

--- Interface for resources manager module
function ResourcesInterface()
    local resources <const> = {}

    resources[#resources + 1] = {
        title = "Refresh all resources",
        icon = "https://zupimages.net/up/24/47/7hmj.png",
        onSelect = function()
            ExecuteCommand("refresh")
            Wait(1000)
            ResourcesInterface()
        end
    }

    for i = 0, GetNumResources() - 1 do
        local resourceName <const> = GetResourceByFindIndex(i)
        if resourceName then
            resources[#resources + 1] = {
                title = resourceName,
                metadata = {
                    { label = "Version", value = GetResourceMetadata(resourceName, "version") or "Unknown" },
                    { label = "Author", value = GetResourceMetadata(resourceName, "author") or "Unknown" },
                    { label = "Description", value = GetResourceMetadata(resourceName, "description") or "No description" },
                },
                onSelect = function()
                    PL.Print.Log(1, "Resource selected: ", resourceName)
                    ResourcesOptions(resourceName)
                end
            }
        end
    end

    lib.registerContext({
        id = "primordial_core_resources_manager",
        title = "Resources",
        description = "Manage server resources",
        options = resources
    })

    lib.showContext("primordial_core_resources_manager")
end