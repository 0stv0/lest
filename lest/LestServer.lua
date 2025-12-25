local socket    = require("socket");
local json      = require('dkjson');
local functions = require('LestFuntions');

---@type table
Server         = {};
Server.__index = Server;

---@type function
---@param code string
---@param body table
---@return string
local function writeResponse(code, body)
    return "HTTP/1.1 " .. code .. "\r\n" ..
    "Content-Type: application/json\r\n" ..
    "Content-Length: " .. #json.encode(body) .. "\r\n" ..
    "Connection: close\r\n" ..
    "\r\n" .. json.encode(body);
end

---@type function
---@param path string
---@param array table
---@return table
local function findRoute(path, array)
    local found = nil;
    for i = 1, #array, 1 do
        local item = array[i];
        if item.path == path then
            found = item;
            break;
        end
    end
    return found;
end

---@type function
---@param port number
---@return table
function Server:create(port)
    local obj = {
        port   = port,
        routes = {}
    };
    setmetatable(obj, Server);
    return obj;
end

---@type function
---@param path string
---@param method string
---@param handler function
---@param middle function | nil
function Server:addRoute(path, method, handler, middle)
    self.routes[#self.routes + 1] = {
        path    = path,
        method  = method,
        handler = handler,
        middle  = middle
    };
end

---@type function
---@param cb function
function Server:listen(cb)
    cb();

    local server = assert(socket.bind("*", self.port));
    server:settimeout(0);

    while true do
        local client = server:accept();

        if client then
            client:settimeout(1);

            -- Request Info
            local request      = client:receive("*l");
            local method, path = request:match("^(%S+)%s+(%S+)");
            local route        = findRoute(functions.split(path, '?')[1], self.routes);
            if route == nil or method ~= route.method then
                client:send(writeResponse("404 Not Found", {message = "Not Found"}));
                client:close();
                goto continue;
            end

            -- Headers
            local headers = {};
            while true do
                local line = client:receive("*l");
                if not line or line == "" then
                    break;
                end

                local key, value = line:match("^(.-):%s*(.*)");
                if key and value then
                    headers[key:lower()] = value;
                end
            end
            if (method == 'POST' or method == 'PUT') and headers['content-type'] ~= 'application/json' then
                client:send(writeResponse("400 Bad Request", {message = "You can only provide json in body."}));
                client:close();
                goto continue;
            end

            -- Body (POST / PUT)
            local body = {};
            if method == 'POST' or method == 'PUT' then
                local length = tonumber(headers['content-length']);
                if length and length > 0 then
                    body = client:receive(length);
                end
            end

            -- Params
            local params = {};
            local parts  = functions.split(path, "?");
            if parts[2] then
                local args = functions.split(parts[2], "&");
                for i = 1, #args, 1 do
                    local sides = functions.split(args[i], "=");
                    if sides[1] and sides[2] then
                        params[sides[1]] = sides[2];
                    end
                end
            end

            -- Request Interface
            local req = {
                headers = headers,
                body    = json.decode(body),
                params  = params
            };

            -- Middleware
            if route.middle ~= nil then
                local data = route.middle(req);
                if not data.valid then
                    client:send(writeResponse("200 OK", data.res));
                    client:close();
                end
            end

            -- Routing
            client:send(writeResponse("200 OK", route.handler(req)));
            client:close();
        end

        ::continue::
    end
end

return Server;