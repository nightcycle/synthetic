--!strict

return function(coreGui)
	local Module = script.Parent
	assert(Module)
	local Package = Module.Parent
	assert(Package)
	local Packages = Package.Parent
	assert(Packages)
	local module = require(Module)
	local Maid = require(Packages:WaitForChild("Maid"))
	local ColdFusion = require(Packages:WaitForChild("ColdFusion"))

	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local demo: module.CheckboxParameters = {
		Scale = 2,
		BackgroundColor3 = Color3.fromHSV(0.75, 0.5, 1),
		BorderColor3 = Color3.fromHSV(0, 0, 0.4),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = coreGui,
		Value = _Value(false),
	} :: any

	local object = module()(demo)
	return function()
		maid:Destroy()
		object:Destroy()
	end
end
