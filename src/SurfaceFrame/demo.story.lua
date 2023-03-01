--!strict

local package = script.Parent.Parent
local packages = package.Parent
local Maid = require(packages:WaitForChild("Maid"))

return function(coreGui)
	local Maid = Maid.new()
	local module = require(script.Parent)

	local part = Instance.new("Part")
	part.Parent = workspace
	Maid:GiveTask(part)

	local demo = {
		BackgroundColor3 = Color3.fromHSV(0.75, 1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = coreGui,
		Adornee = part,
		Size = UDim2.fromOffset(50, 10),
	}

	Maid:GiveTask(module()(demo))
	return function()
		Maid:Destroy()
	end
end
