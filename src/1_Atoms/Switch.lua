local runService = game:GetService("RunService")
local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local typography = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)
	local maid = maidConstructor.new()
	local inst

	--public states
	local Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1))
	local BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.new(0.5,0.5,0.5))
	local Selected = util.import(params.Selected) or fusion.State(false)
	local Typography = util.import(params.Typography) or typography.new(Enum.Font.SourceSans, 10, 14)

	--influencers
	local _Hovered = fusion.State(false)
	local _Clicked = fusion.State(false)

	--properties
	local _Padding = fusion.Computed(function()
		return Typography:get().Padding
	end)
	local _TextSize = fusion.Computed(function()
		return Typography:get().TextSize
	end)


	--preparing config
	local config = {
		Name = script.Name,
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
		LeftColor = util.getInteractionColor(_Clicked, _Hovered, Color),
		RightColor = util.getInteractionColor(_Clicked, _Hovered, BackgroundColor),
		Precision = 0.01,
		Alpha = fusion.Computed(function()
			if Selected:get() == true then
				return 1
			else
				return 0
			end
		end),
		KnobEnabled = true,
		Padding = _Padding,
	}
	util.mergeConfig(config, params, nil, {
		Selected = true,
		Theme = true,
		Color = true,
	})

	inst = synthetic.New "ProgressBar" (config)

	util.setPublicState("Color", Color, inst, maid)
	util.setPublicState("BackgroundColor", BackgroundColor, inst, maid)
	util.setPublicState("Selected", Selected, inst, maid)

	maid:GiveTask(inst)
	util.init(script.Name, inst, maid)

	return inst
end

return constructor