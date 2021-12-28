local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local typography = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)
	local maid = maidConstructor.new()

	--public states
	local Variant = util.import(params.Variant) or fusion.State("Filled")
	local Typography = util.import(params.Typography) or typography.new(Enum.Font.SourceSans, 10, 14)
	local Text = util.import(params.Text) or fusion.State("")
	local Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1))
	local TextColor = util.import(params.TextColor) or fusion.State(Color3.new(0.2,0.2,0.2))
	local Image = util.import(params.Icon) or fusion.State("rbxassetid://3926305904")
	local ImageRectSize = util.import(params.ImageRectSize) or fusion.State(Vector2.new(0,0))
	local ImageRectOffset = util.import(params.ImageRectOffset) or fusion.State(Vector2.new(0, 0))

	--influencers
	local _Hovered = fusion.State(false)
	local _Clicked = fusion.State(false)

	--properties
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
	local _Padding = fusion.Computed(function()
		return Typography:get().Padding
	end)
	local _TextSize = fusion.Computed(function()
		return Typography:get().TextSize
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
			elseif enums.Variant[Variant:get()] == enums.Variant.Filled then
				return 0
			elseif enums.Variant[Variant:get()] == enums.Variant.Text then
				return 1
			else
				return 0
			end
		end)),
		TextSize = util.tween(_TextSize),
		TextColor3 = util.tween(_TextColor),
		Font = typography.getTextSizeState(Typography),
		AutomaticSize = Enum.AutomaticSize.XY,
		AutoButtonColor = false,
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
	util.setPublicState("Typography", Typography, inst, maid)

	util.setPublicState("Color", Color, inst, maid)
	util.setPublicState("TextColor", TextColor, inst, maid)
	util.setPublicState("Text", Text, inst, maid)

	util.setPublicState("Image", Image, inst, maid)
	util.setPublicState("ImageRectSize", ImageRectSize, inst, maid)
	util.setPublicState("ImageRectOffset", ImageRectOffset, inst, maid)

	maid:GiveTask(inst)
	util.init(script.Name, inst, maid)

	return inst
end

return constructor