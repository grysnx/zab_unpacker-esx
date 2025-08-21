-- Register item usage for all package items
CreateThread(function()
    for packageItem, _ in pairs(Config.Packages) do
        exports.ox_inventory:displayMetadata({
            [packageItem] = 'Package - Right click to unpack'
        })
    end
end)

-- Handle item usage
AddEventHandler('ox_inventory:usedItem', function(name, slot, metadata)
    if Config.Packages[name] then
        TriggerServerEvent('zab_unpacker:unpackItem', name, slot)
    end
end)
