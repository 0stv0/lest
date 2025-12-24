local server = require('Server');

local sv = server:create(3000);

sv:addRoute('/test', 'POST', function(req)
    return {
        message = "/test message"
    };
end)

sv:listen(function()
    print('API listening on :' .. sv.port);
end)