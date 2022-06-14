local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return function (coreGui)
	local buttonModule = require(script.Parent.Parent:WaitForChild("Button"))
	local demo = {
		Text = "Button ~~Yeah~~",
		TextColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.5,0.5),
		AnchorPoint = Vector2.new(0.5,0.5),
		Parent = coreGui,
		LeftIcon = "star",
		RightIcon = "star"
	}
	local module = require(script.Parent)
	local button = buttonModule.new(demo)
	local hint = module.new({
		Parent = button,
		AnchorPoint = Vector2.new(0,1),
		Padding = UDim.new(0,4),
		Text = "Awesome button that is cool"
	})
	return function()
		button:Destroy()
		hint:Destroy()
	end
end