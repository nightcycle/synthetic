local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local attributerConstructor = require(packages:WaitForChild("attributer"))

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
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		PlaceholderText = "Input Text Here",
		[fusion.OnEvent "FocusLost"] = function()
			-- inst:SetAttribute("Input", inst.Text)
			Input:set(inst.Text)
		end,
		Size = config.Size or UDim2.fromScale(1,1),
		Position = config.Position or UDim2.fromScale(0.5,0.5),
		AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5),
		LayoutOrder = config.LayoutOrder or 0,
		SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY,
		Visible = config.Visible or true,
		Name = config.Name or script.Name,
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}
	maid:GiveTask(inst)
	maid:GiveTask(synthetic("Style",{
		StyleCategory = "Primary",
		TextClass = "Body",
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
		InputElevationBump = 1,
		StartElevation = 1,
		Parent = inst,
	}))

	--bind to attributes
	local attributer = attributerConstructor.new(inst, {})
	maid:GiveTask(attributer)
	local function bindAttributeToState(key, state)
		attributer:Connect(key, state:get())
		local compat = fusion.Compat(state)
		maid:GiveTask(compat:onChange(function()
			if inst:GetAttribute(key) ~= state:get() then
				inst:SetAttribute(key, state:get())
			end
		end))
		maid:GiveTask(attributer.OnChanged:Connect(function(k, val)
			if k == key then
				state:set(val)
			end
		end))
	end
	bindAttributeToState("Input", Input)

	return inst, maid
end

return constructor