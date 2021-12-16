local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild("attributer"))

local constructor = {}

function constructor.new(config)
	config = config or {}
	local Value = fusion.State(config.Value or true)
	local EnabledText = fusion.State(config.EnabledText or "Enabled")
	local DisabledText = fusion.State(config.DisabledText or "Disabled")

	local currentText = fusion.Computed(function()
		if Value:get() == true then
			return EnabledText:get()
		else
			return DisabledText:get()
		end
	end)

	local maid = maidConstructor.new()
	local inst = synthetic("Button",{
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
	inst.Text = currentText:get()

	maid:GiveTask(inst)

	local onEnabled = fusion.New "BindableEvent" {
		Parent = inst,
		Name = "OnEnabled"
	}
	maid:GiveTask(onEnabled)
	local onDisabled = fusion.New "BindableEvent" {
		Parent = inst,
		Name = "OnDisabled"
	}
	maid:GiveTask(onDisabled)

	local changeCompat = fusion.Compat(Value)
	maid:GiveTask(changeCompat:onChange(function()
		if Value:get() == true then
			inst.BackgroundTransparency = 0
			onEnabled:Fire()
			inst.Text = currentText:get()
		else
			inst.BackgroundTransparency = 0.35
			onDisabled:Fire()
			inst.Text = currentText:get()
		end
	end))

	maid.activationSignal = inst.Activated:Connect(function()
		inst:SetAttribute("Value", not Value:get())
	end)

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

	bindAttributeToState("Value", Value)

	return inst, maid
end

return constructor