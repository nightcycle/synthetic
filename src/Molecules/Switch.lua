local runService = game:GetService("RunService")
local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)

	local inst

	--public states
	local public = {
		Color = util.import(params.Color) or f.v(Color3.new(0.5,0,1)),
		BackgroundColor = util.import(params.BackgroundColor) or f.v(Color3.new(0.5,0.5,0.5)),
		Input = util.import(params.Input) or f.v(false),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		SynthClassName = f.get(function()
			return script.Name
		end),
	}
	local _Alpha = f.get(function()
		if public.Input:get() == true then
			return 1
		else
			return 0
		end
	end)
	public.Value = f.get(function()
		if _Alpha:get() == 1 then
			return true
		else
			return false
		end
	end)

	--influencers
	local _Hovered = f.v(false)
	local _Clicked = f.v(false)

	--properties
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)
	_Padding = f.get(function()
		local pad = public.Typography:get().Padding
		return UDim.new(pad.Scale, pad.Offset*0.5)
	end)

	--constructor
	inst = util.set(synthetic.New "ProgressBar", public, params, {
		[f.e "Activated"] = function(x,y)
			-- local absPos = Vector2.new(x,y)
			local knob = inst:FindFirstChild("Knob")
			local knobColor = f.v(knob.BackgroundColor3)

			local function getPos()
				local v2 = knob.AbsolutePosition + knob.AbsoluteSize*0.5
				return UDim2.fromOffset(v2.X, v2.Y)
			end

			local position = f.v(getPos())
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
		[f.e "InputBegan"] = function()
			_Hovered:set(true)
		end,
		[f.e "InputEnded"] = function()
			_Hovered:set(false)
			_Clicked:set(false)
		end,
		Size = f.get(function()
			local height = _TextSize:get() + _Padding:get().Offset*2
			return UDim2.fromOffset(height*1.85, height)
		end),
		Color = util.getInteractionColor(_Clicked, _Hovered, public.Color),
		BackgroundColor = util.getInteractionColor(_Clicked, _Hovered, public.BackgroundColor),
		Notches = 100,
		Alpha = _Alpha,
		KnobEnabled = true,
		BarPadding = _Padding,
		Padding = _Padding,
	})

	return inst
end

return constructor