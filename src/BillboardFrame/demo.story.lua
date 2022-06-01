local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local package = script.Parent.Parent
local packages = package.Parent
local Maid = require(packages:WaitForChild("maid"))

return function (coreGui)
	local maid = Maid.new()
	local module = require(script.Parent)

	local demo = {
		BackgroundColor3 = Color3.fromHSV(0.75,1,1),
		Position = Vector3.new(0,10,0),
		AnchorPoint = Vector2.new(0.5,0.5),
		Parent = game:WaitForChild("StarterGui"),
	}
	
	local frame = module.new(demo)

	maid:GiveTask(frame)
	return function()
		maid:Destroy()
	end
end