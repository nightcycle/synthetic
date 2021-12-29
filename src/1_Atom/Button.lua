local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)

	--public states
	local public = {
		Variant = util.import(params.Variant) or fusion.State("Filled"),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Text = util.import(params.Text) or fusion.State(""),
		Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1)),
		TextColor = util.import(params.TextColor) or fusion.State(Color3.new(0.2,0.2,0.2)),
		Image = util.import(params.Icon) or fusion.State("rbxassetid://3926305904"),
		ImageRectSize = util.import(params.ImageRectSize) or fusion.State(Vector2.new(0,0)),
		ImageRectOffset = util.import(params.ImageRectOffset) or fusion.State(Vector2.new(0, 0)),
		SynthClass = fusion.Computed(function()
			return script.Name
		end),
	}

	--influencers
	local _Hovered = fusion.State(false)
	local _Clicked = fusion.State(false)

	--properties
	local _MainColor = util.getInteractionColor(_Clicked, _Hovered, public.Color)
	local _DetailColor = util.getInteractionColor(_Clicked, _Hovered, public.TextColor)
	local _TextColor = fusion.Computed(function()
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
	local _Padding = fusion.Computed(function()
		return public.Typography:get().Padding
	end)
	local _TextSize = fusion.Computed(function()
		return public.Typography:get().TextSize
	end)

	--preparing config
	return util.set(fusion.New "TextButton", public, params, {
		Name = script.Name,
		BackgroundColor3 = util.tween(fusion.Computed(function()
			return _MainColor:get()
		end)),
		BackgroundTransparency = util.tween(fusion.Computed(function()
			if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
				return 1
			elseif enums.Variant[public.Variant:get()] == enums.Variant.Filled then
				return 0
			elseif enums.Variant[public.Variant:get()] == enums.Variant.Text then
				return 1
			else
				return 0
			end
		end)),
		TextSize = util.tween(_TextSize),
		TextColor3 = util.tween(_TextColor),
		Font = typographyConstructor.getTextSizeState(public.Typography),
		AutomaticSize = Enum.AutomaticSize.XY,
		AutoButtonColor = false,
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
			synthetic.New 'Label' {
				Typography = public.Typography,
				Text = public.Text,
				Color = _TextColor,
				Image = public.Image,
				ImageRectSize = public.ImageRectSize,
				ImageRectOffset = public.ImageRectOffset,
			}
		},
		[fusion.OnEvent "InputBegan"] = function()
			_Hovered:set(true)
		end,
		[fusion.OnEvent "InputEnded"] = function()
			_Hovered:set(false)
			_Clicked:set(false)
		end,
		[fusion.OnEvent "MouseButton1Down"] = function()
			effects.clickSound(0.75)
			_Clicked:set(true)
		end,
		[fusion.OnEvent "MouseButton1Up"] = function()
			_Clicked:set(false)
		end,
	})
end

return constructor