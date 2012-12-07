--[[ Argument handling

This exports a single table (util.arg) with functions for handling optional and
required arguments in table format and for handling optional parameters in
regular (scalar) format.

This can be used to get the a value of a scalar argument with some default:

	function foo(x)
		util.arg.optional(x, 5)
		...
	end

For named arguments (provided in a table), one can get optional values with some default:

	function foo(argv)
		util.arg.optional(argv, 'x', 5)
		...
	end

or check that required arguments are present:

	function foo(argv)
		util.arg.required(argv, 'x')
		...
	end

or

	function foo(argv)
		util.arg.required(argv, 'x', 'number')
		...
	end

--]]

require 'util'
util.arg = {}

--[[! Verify that list of arguments contains an argument with a given name and type

Parameters:

* argv (const table) : table of named parameters
* argname (string) : name of argument of interest
* argtype : (optional string) : the expected type of the argument

Return the argument or raise an error if the argument is not present or does
not match the expected type.

--]]
function util.arg.required(argv, argname, argtype)
	local x = argv[argname]
	if x == nil then
		error(string.format('no argument \'%s\'', argname), 3)
	end
	if argtype ~= nil and type(x) ~= argtype then
		local msg = string.format('argument \'%s\' has incorrect type (expected %s, found %s)', argname, argtype, type(x))
		error(msg, 3)
	end
	return x
end



--[[! Return value of optional scalar argument with some default

The idomatic way of doing this 'x = x or d' does not work if the default is the
boolean 'true'.
--]]
local function optional_s(x, default)
    if x == nil then return default else return x end
end



--[[! Return value of optional table/named argument with some default

Parameters:

* argv (const table) : table of named parameters
* argname (string) : name of argument of interest
* default : default argument. If not specified, this is nil.

--]]
local function optional_t(argv, argname, default)
	local x = argv[argname]
	default = optional_s(default, nil)
	if x == nil then
		return default
	elseif default and type(x) ~= type(default) then
		local msg = string.format('argument \'%s\' has incorrect type (expected %s, found %s)',
				argname, type(default), type(x))
		error(msg, 3)
	end
	return x
end



--[[! Return value of optional table/named argument with some default

Usage:

	util.arg.optional(table, argname, default)
	util.arg.optional(scalar, default)

--]]
function util.arg.optional(x, ...)
	if util.is_table(x) then
		return optional_t(x, ...)
	else
		return optional_s(x, ...)
	end
end


return util.arg
