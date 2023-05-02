--!strict
local ComponentModule = script.Parent
assert(ComponentModule)
local Package = ComponentModule.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)
local Maid = require(Packages:WaitForChild("Maid"))

return function(coreGui)
	local Maid = Maid.new()
	local module = require(script.Parent)

	local demo: module.BillboardFrameParameters = {
		BackgroundColor3 = Color3.fromHSV(0.75, 1, 1),
		Position = Vector3.new(0, 10, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = coreGui,
	} :: any

	local frame = module()(demo)

	Maid:GiveTask(frame)
	return function()
		Maid:Destroy()
	end
end
