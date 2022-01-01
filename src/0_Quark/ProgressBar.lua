local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

local moveParams = {
	Duration = 0.2,
	EasingStyle = Enum.EasingStyle.Linear,
	EasingDirection = Enum.EasingDirection.InOut
}
function constructor.new(params)
	--public states
	local public = {
		Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1)),
		BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.new(0.5,0.5,0.5)),
		Notches = util.import(params.Precision) or fusion.State(5),
		Alpha = util.import(params.Alpha) or fusion.State(0),
		KnobEnabled = util.import(params.KnobEnabled) or fusion.State(false),
		LockKnobColor = util.import(params.LockKnobColor) or fusion.State(false),
		Padding = util.import(params.Padding) or fusion.State(UDim.new(0, 6)),
		Saturation = util.import(params.Saturation) or fusion.State(0.7),
		SynthClass = fusion.Computed(function()
			return script.Name
		end),
	}

	--read only states
	public.RoundedAlpha = fusion.Computed(function()
		local precision = 1/public.Notches:get()
		return precision * math.round(public.Alpha:get()/precision)
	end)

	--construct
	return util.set(fusion.New "TextButton", public, params, {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		[fusion.Children] = {
			fusion.New "Frame" {
				Name = "Knob",
				AnchorPoint = util.tween(fusion.Computed(function()
					return Vector2.new(public.RoundedAlpha:get(), 0.5)
				end), moveParams),
				BackgroundColor3 = util.tween(fusion.Computed(function()
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
				Position = util.tween(fusion.Computed(function()
					return UDim2.fromScale(public.RoundedAlpha:get(), 0.5)
				end), moveParams),
				Size = UDim2.fromScale(1,1),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				ZIndex = 2,
				Visible = public.KnobEnabled,
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
				Size = fusion.Computed(function()
					return UDim2.new(1, -public.Padding:get().Offset*2, 1, -public.Padding:get().Offset*2)
				end),
				[fusion.Children] = {
					fusion.New "UICorner" {
						CornerRadius = UDim.new(0.5, 0)
					},
					fusion.New "UIStroke" {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Transparency = 0.5
					},
					fusion.New "UIGradient" {
						Color = util.tween(fusion.Computed(function()
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
			}
		}
	})
end

return constructor