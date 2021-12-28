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
	local _Value = fusion.Computed(function()
		if Selected:get() then
			return 1
		else
			return 0
		end
	end)

	--transparency
	local _FillTransparency = fusion.Computed(function()
		if Selected:get() then
			return 0
		else
			return 1
		end
	end)

	--colors
	local _BackgroundColor, _IconColor = util.getInteractionColorStates(
		_Clicked,
		_Highlighted,
		theme.getColorState(Theme),
		theme.getTextColorState(Theme)
	)
	local _StrokeColor = fusion.Computed(function()
		if Selected:get() then
			return _BackgroundColor:get()
		else
			return Color3.new(0.5,0.5,0.5)
		end
	end)

	--sizes
	local maid = maidConstructor.new()

	local config = {
		[fusion.OnEvent "Activated"] = function()
			Selected:set(not Selected:get())
		end,
		[fusion.OnEvent "InputBegan"] = function()
			_Highlighted:set(true)
		end,
		[fusion.OnEvent "InputEnded"] = function()
			_Highlighted:set(false)
			_Clicked:set(false)
		end,
		LeftColor = nil,
		RightColor = nil,
		Precision = nil,
		Alpha = nil,
		KnobEnabled = nil,
		Padding = nil,
		Value = nil,
	}
	util.mergeConfig(config, params, nil, {
		Selected = true,
		Theme = true,
		Color = true,
	})

	local inst = synthetic.New "ProgressBar" (config)

	util.setPublicState("Theme", Theme, inst, maid)
	util.setPublicState("Color", Color, inst, maid)
	util.setPublicState("Selected", Selected, inst, maid)

	maid:GiveTask(inst)
	util.init(script.Name, inst, maid)

	return inst
end

return constructor