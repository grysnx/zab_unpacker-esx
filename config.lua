Config = {}

-- Package definitions
-- Format: ['package_item'] = { item = 'item_to_give', amount = amount_to_give }
Config.Packages = {
    ['ammobox'] = {
        item = 'ammo-9',
        amount = 64
    },
    ['ammo_box_45acp'] = {
        item = 'ammo-45acp',
        amount = 50
    },
    ['bandage_pack'] = {
        item = 'bandage',
        amount = 5
    },
    ['food_pack'] = {
        item = 'sandwich',
        amount = 3
    },
    ['water_pack'] = {
        item = 'water_bottle',
        amount = 6
    }
}

-- Notification settings
Config.Notifications = {
    success = 'You unpacked the package successfully!',
    error = 'Failed to unpack the package!',
    no_space = 'Not enough inventory space!'
}
