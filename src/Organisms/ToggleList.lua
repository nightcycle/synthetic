local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))

local constructor = {}

function constructor.new(params)
	local maid = maidConstructor.new()
	--[=[
		@class ToggleList
		@tag Component
		@tag Organism
		A list of true/false PropertyFrames, similar to what you might see [here](https://material.io/components/switches#usage)
	]=]

	--public states
	local public = {}

	--[=[
		@prop HeaderTypography Typography | FusionState | nil
		The Typography to be used for this component's header text
		@within ToggleList
	]=]
	public.HeaderTypography = util.import(params.HeaderTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)

	--[=[
		@prop BodyTypography Typography | FusionState | nil
		The Typography to be used for this component's body text
		@within ToggleList
	]=]
	public.BodyTypography = util.import(params.BodyTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)

	--[=[
		@prop HeaderText string | FusionState | nil
		The text used in the header
		@within ToggleList
	]=]
	public.HeaderText = util.import(params.HeaderText) or fusion.State("")

	--[=[
		@prop Options dictionary | FusionState | nil
		A table of string keys and associated bool values to be created into property frames
		@within ToggleList
	]=]
	public.Options = util.import(params.Options) or fusion.State({})

	--[=[
		@prop Color Color3 | FusionState | nil
		Color used for any relevant highlights in toggle input areas
		@within ToggleList
	]=]
	public.Color = util.import(params.Color) or fusion.State(Color3.new(1,1,1))

	--[=[
		@prop TextColor Color3 | FusionState | nil
		Color used for all text
		@within ToggleList
	]=]
	public.TextColor = util.import(params.TextColor) or fusion.State(Color3.new(1,1,1))

	--[=[
		@prop ToggleVariant ToggleVariant | FusionState | nil
		@within ToggleList
	]=]
	public.ToggleVariant = util.import(params.ToggleVariant) or fusion.State("Switch")

	--[=[
		@prop BackgroundColor Color3 | FusionState | nil
		Color used for background of toggle elements
		@within ToggleList
	]=]
	public.BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.new(1,1,1))

	--[=[
		@prop Width UDim | FusionState | nil
		Width of the entire component, as Height is solved using Typography
		@within ToggleList
	]=]
	public.Width = util.import(params.Width) or fusion.State(UDim.new(1,0))

	--[=[
		@prop Input string | FusionState | nil
		When ToggleVariant = RadioButton, the selected key can be set here.
		@within ToggleList
	]=]
	public.Input = util.import(params.Input) or fusion.State("")

	--[=[
		@prop Input string | FusionState | nil
		When ToggleVariant = RadioButton, the selected key will be displayed here.
		@within ToggleList
		@readonly
	]=]
	public.Value = fusion.Computed(function()
		return public.Input:get()
	end)

	--[=[
		@prop SynthClassName string
		Read-Only attribute used to identify what type of component it is
		@within ToggleList
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)

	--properties
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.HeaderTypography)

	--construct
	local inst
	inst = util.set(fusion.New "Frame", public, params, {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = fusion.Computed(function()
			return UDim2.new(public.Width:get(), UDim.new(0,0))
		end),
		BackgroundTransparency = 1,
		[fusion.OnChange] = {
			fusion.New "UIListLayout" {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = _Padding,
			},
			fusion.New 'TextLabel' {
				Name = "Header",
				LayoutOrder = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextSize = _TextSize,
				TextWrapped = false,
				Visible = fusion.Computed(function()
					return not (public.HeaderText:get() == "")
				end),
				Font = _Font,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Text = public.HeaderText,
				Size = UDim2.fromScale(1, 0),
				[fusion.OnChange] = {
					fusion.New 'UIPadding' {
						PaddingBottom = _Padding,
						PaddingTop = UDim.new(0,0),
						PaddingLeft = UDim.new(0,0),
						PaddingRight = UDim.new(0,0),
					},
				}
			},
		},
	}, maid)
	fusion.Computeds(public.Options, function(key, _Input)
		local optionMaid = maidConstructor.new()
		local var = public.ToggleVariant:get()
		maid:GiveTask(optionMaid)

		local _ButtonHovered = fusion.State(false)
		local _ButtonClicked = fusion.State(false)

		local propFrame = synthetic.New "PropertyFrame" {
			Name = key,
			Parent = inst,
			Text = key,
			TextColor = public.TextColor,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			Input = _Input,
			DividerEnabled = true,
			LayoutOrder = 3,
		}

		local toggleConfig = {
			Color = public.Color,
			LayoutOrder = 10,
			Position = UDim2.fromScale(1, 0.5),
			AnchorPoint = Vector2.new(1,0.5),
			Input = fusion.Computed(function()
				local curVal = _Input:get()
				local variant = public.ToggleVariant:get()
				local listInput = public.Input:get()
				if variant == "RadioButton" then
					if key == listInput then
						return true
					else
						return false
					end
				else
					return curVal
				end
			end),
			Parent = propFrame:WaitForChild("Content"),
		}

		-- fusion.Computed(function()
		local button
		local newConfig = {}
		for k, v in pairs(toggleConfig) do
			newConfig[k] = v
		end
		if var == "Switch" then
			newConfig.BackgroundColor = public.BackgroundColor
		elseif var == "Checkbox" then
			newConfig.BackgroundColor = public.BackgroundColor
			newConfig.LineColor = public.LineColor
		elseif var == "RadioButton" then
			newConfig.Color = public.Color
			newConfig.LineColor = public.LineColor
			newConfig[fusion.OnEvent "Activated"] = function()
				public.Input:set(key)
				-- for k, v in pairs(public.Options:get()) do
				-- 	if k ~= key then
				-- 		v:set(false)
				-- 	end
				-- end
				-- if _Input:get() == true then
				-- 	public.Input:set(key)
				-- else
				-- 	public.Input:set("")
				-- end
			end
		end
		button = synthetic.New (var) (newConfig)
		-- end)

		optionMaid:GiveTask(propFrame)
		return optionMaid
	end)
	return inst
end

return constructor