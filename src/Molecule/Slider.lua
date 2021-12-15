local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local attributerConstructor = require(packages:WaitForChild("attributer"))

local Component = synthetic:WaitForChild("Component")
local paddingConstructor = require(Component:WaitForChild("Padding"))
local cornerConstructor = require(Component:WaitForChild("Corner"))
local listConstructor = require(Component:WaitForChild("ListLayout"))
local styleConstructor = require(Component:WaitForChild("Style"))
local elevationConstructor = require(Component:WaitForChild("Elevation"))
local lightingConstructor = require(Component:WaitForChild("Lighting"))

local atom = synthetic:WaitForChild("Atom")
local cardConstructor = require(atom:WaitForChild("Card"))
local buttonConstructor = require(atom:WaitForChild("Button"))
local displayConstructor = require(atom:WaitForChild("Display"))

local textService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

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

	local MinimumValue = fusion.State(config.MinimumValue or 0)
	local MaximumValue = fusion.State(config.MaximumValue or 1)
	local Precision = fusion.State(config.Precision or 0.2)
	local LineThickness = fusion.State(config.Line or 20)
	local Value = fusion.State(config.Value or 0.5)
	local LabelWidth = fusion.State(config.LabelWidth or UDim.new(0, 75))

	local absoluteSize = fusion.State(Vector2.new(0,0))
	local maid = maidConstructor.new()

	local inst = cardConstructor.new({
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
		Size = config.Size or UDim2.fromScale(1,1),
		Position = config.Position or UDim2.fromScale(0.5,0.5),
		AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5),
		LayoutOrder = config.LayoutOrder or 0,
		SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY,
		Visible = config.Visible or true,
		Name = config.Name or script.Name,
	})
	maid:GiveTask(inst)
	maid._resizeSignal = inst:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		absoluteSize:set(inst.AbsoluteSize)
	end)

	maid._list = listConstructor.new({
		Parent = inst
	})
	maid._list.VerticalAlignment = Enum.VerticalAlignment.Center
	maid._list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	maid._list.FillDirection = Enum.FillDirection.Horizontal

	local minLabel = fusion.Computed(function()
		return tostring(MinimumValue:get())
	end)
	local maxLabel = fusion.Computed(function()
		return tostring(MaximumValue:get())
	end)
	local font = fusion.State("Gotham")
	local fontSize = fusion.State(8)

	local lineSize = fusion.Computed(function()
		local lineThickness = LineThickness:get()
		return UDim2.new(1, -LabelWidth:get().Offset*2, 0, lineThickness)
	end)
	local labelSizeU2 = fusion.Computed(function()
		return UDim2.new(LabelWidth:get(), UDim.new(1,0))
	end)
	maid._leftLabel = fusion.New "TextLabel" {
		Name = "LeftLabel",
		Text = minLabel,
		Size = labelSizeU2,
		LayoutOrder = 1,
		Parent = inst,
	}
	maid:GiveTask(maid._leftLabel:GetPropertyChangedSignal("TextSize"):Connect(function()
		fontSize:set(maid._leftLabel.TextSize)
	end))
	maid:GiveTask(maid._leftLabel:GetPropertyChangedSignal("Font"):Connect(function()
		font:set(maid._leftLabel.Font.Name)
	end))
	maid:GiveTask(styleConstructor.new({
		Parent = maid._leftLabel,
		Category = "Surface",
		TextClass = "Caption",
	}))

	maid._rightLabel = fusion.New "TextLabel" {
		Name = "RightLabel",
		Text = maxLabel,
		Size = labelSizeU2,
		LayoutOrder = 3,
		Parent = inst,
	}
	maid:GiveTask(maid._rightLabel:GetPropertyChangedSignal("TextSize"):Connect(function()
		fontSize:set(maid._leftLabel.TextSize)
	end))
	maid:GiveTask(maid._rightLabel:GetPropertyChangedSignal("Font"):Connect(function()
		font:set(maid._leftLabel.Font.Name)
	end))
	maid:GiveTask(styleConstructor.new({
		Parent = maid._rightLabel,
		Category = "Surface",
		TextClass = "Caption",
	}))

	local line = fusion.New "Frame" {
		Name = "Line",
		Size = lineSize,
		LayoutOrder = 2,
		Parent = inst,
	}
	maid:GiveTask(line)
	maid:GiveTask(cornerConstructor.new({
		Radius = UDim.new(0, 5),
		Parent = line,
	}))
	maid:GiveTask(styleConstructor.new({
		Parent = line,
		Category = "Secondary",
		TextClass = "Caption",
	}))

	local button = buttonConstructor.new({
		Size = UDim2.fromOffset(55, 55),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		Parent = line,
	})

	button.Modal = false
	maid:GiveTask(button)
	button:WaitForChild("Corner"):SetAttribute("Radius", UDim.new(1,0))

	-- https://devforum.roblox.com/t/how-to-make-an-ui-dragger-for-in-game-settings/1014787/4
	local IsDragging = false
	local inputPosition = Vector2.new(0,0)
	local holdTrackerMaid = maidConstructor.new()

	local onSet = fusion.New "BindableEvent" {
		Name = "OnSet",
		Parent = inst
	}

	maid:GiveTask(holdTrackerMaid)
	maid._sliderInputBegan = button.InputBegan:Connect(function()
		if IsDragging == false and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
			IsDragging = true
			holdTrackerMaid:GiveTask(runService.RenderStepped:Connect(function()
				local startX = line.AbsolutePosition.X
				local finishX = line.AbsolutePosition.X + line.AbsoluteSize.X
				local rangeX = finishX - startX
				local alpha = math.clamp((inputPosition.X-startX)/rangeX, 0, 1)
				local minValue = MinimumValue:get()
				local maxValue = MaximumValue:get()
				local range = maxValue - minValue
				local offsetVal = math.round(range*alpha/Precision:get())*Precision:get()
				alpha = offsetVal/range
				local linePadding = 0.5*button.AbsoluteSize.X/line.AbsoluteSize.X
				alpha = math.clamp(alpha, linePadding, 1-linePadding)
				button.Position = UDim2.new(alpha, 0, 0.5, 0)
				Value:set(minValue + offsetVal)

				if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
					holdTrackerMaid:DoCleaning()
					IsDragging = false
					onSet:Fire(Value:get())
				end
				inputPosition = UserInputService:GetMouseLocation()
			end))
		end
	end)
	maid._renderStepped = runService.RenderStepped:Connect(function()
		if IsDragging then

		end
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
	bindAttributeToState("MinimumValue", MinimumValue)
	bindAttributeToState("MaximumValue", MaximumValue)
	bindAttributeToState("Precision", Precision)
	bindAttributeToState("LineThickness", LineThickness)
	bindAttributeToState("LabelWidth", LabelWidth)

	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			maid:Destroy()
			print("Cleaning up "..tostring(script.Name))
		end
	end)

	return inst
end

return constructor