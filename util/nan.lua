-- Replace NaN-generating functions with wrapped safe version

require 'torch'
require 'util'

local function negative(x)
	return torch.lt(x,0):sum() > 0
end


local function zero(x)
	return torch.eq(x, 0):sum() > 0
end


do
	local orig = torch.DoubleTensor.log
	torch.DoubleTensor.log = function(x)
		assert(not negative(x), 'log called with negative argument')
		return orig(x)
	end
end


do
	local orig = torch.log
	torch.log = function(x)
		assert(not negative(x), 'log called with negative argument')
		return orig(x)
	end
end


do
	local orig = torch.DoubleTensor.sqrt
	torch.DoubleTensor.sqrt = function(x)
		assert(not negative(x), 'sqrt called with negative argument')
		return orig(x)
	end
end


do
	local orig = torch.sqrt
	torch.sqrt = function(x)
		assert(not negative(x), 'sqrt called with negative argument')
		return orig(x)
	end
end


do
	local orig = torch.DoubleTensor.div
	torch.DoubleTensor.div = function(x, y, z)
		if z == nil then
				assert(not (zero(x) and y == 0), '0 / 0')
				return orig(x, y)
		else
				assert(not (util.is_tensor(y) and zero(y) and z == 0), '0 / 0')
				return orig(x, y, z)
		end
	end
end


do
	local orig = torch.div
	torch.div = function(x, y, z)
		if z == nil then
				assert(not (zero(x) and y == 0), '0 / 0')
				return orig(x, y)
		else
				assert(not (util.is_tensor(y) and zero(y) and z == 0), '0 / 0')
				return orig(x, y, z)
		end
	end
end


do
	local orig = torch.DoubleTensor.__div
	torch.DoubleTensor.__div = function(x, y)
		assert(not (zero(x) and y == 0), '0 / 0')
		return orig(x, y)
	end
end


do
	local orig = torch.cdiv
	torch.cdiv = function(x, y, z)
		if z == nil then
				assert(not (zero(x) and zero(y)), '0 / 0')
				return orig(x, y)
		else
				assert(not (zero(y) and zero(z)), '0 / 0')
				return orig(x, y, z)
		end
	end
end


do
	local orig = torch.DoubleTensor.cdiv
	torch.DoubleTensor.cdiv = function(x, y, z)
		if z == nil then
				assert(not (zero(x) and zero(y)), '0 / 0')
				return orig(x, y)
		else
				assert(not (zero(y) and zero(z)), '0 / 0')
				return orig(x, y, z)
		end
	end
end
