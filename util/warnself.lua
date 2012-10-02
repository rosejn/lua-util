
-- This module will check all function calls.
-- An error will be reported, when obj.method() call is used
-- instead of obj:method().
--
-- The checking makes things 2-times slower.
-- You can skip importing of this module when finished with development.
-- For example, import this module only when log level is set to debug.

-- Some functions have their first arg named "self",
-- even when not being proper methods.
-- We ignore these.
local IGNORED_FUNC = {
    Storage__printformat=true,
    Tensor__printMatrix=true,
    Tensor__printTensor=true,
}

local function _getParent(obj)
    local mt = getmetatable(obj)
    if not mt or not mt.__index then
        return nil
    end
    local parent = mt.__index
    if type(parent) ~= "table" then
        -- We don't know what keys to try with the mt.__index(obj, k) func.
        -- As a fallback, we try to find the method on the metatable.
        parent = mt
    end
    return parent
end

local function _findKeyByVal(obj, val)
    for field, fieldVal in pairs(obj) do
        if fieldVal == val then
            return field
        end
    end

    local parent = _getParent(obj)
    if not parent then
        return nil
    end
    return _findKeyByVal(parent, val)
end

-- Checks that var "self" refers to an object
-- with the called method.
local function onCallCheckSelf()
    local var1Name, obj = debug.getlocal(2, 1)
    if var1Name ~= "self" then
        return
    end

    local lookup = obj
    if type(obj) == "userdata" then
        lookup = _getParent(obj)
    end
    if type(lookup) == "table" then
        local func = debug.getinfo(2, "f").func
        local field = _findKeyByVal(lookup, func)
        if field then
            -- OK. Found the method on the used object.
            return
        end
    end

    local info = debug.getinfo(2, "n")
    if IGNORED_FUNC[info.name] then
        return
    end
    local msg = string.format("wrong self for %s()", tostring(info.name))
    error(msg, 3)
end

assert(debug.gethook() == nil, "another hook is active")
debug.sethook(onCallCheckSelf, "c")
