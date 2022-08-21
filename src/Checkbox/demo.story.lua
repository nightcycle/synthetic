return function (coreGui)
	local module = require(script.Parent)
	local demo = {
		Scale = 2,
		BackgroundColor3 = Color3.fromHSV(0.75,0.5,1),
		BorderColor3 = Color3.fromHSV(0,0,0.4),
		Position = UDim2.fromScale(0.5,0.5),
		AnchorPoint = Vector2.new(0.5,0.5),
		Parent = coreGui,
	}

	local object = module()(demo)
	return function()
		object:Destroy()
	end
end