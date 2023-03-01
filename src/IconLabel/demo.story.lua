--!strict
return function(coreGui)
	local object
	task.spawn(function()
		local module = require(script.Parent)
		local demo = {
			IconColor3 = Color3.new(1, 1, 1),
			Icon = "settings",
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = coreGui,
			Size = UDim2.fromOffset(32, 32),
		}
		object = module()(demo)
	end)

	return function()
		object:Destroy()
	end
end
