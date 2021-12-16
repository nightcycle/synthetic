local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild("attributer"))

local constructor = {}

function constructor.new(config)
	config = config or {}

	local Text = fusion.State(config.Text or "Are you sure?")
	local ConfirmLabel = fusion.State(config.ConfirmLabel or "Confirm")
	local DenyLabel = fusion.State(config.DenyLabel or "Deny")

	local maid = maidConstructor.new()
	local inst = synthetic("Canvas",{
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
		Size = config.Size or UDim2.fromOffset(0, 0),
		Position = config.Position or UDim2.fromScale(0.5,0.5),
		AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5),
		LayoutOrder = config.LayoutOrder or 0,
		SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY,
		Visible = config.Visible or true,
		Name = config.Name or script.Name,
		ExitButtonEnabled = false,
		ClosePosition = UDim2.fromScale(1.5,0.5)
	})
	inst.AutomaticSize = Enum.AutomaticSize.XY
	inst:WaitForChild("Content").Size = UDim2.fromScale(0,0)
	inst:WaitForChild("Content").AutomaticSize = Enum.AutomaticSize.XY
	maid:GiveTask(inst)
	maid:GiveTask(synthetic("ListLayout", {
		Parent = inst,
	}))
	maid.contentListLayout = synthetic("ListLayout", {
		Parent = inst:WaitForChild("Content"),
	})
	maid.contentListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	maid.contentListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	local buttonHeight = 30
	local textCard = synthetic("Card", {
		Parent = inst:WaitForChild("Content"),
		AnchorPoint = Vector2.new(0.5,0),
		Size = UDim2.fromScale(1,0),
		Name = "Context",
	})
	textCard.AutomaticSize = Enum.AutomaticSize.Y
	maid:GiveTask(textCard)
	local media = synthetic("Display", {
		Media = "Text",
		Text = Text:get(),
		Size = UDim2.fromScale(0,0),
		Position = UDim2.fromScale(0.5,0.5),
		Parent = textCard,
	})
	media.AutomaticSize = Enum.AutomaticSize.XY
	media.BackgroundTransparency = 1
	media:WaitForChild("Padding"):SetAttribute("Padding", UDim.new(0,20))
	maid:GiveTask(media)
	local buttonCard = synthetic("Card", {
		Parent = inst:WaitForChild("Content"),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(0, 0, 0, 0),
		Name = "Buttons"
	})
	buttonCard.AutomaticSize = Enum.AutomaticSize.XY
	maid._buttonCardListLayout = synthetic("ListLayout", {
		Parent = buttonCard,
	})
	maid._buttonCardListLayout.FillDirection = Enum.FillDirection.Horizontal
	maid._buttonCardListLayout.Padding = UDim.new(0, 7)
	maid:GiveTask(buttonCard)

	local OnDecision = fusion.New "BindableEvent" {
		Name = "OnDecision",
		Parent = inst
	}

	local confirmButton = synthetic("Button", {
		Parent = buttonCard,
		Size = UDim2.fromOffset(125, buttonHeight),
		Position = UDim2.fromScale(0, 0.5),
		AnchorPoint = Vector2.new(0, 0.5),
	})
	maid:GiveTask(confirmButton)
	confirmButton.LayoutOrder = 1
	confirmButton:WaitForChild("Style"):SetAttribute("StyleCategory", "Primary")
	confirmButton:WaitForChild("InputEffect"):SetAttribute("InputSizeBump", UDim.new(0,0))
	confirmButton:WaitForChild("InputEffect"):SetAttribute("InputStyleCategory", "Secondary")
	confirmButton:WaitForChild("InputEffect"):SetAttribute("StartStyleCategory", "Primary")
	local confirmCompat = fusion.Compat(ConfirmLabel)
	confirmButton.Text = ConfirmLabel:get()
	maid:GiveTask(confirmCompat:onChange(function()
		confirmButton.Text = ConfirmLabel:get()
	end))
	maid:GiveTask(confirmButton.Activated:Connect(function()
		print("Click1")
		inst:SetAttribute("Open", false)
		OnDecision:Fire(true)
	end))

	local denyButton = synthetic("Button", {
		Parent = buttonCard,
		Size = UDim2.fromOffset(125, buttonHeight),
		Position = UDim2.fromScale(1, 0.5),
		AnchorPoint = Vector2.new(1, 0.5),
	})
	maid:GiveTask(denyButton)
	denyButton:WaitForChild("Style"):SetAttribute("StyleCategory", "Error")
	denyButton:WaitForChild("InputEffect"):SetAttribute("InputSizeBump", UDim.new(0,0))
	denyButton:WaitForChild("InputEffect"):SetAttribute("InputStyleCategory", "Secondary")
	denyButton:WaitForChild("InputEffect"):SetAttribute("StartStyleCategory", "Error")
	denyButton.Text = DenyLabel:get()
	local denyCompat = fusion.Compat(DenyLabel)
	maid:GiveTask(denyCompat:onChange(function()
		denyButton.Text = DenyLabel:get()
	end))
	maid:GiveTask(denyButton.Activated:Connect(function()
		print("Click2")
		inst:SetAttribute("Open", false)
		OnDecision:Fire(false)
	end))

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

	bindAttributeToState("Text", Text)
	bindAttributeToState("ConfirmLabel", ConfirmLabel)
	bindAttributeToState("DenyLabel", DenyLabel)

	return inst, maid
end

return constructor