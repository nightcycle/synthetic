--!strict
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
return function(coreGui)
	local RadioButton = script.Parent
	assert(RadioButton)
	local Package = RadioButton.Parent
	assert(Package)
	local Packages = Package.Parent
	assert(Packages)
	local module = require(script.Parent)
	local Maid = require(Packages:WaitForChild("Maid"))
	local ColdFusion = require(Packages:WaitForChild("ColdFusion"))

	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

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
