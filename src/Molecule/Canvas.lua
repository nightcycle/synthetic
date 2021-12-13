local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
-- local attributerConstructor = require(packages:WaitForChild("attribute"))

local quark = synthetic:WaitForChild("Quark")
local atom = synthetic:WaitForChild("Atom")
local paddingConstructor = require(quark:WaitForChild("Padding"))
local cornerConstructor = require(quark:WaitForChild("Corner"))
local displayConstructor = require(atom:WaitForChild("Display"))

local enums = synthetic:WaitForChild("Enums")
local UIDisplay = require(enums:WaitForChild("UIDisplay"))

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
		Open = fusion.State(false),
		Blur = fusion.State(true),
		Alignment = fusion.State(1),
		Elevation = fusion.State(1),
		OpenPosition = fusion.State(UDim2.fromScale(0.5,0.5)),
		ClosePosition = fusion.State(UDim2.fromScale(0.5,0.5)),
		ExitButtonEnabled = fusion.State(true),
	})

	local ZIndex = fusion.Computed(function()
		local props = properties:get()
		local elevation = props.Elevation:get()
		return elevation*10
	end)

	local frame = fusion.New "Frame" {
		Name = "Canvas",
		ZIndex = ZIndex,
		Position = fusion.Tween(
			fusion.Computed(function()
				local props = properties:get()

				-- local blurFunction = camLibrary:Get("Blur")
				-- if blurFunction then
				-- 	blurFunction(props.Blur:get())
				-- end

				if props.Open:get() == true then
					return props.OpenPosition:get()
				else
					return props.ClosePosition:get()
				end
			end),
			newTweenInfo()
		),
		AnchorPoint = fusion.Computed(function()
			-- local alignment = alignmentData:get()
			-- if alignment then
			-- 	return alignment.Anchor
			-- else
				return Vector2.new(0.5,0.5)
			-- end
		end),
		Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}

	local content = fusion.New "Frame" {
		Name = "Content",
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(1,1),
		AnchorPoint = Vector2.new(0.5,0.5),
		Parent = frame,
	}

	local exitButton = fusion.New "TextButton" {
		Name = "ExitButton",
		Parent = frame,
		Visible = properties:get().ExitButtonEnabled,
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(1,0),
	}

	local buttonSize = 48
	exitButton:SetAttribute("RestSize", buttonSize)
	exitButton:SetAttribute("FocusSize", math.round(buttonSize*1.2))

	local exitIcon = displayConstructor.new()
	exitIcon.Parent = exitButton
	exitIcon.BackgroundTransparency = 1
	exitIcon.BackgroundColor3 = Color3.new(1,0,0)

	exitIcon.Size = UDim2.fromScale(1,1)
	exitIcon:SetAttribute("Media", UIDisplay.Text)
	exitIcon:SetAttribute("Text", "X")
	exitIcon:SetAttribute("Color", Color3.new(1,1,1))

	local corner = cornerConstructor.new()
	corner:SetAttribute("Corner", math.ceil(buttonSize/2))
	corner.Parent = exitButton

	local padding = paddingConstructor.new()
	padding:SetAttribute("Padding", math.ceil(buttonSize/2))
	padding.Parent = frame

	local maid = maidConstructor.new()
	maid.deathSignal = frame.AncestryChanged:Connect(function()
		if not frame:IsAncestorOf(game.Players.LocalPlayer) then
			maid:DoCleaning()
		end
	end)
	for k, state in pairs(properties:get()) do
		frame:SetAttribute(k, state:get())
		maid[k] = frame:GetAttributeChangedSignal(k):Connect(function()
			local val = frame:GetAttribute(k)
			update(properties,k, val)
		end)
	end

	return frame
end

return constructor