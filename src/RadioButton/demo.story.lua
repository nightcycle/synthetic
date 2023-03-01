--!strict
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
return function(coreGui)
	local package = script.Parent.Parent
	local packages = package.Parent
	local module = require(script.Parent)
	local Maid = require(packages.Maid)
	local ColdFusion = require(packages.ColdFusion)

	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _mount = _fuse.mount
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local _OUT = _fuse.OUT
	local _REF = _fuse.REF
	local _CHILDREN = _fuse.CHILDREN
	local _ON_EVENT = _fuse.ON_EVENT
	local _ON_PROPERTY = _fuse.ON_PROPERTY

	local demo: module.RadioButtonParameters = {
		Scale = 2,
		BackgroundColor3 = Color3.fromHSV(0.75, 0.5, 1),
		BorderColor3 = Color3.fromHSV(0, 0, 0.4),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Value = _Value(false),
		Parent = coreGui,
		-- EnableSound = ReplicatedStorage.Library.Sounds.UI.Button.Confirm["1"]:Clone(),
		-- DisableSound = ReplicatedStorage.Library.Sounds.UI.Button.Cancel:Clone(),
	} :: any
	module(maid)(demo)
	return function()
		maid:Destroy()
	end
end
