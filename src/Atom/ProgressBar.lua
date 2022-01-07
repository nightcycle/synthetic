local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
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

	--[=[
		@class ProgressBar
		@tag Component
		@tag Atom
		A basic progress bar used in Slider.
	]=]


	--public states
	local public = {}
	--[=[
		@prop KnobEnabled bool | FusionState | nil
		Whether the boundary between filled and unfilled is covered by a round knob element
		@within ProgressBar
	]=]
	public.KnobEnabled = util.import(params.KnobEnabled) or fusion.State(false)

	--[=[
		@prop LockKnobColor bool | FusionState | nil
		Whether the knob changes color as the progress bar changes value
		@within ProgressBar
	]=]
	public.LockKnobColor = util.import(params.LockKnobColor) or fusion.State(false)

	--[=[
		@prop BarPadding UDim | FusionState | nil
		How much padding between the bar and the knob
		@within ProgressBar
	]=]
	public.BarPadding = util.import(params.BarPadding) or fusion.State(UDim.new(0, 6))

	--[=[
		@prop Padding UDim | FusionState | nil
		How much padding between the knob and the component frame boundary
		@within ProgressBar
	]=]
	public.Padding = util.import(params.Padding) or fusion.State(UDim.new(0,8))

	--[=[
		@prop Saturation number | FusionState | nil
		How saturated the unfilled area of the bar is
		@within ProgressBar
	]=]
	public.Saturation = util.import(params.Saturation) or fusion.State(0.7)

	--[=[
		@prop Color Color3 | FusionState | nil
		Color used for filled area of progress bar
		@within ProgressBar
	]=]
	public.Color = util.import(params.Color) or fusion.State(Color3.new(0.5, 0, 1))

	--[=[
		@prop BackgroundColor Color3 | FusionState | nil
		Color used for unfilled area of progress bar
		@within ProgressBar
	]=]
	public.BackgroundColor = util.import(params.BackgroundColor)  or fusion.State(Color3.new(0.8,0.8,0.8))

	--[=[
		@prop Notches number | FusionState | nil
		How many values are available within progress bar
		@within ProgressBar
	]=]
	public.Notches = util.import(params.Notches) or fusion.State(10)

	--[=[
		@prop Input number | FusionState | nil
		The point between the max & min values that the slider current represents
		@within ProgressBar
	]=]
	public.Input = util.import(params.Input) or fusion.State(0.5)

	--[=[
		@prop Value number
		The the notch rounded value currently solved for by input
		@within ProgressBar
		@readonly
	]=]
	public.Value = fusion.Computed(function()
		local precision = 1/(public.Notches:get()-1)
		return precision * math.round(public.Input:get()/precision)
	end)

	--[=[
		@prop SynthClassName string
		Read-Only attribute used to identify what type of component it is
		@within ProgressBar
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)


	local _barAbsoluteSize = fusion.State(Vector2.new(0,0))
	local _knobAbsoluteSize = fusion.State(Vector2.new(0,0))

	--construct
	local inst
	local maid = maidConstructor.new()
	--[=[
		@function OnChange:Connect
		Creates a signal that fires when the progress bar value changes
		@within ProgressBar
	]=]
	inst = util.set(fusion.New "TextButton", public, params, {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		[fusion.OnChange "AbsoluteSize"] = function()
			_barAbsoluteSize:set(inst:FindFirstChild("Bar").AbsoluteSize)
			_knobAbsoluteSize:set(inst:FindFirstChild("Knob").AbsoluteSize)
		end,
		[fusion.Children] = {
			fusion.New "BindableEvent" {
				Name = "OnChange",
			},
			fusion.New "Frame" {
				Name = "Knob",
				-- AnchorPoint = Vector2.new(0.5,0.5),
				AnchorPoint = util.tween(fusion.Computed(function()
					return Vector2.new(public.Value:get(), 0.5)
				end), moveParams),
				BackgroundColor3 = util.tween(fusion.Computed(function()
					local recolorEnabled = public.LockKnobColor:get()
					local leftColor = public.BackgroundColor:get()
					local rightColor = public.Color:get()
					local alphaVal = public.Value:get()
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
					local a = public.Value:get()
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
				[fusion.Children] = {
					fusion.New "UICorner" {
						CornerRadius = UDim.new(0.5, 0)
					},
					fusion.New "UIStroke" {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Transparency = 0.8,
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
					return UDim2.new(1, -public.BarPadding:get().Offset*2, 1, -public.BarPadding:get().Offset*2)
				end),
				[fusion.Children] = {
					fusion.New "UICorner" {
						CornerRadius = UDim.new(0.5, 0)
					},
					fusion.New "UIStroke" {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Transparency = 1,
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
							local val = math.clamp(public.Value:get(), 0.01, 0.98)
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
			fusion.New 'UIPadding' {
				PaddingLeft = public.Padding,
				PaddingRight = public.Padding,
				PaddingTop = public.Padding,
				PaddingBottom = public.Padding,
			}
		}
	}, maid)
	maid:GiveTask(fusion.Observer(public.Value):onChange(function()
		inst:FindFirstChild("OnChange"):Fire(public.Value:get())
	end))
	return inst
end

return constructor