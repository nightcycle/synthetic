local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))

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

	config.Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
	config.Size = config.Size or UDim2.fromScale(1,1)
	config.Position = config.Position or UDim2.fromScale(0.5,0.5)
	config.AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5)
	config.LayoutOrder = config.LayoutOrder or 0
	config.SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY
	config.Visible = config.Visible or true
	config.Name = config.Name or script.Name

	local maid = maidConstructor.new()
	local inst = synthetic("Button",config)
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
	util.SetPublicState("Value", Value, inst, maid)

	return inst, maid
end

return constructor