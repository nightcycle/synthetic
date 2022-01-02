local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	local inst

	--public states
	local public = {
		Variant = util.import(params.Variant) or fusion.State("Filled"),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Text = util.import(params.Text) or fusion.State(""),
		Tooltip = util.import(params.Tooltip) or fusion.State(""),
		BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.new(0.5,0,1)),
		LineColor = util.import(params.LineColor) or fusion.State(Color3.new(0.2,0.2,0.2)),
		Image = util.import(params.Icon) or fusion.State(""),
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
	local _Padding = fusion.Computed(function()
		return public.Typography:get().Padding
	end)

	--preparing config
	inst = util.set(fusion.New "TextButton", public, params, {
		BackgroundColor3 = Color3.new(1,1,1),
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
		TextSize = util.tween(fusion.Computed(function()
			return public.Typography:get().TextSize
		end)),
		TextColor3 = util.tween(_LineColor),
		Font = fusion.Computed(function()
			return public.Typography:get().Font
		end),
		AutomaticSize = Enum.AutomaticSize.XY,
		AutoButtonColor = false,
		[fusion.Children] = {
			fusion.New 'UIStroke' {
				Color = util.tween(_MainColor),
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
				CornerRadius = util.tween(fusion.Computed(function()
					return UDim.new(0, _Padding:get().Offset*0.5)
				end)),
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
				Color = _LineColor,
				Image = public.Image,
				ImageRectSize = public.ImageRectSize,
				ImageRectOffset = public.ImageRectOffset,
			},
			synthetic.New 'GradientRipple' {
				Color = public.BackgroundColor,
			},
		},
		[fusion.OnEvent "InputBegan"] = function()
			_Hovered:set(true)
		end,
		[fusion.OnEvent "InputEnded"] = function()
			_Hovered:set(false)
			_Clicked:set(false)
		end,
		[fusion.OnEvent "MouseButton1Down"] = function(x, y)
			effects.sound("ui_tap-variant-01")
			if inst:FindFirstChild("GradientRipple") then
				local ripple = inst:FindFirstChild("GradientRipple")
				ripple.Effect:Fire(Vector2.new(x,y))
			end
			_Clicked:set(true)
		end,
		[fusion.OnEvent "MouseButton1Up"] = function()
			_Clicked:set(false)
		end,
	})
	return inst
end

return constructor