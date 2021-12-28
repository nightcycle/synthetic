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

function lerpColor(c1State, c2State, alpha)
	local leftColor = c1State:get()
	local rightColor = c2State:get()
	local alphaVal = alpha:get()
	local h1,s1,v1 = leftColor:get():ToHSV()
	local h2,s2,v2 = rightColor:get():ToHSV()
	local function lerp(n1, n2, a)
		local dif = n2-n1
		return n1 + dif*a
	end
	local h = lerp(h1, h2, alphaVal)
	local s = lerp(s1, s2, alphaVal)
	local v = lerp(v1, v2, alphaVal)
	return Color3.fromHSV(h,s,v)
end

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)
	local maid = maidConstructor.new()

	--public states
	local LeftColor = util.import(params.LeftColor) or fusion.State("Primary")
	local RightColor = util.import(params.RightColor) or fusion.State("Background")
	local Precision = util.import(params.Precision) or fusion.State(0.2)
	local Alpha = util.import(params.Fill) or fusion.State(0)
	local KnobEnabled = util.import(params.ButtonEnabled) or fusion.State(false)
	local Padding = util.import(params.Padding) or fusion.State(UDim.new(0, 6))
	local Value = fusion.Computed(function() --read only
		return Precision:get() * math.round(Alpha:get()/Precision:get())
	end)

	--misc style
	local _Highlighted = fusion.State(false)
	local _Clicked = fusion.State(false)

	local _Typography = fusion.State("Body")
	local _ButtonLeftColor = theme.getColorState(fusion.State("Surface"))
	local _ButtonRightColor = theme.getColorState(fusion.State("Surface"))
	local _ButtonColor = fusion.Computed(function()
		return lerpColor(_ButtonLeftColor, _ButtonRightColor, Value)
	end)
	local _BarColor = fusion.Computed(function()
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, LeftColor:get()),
			ColorSequenceKeypoint.new(Value:get(), LeftColor:get()),
			ColorSequenceKeypoint.new(Value:get()+0.001, RightColor:get()),
			ColorSequenceKeypoint.new(1, RightColor:get()),
		})
	end)
	local _Position = fusion.Computed(function()
		return UDim2.fromScale(Value:get(), 0.5)
	end)
	local _AnchorPoint = fusion.Computed(function()
		return UDim2.fromScale(Value:get(), 0.5)
	end)
	local _BarSize = fusion.Computed(function()
		return UDim2.new(1, -Padding.Offset*2, 1, -Padding.Offset*2)
	end)
	local config = {
		Name = script.Name,
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		[fusion.OnEvent "InputBegan"] = function()
			_Highlighted:set(true)
		end,
		[fusion.OnEvent "InputEnded"] = function()
			_Highlighted:set(false)
			_Clicked:set(false)
		end,
		[fusion.Children] = {
			fusion.New "Frame" {
				Name = "Knob",
				AnchorPoint = util.tween(_AnchorPoint),
				BackgroundColor3 = util.tween(_ButtonColor),
				Position = util.tween(_Position),
				Size = UDim2.fromScale(1,1),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				ZIndex = 2,
				Visible = KnobEnabled,
				[fusion.Children] = {
					fusion.New "UICorner" {
						CornerRadius = UDim.new(0.5, 0)
					},
					fusion.New "UIStroke" {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Transparency = 0.5
					}
				}
			},
			fusion.New "Frame" {
				Name = "Bar",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = _BarSize,

				[fusion.Children] = {
					fusion.New "UICorner" {
						CornerRadius = UDim.new(0.5, 0)
					},
					fusion.New "UIStroke" {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Transparency = 0.5
					},
					fusion.New "UIGradient" {
						Color = util.tween(_BarColor),
					},
				}
			}
		}
	}

	util.mergeConfig(config, params, nil, {
		LeftColor = true,
		RightColor = true,
		Precision = true,
		Alpha = true,
		KnobEnabled = true,
		Padding = true,
		Value = true,
	})

	local inst = fusion.New 'TextButton' (config)
	maid:GiveTask(inst)

	util.setPublicState("LeftColor", LeftColor, inst, maid)
	util.setPublicState("RightColor", RightColor, inst, maid)
	util.setPublicState("Precision", Precision, inst, maid)
	util.setPublicState("Alpha", Alpha, inst, maid)
	util.setPublicState("KnobEnabled", KnobEnabled, inst, maid)
	util.setPublicState("Padding", Padding, inst, maid)
	util.setPublicState("Value", Value, inst, maid)

	util.init(script.Name, inst, maid)

	return inst
end

return constructor