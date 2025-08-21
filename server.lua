-- Get the ESX Shared Object
ESX = exports['es_extended']:getSharedObject()

-- Rate limiting storage
local playerCooldowns = {}
local COOLDOWN_TIME = 1000 -- 1 second cooldown

-- Security logging
local function logSecurity(source, action, details)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerName = GetPlayerName(source) or 'Unknown'
    local identifier = xPlayer and xPlayer.getIdentifier() or 'Unknown'
    print(('[SECURITY] %s (ID: %s, Source: %s) - %s: %s'):format(playerName, identifier, source, action, details))
end

-- Input validation
local function validateInput(source, item, slot)
    -- Validate source
    if not source or source <= 0 then
        logSecurity(source or 0, 'INVALID_SOURCE', 'Invalid player source')
        return false
    end
    
    -- Validate item name
    if type(item) ~= 'string' or item == '' or #item > 50 then
        logSecurity(source, 'INVALID_ITEM', 'Invalid item name: ' .. tostring(item))
        return false
    end
    
    -- Validate slot
    if type(slot) ~= 'number' or slot < 1 or slot > 50 then
        logSecurity(source, 'INVALID_SLOT', 'Invalid slot number: ' .. tostring(slot))
        return false
    end
    
    -- Check if item exists in config
    if not Config.Packages[item] then
        logSecurity(source, 'UNKNOWN_PACKAGE', 'Attempted to unpack unknown package: ' .. item)
        return false
    end
    
    return true
end

-- Rate limiting check
local function checkRateLimit(source)
    local currentTime = GetGameTimer()
    local lastUse = playerCooldowns[source]
    
    if lastUse and (currentTime - lastUse) < COOLDOWN_TIME then
        logSecurity(source, 'RATE_LIMIT', 'Player hit rate limit')
        return false
    end
    
    playerCooldowns[source] = currentTime
    return true
end

-- Player validation
local function validatePlayer(source)
    local player = ESX.GetPlayerFromId(source)
    if not player then
        logSecurity(source, 'INVALID_PLAYER', 'Player not found in core')
        return false
    end
    
    -- Check if player is online
    if not GetPlayerPing(source) or GetPlayerPing(source) <= 0 then
        logSecurity(source, 'INVALID_PING', 'Player has invalid ping')
        return false
    end
    
    return true
end

local function unpackItem(source, item, slot)
    local packageData = Config.Packages[item]
    
    -- Double-check package exists (security validation already done)
    if not packageData then
        logSecurity(source, 'PACKAGE_NOT_FOUND', 'Package data not found: ' .. item)
        return false
    end
    
    -- Verify player actually has the item in the specified slot
    local inventory = exports.ox_inventory:GetInventory(source)
    if not inventory or not inventory.items or not inventory.items[slot] then
        logSecurity(source, 'INVALID_INVENTORY_SLOT', 'No item in slot: ' .. slot)
        return false
    end
    
    local slotItem = inventory.items[slot]
    if slotItem.name ~= item then
        logSecurity(source, 'ITEM_MISMATCH', 'Item mismatch in slot. Expected: ' .. item .. ', Found: ' .. (slotItem.name or 'nil'))
        return false
    end
    
    -- Check if player has enough space for the unpacked items
    local canCarry = exports.ox_inventory:CanCarryItem(source, packageData.item, packageData.amount)
    if not canCarry then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = Config.Notifications.no_space
        })
        return false
    end
    
    -- Remove the package item
    local removed = exports.ox_inventory:RemoveItem(source, item, 1, nil, slot)
    if not removed then
        logSecurity(source, 'REMOVE_FAILED', 'Failed to remove package item: ' .. item)
        return false
    end
    
    -- Add the unpacked items
    local added = exports.ox_inventory:AddItem(source, packageData.item, packageData.amount)
    if not added then
        -- If adding failed, give back the package item
        exports.ox_inventory:AddItem(source, item, 1)
        logSecurity(source, 'ADD_FAILED', 'Failed to add unpacked items, refunded package')
        return false
    end
    
    logSecurity(source, 'UNPACK_SUCCESS', item .. ' -> ' .. packageData.amount .. 'x ' .. packageData.item)
    return true
end

-- Secure event registration
RegisterNetEvent('zab_unpacker:unpackItem', function(item, slot)
    local source = source
    
    -- Security validations
    if not validatePlayer(source) then return end
    if not checkRateLimit(source) then return end
    if not validateInput(source, item, slot) then return end
    
    -- Process the unpack request
    if unpackItem(source, item, slot) then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'success',
            description = Config.Notifications.success
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = Config.Notifications.error
        })
    end
end)

-- Cleanup cooldowns when player disconnects
AddEventHandler('playerDropped', function()
    local source = source
    if playerCooldowns[source] then
        playerCooldowns[source] = nil
    end
end)
