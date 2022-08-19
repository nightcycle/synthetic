local package = script.Parent.Parent
local packages = package.Parent
local Maid = require(packages:WaitForChild("maid"))

return function (coreGui)
	local maid = Maid.new()
	local module = require(script.Parent)

	local demo = {
		BackgroundColor3 = Color3.fromHSV(0.75,1,1),
		Position = UDim2.fromScale(0.5,0.5),
		AnchorPoint = Vector2.new(0.5,0.5),
		Parent = game:WaitForChild("StarterGui"),
		Adornee = workspace:WaitForChild("Part"),
		Size = UDim2.fromOffset(50,10),
	}
	
	maid:GiveTask(module(demo))
	return function()
		maid:Destroy()
	end
end