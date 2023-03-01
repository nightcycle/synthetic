--!strict

return function(coreGui)
	local module = require(script.Parent)
	local demo: any = {
		-- Text = "Label",
		-- TextSize = 18,
		-- TextColor3 = Color3.fromHSV(1,0,0.2),
		-- BackgroundColor3 = Color3.fromHSV(1,0,0.9),
		-- HoverBackgroundColor3 = Color3.fromHSV(1,0,0.8),
		-- FocusedBackgroundColor3 = Color3.fromHSV(1,0,0.7),
		-- BorderColor3 = Color3.fromHSV(0.7,0.7,1),
		-- CharacterLimit = 20,
		-- LowerText = "Test 123 is bad",
		-- MaintainLowerSpacing = true,
		-- BackgroundTransparency = 1,
		-- LeftIcon = "home",
		-- RightIcon = "settings",
		-- Position = UDim2.fromScale(0.5,0.5),
		-- AnchorPoint = Vector2.new(0.5,0.5),
		Parent = coreGui,
	}
	local object = module()(demo)
	return function()
		object:Destroy()
	end
end
