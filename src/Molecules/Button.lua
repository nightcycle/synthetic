local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

type FusionState = typeof(fusion.State()) | typeof(fusion.Computed(function() end))
type Typography = typeof(typographyConstructor.new(Enum.Font.Gotham, 1, 2))
type ButtonParameters = {
	ButtonVariant: string | FusionState | nil,
	Typography: Typography | nil,
	Text: string | FusionState | nil,
	Tooltip: string | FusionState | nil,
	TooltipDirection: Vector2 | FusionState | nil,
	Color: Color3 | FusionState | nil,
	TextColor: Color3 | FusionState | nil,
	Image: string | FusionState | nil,
	ImageRectSize: Vector2 | FusionState | nil,
	ImageRectOffset: Vector2 | FusionState | nil,
}
function constructor.new(params:ButtonParameters | nil)
	local inst
	local maid = maidConstructor.new()

	--[=[
		@class Button
		@tag Component
		@tag Molecule
		A basic [button](https://material.io/components/buttons)
	]=]

	--public states
	local public = {}

	--[=[
		@prop ButtonVariant ButtonVariant | FusionState | nil
		The style of construction as detailed [here](https://material.io/components/buttons#anatomy), excluding "Toggle button"
		@within Button
	]=]
	public.ButtonVariant = util.import(params.ButtonVariant) or fusion.State("Filled")

	--[=[
		@prop Typography Typography | FusionState | nil
		The Typography to be used for this component
		@within Button
	]=]
	public.Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)

	--[=[
		@prop Text string | FusionState | nil
		Text that fills the button
		@within Button
	]=]
	public.Text = util.import(params.Text) or fusion.State("")

	--[=[
		@prop Tooltip string | FusionState | nil
		Text that appears when the cursor hovers over button
		@within Button
	]=]
	public.Tooltip = util.import(params.Tooltip) or fusion.State("")

	--[=[
		@prop TooltipDirection string | FusionState | nil
		What anchor point on the button should be used to display
		@within Button
	]=]
	public.TooltipDirection = util.import(params.TooltipDirection) or fusion.State(Vector2.new(0.5,0))

	--[=[
		@prop Color Color3 | FusionState | nil
		Color used for non-text areas of button
		@within Button
	]=]
	public.Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1))

	--[=[
		@prop TextColor Color3 | FusionState | nil
		Color used for text
		@within Button
	]=]
	public.TextColor = util.import(params.TextColor) or fusion.State(Color3.new(0.2,0.2,0.2))

	--[=[
		@prop Image string | FusionState | nil
		Roblox Asset URL used to load in an icon's custom texture. If left nil an image won't be created.
		@within Button
	]=]
	public.Image = util.import(params.Image) or fusion.State("")

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

	--influencers
	local _Hovered = fusion.State(false)
	local _Clicked = fusion.State(false)

	--properties
	local _MainColor = util.getInteractionColor(_Clicked, _Hovered, public.Color)
	local _DetailColor = util.getInteractionColor(_Clicked, _Hovered, public.TextColor)
	local _TextColor = fusion.Computed(function()
		if enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Outlined then
			return _MainColor:get()
		elseif enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Filled then
			return _DetailColor:get()
		elseif enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Text then
			return _MainColor:get()
		else
			return _DetailColor:get()
		end
	end)
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)

	--tooltip stuff
	local _AbsPosition = fusion.State(Vector2.new(0,0))
	local _AbsSize = fusion.State(Vector2.new(0,0))
	local _TipEnabled = fusion.State(false)
	effects.tip(maid, {
		Text = public.Tooltip,
		Visible = fusion.Computed(function()
			local tipEnabled = _TipEnabled:get()
			local txt = public.Tooltip:get()
			return tipEnabled and txt ~= ""
		end),
	}, _AbsPosition, _AbsSize, public.TooltipDirection)

	--preparing config
	inst = util.set(fusion.New "TextButton", public, params, {
		[fusion.OnChange("AbsoluteSize")] = function()
			_AbsSize:set(inst.AbsoluteSize)
		end,
		[fusion.OnChange("AbsolutePosition")] = function()
			_AbsPosition:set(inst.AbsolutePosition)
		end,
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = util.tween(fusion.Computed(function()
			if enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Outlined then
				return 1
			elseif enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Filled then
				return 0
			elseif enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Text then
				return 1
			else
				return 0
			end
		end)),
		TextSize = _TextSize,
		TextColor3 = util.tween(public.TextColor),
		Font = _Font,
		AutomaticSize = Enum.AutomaticSize.XY,
		AutoButtonColor = false,
		[fusion.Children] = {
			fusion.New 'UIStroke' {
				Color = util.tween(_MainColor),
				Transparency = util.tween(fusion.Computed(function()
					if enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Outlined then
						return 0
					elseif enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Filled then
						return 1
					elseif enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Text then
						return 1
					else
						return 0
					end
				end)),
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 2,
			},
			fusion.New 'UICorner' {
				CornerRadius = util.cornerRadius,
			},
			fusion.New 'UIListLayout' {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			},
			fusion.New 'UIPadding' {
				PaddingBottom = _Padding,
				PaddingTop = _Padding,
				PaddingLeft = _Padding,
				PaddingRight = _Padding,
			},
			synthetic.New 'Label' {
				Typography = public.Typography,
				Text = public.Text,
				TextColor = _TextColor,
				Image = public.Image,
				ImageRectSize = public.ImageRectSize,
				ImageRectOffset = public.ImageRectOffset,
			},
			synthetic.New 'GradientRipple' {
				Color = _MainColor,
			},
		},
		[fusion.OnEvent "InputBegan"] = function(inputObj)
			_Hovered:set(true)
			_TipEnabled:set(true)
		end,
		[fusion.OnEvent "InputEnded"] = function(inputObj)
			_TipEnabled:set(false)
			_Hovered:set(false)
			_Clicked:set(false)
		end,
		[fusion.OnEvent "MouseButton1Down"] = function(x, y)
			effects.sound("ui_tap-variant-01")
			if inst:FindFirstChild("GradientRipple") then
				local ripple = inst:FindFirstChild("GradientRipple")
				ripple.Effect:Fire(Vector2.new(x,y))
			end
			_Clicked:set(true)
		end,
		[fusion.OnEvent "MouseButton1Up"] = function()
			_Clicked:set(false)
		end,
	}, maid)
	return inst
end

return constructor