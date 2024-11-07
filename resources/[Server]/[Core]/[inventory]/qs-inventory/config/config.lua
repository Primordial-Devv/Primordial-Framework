--[[
    Welcome to the **qs-inventory configuration**!

    This configuration file contains essential settings to customize and optimize your inventory system. Before you begin modifying the settings, please ensure you have reviewed each section of the documentation linked below, as it provides step-by-step instructions and in-depth explanations for each configurable option.

    Key settings within this file are designed for flexibility. You are encouraged to adjust and adapt these configurations to seamlessly integrate with your server's framework, creating a more personalized inventory experience for your players.

    Editable configurations are located primarily in the **client/custom/** and **server/custom/** directories, making adjustments straightforward and organized.

    📄 **Direct Documentation Link:**
    Refer to the official documentation here for comprehensive details and guidance: https://docs.quasar-store.com/
]]

Config = Config or {}
Locales = Locales or {}

--[[ 
    Choose your preferred language!

    In this section, you can select the main language for your asset. We have a wide
    selection of default languages available, located in the locales/* folder.

    If your language is not listed, don't worry! You can easily create a new one
    by adding a new file in the locales folder and customizing it to your needs.

    🌐 Default languages available:
        'ar'     -- Arabic
        'bg'     -- Bulgarian
        'ca'     -- Catalan
        'cs'     -- Czech
        'da'     -- Danish
        'de'     -- German
        'el'     -- Greek
        'en'     -- English
        'es'     -- Spanish
        'fa'     -- Persian
        'fr'     -- French
        'he'     -- Hebrew
        'hi'     -- Hindi
        'hu'     -- Hungarian
        'it'     -- Italian
        'ja'     -- Japanese
        'ko'     -- Korean
        'nl'     -- Dutch
        'no'     -- Norwegian
        'pl'     -- Polish
        'pt'     -- Portuguese
        'ro'     -- Romanian
        'ru'     -- Russian
        'sl'     -- Slovenian
        'sv'     -- Swedish
        'th'     -- Thai
        'tr'     -- Turkish
        'zh-CN'  -- Chinese (Simplified)
        'zh-TW'  -- Chinese (Traditional)

    After selecting your preferred language, be sure to save your changes and test
    the asset to ensure everything works as expected!
]]

Config.Language = 'en'

--[[
    Framework Detection and Configuration Guide for qs-inventory

    This inventory system automatically detects whether you are using `qb-core`, `es_extended`, or `qbx_core`
    as your main framework, assigning it to `Config.Framework` accordingly. However, if you have renamed
    any of these resources, or use a modified framework setup, you may need to update this configuration manually.

    To set up manually:
        1. Remove the automatic detection code by clearing `Config.Framework`'s value.
        2. Replace it with the name of your custom framework setup.
        3. Update any relevant framework-specific functions within the script's client and server files.

    Warning:
    ⚠️ The automatic framework detection is set for standard setups. Avoid modifying this section
    unless you have a deep understanding of the framework structure, as incorrect modifications
    could disrupt functionality.

    Remember, for the inventory system to work seamlessly, make sure `qb-core`, `es_extended`,
    or `qbx_core` (or their equivalent files) are running at startup.
]]

local esxHas = GetResourceState('es_extended') == 'started'
local qbHas = GetResourceState('qb-core') == 'started'
local qbxHas = GetResourceState('qbx_core') == 'started'

Config.Framework = esxHas and 'esx' or qbHas and 'qb' or qbxHas and 'qb' or 'esx'

--[[
    Backward Compatibility Mode for qs-inventory Migration

    The `Config.FetchOldInventory` setting is designed for users migrating data from an older version of qs-inventory to the current system.

    - **Purpose:** When set to `true`, this option initiates a one-time data migration process, transferring all relevant inventory data from the old qs-inventory to the updated version.
    - **Completion Alert:** Once the migration is successfully finished, a message saying `Backward compatibility has been completed` will display in your console.
    - **IMPORTANT:** After the migration is complete, immediately switch `Config.FetchOldInventory` back to `false`. Keeping it enabled after migration can result in potential errors, as the script is not intended to run with backward compatibility enabled long-term.
    - **Usage Warning:** Do not use or modify other settings in the script while `Config.FetchOldInventory` is active, as this is a one-time migration setting designed solely for data transfer.

    Ensure to read the documentation for any additional guidance on migration steps.
]]

Config.FetchOldInventory = false -- Set to `true` only once to start the migration process, then return to `false` immediately after.

--[[
    Target systems configuration compatible with both qb-core and es_extended frameworks.
    Options:
        'qb-target'     : Uses the qb-target framework for item targeting.
        'ox_target'     : Uses the ox_target framework for item targeting.
        'none'          : Deactivates all targeting features.

    Note: Targeting is not available for the item DROP or THROW functionalities in this configuration.
]]

Config.UseTarget = false -- Set to true to enable targeting with either 'qb-target' or 'ox_target', or false to disable entirely.

--[[
    General Configuration Guide for the Inventory System

    This section outlines various customization options available within the qs-inventory system. Each setting allows
    for detailed customization, from item targeting methods to inventory slot configurations and item interaction options.
    To adjust the settings for your server, carefully review each parameter below. Note that certain adjustments (e.g.,
    slot limits or item weight capacities) may require special attention to avoid issues with existing inventories.

    ---- CONFIGURATION SETTINGS BREAKDOWN ----
]]

Config.ThrowKeybind = 'E'                -- Sets the keybinding for throwing items from the inventory (default: 'E').
Config.BlockedSwap = false               -- Set to true to prevent item swapping between slots, restricting reorganization.
Config.BlockedSlot = true                -- Locks the sixth slot to prevent stealing; valuable items placed here are protected.
Config.GiveItemHideName = false          -- Hides item names during give-item actions, showing only the item ID for privacy.
Config.OpenProgressBar = false           -- Enable to add a progress bar for inventory opening, reducing duplication risks.
Config.EnableSounds = true               -- Select if you want the default inventory sounds completely muted

Config.Handsup = true                    -- Toggle on/off the hands-up feature and enable/disable robbery options.
Config.StealDeadPlayer = true            -- Allows players to loot items from dead players when enabled.
Config.StealWithoutWeapons = false       -- Restricts robbery interactions; can only rob if target has hands raised without a weapon.
Config.DropItemWhenInventoryFull = false -- Automatically drops items when inventory is full; prevents item overload.

Config.InventoryWeight = {               -- Player inventory capacity configurations:
    ['weight'] = 120000,                 -- Maximum weight capacity for inventory in grams. ⚠️ Changes require inventory wipe to avoid duplication issues.
    ['slots'] = 41,                      -- Total available slots. Set to 40 to remove the sixth (protected) slot.
}

Config.DropWeight = {      -- Drop item weight and slot configurations:
    ['weight'] = 20000000, -- Maximum drop item weight in grams, managing ground clutter capacity.
    ['slots'] = 130,       -- Total slot capacity for dropped items. Adjust to limit or increase ground item limits.
}

Config.LabelChange = true          -- Enables players to rename inventory items for customization.
Config.LabelChangePrice = false    -- Sets a price for label changes; set to 'false' to make renaming free.
Config.BlockedLabelChangeItems = { -- Restricts renaming for certain items:
    ['money'] = true,              -- Prevents renaming of currency items.
    ['phone'] = true,              -- Prevents renaming of phones.
}

Config.UsableItemsFromHotbar = true -- Enables quick access for item use directly from hotbar (slots 1-5).
Config.BlockedItemsHotbar = {       -- Restricts specific items from hotbar use, requiring full inventory access for use.
    'lockpick',                     -- Example item restricted from hotbar usage.
    -- Add additional items as needed to restrict their hotbar access.
}

--[[
    Quasar Store - Backpack Configuration for qs-inventory

    This section configures backpack functionality within the inventory system. Backpacks are managed as unique items
    with a limit of one per player. By defining items as non-storable or non-stealable, you can control item interactions
    and storage rules for specific items. Additionally, this configuration allows for customization of item drop visuals,
    clothing management, and gender identification in inventory contexts.

    ---- DETAILED CONFIGURATION SETTINGS ----
]]

Config.OnePerItem = {
    -- Restricts certain items to a single instance per player. For example, only one backpack can be held at a time.
    ['backpack'] = 1,
    -- Add more items here to set maximum quantity per item type.
}

Config.notStolenItems = {
    -- Defines items that cannot be stolen from other players. Helps protect specific personal or essential items.
    ['id_card'] = true,      -- ID cards cannot be stolen.
    ['water_bottle'] = true, -- Water bottles are non-stealable.
    ['tosti'] = true         -- Additional protected item (example).
}

Config.notStoredItems = {
    -- Defines items that cannot be stored in stashes or shared containers, ensuring these items stay in the player inventory.
    ['backpack'] = true, -- Prevents backpacks from being stored.
}

-- Enables or disables clothing system integration. Refer to the documentation for your framework setup:
-- ESX Documentation: https://docs.quasar-store.com/ Inventory > Functions > Clothing
-- QB Documentation: https://docs.quasar-store.com/
Config.Clothing = true                         -- Enables clothing options in the inventory, with a corresponding button.
Config.TakePreviousClothes = true              -- Determines if previously worn clothes are added back to inventory upon changing.

Config.ItemDropObject = `prop_paper_bag_small` -- Sets the model for dropped items. Can be set to `false` for no visual object.
Config.DropRefreshTime = 15 * 60               -- Sets how often dropped items are refreshed (in seconds).
Config.MaxDropViewDistance = 9.5               -- Maximum distance a player can view dropped items.

Config.Genders = {
    -- Gender labels in the inventory system. No need to adjust unless expanding gender categories.
    ['m'] = 'Male',
    ['f'] = 'Female',
    [1] = 'Male',
    [2] = 'Female'
}

--[[
    Visual Configuration Overview:

    This section controls the visual and user interface settings of the resource.
    Here, you can adjust everything from the animation style used to open the inventory,
    to the logo and item icons within the inventory interface.

    * `InventoryOptions` includes options to display or hide sidebar information,
      such as health, armor, and other character stats.
    * `Config.Defaults` contains settings for base character appearances, such as
      clothing defaults, which you may need to modify if you’re using custom clothes.
]]

Config.OpenInventoryAnim = true                         -- Enables a player animation when opening the inventory
Config.OpenInventoryScene = false                       -- Toggles the scene animation when the inventory is opened
Config.Logo = 'https://i.ibb.co/CJfj6KV/Mini-copia.png' -- Path to a logo image (use a URL or a local path such as './icons/logo.png') or set false
Config.IdleCamera = true                                -- Enables or disables idle camera functionality in the inventory screen

-- Configure additional sidebar options within the inventory display:
Config.InventoryOptions = {
    -- Generic menus
    ['clothes'] = Config.Clothing, -- Controls visibility of clothing customization in Config.Clothing
    ['configuration'] = true,      -- Toggle configuration options visibility in the inventory

    -- Left sidebar items
    ['health'] = true, -- Displays player health status
    ['armor'] = true,  -- Displays player armor status
    ['hunger'] = true, -- Displays hunger status (if applicable)
    ['thirst'] = true, -- Displays thirst status (if applicable)

    -- Right sidebar items
    ['id'] = true,         -- Shows player ID
    ['money'] = true,      -- Displays player cash amount
    ['bank'] = true,       -- Displays player bank balance
    ['blackmoney'] = true, -- Displays player 'black money' (if applicable)
}

-- Custom icons for items in the inventory UI, utilizing FontAwesome icons (https://fontawesome.com/)
Config.getItemicons = {
    ['tosti'] = {
        icon = 'fa-solid fa-utensils', -- Icon for "tosti" item
    },
    ['water_bottle'] = {
        icon = 'fa-solid fa-utensils', -- Icon for "water bottle" item
    },
}

-- Default character appearance options (adjust as needed for custom clothing setups)
Config.Defaults = {
    ['female'] = {
        torso = 15,
        jeans = 14,
        shoes = 45,
        arms = 15,
        helmet = -1,
        glasses = -1,
        mask = 0,
        tshirt = -1,
        ears = -1,
        bag = 0,
    },
    ['male'] = {
        torso = 15,
        jeans = 14,
        shoes = 45,
        arms = 15,
        helmet = -1,
        glasses = -1,
        mask = 0,
        tshirt = 15,
        ears = -1,
        bag = 0,
    }
}

-- Key Bindings: Configure shortcut keys for inventory actions
-- Check the documentation for guidelines on modifying these key mappings
Config.KeyBinds = {
    ['inventory'] = 'TAB', -- Open inventory
    ['hotbar'] = 'Z',      -- Show hotbar
    ['reload'] = 'R',      -- Reload action
    ['handsup'] = 'X',     -- Hands-up/robbery gesture
}

--[[
    Debug Configuration:

    This section is primarily for development purposes, enabling debug mode allows you to view
    various logs and prints related to script actions, events, and errors. This is useful for
    identifying issues and fine-tuning the script during the development stage.

    NOTE: Enable these options only if you are actively developing or troubleshooting,
    as they may increase server load and provide detailed output that isn’t necessary
    for standard gameplay.
]]

Config.Debug = true                  -- Enables detailed print logs for debugging; leave off for production
Config.ZoneDebug = false             -- Toggles additional debug information for zones; use only if you're troubleshooting specific zones
Config.InventoryPrefix = 'inventory' -- Prefix for inventory references in the codebase; modifying this requires codebase-wide adjustments
