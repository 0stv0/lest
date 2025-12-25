---@type table
Functions = {};

---@type function
---@param str string
---@param cond string
---@return table
function Functions.split(str, cond)
    local result = {};
    for part in string.gmatch(str, "([^" .. cond .. "]+)") do
        result[#result + 1] = part;
    end
    return result;
end

return Functions;