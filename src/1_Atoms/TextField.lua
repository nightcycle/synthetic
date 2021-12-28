local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local typography = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)
	local maid = maidConstructor.new()
	local config = {}
	util.mergeConfig(config, params)

	--public states
	local Variant = util.import(params.Variant) or fusion.State("Filled")
	local Value = fusion.State(config.Value or "")
	local Label = fusion.State(config.Label or "")
	local Prefix = fusion.State(config.Prefix or "")
	local Suffix = fusion.State(config.Suffix or "")
	local Color = fusion.State(config.Suffix or Color3.new(0.5,0,1))
	local TextColor = fusion.State(config.Suffix or Color3.new(0.5,0.5,0.5))
	local Typography = util.import(params.Typography) or typography.new(Enum.Font.SourceSans, 10, 14)

	--influencers
	local _Clicked = fusion.State(false)
	local _Focused = fusion.State(false)
	local _Hovered = fusion.State(false)

	--properties
	local _Padding = fusion.Computed(function()
		return Typography:get().Padding
	end)
	local _TextSize = fusion.Computed(function()
		return Typography:get().TextSize
	end)
	local filter = filterConstructor.new(game.Players.LocalPlayer)
	local _MainColor = util.getInteractionColor(_Clicked, _Hovered, Color)
	local _DetailColor = util.getInteractionColor(_Clicked, _Hovered, TextColor)
	local _TextColor = fusion.Computed(function()
		if enums.Variant[Variant:get()] == enums.Variant.Outlined then
			return _MainColor:get()
		elseif enums.Variant[Variant:get()] == enums.Variant.Filled then
			return _DetailColor:get()
		elseif enums.Variant[Variant:get()] == enums.Variant.Text then
			return _MainColor:get()
		else
			return _DetailColor:get()
		end
	end)

	--preparing config
	local config = {
		Name = script.Name,
		BackgroundColor3 = util.tween(fusion.Computed(function()
			return _MainColor:get()
		end)),
		BackgroundTransparency = util.tween(fusion.Computed(function()
			if enums.Variant[Variant:get()] == enums.Variant.Outlined then
				return 1
			else
				return 0
			end
		end)),
		[fusion.Children] = {
			fusion.New 'UIStroke' {
				Color = util.tween(fusion.Computed(function()
					return _MainColor:get()
				end)),
				Transparency = util.tween(fusion.Computed(function()
					if enums.Variant[Variant:get()] == enums.Variant.Outlined then
						return 0
					elseif enums.Variant[Variant:get()] == enums.Variant.Filled then
						return 1
					elseif enums.Variant[Variant:get()] == enums.Variant.Text then
						return 1
					else
						return 0
					end
				end)),
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 2,
			},
			fusion.New 'UICorner' {
				CornerRadius = util.tween(_Padding),
			},
			fusion.New 'UIListLayout' {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			},
			fusion.New 'UIPadding' {
				PaddingBottom = _Padding,
				PaddingTop = _Padding,
				PaddingLeft = _Padding,
				PaddingRight = _Padding,
			},
		},
	}


	local inst = fusion.New "TextBox" (config)

	--bind to attributes
	util.setPublicState("Value", Value, inst, maid)
	util.init(script.Name, inst, maid)
	return inst
end

return constructor