require 'torch'
require 'os'

util = {}


--------------------------------
-- Namespace functions
--------------------------------


-- Reload a lua module that has already been required.
-- (Useful when testing code from the repl, so you don't have to restart the
-- program.)
function util.reload(module)
  package.loaded[module] = nil
  require(module)
end



--------------------------------
-- Metatable functions
--------------------------------


-- Set the __index function in the metatable of tbl, so that tbl[i] will
-- return the value of f(self, i).
function util.set_index_fn(tbl, fn)
    local mt = getmetatable(tbl) or {}
    rawset(mt, '__index', fn)
    setmetatable(tbl, mt)
end


-- Set the __len function in the metatable of tbl, so that #tbl will
-- return a valid size.
-- NOTE: doesn't work on tables until __len support is added in Lua 5.2.
function util.set_size_fn(tbl, fn)
    local mt = getmetatable(tbl) or {}
    rawset(mt, '__len', fn)
    setmetatable(tbl, mt)
end


--------------------------------
-- Map functions
--------------------------------


-- Return all of the keys in a table
function util.keys(tbl)
    local keys = {}

    for k,v in pairs(tbl) do
        table.insert(keys, k)
    end

    return keys
end


-- Return all of the values in a table
function util.vals(tbl)
    local vals = {}

    for k,v in pairs(tbl) do
        table.insert(vals, v)
    end

    return vals
end


--------------------------------
-- Tensor utility functions
--------------------------------


-- Returns true of obj is a torch.Tensor.
-- TODO: find out if there is a better way to inspect userdata objects...
function util.is_tensor(obj)
	return type(obj) == 'userdata' and obj.dim ~= nil
end


--------------------------------
-- Table utility functions
--------------------------------


-- Returns true of obj is a table.
function util.is_table(obj)
    return type(obj) == 'table'
end


-- Returns a new shallow copy of a table, with original metatable
function util.copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return setmetatable(t2, getmetatable(t))
end


-- Recursively deep copy all values in t, works for nested tables
function util.deep_copy(t)
    if type(t) ~= 'table' then
      return t
    end

    local mt = getmetatable(t)
    local res = {}

    for k,v in pairs(t) do
        if type(v) == 'table' then
            v = util.deep_copy(v)
        end
        res[k] = v
    end

    setmetatable(res,mt)
    return res
end


-- Recursively copies elements of table b into table a, overwriting any keys that have
-- values in both tables to be the values in table b.
function util.merge(a, b)
    for k, v in pairs(b) do
        if (type(v) == "table") and (type(a[k] or false) == "table") then
            util.merge(a[k], b[k])
        else
            a[k] = v
        end
    end

    return a
end


-- Returns a new table containing the sequential (numeric indices) elements of
-- tables a and b.
function util.concat(a, b)
    local res = {}
    for _, v in ipairs(a) do
        table.insert(res, v)
    end

    for _, v in ipairs(b) do
        table.insert(res, v)
    end

    return res
end


-- Pause the process for n seconds.
function util.sleep(n)
    os.execute("sleep " .. n)
end

