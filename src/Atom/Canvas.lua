local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local util = require(script.Parent.Parent:WaitForChild("Util"))

local constructor = {}

local ed = Enum.EasingDirection
local es = Enum.EasingStyle
function newTweenInfo(params)
	params = params or {}
	local duration = params.Duration or 0.5
	local easingStyle = params.EasingStyle or es.Quint
	local easingDirection = params.EasingDirection or ed.InOut
	local repeatCount = params.RepeatCount or 0
	local reverses = params.Reverses or false
	local delayTime = params.DelayTime or 0
	return TweenInfo.new(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime)
end

function constructor.new(config)
	config = config or {}
	local maid = maidConstructor.new()

	local Open = fusion.State(config.Open or true)
	local OpenPosition = fusion.State(config.OpenPosition or config.Position or UDim2.fromScale(0.5,0.5))
	local ClosePosition = fusion.State(config.ClosePosition or config.Position or UDim2.fromScale(1.5,0.5))
	local OpenSize = fusion.State(config.OpenSize or config.Size or UDim2.fromScale(0.5,0.5))
	local CloseSize = fusion.State(config.CloseSize or config.Size or UDim2.fromScale(0.5,0.5))
	local ExitButtonEnabled = fusion.State(true)
	if config.ExitButtonEnabled ~= nil then
		ExitButtonEnabled = fusion.State(config.ExitButtonEnabled)
	end
	-- local AbsoluteScrollLength = fusion.State(config.AbsoluteScrollLength or 0)
	config.Position = config.Position or fusion.Tween(
		fusion.Computed(function()
			if Open:get() == true then
				return OpenPosition:get()
			else
				return ClosePosition:get()
			end
		end),
		newTweenInfo()
	)
	config.Size = config.Size or fusion.Tween(
		fusion.Computed(function()
			if Open:get() == true then
				return OpenSize:get()
			else
				return CloseSize:get()
			end
		end),
		newTweenInfo()
	)
	config.Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
	config.Size = config.Size or UDim2.fromScale(1,1)
	config.Position = config.Position or UDim2.fromScale(0.5,0.5)
	config.AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5)
	config.LayoutOrder = config.LayoutOrder or 0
	config.SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY
	config.Visible = config.Visible or true
	config.Name = config.Name or script.Name

	local inst = fusion.New "Frame" (config)

	maid:GiveTask(inst)
	maid:GiveTask(synthetic("Theme",{
		ThemeCategory = "Background",
		Parent = inst,
	}))
	maid:GiveTask(synthetic("Elevation",{
		Parent = inst,
	}))
	maid:GiveTask(synthetic("Dropshadow",{
		Parent = inst,
	}))
	maid:GiveTask(synthetic("Corner",{
		Radius = UDim.new(0, 5),
		Parent = inst
	}))
	local buttonSize = 24
	maid._instPadding = synthetic("Padding",{
		Padding = UDim.new(0, math.ceil(buttonSize/2)),
		Parent = inst
	})
	local scrollBarThickness = buttonSize/2
	local currentScrollBarThickness = fusion.State(scrollBarThickness)
	maid._instPadding.PaddingRight = UDim.new(0, math.max(2, buttonSize/2 - currentScrollBarThickness:get()))

	local content = fusion.New "ScrollingFrame" {
		Name = "Content",
		Size = UDim2.fromScale(1,1),
		ScrollBarThickness = currentScrollBarThickness,
		CanvasSize = UDim2.new(0,0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromScale(0.5,0.5),
		AnchorPoint = Vector2.new(0.5,0.5),
		Parent = inst,
	}
	maid:GiveTask(synthetic("Theme",{
		ThemeCategory = "Background",
		Parent = content,
	}))
	maid:GiveTask(content:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
		if content.AbsoluteCanvasSize.Y > content.AbsoluteWindowSize.Y then
			currentScrollBarThickness:set(scrollBarThickness)
		else
			currentScrollBarThickness:set(0)
		end
	end))

	maid:GiveTask(inst:GetAttributeChangedSignal("AbsoluteElevation"):Connect(function()
		content:SetAttribute("AbsoluteElevation", inst:GetAttribute("AbsoluteElevation"))
	end))
	local basePadding = 3
	maid._contentPadding = fusion.New "UIPadding"{
		PaddingRight = UDim.new(0, currentScrollBarThickness:get() + basePadding),
		PaddingLeft = UDim.new(0, basePadding),
		PaddingTop = UDim.new(0, basePadding),
		PaddingBottom = UDim.new(0, basePadding),
		Parent = content,
	}

	local exitButton = synthetic("Button",{
		Name = "ExitButton",
		Parent = inst,
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.new(1, -currentScrollBarThickness:get()/2 + buttonSize/2, 0, -buttonSize/2),
		Size = UDim2.fromOffset(buttonSize, buttonSize),
	})
	exitButton.Visible = ExitButtonEnabled:get()
	local scrollBarUpdate = fusion.Compat(currentScrollBarThickness)
	maid:GiveTask(scrollBarUpdate:onChange(function()
		maid._contentPadding.PaddingRight = UDim.new(0, currentScrollBarThickness:get() + basePadding)
		local paddingRight = math.max(2, buttonSize/2 - currentScrollBarThickness:get())
		maid._instPadding.PaddingRight = UDim.new(0, paddingRight)
		exitButton.Position = UDim2.new(1, paddingRight, 0, -buttonSize/2)
	end))

	exitButton.Text = "X"
	maid:GiveTask(exitButton)

	exitButton:WaitForChild("InputEffect"):SetAttribute("StartSize", UDim2.fromOffset(buttonSize, buttonSize))
	exitButton:WaitForChild("Corner").CornerRadius = UDim.new(0.5, 0)
	local exitButtonCompat = fusion.Compat(ExitButtonEnabled)
	maid:GiveTask(exitButtonCompat:onChange(function()
		exitButton.Visible = ExitButtonEnabled:get()
	end))
	maid:GiveTask(exitButton.Activated:Connect(function()
		Open:set(false)
	end))
	exitButton:WaitForChild("Theme"):SetAttribute("ThemeCategory", "Error")
	exitButton:WaitForChild("Theme"):SetAttribute("TextClass", "Caption")

	--bind to attributes
	util.SetPublicState("Open", Open, inst, maid)
	util.SetPublicState("OpenPosition", OpenPosition, inst, maid)
	util.SetPublicState("ClosePosition", ClosePosition, inst, maid)
	util.SetPublicState("OpenSize", OpenSize, inst, maid)
	util.SetPublicState("CloseSize", CloseSize, inst, maid)
	util.SetPublicState("ExitButtonEnabled", ExitButtonEnabled, inst, maid)

	return inst, maid
end

return constructor