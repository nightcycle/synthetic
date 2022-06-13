return function (coreGui)
	local module = require(script.Parent)
	local demo = {
		Name = "FX",
		Parent = coreGui,
	}
	local object = module.new(demo)
	return function()
		object:Destroy()
	end
end