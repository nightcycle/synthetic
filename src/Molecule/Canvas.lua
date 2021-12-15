local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local attributerConstructor = require(packages:WaitForChild("attributer"))

local Component = synthetic:WaitForChild("Component")
local paddingConstructor = require(Component:WaitForChild("Padding"))
local cornerConstructor = require(Component:WaitForChild("Corner"))
local styleConstructor = require(Component:WaitForChild("Style"))
local elevationConstructor = require(Component:WaitForChild("Elevation"))
local lightingConstructor = require(Component:WaitForChild("Lighting"))
local inputEffectConstructor = require(Component:WaitForChild("InputEffect"))

local atom = synthetic:WaitForChild("Atom")
local displayConstructor = require(atom:WaitForChild("Display"))
local buttonConstructor = require(atom:WaitForChild("Button"))


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

	local Open = fusion.State(config.Open or false)
	local OpenPosition = fusion.State(config.OpenPosition or config.Position or UDim2.fromScale(0.5,0.5))
	local ClosePosition = fusion.State(config.ClosePosition or config.Position or UDim2.fromScale(0.5,0.5))
	local OpenSize = fusion.State(config.OpenSize or config.Size or UDim2.fromScale(0.5,0.5))
	local CloseSize = fusion.State(config.CloseSize or config.Size or UDim2.fromScale(0.5,0.5))
	local ExitButtonEnabled = fusion.State(config.ExitButtonEnabled or true)
	local AbsoluteScrollLength = fusion.State(config.AbsoluteScrollLength or 0)
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
	maid:GiveTask(styleConstructor.new({
		Category = "Background",
		Parent = inst,
	}))
	maid:GiveTask(elevationConstructor.new({
		Parent = inst,
	}))
	maid:GiveTask(lightingConstructor.new({
		Parent = inst,
	}))
	maid:GiveTask(cornerConstructor.new({
		Radius = UDim.new(0, 5),
		Parent = inst
	}))
	local CanvasSize = fusion.Computed(function()
		return UDim2.new(0,0,0, AbsoluteScrollLength:get())
	end)
	local buttonSize = 24
	local scrollBarThickness = 14
	local content = fusion.New "ScrollingFrame" {
		Name = "Content",
		Size = UDim2.fromScale(1,1),
		ScrollBarThickness = scrollBarThickness,
		CanvasSize = CanvasSize,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.5,0.5),
		AnchorPoint = Vector2.new(0.5,0.5),
		Parent = inst,
	}
	maid:GiveTask(cornerConstructor.new({
		Radius = UDim.new(0, math.ceil(buttonSize/2)),
		Parent = inst
	}))
	maid:GiveTask(paddingConstructor.new({
		Padding = UDim.new(0, math.ceil(buttonSize/2)),
		Parent = inst
	}))

	maid:GiveTask(fusion.New "UIPadding"{
		PaddingRight = UDim.new(0,scrollBarThickness),
		Parent = content,
	})


	local exitButton = buttonConstructor.new({
		Name = "ExitButton",
		Parent = inst,
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(1,0),
		Size = UDim2.fromOffset(buttonSize, buttonSize),
	})
	exitButton.Text = "X"
	maid:GiveTask(exitButton)

	exitButton:WaitForChild("InputEffect"):SetAttribute("StartSize", UDim2.fromOffset(buttonSize, buttonSize))
	maid:GiveTask(cornerConstructor.new({
		Radius = UDim.new(0.5, 0),
		Parent = exitButton
	}))
	local exitButtonCompat = fusion.Compat(ExitButtonEnabled)
	maid:GiveTask(exitButtonCompat:onChange(function()
		exitButton.Visible = ExitButtonEnabled:get()
	end))
	maid:GiveTask(exitButton.Activated:Connect(function()
		Open:set(false)
	end))
	exitButton:WaitForChild("Style"):SetAttribute("Category", "Error")
	exitButton:WaitForChild("Style"):SetAttribute("TextClass", "Caption")

	--bind to attributes
	local attributer = attributerConstructor.new(inst, {})
	maid:GiveTask(attributer)
	local function bindAttributeToState(key, state)
		attributer:Connect(key, state:get())
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
	bindAttributeToState("AbsoluteScrollLength", AbsoluteScrollLength)

	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			maid:Destroy()
			print("Cleaning up "..tostring(script.Name))
		end
	end)

	return inst
end

return constructor