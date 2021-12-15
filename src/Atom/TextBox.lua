local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local attributerConstructor = require(packages:WaitForChild("attributer"))

local Component = synthetic:WaitForChild("Component")
local styleConstructor = require(Component:WaitForChild("Style"))
local elevationConstructor = require(Component:WaitForChild("Elevation"))
local lightingConstructor = require(Component:WaitForChild("Lighting"))
local inputEffectConstructor = require(Component:WaitForChild("InputEffect"))

local constructor = {}

function constructor.new(config)
	config = config or {}
	local maid = maidConstructor.new()

	local Input = fusion.State(config.Input or "")

	local filter = filterConstructor.new(game.Players.LocalPlayer)

	local text = fusion.Computed(function()
		return filter:Get(Input:get())
	end)

	local inst
	inst = fusion.New "TextBox" {
		Text = text,
		PlaceholderText = "Input Text Here",
		[fusion.OnEvent "FocusLost"] = function()
			Input:set(inst.Text)
		end,
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
		Category = "Primary",
		TextClass = "Button",
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

	--bind to attributes
	local attributer = attributerConstructor.new(inst, {})
	maid:GiveTask(attributer)
	local function bindAttributeToState(key, state)
		attributer:Connect(key, state:get())
		maid:GiveTask(attributer.OnChanged:Connect(function(k, val)
			if k == key then
				state:set(val)
			end
		end))
	end
	bindAttributeToState("Input", Input)

	local maid = maidConstructor.new()
	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			maid:Destroy()
			print("Cleaning up "..tostring(script.Name))
		end
	end)

	return inst
end

return constructor