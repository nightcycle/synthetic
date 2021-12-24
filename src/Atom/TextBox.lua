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

	config.Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
	config.Size = config.Size or UDim2.fromScale(1,1)
	config.Position = config.Position or UDim2.fromScale(0.5,0.5)
	config.AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5)
	config.LayoutOrder = config.LayoutOrder or 0
	config.SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY
	config.Visible = config.Visible or true
	config.Name = config.Name or script.Name
	config.Text = config.Text or ""
	config.TextXAlignment = config.TextXAlignment or Enum.TextXAlignment.Left
	config.TextYAlignment = config.TextYAlignment or Enum.TextYAlignment.Center
	config.PlaceholderText = config.PlaceholderText or "Input Text Here"
	config[fusion.OnEvent "FocusLost"] = function()
		Input:set(inst.Text)
	end

	inst = fusion.New "TextBox" (config)
	maid:GiveTask(inst)
	maid:GiveTask(synthetic("Theme",{
		ThemeCategory = "Primary",
		TextClass = "Body",
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