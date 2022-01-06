local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))

local constructor = {}

function constructor.new(params)
	--public states
	--[=[
		@class Label
		@tag Component
		@tag Atom
		The text & icon combo used within the Button component among others
	]=]

	--public states

	local public = {}

	--[=[
		@prop Typography Typography | FusionState | nil
		The Typography to be used for this component
		@within Button
	]=]
	public.Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)

	--[=[
		@prop Text string | FusionState | nil
		Text that fills the label
		@within Button
	]=]
	public.Text = util.import(params.Text) or fusion.State("")

	--[=[
		@prop Color Color3 | FusionState | nil
		Color used for text
		@within Button
	]=]
	public.TextColor = util.import(params.TextColor) or fusion.State(Color3.new(0.5,0,1))

	--[=[
		@prop Image string | FusionState | nil
		Roblox Asset URL used to load in an icon's custom texture. If left nil an image won't be created.
		@within Button
	]=]
	public.Image = util.import(params.Icon) or fusion.State("")

	--[=[
		@prop ImageRectSize Vector2 | FusionState | nil
		How big the icon's sprite-sheet cells are
		@within Button
	]=]
	public.ImageRectSize = util.import(params.ImageRectSize) or fusion.State(Vector2.new(0,0))

	--[=[
		@prop ImageRectOffset Vector2 | FusionState | nil
		What position on a sprite-sheet should an icon be grabbed from
		@within Button
	]=]
	public.ImageRectOffset = util.import(params.ImageRectOffset) or fusion.State(Vector2.new(0, 0))

	--[=[
		@prop SynthClassName string
		Read-Only attribute used to identify what type of component it is
		@within Button
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)
	--read only public states
	public.IconEnabled = fusion.Computed(function()
		local image = public.Image:get()
		if image == "" then
			return false
		else
			return true
		end
	end)

	--properties
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)

	--construct
	return util.set(fusion.New "Frame", public, params, {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.new(1, 1, 1),
		[fusion.OnChange] = {
			fusion.New 'TextLabel' {
				LayoutOrder = 1000,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextColor3 = util.tween(public.Color),
				Text = public.Text,
				BackgroundTransparency = 1,
				Font = fusion.Computed(function()
					return public.Typography:get().Font
				end)
			,
				TextSize = util.tween(_TextSize),
			},
			fusion.New 'UIListLayout' {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = fusion.Computed(function()
					return public.Typography:get().Padding
				end),
				FillDirection = Enum.FillDirection.Horizontal,
			},
			fusion.New 'ImageButton' {
				BackgroundTransparency = 1,
				Image = public.Image,
				ImageRectSize = public.ImageRectSize,
				Size = util.tween(fusion.Computed(function()
					local textSize = _TextSize:get()
					return UDim2.fromOffset(textSize, textSize)
				end)),
				Visible = public.IconEnabled,
				ImageColor3 = util.tween(public.Color),
				ImageRectOffset = public.ImageRectOffset,
				Name = 'Icon',
				Position = UDim2.new(0.5,0,0.5,0),
			},
		},
	})
end

return constructor