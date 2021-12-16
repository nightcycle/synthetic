local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local attributerConstructor = require(packages:WaitForChild("attributer"))

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
	local inst = fusion.New "Frame" {
		Position = fusion.Tween(
			fusion.Computed(function()
				if Open:get() == true then
					return OpenPosition:get()
				else
					return ClosePosition:get()
				end
			end),
			newTweenInfo()
		),
		Size = fusion.Tween(
			fusion.Computed(function()
				if Open:get() == true then
					return OpenSize:get()
				else
					return CloseSize:get()
				end
			end),
			newTweenInfo()
		),
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
		AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5),
		LayoutOrder = config.LayoutOrder or 0,
		SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY,
		Visible = config.Visible or true,
		Name = config.Name or script.Name,
	}
	maid:GiveTask(inst)
	maid:GiveTask(synthetic("Style",{
		StyleCategory = "Background",
		Parent = inst,
	}))
	maid:GiveTask(synthetic("Elevation",{
		Parent = inst,
	}))
	maid:GiveTask(synthetic("Lighting",{
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
	maid:GiveTask(synthetic("Style",{
		StyleCategory = "Background",
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
	exitButton:WaitForChild("Style"):SetAttribute("StyleCategory", "Error")
	exitButton:WaitForChild("Style"):SetAttribute("TextClass", "Caption")

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
	bindAttributeToState("Open", Open)
	bindAttributeToState("OpenPosition", OpenPosition)
	bindAttributeToState("ClosePosition", ClosePosition)
	bindAttributeToState("OpenSize", OpenSize)
	bindAttributeToState("CloseSize", CloseSize)
	bindAttributeToState("ExitButtonEnabled", ExitButtonEnabled)
	-- bindAttributeToState("AbsoluteScrollLength", AbsoluteScrollLength)

	return inst, maid
end

return constructor