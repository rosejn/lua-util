require 'os'

util = {}

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
            v = deep_copy(v)
        end
        res[k] = v
    end

    setmetatable(res,mt)
    return res
end


-- Copies elements of table b into table a.
function util.merge(a, b)
  for k, v in pairs(b) do
      a[k] = v
  end

  return a
end


-- Returns a new table concatenating a and b.
function util.concat(a, b)
  return merge(copy(a), b)
end


-- Concatenate two sequential tables (numeric indices), returning a new table.
function util.seq_concat(a, b)
    local res = {}
    for _,v in pairs(a) do
        table.insert(res, v)
    end

    for _,v in pairs(b) do
        table.insert(res, v)
    end

    return res
end


-- Reload a lua module that has already been required.
-- (Useful when testing code from the repl, so you don't have to restart the
-- program.)
function util.reload(module)
  package.loaded[module] = nil
  require(module)
end


-- Pause the process for n seconds.
function util.sleep(n)
    os.execute("sleep " .. n)
end

