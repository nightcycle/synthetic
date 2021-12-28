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
	local _Typography = fusion.State("Body")
	local _Padding = typography.getPaddingState(_Typography)
	local _TextSize = typography.getTextSizeState(_Typography)
	local _Size = fusion.Computed(function()
		local dim = _TextSize:get()
		return UDim2.fromOffset(dim, dim)
	end)
	local _InnerSize = fusion.Computed(function()
		local dim = _TextSize:get() - 4
		return UDim2.fromOffset(dim, dim)
	end)

	local maid = maidConstructor.new()

	local config = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = util.tween(_BackgroundColor),
		BackgroundTransparency = 1,
		Size = _Size,
		Text = "",
		[fusion.Children] = {
			fusion.New "UICorner" {
				CornerRadius = UDim.new(0.5,0),
			},
			fusion.New "UIStroke" {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = util.tween(_StrokeColor),
				Thickness = 2,
			},
			fusion.New "Frame" {
				AnchorPoint = Vector2.new(0.5,0.5),
				Position = UDim2.fromScale(0.5,0.5),
				BackgroundTransparency = util.tween(_FillTransparency),
				BackgroundColor3 = util.tween(_BackgroundColor),
				Size = util.tween(_InnerSize),
				[fusion.Children] = {
					fusion.New "UICorner" {
						CornerRadius = UDim.new(0.5,0),
					},
				}
			}
		},
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
		[fusion.OnEvent "MouseButton1Down"] = function()
			_Clicked:set(true)
		end,
		[fusion.OnEvent "MouseButton1Up"] = function()
			_Clicked:set(false)
		end,
	}
	util.mergeConfig(config, params, nil, {
		Selected = true,
		Theme = true,
		Color = true,
	})

	local inst = fusion.New "TextButton" (config)

	util.setPublicState("Theme", Theme, inst, maid)
	util.setPublicState("Color", Color, inst, maid)
	util.setPublicState("Selected", Selected, inst, maid)

	maid:GiveTask(inst)
	util.init(script.Name, inst, maid)

	return inst
end

return constructor