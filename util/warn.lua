warn = {}

local IGNORED_READS = { qt=true }

-- Raises an error when an undeclared variable is read.
warn.guard_globals = function()
    local existing = getmetatable(_G)
    if existing then
        assert(getmetatable(_G) == nil, "a global metatable exists: "..existing)
    end

    -- The detecting of undeclared vars is discussed on:
    -- http://www.lua.org/pil/14.2.html
    -- http://lua-users.org/wiki/DetectingUndefinedVariables
    setmetatable(_G, {
        __newindex = function (table, key, value)
            print("[warn] write to undeclared variable: "..key)
            rawset(table, key, value)
        end,
        __index = function (table, key)
            if IGNORED_READS[key] then
                return
            end
            error("[warn] attempt to read undeclared variable "..key, 2)
        end,
    })
end


-- Adds a check for the correct 'self' to each method call.
local function guard_methods(meta)
    assert(not getmetatable(meta))
    local metameta = {}

    metameta.__newindex = function (table, key, func)
        if type(func) ~= "function" then
            rawset(table, key, func)
        end

        local decorated = function(instance, ...)
            local parent = getmetatable(instance)
            while parent and parent ~= meta do
                parent = getmetatable(parent)
            end
            if not parent then
                error("[warn] wrong self for " ..  meta.__typename .. ": " ..
                    tostring(instance), 2)
            end
            return func(instance, ...)
        end
        rawset(table, key, decorated)
    end

    setmetatable(meta, metameta)
end

local origTorchClass = nil

-- Will raise an error when obj.call() is used instead of obj:call().
-- The guarding needs to be enabled before declaring the classes.
warn.guard_torch_methods = function()
    if package.loaded['torch'] then
        origTorchClass = torch.class

        torch.class = function(name, parentname)
            if parentname then
                -- Classes with a parent are not checked.
                -- Update the code if you want to check them also.
                return origTorchClass(name, parentname)
            end
            local meta = origTorchClass(name)
            _guardMethods(meta)
            return meta
        end
    end
end

local function warn_all()
    warn.guard_globals()
    warn.guard_torch_methods()
end

warn_all()
