package = "lestserver"
version = "1.0"

source = {
    url = "https://github.com/0stv0/lest"
}

description = {
    summary = "Simple HTTP server framework for Lua",
    detailed = "A lightweight HTTP server framework written in pure Lua using LuaSocket.",
    license = "MIT",
    homepage = "https://github.com/0stv0/lest"
}

dependencies = {
    "luasocket",
    "dkjson"
}

build = {
    type = "builtin",
    modules = {
        ["LestServer"] = "LestServer.lua",
        ["LestFunctions"] = "LestFunctions.lua"
    }
}