local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)


	--public states
	local public = {
		LineColor = util.import(params.LineColor) or f.v(Color3.new(0.5,0.5,0.5)),
		Color = util.import(params.Color) or f.v(Color3.new(0.5,0,1)),
		Input = util.import(params.Input) or f.v(false),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		SynthClassName = f.get(function()
			return script.Name
		end),
	}

	--influencers
	local _Hovered = f.v(false)
	local _Clicked = f.v(false)

	--properties
	local _MainColor = util.getInteractionColor(_Clicked, _Hovered, public.Color)
	local _LineColor = util.getInteractionColor(_Clicked, _Hovered, public.LineColor)
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)


	--preparing config
	local inst
	inst = util.set(f.new "TextButton", public, params, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = util.tween(f.get(function()
			local enabColor = _MainColor:get()
			local disabledColor = _LineColor:get()
			if public.Input:get() then
				return enabColor
			else
				return disabledColor
			end
		end)),
		BackgroundTransparency = 1,
		Size = f.get(function()
			local dim = _TextSize:get()
			return UDim2.fromOffset(dim, dim)
		end),
		Text = "",
		[f.c] = {
			f.new "UICorner" {
				CornerRadius = UDim.new(0.5,0),
			},
			f.new "UIStroke" {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = util.tween(f.get(function()
					if public.Input:get() then
						return _MainColor:get()
					else
						return _LineColor:get()
					end
				end)),
				Thickness = 2,
			},
			f.new "Frame" {
				AnchorPoint = Vector2.new(0.5,0.5),
				Position = UDim2.fromScale(0.5,0.5),
				BackgroundTransparency = util.tween(f.get(function()
					if public.Input:get() then
						return 0
					else
						return 1
					end
				end)),
				BackgroundColor3 = util.tween(_MainColor),
				Size = util.tween(f.get(function()
					local dim = _TextSize:get() - 4
					return UDim2.fromOffset(dim, dim)
				end)),
				[f.c] = {
					f.new "UICorner" {
						CornerRadius = UDim.new(0.5,0),
					},
				}
			}
		},
		[f.e "Activated"] = function()
			if public.Input.set then
				public.Input:set(not public.Input:get())
			end
			local pos = inst.AbsolutePosition + inst.AbsoluteSize * 0.5
			effects.ripple(f.v(UDim2.fromOffset(pos.X, pos.Y)), _MainColor)
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

	return inst
end

return constructor