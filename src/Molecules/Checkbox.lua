local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	--public states
	local public = {
		BackgroundColor = util.import(params.BackgroundColor) or f.v(Color3.new(0.5,0.5,0.5)),
		Color = util.import(params.Color)  or f.v(Color3.new(0.5,0,1)),
		LineColor = util.import(params.LineColor) or f.v(Color3.new(0.2,0.2,0.2)),
		Input = util.import(params.Input) or f.v(false),
		SynthClassName = f.get(function()
			return script.Name
		end),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
	}

	--influencers
	local _Hovered = f.v(false)
	local _Clicked = f.v(false)

	--properties
	local _FillTransparency = f.get(function()
		if public.Input:get() then
			return 0
		else
			return 1
		end
	end)
	local _LineColor = util.getInteractionColor(_Clicked, _Hovered, public.LineColor)
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)
	_TextSize = f.get(function()
		return public.Typography:get().TextSize * 0.5
	end)

	--preparing config
	local inst
	inst = util.set(f.new "ImageButton", public, params, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = util.tween(f.get(function()
			local enabColor = public.Color:get()
			local disabledColor = _LineColor:get()
			if public.Input:get() then
				return enabColor
			else
				return disabledColor
			end
		end)),
		BackgroundTransparency = util.tween(_FillTransparency),
		Size = f.get(function()
			local dim = _TextSize:get()
			return UDim2.fromOffset(dim, dim)
		end),
		AutomaticSize = Enum.AutomaticSize.XY,
		Image = "rbxassetid://3926305904",
		ImageColor3 = util.tween(util.getInteractionColor(_Clicked, _Hovered, public.LineColor)),
		ImageRectOffset = Vector2.new(644, 204),
		ImageRectSize = Vector2.new(36, 36),
		ImageTransparency = util.tween(_FillTransparency),
		ScaleType = Enum.ScaleType.Fit,

		[f.c] = {
			f.new "UIPadding" {
				PaddingBottom = _Padding,
				PaddingLeft = _Padding,
				PaddingRight = _Padding,
				PaddingTop = _Padding
			},
			f.new "UICorner" {
				CornerRadius = util.cornerRadius,
			},
			f.new "UIStroke" {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = util.tween(f.get(function()
					if public.Input:get() then
						return public.Color:get()
					else
						return public.BackgroundColor:get()
					end
				end)),
				Thickness = 2,
			}
		},
		[f.e "Activated"] = function()
			public.Input:set(not public.Input:get())
			local pos = inst.AbsolutePosition + inst.AbsoluteSize * 0.5
			effects.ripple(f.v(UDim2.fromOffset(pos.X, pos.Y)), public.Color)
			effects.sound("ui_tap-variant-01")
		end,
		[f.e "InputBegan"] = function()
			_Hovered:set(true)
		end,
		[f.e "InputEnded"] = function()
			_Hovered:set(false)
			_Clicked:set(false)
		end,
		[f.e "MouseButton1Down"] = function()
			_Clicked:set(true)
		end,
		[f.e "MouseButton1Up"] = function()
			_Clicked:set(false)
		end,
	})
	print("Inst done! ", tostring(inst))
	return inst
end

return constructor