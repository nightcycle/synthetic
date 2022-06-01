local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
return function (coreGui)
	local object
	task.spawn(function()
		print("A")
		local module = require(script.Parent)
		print("B")
		local demo = {
			IconColor3 = Color3.new(1,1,1),
			Icon = "star_half",
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0.5,0.5),
			AnchorPoint = Vector2.new(0.5,0.5),
			Parent = coreGui,
			Size = UDim2.fromOffset(32,32),
		}
		print("C")
		object = module.new(demo)
		print("D")
	end)

	return function()
		object:Destroy()
	end
end