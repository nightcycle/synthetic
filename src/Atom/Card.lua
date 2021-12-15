local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local Component = synthetic:WaitForChild("Component")
local paddingConstructor = require(Component:WaitForChild("Padding"))
local cornerConstructor = require(Component:WaitForChild("Corner"))
local styleConstructor = require(Component:WaitForChild("Style"))

local constructor = {}

function constructor.new(config)
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

	local padding = paddingConstructor.new()
	padding.Parent = inst
	maid:GiveTask(padding)

	local corner = cornerConstructor.new()
	corner.Parent = inst
	maid:GiveTask(corner)

	local style = styleConstructor.new()
	style.Parent = inst
	style:SetAttribute("Category", "Surface")
	maid:GiveTask(corner)

	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			maid:Destroy()
		end
	end)

	return inst
end

return constructor