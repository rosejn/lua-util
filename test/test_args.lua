require 'torch'
require 'util'
require 'fn'

function foo(...)
   return util.args(..., {'a', 'b', c = 'number', d = 'string'}, {foo = 'bar'})
end

--[[function tests.test_args()
    tester:asserteq(fn.count({}), 0, "count empty {}")
    tester:asserteq(fn.count(coll), 4, "count coll")
end]]

