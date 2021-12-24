local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local constructor = {}

function constructor.new(config)
	config = config or {}
	local maid = maidConstructor.new()

	config.Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
	config.Size = config.Size or UDim2.fromScale(1,1)
	config.Position = config.Position or UDim2.fromScale(0.5,0.5)
	config.AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5)
	config.LayoutOrder = config.LayoutOrder or 0
	config.SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY
	config.Visible = config.Visible or true
	config.Name = config.Name or script.Name
	config.Text = config.Text or ""
	config.AutoButtonColor = config.AutoButtonColor or false

	local inst = fusion.New "TextButton" (config)
	maid:GiveTask(inst)
	maid:GiveTask(synthetic("Corner",{
		Radius = UDim.new(0, 5),
		Parent = inst
	}))
	maid:GiveTask(synthetic("Theme",{
		ThemeCategory = "Primary",
		TextClass = "Button",
		Parent = inst,
	}))
	maid:GiveTask(synthetic("Elevation",{
		Parent = inst,
	}))
	maid:GiveTask(synthetic("Dropshadow",{
		Parent = inst,
	}))
	maid:GiveTask(synthetic("InputEffect",{
		StartSize = config.Size or UDim2.fromScale(1,1),
		InputSizeBump = UDim.new(0, 10),
		StartElevation = 1,
		InputElevationBump = 1,
		StartStyleCategory = "Surface",
		InputStyleCategory = "Secondary",
		Parent = inst,
	}))

	return inst, maid
end

return constructor