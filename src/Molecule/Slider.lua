local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
-- local attributerConstructor = require(packages:WaitForChild("attribute"))

local Component = synthetic:WaitForChild("Component")
local atom = synthetic:WaitForChild("Atom")
local cardConstructor = require(atom:WaitForChild("Card"))
local buttonConstructor = require(atom:WaitForChild("Button"))
local paddingConstructor = require(Component:WaitForChild("Padding"))
local cornerConstructor = require(Component:WaitForChild("Corner"))
local listConstructor = require(Component:WaitForChild("ListLayout"))

local enums = synthetic:WaitForChild("Enums")

local textService = game:GetService("TextService")
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

function index(properties, key)
	local props = properties:get()
	return props[key]:get()
end

function update(properties, key, val)
	local props = properties:get()
	props[key]:set(val)
	properties:set(props)
end

function constructor.new()
	local properties = fusion.State({
		MinimumLabel = fusion.State("L"),
		MinimumValue = fusion.State(0),
		MaximumLabel = fusion.State("R"),
		MaximumValue = fusion.State(1),
		Font = fusion.State("Gotham"),
		FontSize = fusion.State(8),
		LineWidth = fusion.State(5),
		Value = fusion.State(0.5),
	})

	local inst = cardConstructor.new()
	inst.Name = "Slider"

	local absoluteSize = fusion.State(Vector2.new(0,0))

	local maid = maidConstructor.new()
	maid._resizeSignal = inst:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		absoluteSize:set(inst.AbsoluteSize)
	end)

	local list = listConstructor.new()
	list:SetAttribute("Alignment", enums:Get("UIAlignment").Center)
	list.FillDirection = Enum.FillDirection.Horizontal
	list.Parent = inst

	local padState = fusion.State(5)
	local padding = paddingConstructor.new()
	padding:SetAttribute("Padding", padState:get())
	padding.Parent = inst

	maid._paddingSizeSignal = padding:GetAttributeChangedSignal("Padding"):Connect(function()
		padding:set(padding:GetAttribute("Padding"))
	end)

	local labelSize = fusion.Computed(function()

		local minText = index(properties, "MinimumLabel")
		local maxText = index(properties, "MaximumLabel")
		local fontSize = index(properties, "FontSize")
		local font = Enum.Font[index(properties, "Font")]

		local absoluteSize = absoluteSize:get()
		local frameSize = Vector2.new(absoluteSize.X - padding:get()*2, absoluteSize.Y)

		local minLength = textService:GetTextSize(minText, fontSize, font, frameSize)
		local maxLength = textService:GetTextSize(maxText, fontSize, font, frameSize)

		return UDim2.new(0, math.max(minLength, maxLength), 1, 0)
	end)

	local lineSize = fusion.Computed(function()
		local lineWidth = index(properties, "LineWidth")
		return UDim2.new(1, -labelSize:get().X.Offset*2, 0, lineWidth)
	end)

	fusion.New "TextLabel" {
		Name = "LeftLabel",
		TextSize = 8,
		Font = Enum.Font.Gotham,
		Text = properties:get().MinimumLabel,
		Size = labelSize,
		Parent = inst,
	}
	fusion.New "TextLabel" {
		Name = "RightLabel",
		TextSize = 8,
		Font = Enum.Font.Gotham,
		Text = properties:get().MaximumLabel,
		Size = labelSize,
		LayoutOrder = 3,
		Parent = inst,
	}
	local line = fusion.New "Frame" {
		Name = "Line",
		Size = lineSize,
		LayoutOrder = 2,
		Parent = inst,
	}

	fusion.New "UICorner" {
		CornerRadius = properties:get("CornerRadius"),
		Parent = line,
	}

	local button = buttonConstructor.new()
	button.Size = UDim2.fromOffset(55, 55)
	button.SizeConstraint = Enum.SizeConstraint.RelativeYY
	button.Parent = line
	button.Modal = false

	fusion.New "UICorner" {
		CornerRadius = UDim.new(1,0),
		Parent = button,
	}

	-- https://devforum.roblox.com/t/how-to-make-an-ui-dragger-for-in-game-settings/1014787/4
	local IsDragging = false
	local inputPosition = Vector2.new(0,0)
	maid._sliderInputBegan = button.InputBegan:Connect(function()
		IsDragging = true
	end)
	maid._sliderInputEnded = button.InputEnded:Connect(function()
		IsDragging = false
	end)
	maid._sliderInputChanged = button.InputChanged:Connect(function(inputObj)
		inputPosition = Vector2.new(inputObj.Position.X, inputObj.Position.Y)
	end)

	maid._renderStepped = runService.RenderStepped:Connect(function()
		if IsDragging then
			local buffer = labelSize:get().X.Offset
			local startX = line.AbsolutePosition.X + buffer
			local finishX = line.AbsoluteSize.X-buffer
			local rangeX = finishX - startX
			local alpha = math.clamp((inputPosition.X - buffer*2)/rangeX, 0, 1)

			button.Position = UDim2.new(alpha, 0, 0.5, 0)

			local minValue = index(properties, "MinimumValue")
			local maxValue = index(properties, "MaximumValue")
			local range = maxValue - minValue

			inst:SetAttribute("Value", minValue + alpha * range)
		end
	end)


	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsAncestorOf(game.Players.LocalPlayer) then
			maid:DoCleaning()
		end
	end)

	for k, state in pairs(properties:get()) do
		inst:SetAttribute(k, state:get())
		maid[k] = inst:GetAttributeChangedSignal(k):Connect(function()
			local val = inst:GetAttribute(k)
			update(properties,k, val)
		end)
	end

	return inst
end

return constructor