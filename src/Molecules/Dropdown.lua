local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	local maid = maidConstructor.new()
	local menuMaid = maidConstructor.new()
	maid:GiveTask(menuMaid)

	--[=[
		@class Dropdown
		@tag Component
		@tag Molecule
		A basic [dropdown menu](https://material.io/components/menus#dropdown-menu)
	]=]

	--public states
	local public = {}
	--[=[
		@prop ButtonVariant ButtonVariant | FusionState | nil
		The style of construction as detailed [here](https://material.io/components/buttons#anatomy), excluding "Toggle button"
		@within Dropdown
	]=]
	public.ButtonVariant = util.import(params.ButtonVariant) or fusion.State("Filled")

	--[=[
		@prop Typography Typography | FusionState | nil
		The Typography to be used for this component
		@within Dropdown
	]=]
	public.Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)

	--[=[
		@prop Input string | FusionState | nil
		The value currently filling text field
		@within Dropdown
	]=]
	public.Input = util.import(params.Input) or fusion.State("")

	--[=[
		@prop Context string | FusionState | nil
		The text that goes below field and can provide extra info
		@within Dropdown
	]=]
	public.Context = util.import(params.Context) or fusion.State("")

	--[=[
		@prop Error string | FusionState | nil
		The text for any error message below the field
		@within Dropdown
	]=]
	public.Error = util.import(params.Error) or fusion.State("")

	--[=[
		@prop Label string | FusionState | nil
		The text that fills the blank text field as well as the section above the field when filled
		@within Dropdown
	]=]
	public.Label = util.import(params.Label) or fusion.State("")

	--[=[
		@prop BackgroundColor Color3 | FusionState | nil
		Color used for background of menu
		@within Dropdown
	]=]
	public.BackgroundColor = util.import(params.BackgroundColor) or fusion.State(params.BackgroundColor or Color3.new(0.8,0.8,0.8))

	--[=[
		@prop Color Color3 | FusionState | nil
		Color used to add texture to component
		@within Dropdown
	]=]
	public.Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1))

	--[=[
		@prop LineColor Color3 | FusionState | nil
		Color used for lines
		@within Dropdown
	]=]
	public.LineColor = util.import(params.LineColor) or fusion.State(Color3.new(0.2,0.2,0.2))

	--[=[
		@prop TextColor Color3 | FusionState | nil
		Color used for text
		@within Dropdown
	]=]
	public.TextColor = util.import(params.TextColor) or fusion.State(Color3.new(0.2,0.2,0.2))

	--[=[
		@prop ErrorColor Color3 | FusionState | nil
		Color used for error text
		@within Dropdown
	]=]
	public.ErrorColor = util.import(params.ErrorColor) or fusion.State(Color3.new(1,0,0))

	--[=[
		@prop Width UDim | FusionState | nil
		Width of the entire component, as Height is solved using Typography
		@within Dropdown
	]=]
	public.Width = util.import(params.Width) or fusion.State(UDim.new(1, 0))

	--[=[
		@prop Options {string} | FusionState | nil
		A list of options that can be selected from
		@within Dropdown
	]=]
	public.Options = util.import(params.Options) or fusion.State({})

	--[=[
		@prop Open bool | FusionState | nil
		Whether the menu is currently open
		@within Dropdown
	]=]
	public.Open = util.import(params.Open) or fusion.State(false)

	--[=[
		@prop Value bool
		Attribute used to communicate current value
		@within Dropdown
		@readonly
	]=]
	public.Value = fusion.Computed(function()
		return public.Input:get()
	end)

	--[=[
		@prop SynthClassName string
		Attribute used to identify what type of component it is
		@within Dropdown
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)

	--influencers
	local _Focused = fusion.State(false)
	local _Hovered = fusion.State(false)

	--properties
	maid:GiveTask(fusion.Observer(_Focused):onChange(function()
		if _Focused:get() == false then
			task.delay(0.6, function()
				menuMaid:DoCleaning()
			end)
		end
	end))
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)
	local _LabelTextSize = fusion.Computed(function()
		return _TextSize:get()*0.7
	end)
	local _BackgroundColor = util.getInteractionColor(fusion.State(false), _Hovered, public.BackgroundColor)
	local _Color = util.getInteractionColor(_Focused, _Hovered, public.Color)
	local _TextColor = util.getInteractionColor(_Focused, _Hovered, public.TextColor)
	local _DetailColor = util.getInteractionColor(_Focused, _Hovered, public.LineColor)
	local _LineColor = fusion.Computed(function()
		if enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Outlined then
			return _BackgroundColor:get()
		elseif enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Filled then
			return _DetailColor:get()
		else
			return _DetailColor:get()
		end
	end)

	local _LabelSize = fusion.Computed(function()
		return UDim2.new(public.Width:get(), UDim.new(0,0))
	end)

	--construct
	local _AbsoluteSize = fusion.State(Vector2.new(0,0))
	local _AbsolutePosition = fusion.State(Vector2.new(0,0))
	local inst
	inst = util.set(fusion.New "TextButton", public, params, {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		TextTransparency = 1,
		[fusion.OnEvent "InputBegan"] = function()
			_Hovered:set(true)
		end,
		[fusion.OnEvent "InputEnded"] = function()
			_Hovered:set(false)
		end,
		[fusion.OnEvent "Activated"] = function()
			_Focused:set(not _Focused:get())
			effects.sound("ui_tap-variant-01")
			local menu = effects.menu(maid, {
				Typography = public.Typography,
				BackgroundColor = public.BackgroundColor,
				TextColor = public.TextColor,
				Width = public.Width,
				Input = public.Value,
				Options = public.Options,
			}, _AbsoluteSize, _AbsolutePosition)
			menuMaid:GiveTask(menu)
			menuMaid:GiveTask(menu:WaitForChild("OnSelect").Event:Connect(function(val)
				if val ~= nil then
					public.Input:set(val)
				end
				_Focused:set(false)
				task.delay(0.6, function()
					menuMaid:DoCleaning()
				end)

			end))
		end,
		[fusion.Children] = {
			fusion.New 'UIListLayout' {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = fusion.Computed(function()
					return UDim.new(0,_Padding:get().Offset*0.25)
				end),
			},
			fusion.New 'TextLabel' {
				Name = "UpperLabel",
				Text = public.Label,
				Font = _Font,
				TextSize = fusion.Computed(function()
					return _LabelTextSize:get()
				end),
				AutomaticSize = Enum.AutomaticSize.XY,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				TextColor3 = util.tween(fusion.Computed(function()

					local focusedColor = public.Color:get()
					local textColor = public.TextColor:get()
					local focused = _Focused:get()

					if focused then
						return focusedColor
					else
						return textColor
					end
				end)),
				TextTransparency = util.tween(fusion.Computed(function()
					local label = public.Label:get()
					local isFocused = _Focused:get()
					local input = public.Input:get()
					if input ~= "" or isFocused == true then
						return 0
					else
						return 1
					end
				end)),
				LayoutOrder = 1,
				BackgroundTransparency = 1,
			},
			synthetic.New 'Frame' {
				Name = "Label",
				BackgroundColor3 = Color3.new(1,1,1),
				Size = fusion.Computed(function()
					local padding = _Padding:get().Offset
					local height = UDim.new(0, _LabelTextSize:get()+padding*3)
					local width = public.Width:get()
					local size = UDim2.new(width, height)
					return size
				end),
				LayoutOrder = 2,
				ClipsDescendants = true,
				BackgroundTransparency = util.tween(fusion.Computed(function()
					if enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Outlined then
						return 1
					else
						return 0
					end
				end)),
				[fusion.Children] = {
					fusion.New "ImageLabel" {
						ImageRectOffset = fusion.Computed(function()
							if _Focused:get() then
								return Vector2.new(164, 482)
							else
								return Vector2.new(324, 524)
							end
						end),
						Size = UDim2.fromOffset(20,20),
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.fromScale(1, 0.5),
						ImageRectSize = Vector2.new(36,36),
						Image = "rbxassetid://3926307971",
						ImageColor3 = _TextColor,
					},
					fusion.New "TextLabel" {
						TextSize = _TextSize,
						Font = _Font,
						TextColor3 = _TextColor,
						AutomaticSize = Enum.AutomaticSize.X,
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Text = fusion.Computed(function()
							local label = public.Label:get()
							local isFocused = _Focused:get()
							local input = public.Input:get()
							if input == "" and isFocused == false then
								return label
							else
								return input
							end
						end),
					},
					fusion.New 'UIStroke' {
						Color = util.tween(fusion.Computed(function()
							local lineColor = public.LineColor:get()
							local color = public.Color:get()
							if _Focused:get() then
								return color
							else
								return lineColor
							end
						end)),
						Transparency = util.tween(fusion.Computed(function()
							if enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Outlined then
								return 0
							elseif enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Filled then
								return 1
							else
								return 0
							end
						end)),
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Thickness = 2,
					},
					fusion.New 'UIGradient' {
						Rotation = 90,
						Color = fusion.Computed(function()
							local c1 = _BackgroundColor:get()
							local color = _Color:get()
							local lineColor = public.LineColor:get()
							local c2 = lineColor
							if _Focused:get() then
								c2 = color
							end
							local lineAlpha = 1/_TextSize:get()
							return ColorSequence.new({
								ColorSequenceKeypoint.new(0, c1),
								ColorSequenceKeypoint.new(1-lineAlpha, c1),
								ColorSequenceKeypoint.new(1-lineAlpha+0.01, c2),
								ColorSequenceKeypoint.new(1, c2),
							})
						end)
					},
					fusion.New 'UICorner' {
						CornerRadius = util.cornerRadius,
					},
					fusion.New 'UIPadding' {
						PaddingBottom = fusion.Computed(function()
							local padding = _Padding:get()
							if enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Outlined then
								return padding
							else
								return UDim.new(0, padding.Offset + 2)
							end
						end),
						PaddingTop = fusion.Computed(function()
							local padding = _Padding:get()
							if enums.ButtonVariant[public.ButtonVariant:get()] == enums.ButtonVariant.Outlined then
								return padding
							else
								return UDim.new(0, padding.Offset + 2)
							end
						end),
						PaddingLeft = _Padding,
						PaddingRight = _Padding,
					},
				},
			},
			fusion.New 'TextLabel' {
				Name = "ContextLabel",
				Text = fusion.Computed(function()
					local errorTxt = public.Error:get()
					local contextTxt = public.Context:get()
					if errorTxt ~= "" then
						return errorTxt
					else
						return contextTxt
					end
				end),
				TextSize = fusion.Computed(function()
					return _LabelTextSize:get()
				end),
				Size = fusion.Computed(function()
					return UDim2.fromOffset(0, _LabelTextSize:get())
				end),
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Font = _Font,
				TextColor3 = util.tween(fusion.Computed(function()
					local errorColor = public.ErrorColor:get()
					local textColor = public.TextColor:get()
					if public.Error:get() == "" then
						return textColor
					else
						return errorColor
					end
				end)),
				TextTransparency = util.tween(fusion.Computed(function()
					local errorTxt = public.Error:get()
					local contextTxt = public.Context:get()

					if errorTxt ~= "" or contextTxt ~= "" then
						return 0
					else
						return 1
					end
				end)),
				LayoutOrder = 3,
				BackgroundTransparency = 1,
			},
		},
	}, maid)
	local label = inst:WaitForChild("Label")
	_AbsoluteSize:set(label.AbsoluteSize)
	maid:GiveTask(label:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		_AbsoluteSize:set(label.AbsoluteSize)
	end))
	_AbsolutePosition:set(label.AbsolutePosition)
	maid:GiveTask(label:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
		_AbsolutePosition:set(label.AbsolutePosition+Vector2.new(0,1))
	end))

	-- maid:GiveTask(fusion.Observer(_LabelSize):onChange(function()
	-- 	label.Size = _LabelSize:get()
	-- end))

	return inst
end

return constructor