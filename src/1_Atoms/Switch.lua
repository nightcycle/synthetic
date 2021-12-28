local runService = game:GetService("RunService")
local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local theme = require(script.Parent.Parent:WaitForChild("Theme"))
local typography = require(script.Parent.Parent:WaitForChild("Typography"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)

	--public states
	local Theme = util.import(params.Theme) or fusion.State("Primary")
	local Color = util.import(params.Color) or fusion.State(Color3.new(1,1,1))
	local Selected = util.import(params.Selected) or fusion.State(false)

	--misc style
	local _Highlighted = fusion.State(false)
	local _Clicked = fusion.State(false)
	local _Alpha = fusion.Computed(function()
		if Selected:get() == true then
			return 1
		else
			return 0
		end
	end)

	--colors
	local _Typography = fusion.State("Body")
	local _TextSize = typography.getTextSizeState(_Typography)
	local _Padding = typography.getPaddingState(_Typography)
	local _MainColor = util.getInteractionColor(_Clicked, _Highlighted, theme.getColorState(Theme))
	local _BackgroundColor = util.getInteractionColor(_Clicked, _Highlighted, theme.getColorState(fusion.State("Background")))
	--sizes
	local maid = maidConstructor.new()
	local inst
	local config = {
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
			effects.clickSound()
			local rippleMaid = maidConstructor.new()
			rippleMaid:GiveTask(runService.RenderStepped:Connect(function(delta)
				position:set(getPos())
				knobColor:set(knob.BackgroundColor3)
			end))
			task.delay(1, function()
				rippleMaid:Destroy()
			end)
			Selected:set(not Selected:get())
		end,
		[fusion.OnEvent "InputBegan"] = function()
			_Highlighted:set(true)
		end,
		[fusion.OnEvent "InputEnded"] = function()
			_Highlighted:set(false)
			_Clicked:set(false)
		end,
		Size = fusion.Computed(function()
			local height = _TextSize:get() + _Padding:get().Offset*2
			return UDim2.fromOffset(height*2, height)
		end),
		LeftColor = _MainColor,
		RightColor = _BackgroundColor,
		Precision = 0.01,
		Alpha = _Alpha,
		KnobEnabled = true,
		Padding = _Padding,
	}
	util.mergeConfig(config, params, nil, {
		Selected = true,
		Theme = true,
		Color = true,
	})

	inst = synthetic.New "ProgressBar" (config)

	util.setPublicState("Theme", Theme, inst, maid)
	util.setPublicState("Color", Color, inst, maid)
	util.setPublicState("Selected", Selected, inst, maid)

	maid:GiveTask(inst)
	util.init(script.Name, inst, maid)

	return inst
end

return constructor