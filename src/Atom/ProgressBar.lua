local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

local moveParams = {
	Duration = 0.1,
	EasingStyle = Enum.EasingStyle.Linear,
	EasingDirection = Enum.EasingDirection.InOut
}
function constructor.new(params)
	--public states
	local public = {
		Color = util.import(params.Color) or f.v(Color3.new(0.5,0,1)),
		BackgroundColor = util.import(params.BackgroundColor) or f.v(Color3.new(0.5,0.5,0.5)),
		Notches = util.import(params.Precision) or f.v(5),
		Alpha = util.import(params.Alpha) or f.v(0),
		KnobEnabled = util.import(params.KnobEnabled) or f.v(false),
		LockKnobColor = util.import(params.LockKnobColor) or f.v(false),
		BarPadding = util.import(params.BarPadding) or f.v(UDim.new(0, 6)),
		Padding = util.import(params.Padding) or f.v(UDim.new(0,8)),
		Saturation = util.import(params.Saturation) or f.v(0.7),
		SynthClassName = f.get(function()
			return script.Name
		end),
	}

	--read only states
	public.RoundedAlpha = f.get(function()
		local precision = 1/(public.Notches:get()-1)
		return precision * math.round(public.Alpha:get()/precision)
	end)

	local _barAbsoluteSize = f.v(Vector2.new(0,0))
	local _knobAbsoluteSize = f.v(Vector2.new(0,0))

	--construct
	local inst
	local maid = maidConstructor.new()
	inst = util.set(f.new "TextButton", public, params, {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		[f.dt "AbsoluteSize"] = function()
			_barAbsoluteSize:set(inst:FindFirstChild("Bar").AbsoluteSize)
			_knobAbsoluteSize:set(inst:FindFirstChild("Knob").AbsoluteSize)
		end,
		[f.c] = {
			f.new "BindableEvent" {
				Name = "OnChange",
			},
			f.new "Frame" {
				Name = "Knob",
				-- AnchorPoint = Vector2.new(0.5,0.5),
				AnchorPoint = util.tween(f.get(function()
					return Vector2.new(public.RoundedAlpha:get(), 0.5)
				end), moveParams),
				BackgroundColor3 = util.tween(f.get(function()
					local recolorEnabled = public.LockKnobColor:get()
					local leftColor = public.BackgroundColor:get()
					local rightColor = public.Color:get()
					local alphaVal = public.Alpha:get()
					if recolorEnabled then

						local h1,s1,v1 = leftColor:ToHSV()
						local h2,s2,v2 = rightColor:ToHSV()
						local function lerp(n1, n2, a)
							local dif = n2-n1
							return n1 + dif*a
						end
						local h = lerp(h1, h2, alphaVal)
						local s = lerp(s1, s2, alphaVal)
						local v = lerp(v1, v2, alphaVal)
						return Color3.fromHSV(h,s,v)
					else
						return rightColor
					end
				end)),
				Position = util.tween(f.get(function()
					local a = public.RoundedAlpha:get()
					local xWidth = _barAbsoluteSize:get().X
					local xOffset = xWidth*(a-0.5)
					local xScale = 0.5
					local yScale = 0.5
					local yOffset = 0
					return UDim2.new(xScale, xOffset, yScale, yOffset)
				end), moveParams),
				Size = UDim2.fromScale(1,1),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				ZIndex = 2,
				Visible = public.KnobEnabled,
				[f.c] = {
					f.new "UICorner" {
						CornerRadius = UDim.new(0.5, 0)
					},
					f.new "UIStroke" {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Transparency = 0.8,
					}
				}
			},
			f.new "Frame" {
				Name = "Bar",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = f.get(function()
					return UDim2.new(1, -public.BarPadding:get().Offset*2, 1, -public.BarPadding:get().Offset*2)
				end),
				[f.c] = {
					f.new "UICorner" {
						CornerRadius = UDim.new(0.5, 0)
					},
					f.new "UIStroke" {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Transparency = 1,
					},
					f.new "UIGradient" {
						Color = util.tween(f.get(function()
							local sat = public.Saturation:get()
							local function lowerBrightness(col)
								local h,s,v = col:ToHSV()
								return Color3.fromHSV(h,s*sat,v)
							end
							local rightCol = lowerBrightness(public.BackgroundColor:get())
							local leftCol = lowerBrightness(public.Color:get())
							local val = math.clamp(public.RoundedAlpha:get(), 0.01, 0.98)
							return ColorSequence.new{
								ColorSequenceKeypoint.new(0, leftCol),
								ColorSequenceKeypoint.new(val, leftCol),
								ColorSequenceKeypoint.new(val+0.01, rightCol),
								ColorSequenceKeypoint.new(1, rightCol),
							}
						end), moveParams),
					},
				}
			},
			f.new 'UIPadding' {
				PaddingLeft = public.Padding,
				PaddingRight = public.Padding,
				PaddingTop = public.Padding,
				PaddingBottom = public.Padding,
			}
		}
	}, maid)
	maid:GiveTask(f.step(public.RoundedAlpha):onChange(function()
		inst:FindFirstChild("OnChange"):Fire(public.RoundedAlpha:get())
	end))
	return inst
end

return constructor