local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local constructor = {}

function constructor.new(params)
	local inst
	local maid = maidConstructor.new()

	--public states
	local public = {
		Color = util.import(params.Color) or f.v(params.Color or Color3.new(0.5, 0, 1)),
		MinimumValue = util.import(params.MinimumValue) or f.v(0),
		MaximumValue = util.import(params.MaximumValue) or f.v(1),
		Notches = util.import(params.Notches) or f.v(5),
		Input = util.import(params.Input) or f.Input(0.5),
		ValueTextEnabled = util.import(params.ValueTextEnabled) or f.v(false),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		SynthClassName = f.get(function()
			return script.Name
		end),
	}

	--read only public states
	public.Alpha = f.get(function()
		local minVal = public.MinimumValue:get()
		local maxVal = public.MaximumValue:get()
		local val = public.Input:get()
		local rangeVal = maxVal - minVal
		return (val-minVal)/rangeVal
	end)
	local _DisplayAlpha = f.v(public.Alpha:get())
	public.Value = f.get(function()
		local minVal = public.MinimumValue:get()
		local maxVal = public.MaximumValue:get()
		local rangeVal = maxVal - minVal
		local a = _DisplayAlpha:get()
		return minVal + rangeVal*a
	end)

	--influencers
	local _Hovered = f.v(false)
	local _Clicked = f.v(false)

	--properties
	local _BubbleTransparency = f.get(function()
		local hovered = _Hovered:get()
		local clicked = _Clicked:get()
		if clicked then
			return 0.6
		elseif hovered then
			return 0.9
		end
		return 1
	end)
	local _BubbleSize = f.get(function()
		local hovered = _Hovered:get()
		local clicked = _Clicked:get()
		if clicked or hovered then
			return UDim.new(0, 40)
		else
			return UDim.new(0, 0)
		end
	end)
	local _Height = f.get(function()
		local typography = public.Typography:get()
		return typography.TextSize --+ typography.Padding.Offset*2
	end)
	-- local _BubblePosition = f.v(UDim2.fromOffset(0,0))

	local function updateBar(cursorPos:Vector2)
		local typography = public.Typography:get()
		local pad = typography.Padding.Offset

		local absPos = inst.AbsolutePosition + Vector2.new(pad, pad)
		local absSize = inst.AbsoluteSize - Vector2.new(pad*2, pad*2)
		local alpha = (cursorPos.X - absPos.X)/absSize.X
		local minVal = public.MinimumValue:get()
		local maxVal = public.MaximumValue:get()
		local rangeVal = maxVal - minVal
		public.Input:set(alpha*rangeVal + minVal)
	end

	local _MutedColor = f.get(function()
		local h,s,v = public.Color:get():ToHSV()

		return Color3.fromHSV(h,s*0.4,v)
	end)

	local _TipEnabled = f.v(false)
	--preparing config
	inst = util.set(synthetic.New "ProgressBar", public, params, {
		BackgroundColor = _MutedColor,
		Color = public.Color,
		Notches = public.Notches,
		Alpha = public.Alpha,
		KnobEnabled = true,
		LockKnobColor = false,
		Saturation = 1,
		Padding = f.get(function()
			local pad = public.Typography:get().Padding
			return UDim.new(pad.Scale, pad.Offset)
		end),
		BarPadding = f.get(function()
			local typography = public.Typography:get()
			local pad = typography.Padding.Offset*2
			return UDim.new(0, (-pad + 2*_Height:get())*0.325)
		end),
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		Size = f.get(function()
			local height = _Height:get()
			local typography = public.Typography:get()
			local pad = typography.Padding.Offset
			return UDim2.fromOffset(7*height, height+pad*2)
		end),
		[f.e "InputChanged"] = function(inputObj)
			_Hovered:set(true)
			if not _Clicked:get() then return end
			local cursorPos = inputObj.Position
			updateBar(Vector2.new(cursorPos.X, cursorPos.Y))
		end,
		[f.e "MouseButton1Down"] = function(x,y)
			_Clicked:set(true)
			_TipEnabled:set(true)
			effects.sound("ui_tap-variant-01")

			updateBar(Vector2.new(x,y))
		end,
		[f.e "MouseButton1Up"] = function()
			_Clicked:set(false)
			_TipEnabled:set(false)
			maid.rippleMaid = nil
		end,
		[f.e "InputEnded"] = function()
			_Clicked:set(false)
			_Hovered:set(false)
			_TipEnabled:set(false)
		end,
	}, maid)
	local knob = inst:FindFirstChild("Knob")
	local onChange = inst:FindFirstChild("OnChange")
	--tooltip stuff
	local _AbsPosition = f.v(Vector2.new(0,0))
	local _AbsSize = f.v(Vector2.new(0,0))


	maid:GiveTask(onChange.Event:Connect(function(val)
		_DisplayAlpha:set(val)
	end))

	maid:GiveTask(knob:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
		_AbsPosition:set(knob.AbsolutePosition)
	end))
	maid:GiveTask(knob:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		_AbsSize:set(knob.AbsoluteSize)
	end))
	effects.tip(maid, {
		Text = public.Value,
		Visible = _TipEnabled,
	}, _AbsPosition, _AbsSize, f.v(Vector2.new(0.5,0)))
	maid:GiveTask(synthetic.New "Bubble" {
		Position = UDim2.fromScale(0.5,0.5),
		Size = _BubbleSize,
		Transparency = _BubbleTransparency,
		Color = public.Color,
		Parent = knob,
	})
	return inst
end

return constructor