--!strict

local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}


type FusionState = typeof(f.v())
type Typography = typeof(typographyConstructor.new(Enum.Font.Gotham, 1, 2))
type Public = {
	Variant: string | FusionState | nil,
	Typography: Typography | nil,
	Text: string | FusionState | nil,
	Tooltip: string | FusionState | nil,
	TooltipDirection: Vector2 | FusionState | nil,
	Color: Color3 | FusionState | nil,
	TextColor: Color3 | FusionState | nil,
	Image: string | FusionState | nil,
	ImageRectSize: Vector2 | FusionState | nil,
	ImageRectOffset: Vector2 | FusionState | nil,
	SynthClassName: string | FusionState | nil,
}

function constructor.new(params:table | nil)
	local inst
	local maid = maidConstructor.new()

	--[=[
		@class Button
		@tag Molecule
		A basic [button](https://material.io/components/buttons)
	]=]

	--public states
	local public: Public = {}
	--[=[
		@prop Variant SynthEnumItem
		The style of construction as detailed [here](https://material.io/components/buttons#anatomy), excluding "Toggle button"
		@within Button
	]=]
	public.Variant = util.import(params.Variant) or f.v("Filled")
	--[=[
		@prop Typography Typography
		The Typography to be used for this component
		@within Button
	]=]
	public.Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)
	--[=[
		@prop Text string
		Text that fills the button
		@within Button
	]=]
	public.Text = util.import(params.Text) or f.v("")
	--[=[
		@prop Tooltip string
		Text that appears when the cursor hovers over button
		@within Button
	]=]
	public.Tooltip = util.import(params.Tooltip) or f.v("")
	--[=[
		@prop TooltipDirection string
		What anchor point on the button should be used to display
		@within Button
	]=]
	public.TooltipDirection = util.import(params.TooltipDirection) or f.v(Vector2.new(0.5,0))
	--[=[
		@prop Color Color3
		Color used for non-text areas of button
		@within Button
	]=]
	public.BackgroundColor = util.import(params.BackgroundColor) or f.v(Color3.new(0.5,0,1))
	--[=[
		@prop TextColor Color3
		Color used for text
		@within Button
	]=]
	public.TextColor = util.import(params.TextColor) or f.v(Color3.new(0.2,0.2,0.2))
	--[=[
		@prop LineColor Color3
		<Missing Docs> 
		@within Button
	]=]
	public.LineColor = util.import(params.LineColor) or f.v(Color3.new(0.5,0,1))
	--[=[
		@prop Image string
		Roblox Asset URL used to load in an icon's custom texture
		@within Button
	]=]
	public.Image = util.import(params.Icon) or f.v("")
	--[=[
		@prop ImageRectSize Vector2
		How big the icon's sprite-sheet cells are
		@within Button
	]=]
	public.ImageRectSize = util.import(params.ImageRectSize) or f.v(Vector2.new(0,0))
	--[=[
		@prop ImageRectOffset Vector2
		What position on a sprite-sheet should an icon be grabbed from
		@within Button
	]=]
	public.ImageRectOffset = util.import(params.ImageRectOffset) or f.v(Vector2.new(0, 0))
	--[=[
		@prop SynthClassName string
		Read-Only attribute used to identify what type of component it is
		@within Button
	]=]
	public.SynthClassName = f.get(function()
		return script.Name
	end)

	--influencers
	local _Hovered = f.v(false)
	local _Clicked = f.v(false)

	--properties
	local _MainColor = util.getInteractionColor(_Clicked, _Hovered, public.BackgroundColor)
	local _DetailColor = util.getInteractionColor(_Clicked, _Hovered, public.LineColor)
	local _LineColor = f.get(function()
		if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
			return _MainColor:get()
		elseif enums.Variant[public.Variant:get()] == enums.Variant.Filled then
			return _DetailColor:get()
		elseif enums.Variant[public.Variant:get()] == enums.Variant.Text then
			return _MainColor:get()
		else
			return _DetailColor:get()
		end
	end)
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)

	--tooltip stuff
	local _AbsPosition = f.v(Vector2.new(0,0))
	local _AbsSize = f.v(Vector2.new(0,0))
	local _TipEnabled = f.v(false)
	effects.tip(maid, {
		Text = public.Tooltip,
		Visible = f.get(function()
			local tipEnabled = _TipEnabled:get()
			local txt = public.Tooltip:get()
			return tipEnabled and txt ~= ""
		end),
	}, _AbsPosition, _AbsSize, public.TooltipDirection)

	--preparing config
	inst = util.set(f.new "TextButton", public, params, {
		[f.dt("AbsoluteSize")] = function()
			_AbsSize:set(inst.AbsoluteSize)
		end,
		[f.dt("AbsolutePosition")] = function()
			_AbsPosition:set(inst.AbsolutePosition)
		end,
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = util.tween(f.get(function()
			if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
				return 1
			elseif enums.Variant[public.Variant:get()] == enums.Variant.Filled then
				return 0
			elseif enums.Variant[public.Variant:get()] == enums.Variant.Text then
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
		[f.c] = {
			f.new 'UIStroke' {
				Color = util.tween(_MainColor),
				Transparency = util.tween(f.get(function()
					if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
						return 0
					elseif enums.Variant[public.Variant:get()] == enums.Variant.Filled then
						return 1
					elseif enums.Variant[public.Variant:get()] == enums.Variant.Text then
						return 1
					else
						return 0
					end
				end)),
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = 2,
			},
			f.new 'UICorner' {
				CornerRadius = util.cornerRadius,
			},
			f.new 'UIListLayout' {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			},
			f.new 'UIPadding' {
				PaddingBottom = _Padding,
				PaddingTop = _Padding,
				PaddingLeft = _Padding,
				PaddingRight = _Padding,
			},
			synthetic.New 'Label' {
				Typography = public.Typography,
				Text = public.Text,
				Color = _LineColor,
				Image = public.Image,
				ImageRectSize = public.ImageRectSize,
				ImageRectOffset = public.ImageRectOffset,
			},
			synthetic.New 'GradientRipple' {
				Color = _MainColor,
			},
		},
		[f.e "InputBegan"] = function(inputObj)
			_Hovered:set(true)
			_TipEnabled:set(true)
		end,
		[f.e "InputEnded"] = function(inputObj)
			_TipEnabled:set(false)
			_Hovered:set(false)
			_Clicked:set(false)
		end,
		[f.e "MouseButton1Down"] = function(x, y)
			effects.sound("ui_tap-variant-01")
			if inst:FindFirstChild("GradientRipple") then
				local ripple = inst:FindFirstChild("GradientRipple")
				ripple.Effect:Fire(Vector2.new(x,y))
			end
			_Clicked:set(true)
		end,
		[f.e "MouseButton1Up"] = function()
			_Clicked:set(false)
		end,
	}, maid)
	return inst
end

return constructor