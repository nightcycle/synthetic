--!strict

return function(coreGui)
	local module = require(script.Parent)
	local demo: any = {
		Name = "FX",
		Parent = coreGui,
	}
	local object = module()(demo)
	return function()
		object:Destroy()
	end
end
