local runService = game:GetService("RunService")
local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local typographyConstructor = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)

	local inst

	--public states
	local public = {
		Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1)),
		BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.new(0.5,0.5,0.5)),
		Selected = util.import(params.Selected) or fusion.State(false),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		SynthClass = fusion.Computed(function()
			return script.Name
		end),
	}

	--influencers
	local _Hovered = fusion.State(false)
	local _Clicked = fusion.State(false)

	--properties
	local _Padding = fusion.Computed(function()
		return public.Typography:get().Padding
	end)
	local _TextSize = fusion.Computed(function()
		return public.Typography:get().TextSize
	end)

	--constructor
	inst = util.set(synthetic.New "ProgressBar", public, params, {
		[fusion.OnEvent "Activated"] = function(x,y)
			local absPos = Vector2.new(x,y)
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
			public.Selected:set(not public.Selected:get())
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
			return UDim2.fromOffset(height*2, height)
		end),
		LeftColor = util.getInteractionColor(_Clicked, _Hovered, public.Color),
		RightColor = util.getInteractionColor(_Clicked, _Hovered, public.BackgroundColor),
		Precision = 0.01,
		Alpha = fusion.Computed(function()
			if public.Selected:get() == true then
				return 1
			else
				return 0
			end
		end),
		KnobEnabled = true,
		Padding = _Padding,
	})

	return inst
end

return constructor