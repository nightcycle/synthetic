local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local Component = synthetic:WaitForChild("Component")
local paddingConstructor = require(Component:WaitForChild("Padding"))
local cornerConstructor = require(Component:WaitForChild("Corner"))
local styleConstructor = require(Component:WaitForChild("Style"))
local elevationConstructor = require(Component:WaitForChild("Elevation"))
local lightingConstructor = require(Component:WaitForChild("Lighting"))
local inputEffectConstructor = require(Component:WaitForChild("InputEffect"))


local constructor = {}

function constructor.new(config)
	config = config or {}
	local maid = maidConstructor.new()
	local inst = fusion.New "Frame" {
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

	maid:GiveTask(styleConstructor.new({
		Category = "Surface",
		TextClass = "Body",
		Parent = inst,
	}))
	maid:GiveTask(elevationConstructor.new({
		Parent = inst,
	}))
	maid:GiveTask(lightingConstructor.new({
		Parent = inst,
	}))
	maid:GiveTask(inputEffectConstructor.new({
		StartSize = config.Size or UDim2.fromScale(1,1),
		SizeBump = UDim.new(0, 10),
		ElevationBump = 1,
		Parent = inst,
	}))
	maid:GiveTask(paddingConstructor.new({
		Parent = inst
	}))
	maid:GiveTask(cornerConstructor.new({
		Parent = inst,
		Radius = UDim.new(0,5),
	}))

	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			maid:Destroy()
			print("Cleaning up "..tostring(script.Name))
		end
	end)

	return inst
end

return constructor