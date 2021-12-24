local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local util = require(script.Parent.Parent:WaitForChild("Util"))

local userInputService = game:GetService("UserInputService")
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

	config.Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
	config.Size = config.Size or UDim2.fromScale(1,1)
	config.Position = config.Position or UDim2.fromScale(0.5,0.5)
	config.AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5)
	config.LayoutOrder = config.LayoutOrder or 0
	config.SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY
	config.Visible = config.Visible or true
	config.Name = config.Name or script.Name

	local inst = synthetic("Card",config)
	maid:GiveTask(inst)
	maid._resizeSignal = inst:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		absoluteSize:set(inst.AbsoluteSize)
	end)

	maid._list = synthetic("ListLayout",{
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
	maid:GiveTask(synthetic("Theme",{
		Parent = maid._leftLabel,
		ThemeCategory = "Surface",
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
	maid:GiveTask(synthetic("Theme",{
		Parent = maid._rightLabel,
		ThemeCategory = "Surface",
		TextClass = "Caption",
	}))

	local line = fusion.New "Frame" {
		Name = "Line",
		Size = lineSize,
		LayoutOrder = 2,
		Parent = inst,
	}
	maid:GiveTask(line)
	maid:GiveTask(synthetic("Corner",{
		Radius = UDim.new(0, 5),
		Parent = line,
	}))
	maid:GiveTask(synthetic("Theme",{
		Parent = line,
		ThemeCategory = "Secondary",
		TextClass = "Caption",
	}))

	local button = synthetic("Button",{
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
		if IsDragging == false and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
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

				if not userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
					holdTrackerMaid:DoCleaning()
					IsDragging = false
					onSet:Fire(Value:get())
				end
				inputPosition = userInputService:GetMouseLocation()
			end))
		end
	end)
	maid._renderStepped = runService.RenderStepped:Connect(function()
		if IsDragging then

		end
	end)

	--bind to attributes
	util.SetPublicState("Value", Value, inst, maid)
	util.SetPublicState("MinimumValue", MinimumValue, inst, maid)
	util.SetPublicState("MaximumValue", MaximumValue, inst, maid)
	util.SetPublicState("Precision", Precision, inst, maid)
	util.SetPublicState("LineThickness", LineThickness, inst, maid)
	util.SetPublicState("LabelWidth", LabelWidth, inst, maid)

	util.init(inst, maid)
	return inst
end

return constructor