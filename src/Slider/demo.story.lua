--!strict

-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
return function(coreGui)
	local module = require(script.Parent)
	local demo = {
		EnabledColor3 = Color3.fromHSV(0.6, 1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Padding = UDim.new(0, 2),
		Size = UDim2.fromOffset(150, 30),
		BorderSizePixel = 8,
		Parent = coreGui,
		HintEnabled = true,
		-- EnableSound = ReplicatedStorage.Library.Sounds.UI.Button.Confirm["1"],
		-- DisableSound = ReplicatedStorage.Library.Sounds.UI.Button.Cancel,
		-- TickSound = ReplicatedStorage.Library.Sounds.UI.Tap["1"],
	}
	local object = module()(demo)
	return function()
		object:Destroy()
	end
end
