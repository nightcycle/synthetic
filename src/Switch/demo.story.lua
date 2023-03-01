--!strict

-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
return function(coreGui)
	local module = require(script.Parent)
	local demo = {
		Scale = 2,
		EnabledColor3 = Color3.fromHSV(0.6, 1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = coreGui,
		-- EnableSound = ReplicatedStorage.Library.Sounds.UI.Button.Confirm["1"]:Clone(),
		-- DisableSound = ReplicatedStorage.Library.Sounds.UI.Button.Cancel:Clone(),
	}
	local object = module()(demo :: any)
	return function()
		object:Destroy()
	end
end
