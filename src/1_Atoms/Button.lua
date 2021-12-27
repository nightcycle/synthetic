local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local theme = require(script.Parent.Parent:WaitForChild("Theme"))
local typography = require(script.Parent.Parent:WaitForChild("Typography"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)

	--public states
	local Variant = util.import(params.Variant) or fusion.State("Filled")
	local Theme = util.import(params.Theme) or fusion.State("Primary")
	local Typography = util.import(params.Typography) or fusion.State("Button")
	local Text = util.import(params.Text) or fusion.State("")
	local Color = util.import(params.Color) or fusion.State(Color3.new(1,1,1))
	local Image = util.import(params.Icon) or fusion.State("rbxassetid://3926305904")
	local ImageRectSize = util.import(params.ImageRectSize) or fusion.State(Vector2.new(0,0))
	local ImageRectOffset = util.import(params.ImageRectOffset) or fusion.State(Vector2.new(0, 0))

	--transparency
	local _StrokeTransparency = fusion.Computed(function()
		if enums.ButtonVariant[Variant:get()] == enums.ButtonVariant.Outlined then
			return 0
		elseif enums.ButtonVariant[Variant:get()] == enums.ButtonVariant.Filled then
			return 1
		elseif enums.ButtonVariant[Variant:get()] == enums.ButtonVariant.Text then
			return 1
		else
			return 0
		end
	end)
	local _BackgroundTransparency = fusion.Computed(function()
		if enums.ButtonVariant[Variant:get()] == enums.ButtonVariant.Outlined then
			return 1
		elseif enums.ButtonVariant[Variant:get()] == enums.ButtonVariant.Filled then
			return 0
		elseif enums.ButtonVariant[Variant:get()] == enums.ButtonVariant.Text then
			return 1
		else
			return 0
		end
	end)

	--misc style
	local _Highlighted = fusion.State(false)
	local _Clicked = fusion.State(false)
	local _Font = typography.getTextSizeState(Typography)

	--colors
	local _MainColor = theme.getColorState(Theme)
	local RecolorWeight = 0.8
	local _MainHighlightColor = fusion.Computed(function()
		local h,s,v = _MainColor:get():ToHSV()
		return Color3.fromHSV(h,s*RecolorWeight,1 - (1-v)*RecolorWeight)
	end)
	local _MainShadowColor = fusion.Computed(function()
		local h,s,v = _MainColor:get():ToHSV()
		return Color3.fromHSV(h,s,v*RecolorWeight)
	end)
	local _DynamicMainColor = fusion.Computed(function()
		if _Clicked:get() then
			return _MainShadowColor:get()
		elseif _Highlighted:get() then
			return _MainHighlightColor:get()
		else
			return _MainColor:get()
		end
	end)

	local _DetailColor = theme.getTextColorState(Theme)
	local _DetailHighlightColor = fusion.Computed(function()
		local h,s,v = _DetailColor:get():ToHSV()
		return Color3.fromHSV(h,s,1 - (1-v)*0.9)
	end)
	local _DetailShadowColor = fusion.Computed(function()
		local h,s,v = _DetailColor:get():ToHSV()
		return Color3.fromHSV(h,s,v*0.9)
	end)
	local _DynamicDetailColor = fusion.Computed(function()
		if _Clicked:get() then
			return _DetailShadowColor:get()
		elseif _Highlighted:get() then
			return _DetailHighlightColor:get()
		else
			return _DetailColor:get()
		end
	end)

	local _BackgroundColor = fusion.Computed(function()
		return _DynamicMainColor:get()
	end)

	local _StrokeColor = fusion.Computed(function()
		return _DynamicMainColor:get()
	end)
	local _TextColor = fusion.Computed(function()
		if enums.ButtonVariant[Variant:get()] == enums.ButtonVariant.Outlined then

			return _DynamicMainColor:get()

		elseif enums.ButtonVariant[Variant:get()] == enums.ButtonVariant.Filled then

			return _DynamicDetailColor:get()

		elseif enums.ButtonVariant[Variant:get()] == enums.ButtonVariant.Text then

			return _DynamicMainColor:get()

		else

			return _DynamicDetailColor:get()

		end
	end)

	--sizes
	local _Padding = typography.getPaddingState(Typography)
	local _TextSize = typography.getTextSizeState(Typography)

	local maid = maidConstructor.new()

	local config = {
		BackgroundColor3 = util.tween(_BackgroundColor),
		BackgroundTransparency = util.tween(_BackgroundTransparency),
		TextSize = util.tween(_TextSize),
		TextColor3 = util.tween(_TextColor),
		Font = _Font,
		AutomaticSize = Enum.AutomaticSize.XY,
		AutoButtonColor = false,
		[fusion.Children] = {
			fusion.New 'UIStroke' {
				Color = util.tween(_StrokeColor),
				Transparency = util.tween(_StrokeTransparency),
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
				Typography = Typography,
				Text = Text,
				Color = _TextColor,
				Image = Image,
				ImageRectSize = ImageRectSize,
				ImageRectOffset = ImageRectOffset,
			}
		},
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
		Variant = true,
		Theme = true,
		Typography = true,
		Text = true,
		Color = true,
		Image = true,
		ImageRectSize = true,
		ImageRectOffset = true,
	})

	local inst = fusion.New "TextButton" (config)

	util.setPublicState("Variant", Variant, inst, maid)
	util.setPublicState("Theme", Theme, inst, maid)
	util.setPublicState("Typography", Typography, inst, maid)

	util.setPublicState("Color", Color, inst, maid)
	util.setPublicState("Text", Text, inst, maid)

	util.setPublicState("Image", Image, inst, maid)
	util.setPublicState("ImageRectSize", ImageRectSize, inst, maid)
	util.setPublicState("ImageRectOffset", ImageRectOffset, inst, maid)

	maid:GiveTask(inst)
	util.init(script.Name, inst, maid)

	return inst
end

return constructor