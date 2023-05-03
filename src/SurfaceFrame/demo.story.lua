--!strict
local SurfaceFrame = script.Parent
assert(SurfaceFrame)
local Package = SurfaceFrame.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)
local Maid = require(Packages:WaitForChild("Maid"))

return function(coreGui: Frame)
	local Maid = Maid.new()
	local module = require(script.Parent)

	local part = Instance.new("Part")
	part.Parent = workspace
	Maid:GiveTask(part)

	Maid:GiveTask(module()({
		BackgroundColor3 = Color3.fromHSV(0.75, 1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = coreGui,
		Adornee = part,
		Size = UDim2.fromOffset(50, 10),
	}))
	return function()
		Maid:Destroy()
	end
end
