return function (coreGui)
	local module = require(script.Parent)
	local demo = {
		-- BackgroundTransparency = 0,
		-- BorderTransparency = 0,
		-- TextSize = 20,
		-- Padding = UDim.new(0, 8),
		-- IconScale = 1,
		-- TextOnly = false,
		-- Position = UDim2.fromScale(0.5,0.5),
		-- Size = UDim2.fromOffset(200, 60),
		-- AutomaticSize = Enum.AutomaticSize.XY,
		-- AnchorPoint = Vector2.new(0.5,0.5),
		Parent = coreGui,
	}
	local object = module(nil)(demo)
	local insertButtonFunction = object:WaitForChild("InsertButton")
	insertButtonFunction:Invoke("Test123", 1, nil, "home", "settings")
	insertButtonFunction:Invoke("Test456", 2, nil, "accessibility", "menu")
	return function()
		object:Destroy()
	end
end