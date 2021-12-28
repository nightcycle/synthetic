local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local typography = require(script.Parent.Parent:WaitForChild("Typography"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)
	local maid = maidConstructor.new()

	--public states
	local LeftColor = util.import(params.LeftColor) or fusion.State(Color3.new(0.5,0,1))
	local RightColor = util.import(params.RightColor) or fusion.State(Color3.new(0.5,0.5,0.5))
	local Precision = util.import(params.Precision) or fusion.State(0.2)
	local Alpha = util.import(params.Alpha) or fusion.State(0)
	local KnobEnabled = util.import(params.KnobEnabled) or fusion.State(false)
	local Padding = util.import(params.Padding) or fusion.State(UDim.new(0, 6))

	--read only states
	local Value = fusion.Computed(function()
		return Precision:get() * math.round(Alpha:get()/Precision:get())
	end)

	--preparing config
	local config = {
		Name = script.Name,
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		[fusion.Children] = {
			fusion.New "Frame" {
				Name = "Knob",
				AnchorPoint = util.tween(fusion.Computed(function()
					return Vector2.new(Value:get(), 0.5)
				end)),
				BackgroundColor3 = util.tween(fusion.Computed(function()
					local leftColor = RightColor:get()
					local rightColor = LeftColor:get()
					local alphaVal = Alpha:get()
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
				end)),
				Position = util.tween(fusion.Computed(function()
					return UDim2.fromScale(Value:get(), 0.5)
				end)),
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
				Size = fusion.Computed(function()
					return UDim2.new(1, -Padding:get().Offset*2, 1, -Padding:get().Offset*2)
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
							local function lowerBrightness(col)
								local h,s,v = col:ToHSV()
								return Color3.fromHSV(h,s*0.45,0.75)
							end
							local leftCol = lowerBrightness(LeftColor:get())
							local rightCol = lowerBrightness(RightColor:get())
							local val = math.clamp(Value:get(), 0.01, 0.98)
							return ColorSequence.new{
								ColorSequenceKeypoint.new(0, leftCol),
								ColorSequenceKeypoint.new(val, leftCol),
								ColorSequenceKeypoint.new(val+0.01, rightCol),
								ColorSequenceKeypoint.new(1, rightCol),
							}
						end)),
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