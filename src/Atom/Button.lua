local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local constructor = {}

function constructor.new(config)
	config = config or {}
	local maid = maidConstructor.new()
	local inst = fusion.New "TextButton" {
		Text = "",
		AutoButtonColor = false,
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
		Size = config.Size or UDim2.fromScale(1,1),
		Position = config.Position or UDim2.fromScale(0.5,0.5),
		AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5),
		LayoutOrder = config.LayoutOrder or 0,
		SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY,
		Visible = config.Visible or true,
		Name = config.Name or script.Name,
	}
	maid:GiveTask(inst)
	maid:GiveTask(synthetic("Corner",{
		Radius = UDim.new(0, 5),
		Parent = inst
	}))
	maid:GiveTask(synthetic("Style",{
		StyleCategory = "Primary",
		TextClass = "Button",
		Parent = inst,
	}))
	maid:GiveTask(synthetic("Elevation",{
		Parent = inst,
	}))
	maid:GiveTask(synthetic("Lighting",{
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