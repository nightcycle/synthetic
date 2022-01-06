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
		@class Dialog
		@tag Component
		@tag Organism
		A basic two-button [dialog](https://material.io/components/dialogs)
	]=]

	--public states
	local public = {}

	--[=[
		@prop HeaderTypography Typography | FusionState | nil
		The Typography to be used for this component's header text
		@within Dialog
	]=]
	public.HeaderTypography = util.import(params.HeaderTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)

	--[=[
		@prop BodyTypography Typography | FusionState | nil
		The Typography to be used for this component's body text
		@within Dialog
	]=]
	public.BodyTypography = util.import(params.BodyTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)

	--[=[
		@prop ButtonTypography Typography | FusionState | nil
		The Typography to be used for this component's button text
		@within Dialog
	]=]
	public.ButtonTypography = util.import(params.ButtonTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)

	--[=[
		@prop HeaderText string | FusionState | nil
		The text used in the header
		@within Dialog
	]=]
	public.HeaderText = util.import(params.HeaderText) or fusion.State("")

	--[=[
		@prop BodyText string | FusionState | nil
		The text used in the body
		@within Dialog
	]=]
	public.BodyText = util.import(params.BodyText) or fusion.State("")

	--[=[
		@prop Button1Text string | FusionState | nil
		The text used in the left button, typically the disagree / deny option
		@within Dialog
	]=]
	public.Button1Text = util.import(params.Button1Text) or fusion.State("Disagree")

	--[=[
		@prop Button2Text string | FusionState | nil
		The text used in the left button, typically the agree / confirm option
		@within Dialog
	]=]
	public.Button2Text = util.import(params.Button2Text) or fusion.State("Agree")

	--[=[
		@prop BackgroundColor Color3 | FusionState | nil
		Color used for background
		@within Dialog
	]=]
	public.BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.new(1,1,1))

	--[=[
		@prop Color Color3 | FusionState | nil
		Color used for highlighting things, in this case button text
		@within Dialog
	]=]
	public.Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1))

	--[=[
		@prop TextColor Color3 | FusionState | nil
		Color used for body & header text
		@within Dialog
	]=]
	public.TextColor = util.import(params.TextColor) or fusion.State(Color3.new(0.2,0.2,0.2))

	--[=[
		@prop Enabled bool | FusionState | nil
		Whether the prompt is currently displaying & darkening the background
		@within Dialog
	]=]
	public.Enabled = util.import(params.Enabled) or fusion.State(false)

	--[=[
		@prop SynthClassName string
		Read-Only attribute used to identify what type of component it is
		@within Dialog
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)

	--properties
	local _Padding, _HeaderTextSize, _HeaderFont = util.getTypographyStates(public.HeaderTypography)
	local _BodyPadding, _BodyTextSize, _BodyFont = util.getTypographyStates(public.BodyTypography)
	local _AbsoluteHeaderSize = fusion.State(Vector2.new(0,0))

	--construct
	--[=[
		@function OnSelect:Connect
		Creates a signal that fires when a choice is clicked
		@within Dialog
	]=]
	local inst
	inst = util.set(fusion.New "Frame", public, params,  {
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = util.tween(fusion.Computed(function()
			if public.Enabled:get() then
				return 0.5
			else
				return 1
			end
		end)),
		[fusion.OnChange] = {
			fusion.New "BindableEvent" {
				Name = "OnSelect",
			},
			fusion.New "Frame" {
				Name = "Panel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = public.BackgroundColor,
				Position = UDim2.fromScale(0.5, 0.5),
				Visible = public.Enabled,
				[fusion.OnChange] = {
					fusion.New "TextLabel" {
						Name = "Header",
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Visible = fusion.Computed(function()
							return not (public.HeaderText:get() == "")
						end),
						[fusion.OnChange "AbsoluteSize"] = function()
							local panel = inst:WaitForChild("Panel")
							local header = panel:WaitForChild("Header")
							_AbsoluteHeaderSize:set(header.AbsoluteSize)
						end,
						Font = _HeaderFont,
						Text = public.HeaderText,
						TextColor3 = public.TextColor,
						TextSize = _HeaderTextSize,
						TextXAlignment = Enum.TextXAlignment.Left
					},
					fusion.New "TextLabel" {
						Name = "Body",
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Visible = fusion.Computed(function()
							return not (public.BodyText:get() == "")
						end),
						Size = fusion.Computed(function()
							local absSize = _AbsoluteHeaderSize:get()
							return UDim2.fromOffset(absSize.X, 0)
						end),
						Font = _BodyFont,
						Text = public.BodyText,
						TextColor3 = public.TextColor,
						TextSize = _BodyTextSize,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,

						[fusion.OnChange] = {
							fusion.New "UISizeConstraint" {
								MaxSize = Vector2.new(200, math.huge)
							}
						}
					},
					fusion.New "UIListLayout" {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = _Padding,
					},
					fusion.New "UIPadding" {
						PaddingBottom = _Padding,
						PaddingLeft = _Padding,
						PaddingRight = _Padding,
						PaddingTop = _Padding
					},
					fusion.New "UICorner" {
						CornerRadius = util.cornerRadius,
					},
					fusion.New "Frame" {
						Name = "Response",
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						Size = UDim2.fromScale(1, 0),

						[fusion.OnChange] = {
							fusion.New "UIListLayout" {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Right,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 18)
							},
							synthetic.New "Button" {
								Name = "Button1",
								ButtonVariant = "Text",
								Typography = public.ButtonTypography,
								Text = public.Button1Text,
								TextColor = public.Color,
								AutomaticSize = Enum.AutomaticSize.XY,
								LayoutOrder = 1,
								[fusion.OnEvent "Activated"] = function()
									inst:WaitForChild("OnSelect"):Fire(public.Button1Text:get())
									public.Enabled:set(false)
								end,
							},
							synthetic.New "Button" {
								Name = "Button2",
								ButtonVariant = "Text",
								Typography = public.ButtonTypography,
								Text = public.Button2Text,
								TextColor = public.Color,
								AutomaticSize = Enum.AutomaticSize.XY,
								LayoutOrder = 2,
								[fusion.OnEvent "Activated"] = function()
									inst:WaitForChild("OnSelect"):Fire(public.Button2Text:get())
									public.Enabled:set(false)
								end,
							},
							fusion.New "UIPadding" {
								PaddingTop = _Padding,
							}
						}
					}
				}
			}
		},
	})

	return inst
end

return constructor

