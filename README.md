## LEST Framework

Minimal Surface framework for lua to build REST APIs.

## Dependencies & Install

Made on lua 5.4

Dependencies:
- luasocket
- dkjson

Install: ``luarocks install lest``

## Docs

Server Init
```lua
local Server = require("LestServer");

local sv = Server:create(3000);

sv:listen(function()
    print('API listening on :' .. sv.port);
end)
```

---

First Route
```lua
sv:addRoute('/', 'GET', function(req)
    return {
        message = "Lua Framework"
    };
end)
```

--- 

Middleware
```lua
-- Always use format {valid = boolean, res = {}} in return
local function middle(req)
    local age = 16;
    if age < 18 then
        return {
            valid = false
            res   = {
                error = "Too young"
            }
        };
    end
    return {
        valid = true,
        res   = {}
    };
end

sv:addRoute('/register', 'POST', function(req)
    return {
        message = "registered"
    };
end, middle);
```

---

Request Interface

| Name | Description |
|----------|-----------|
| Wartość A1 | Wartość B1 | 
| Wartość A2 | Wartość B2 | 
| Wartość A3 | Wartość B3 | 