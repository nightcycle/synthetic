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
		Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1)),
		TextColor = util.import(params.TextColor) or fusion.State(Color3.new(0.2,0.2,0.2)),
		Selected = util.import(params.Selected) or fusion.State(false),
		SynthClass = fusion.Computed(function()
			return script.Name
		end),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
	}

	--influencers
	local _Hovered = fusion.State(false)
	local _Clicked = fusion.State(false)

	--properties
	local _FillTransparency = fusion.Computed(function()
		if public.Selected:get() then
			return 0
		else
			return 1
		end
	end)
	local _BackgroundColor = util.getInteractionColor(_Clicked, _Hovered, public.Color)
	local _Padding = fusion.Computed(function()
		return public.Typography:get().Padding
	end)
	local _TextSize = fusion.Computed(function()
		return public.Typography:get().TextSize
	end)

	--preparing config
	local inst

	inst = util.set(fusion.New "ImageButton", public, params, {
		Name = script.Name,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = util.tween(_BackgroundColor),
		BackgroundTransparency = util.tween(_FillTransparency),
		Size = fusion.Computed(function()
			local dim = _TextSize:get()
			return UDim2.fromOffset(dim, dim)
		end),
		AutomaticSize = Enum.AutomaticSize.XY,
		Image = "rbxassetid://3926305904",
		ImageColor3 = util.tween(util.getInteractionColor(_Clicked, _Hovered, public.TextColor)),
		ImageRectOffset = Vector2.new(644, 204),
		ImageRectSize = Vector2.new(36, 36),
		ImageTransparency = util.tween(_FillTransparency),
		ScaleType = Enum.ScaleType.Fit,

		[fusion.Children] = {
			fusion.New "UIPadding" {
				PaddingBottom = _Padding,
				PaddingLeft = _Padding,
				PaddingRight = _Padding,
				PaddingTop = _Padding
			},
			fusion.New "UICorner" {
				CornerRadius = _Padding
			},
			fusion.New "UIStroke" {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = util.tween(fusion.Computed(function()
					if public.Selected:get() then
						return _BackgroundColor:get()
					else
						return Color3.new(0.5,0.5,0.5)
					end
				end)),
				Thickness = 2,
			}
		},
		[fusion.OnEvent "Activated"] = function()
			public.Selected:set(not public.Selected:get())
			effects.ripple(fusion.State(inst.AbsolutePosition), _BackgroundColor)
			effects.clickSound(0.7)
		end,
		[fusion.OnEvent "InputBegan"] = function()
			_Hovered:set(true)
		end,
		[fusion.OnEvent "InputEnded"] = function()
			_Hovered:set(false)
			_Clicked:set(false)
		end,
		[fusion.OnEvent "MouseButton1Down"] = function()
			_Clicked:set(true)
		end,
		[fusion.OnEvent "MouseButton1Up"] = function()
			_Clicked:set(false)
		end,
	})
	return inst
end

return constructor