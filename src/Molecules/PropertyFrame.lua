local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))

local constructor = {}

function constructor.new(params)

	--[=[
		@class PropertyFrame
		@tag Component
		@tag Molecule
		A basic container used for pairing an interactive element with text on the left side.
		You can see an example of a list of them using switches [here](https://material.io/components/switches#usage).
	]=]

	--public states
	local public = {}
	--[=[
		@prop Typography Typography | FusionState | nil
		The Typography to be used for this component
		@within PropertyFrame
	]=]
	public.Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)

	--[=[
		@prop Text string | FusionState | nil
		Text that fills the left side of the frame
		@within PropertyFrame
	]=]
	public.Text = util.import(params.Text) or fusion.State("")

	--[=[
		@prop TextColor Color3 | FusionState | nil
		Color used for text
		@within PropertyFrame
	]=]
	public.TextColor = util.import(params.TextColor) or fusion.State(Color3.new(1,1,1))

	--[=[
		@prop Text any | FusionState | nil
		Whatever value will be passed on to any component with an Input field under the Content frame
		@within PropertyFrame
	]=]
	public.Input = util.import(params.Input) or fusion.State(nil)

	--[=[
		@prop DividerEnabled bool | FusionState | nil
		Whether a divider is placed below the property frame
		@within PropertyFrame
	]=]
	public.DividerEnabled = util.import(params.DividerEnabled) or fusion.State(false)

	--[=[
		@prop Value any
		The value resultant of the input
		@within PropertyFrame
		@readonly
	]=]
	public.Value = fusion.Computed(function()
		return public.Input:get()
	end)

	--[=[
		@prop SynthClassName string
		Read-Only attribute used to identify what type of component it is
		@within PropertyFrame
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)

	--properties
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)

	--construct
	return util.set(fusion.New "Frame", public, params, {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1,0),
		BackgroundTransparency = 1,
		[fusion.OnChange] = {
			fusion.New 'UIListLayout' {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0,0),
				FillDirection = Enum.FillDirection.Vertical,
			},
			fusion.New 'Frame' {
				Name = "Content",
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1,0),
				[fusion.OnChange] = {
					fusion.New 'UIPadding' {
						PaddingBottom = UDim.new(0,0),
						PaddingTop = UDim.new(0,0),
						PaddingLeft = _Padding,
						PaddingRight = _Padding,
					},
					fusion.New 'TextLabel' {
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextColor3 = util.tween(public.TextColor),
						Text = public.Text,
						Position = UDim2.fromScale(0, 0.5),
						AnchorPoint = Vector2.new(0,0.5),
						BackgroundTransparency = 1,
						Font = fusion.Computed(function()
							return public.Typography:get().Font
						end),
						TextSize = util.tween(_TextSize),
					},
				},
			},
			synthetic.New "Divider" {
				Typography = public.Typography,
				Color = public.TextColor,
				LayoutOrder = 2,
				Visible = public.DividerEnabled,
				Direction = "Horizontal",
			},
		},
	})
end

return constructor