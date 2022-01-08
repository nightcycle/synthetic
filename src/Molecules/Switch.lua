local runService = game:GetService("RunService")
local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)

	local inst
	--[=[
		@class Switch
		@tag Component
		@tag Molecule
		A basic [switch](https://material.io/components/switches).
	]=]

	--public states
	local public = {}

	--[=[
		@prop Color Color3 | FusionState | nil
		Color used for activated state
		@within Switch
	]=]
	public.Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1))

	--[=[
		@prop BackgroundColor Color3 | FusionState | nil
		Color used for off state
		@within Switch
	]=]
	public.BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.new(0.5,0.5,0.5))

	--[=[
		@prop Input bool | FusionState | nil
		Whether the switch is on or off
		@within Switch
	]=]
	public.Input = util.import(params.Input) or fusion.State(false)

	--[=[
		@prop Typography Typography | FusionState | nil
		The Typography to be used for this component
		@within Switch
	]=]
	public.Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)

	local _Input = fusion.Computed(function()
		if public.Input:get() == true then
			return 1
		else
			return 0
		end
	end)

	--[=[
		@prop Value bool
		Whether the switch is on or off
		@within Switch
		@readonly
	]=]

	--[=[
		@prop SynthClassName string
		Attribute used to identify what type of component it is
		@within Switch
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)

	--influencers
	local _Hovered = fusion.State(false)
	local _Clicked = fusion.State(false)

	--properties
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)
	_Padding = fusion.Computed(function()
		local pad = public.Typography:get().Padding
		return UDim.new(pad.Scale, pad.Offset*0.5)
	end)

	--constructor
	inst = util.set(synthetic.New "ProgressBar", public, params, {
		[fusion.OnEvent "Activated"] = function(x,y)
			-- local absPos = Vector2.new(x,y)
			local knob = inst:FindFirstChild("Knob")
			local knobColor = fusion.State(knob.BackgroundColor3)

			local function getPos()
				local v2 = knob.AbsolutePosition + knob.AbsoluteSize*0.5
				return UDim2.fromOffset(v2.X, v2.Y)
			end

			local position = fusion.State(getPos())
			effects.ripple(position, knobColor)
			effects.sound("ui_tap-variant-01")

			local rippleMaid = maidConstructor.new()
			rippleMaid:GiveTask(runService.RenderStepped:Connect(function(delta)
				position:set(getPos())
				knobColor:set(knob.BackgroundColor3)
			end))

			task.delay(1, function()
				rippleMaid:Destroy()
			end)
			public.Input:set(not public.Input:get())
		end,
		[fusion.OnEvent "InputBegan"] = function()
			_Hovered:set(true)
		end,
		[fusion.OnEvent "InputEnded"] = function()
			_Hovered:set(false)
			_Clicked:set(false)
		end,
		Size = fusion.Computed(function()
			local height = _TextSize:get() + _Padding:get().Offset*2
			return UDim2.fromOffset(height*1.85, height)
		end),
		Color = util.getInteractionColor(_Clicked, _Hovered, public.Color),
		BackgroundColor = util.getInteractionColor(_Clicked, _Hovered, public.BackgroundColor),
		Notches = 2,
		Alpha = _Input,
		KnobEnabled = true,
		BarPadding = _Padding,
		Padding = _Padding,
	})

	public.Value = fusion.Computed(function()
		return public.Input:get()
	end)

	return inst
end

return constructor