local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local typographyConstructor = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))

local constructor = {}

function constructor.new(params)
	--public states
	local public = {
		Variant = util.import(params.Variant) or fusion.State("Filled"),
		Value = fusion.State(params.Value or ""),
		Label = fusion.State(params.Label or ""),
		Prefix = fusion.State(params.Prefix or ""),
		Suffix = fusion.State(params.Suffix or ""),
		BackgroundColor = fusion.State(params.BackgroundColor or Color3.new(0.5,0,1)),
		LineColor = fusion.State(params.LineColor or Color3.new(0.5,0.5,0.5)),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		SynthClass = fusion.Computed(function()
			return script.Name
		end),
	}
	--influencers
	local _Clicked = fusion.State(false)
	local _Focused = fusion.State(false)
	local _Hovered = fusion.State(false)

	--properties
	local _Padding = fusion.Computed(function()
		return public.Typography:get().Padding
	end)
	local _TextSize = fusion.Computed(function()
		return public.Typography:get().TextSize
	end)
	local filter = filterConstructor.new(game.Players.LocalPlayer)
	local _MainColor = util.getInteractionColor(_Clicked, _Hovered, public.BackgroundColor)
	local _DetailColor = util.getInteractionColor(_Clicked, _Hovered, public.LineColor)
	local _LineColor = fusion.Computed(function()
		if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
			return _MainColor:get()
		elseif enums.Variant[public.Variant:get()] == enums.Variant.Filled then
			return _DetailColor:get()
		elseif enums.Variant[public.Variant:get()] == enums.Variant.Text then
			return _MainColor:get()
		else
			return _DetailColor:get()
		end
	end)

	--constructor
	return util.set(fusion.New "TextBox", public, params, {
		BackgroundColor3 = util.tween(fusion.Computed(function()
			return _MainColor:get()
		end)),
		BackgroundTransparency = util.tween(fusion.Computed(function()
			if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
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
					if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
						return 0
					elseif enums.Variant[public.Variant:get()] == enums.Variant.Filled then
						return 1
					elseif enums.Variant[public.Variant:get()] == enums.Variant.Text then
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
	})
end

return constructor