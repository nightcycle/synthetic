local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
-- local attributerConstructor = require(packages:WaitForChild("attribute"))

local Component = synthetic:WaitForChild("Component")
local atom = synthetic:WaitForChild("Atom")
local cardConstructor = require(atom:WaitForChild("Card"))
local buttonConstructor = require(atom:WaitForChild("Button"))
local paddingConstructor = require(Component:WaitForChild("Padding"))
local cornerConstructor = require(Component:WaitForChild("Corner"))
local listConstructor = require(Component:WaitForChild("ListLayout"))

local constructor = {}

function constructor.new(config)
	local properties = fusion.State({
		EnabledColor = fusion.State(Color3.fromHex("#1976d2")),
		DisabledColor = fusion.State(Color3.fromHex("#ff8f00")),
		Value = fusion.State(true),
	})

	local inst = buttonConstructor.new({
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
		Size = config.Size or UDim2.fromScale(1,1),
		Position = config.Position or UDim2.fromScale(0.5,0.5),
		AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5),
		LayoutOrder = config.LayoutOrder or 0,
		SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY,
		Visible = config.Visible or true,
		Name = config.Name or script.Name,
	})
	inst.Name = "Switch"
	local maid = maidConstructor.new()

	maid.activationSignal = inst.Activated:Connect(function()
		properties:Update("Enabled", not index(properties,"Enabled"))
		inst:SetAttribute("Enabled", index(properties,"Enabled"))
	end)
	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			maid:Destroy()
		end
	end)

	for k, state in pairs(properties:get()) do
		inst:SetAttribute(k, state:get())
		maid[k] = inst:GetAttributeChangedSignal(k):Connect(function()
			local val = inst:GetAttribute(k)
			update(properties,k, val)
		end)
	end

	return inst
end

return constructor