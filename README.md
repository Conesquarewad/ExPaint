ExPainter (Stylish: ***Ex*Painter**) is a utility script for [BASF](https://www.roblox.com/games/4435144047 "BASF") on Roblox.

## Environment
⭐: Important
✅: Require
⏺️: Optional

|  Function | Required |          Description                 |
| :--------------:  | :--: | :----------------------------- |
|  `setclipboard()` or `toclipboard` | ⏺️ | Used for copy to Clipboard |
|  `loadstring()`     | ⭐ | This function is important for loading the **Main.lua** and other components in the script  |


## Install
You can copy this code and paste it into your Executor such as **[Xeno](https://www.xeno.now/ "Xeno")**, **[Wave](https://www.getwave.gg/ "Wave")**, **[Cryptic](https://getcryptic.net/ "Cryptic")** or **[Synapse Z](https://synapsez.net/ "Synapse Z")**

```lua
-- ▓█████ ▒██   ██▒ ██▓███   ▄▄▄       ██▓ ███▄    █ ▄▄▄█████▓▓█████  ██▀███  
-- ▓█   ▀ ▒▒ █ █ ▒░▓██░  ██▒▒████▄    ▓██▒ ██ ▀█   █ ▓  ██▒ ▓▒▓█   ▀ ▓██ ▒ ██▒
-- ▒███   ░░  █   ░▓██░ ██▓▒▒██  ▀█▄  ▒██▒▓██  ▀█ ██▒▒ ▓██░ ▒░▒███   ▓██ ░▄█ ▒
-- ▒▓█  ▄  ░ █ █ ▒ ▒██▄█▓▒ ▒░██▄▄▄▄██ ░██░▓██▒  ▐▌██▒░ ▓██▓ ░ ▒▓█  ▄ ▒██▀▀█▄  
-- ░▒████▒▒██▒ ▒██▒▒██▒ ░  ░ ▓█   ▓██▒░██░▒██░   ▓██░  ▒██▒ ░ ░▒████▒░██▓ ▒██▒
-- ░░ ▒░ ░▒▒ ░ ░▓ ░▒▓▒░ ░  ░ ▒▒   ▓▒█░░▓  ░ ▒░   ▒ ▒   ▒ ░░   ░░ ▒░ ░░ ▒▓ ░▒▓░
--  ░ ░  ░░░   ░▒ ░░▒ ░       ▒   ▒▒ ░ ▒ ░░ ░░   ░ ▒░    ░     ░ ░  ░  ░▒ ░ ▒░
--    ░    ░    ░  ░░         ░   ▒    ▒ ░   ░   ░ ░   ░         ░     ░░   ░ 
--    ░  ░ ░    ░                 ░  ░ ░           ░             ░  ░   ░     

local URL = "https://raw.githubusercontent.com/Conesquarewad/ExPainter/refs/heads/main/Master/Main.lua"

local Success, Result = pcall(function()
    return loadstring( game:HttpGet( URL ) )
end)

if Success then
    Result()
else
    error("Your envrionment does not supported loadstring() Please use a different executor")
    error("--[ More information for DEBUGGING]--")
    error( tostring( Result ) )
end
```


