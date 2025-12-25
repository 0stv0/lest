## LEST Framework

Minimal Surface framework for lua to build REST APIs.

## Dependencies & Install

Made on lua 5.4

Dependencies:
- luasocket
- dkjson

Install: ``luarocks install lest``

## Docs

Init
```lua
local Server = require("LestServer");

local sv = Server:create(3000);

sv:listen(function()
    print('API listening on :' .. sv.port);
end)
```