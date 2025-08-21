# ZAB Unpacker

A secure and simple ox_inventory unpacker script for FiveM servers using QBX Framework.

## Features

- **Configurable Packages**: Easy-to-modify config for different package types
- **Security Focused**: Comprehensive server-side validation and rate limiting
- **ox_inventory Integration**: Seamless integration with ox_inventory system
- **QBX Framework**: Built for QBX Core framework
- **Logging**: Complete security logging for monitoring

## Installation

1. Download the resource and place it in your `resources` folder
2. Add `ensure zab_unpacker` to your `server.cfg`
3. Configure your packages in `config.lua`
4. Restart your server

## Configuration

Edit `config.lua` to add your own packages:

```lua
Config.Packages = {
    ['ammobox'] = {
        item = 'ammo-9',
        amount = 64
    },
    -- Add more packages here
}
```

## Usage

Players can right-click on any configured package item in their inventory to unpack it. The package will be removed and replaced with the configured items.

## Security Features

- **Rate Limiting**: 1-second cooldown between unpacks
- **Input Validation**: All inputs are validated server-side
- **Player Verification**: Checks player validity through QBX Core
- **Inventory Validation**: Verifies items exist in specified slots
- **Security Logging**: Logs all actions and potential exploits
- **Memory Management**: Automatic cleanup on player disconnect

## Dependencies

- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_lib](https://github.com/overextended/ox_lib)
- [qbx_core](https://github.com/Qbox-project/qbx_core)

## License

This project is open source and available under the MIT License.

## Support

For support, please create an issue on GitHub or contact the developer.
