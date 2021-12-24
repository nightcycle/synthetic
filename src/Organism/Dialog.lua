local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))

local constructor = {}

function constructor.new(config)
	config = config or {}

	local Text = fusion.State(config.Text or "Are you sure?")
	local ConfirmLabel = fusion.State(config.ConfirmLabel or "Confirm")
	local DenyLabel = fusion.State(config.DenyLabel or "Deny")

	local maid = maidConstructor.new()
	config.Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
	config.Size = config.Size or UDim2.fromScale(1,1)
	config.Position = config.Position or UDim2.fromScale(0.5,0.5)
	config.AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5)
	config.LayoutOrder = config.LayoutOrder or 0
	config.SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY
	config.Visible = config.Visible or true
	config.Name = config.Name or script.Name
	config.ExitButtonEnabled = config.ExitButtonEnabled or false
	config.ClosePosition = config.ClosePosition or UDim2.fromScale(1.5, 0.5)

	local inst = synthetic("Canvas",config)
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

	util.SetPublicState("Text", Text, inst, maid)
	util.SetPublicState("ConfirmLabel", ConfirmLabel, inst, maid)
	util.SetPublicState("DenyLabel", DenyLabel, inst, maid)

	return inst, maid
end

return constructor