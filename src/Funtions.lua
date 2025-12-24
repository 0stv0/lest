Functions = {};

function Functions.split(str, cond)
    local result = {};
    for part in string.gmatch(str, "([^" .. cond .. "]+)") do
        result[#result + 1] = part;
    end
    return result;
end

return Functions;