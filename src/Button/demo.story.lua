--!strict

return function(coreGui)
	local module = require(script.Parent)
	local demo = {
		Text = "Button *Time*",
		BackgroundTransparency = 1,
		BorderTransparency = 0,
		TextSize = 20,
		Padding = UDim.new(0, 8),
		IconScale = 1,
		TextOnly = false,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = coreGui,
		LeftIcon = "star",
		RightIcon = "accessibility",
	}
	local object = module()(demo)
	return function()
		object:Destroy()
	end
end
