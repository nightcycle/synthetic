local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild('Util'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	local maid = maidConstructor.new()
	local menuMaid = maidConstructor.new()
	maid:GiveTask(menuMaid)
	--public states
	local public = {
		Variant = util.import(params.Variant) or fusion.State("Filled"),

		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Input = util.import(params.Input) or fusion.State(""),
		Context = util.import(params.Context) or fusion.State(""),
		Error = util.import(params.Error) or fusion.State(""),
		Label = util.import(params.Label) or fusion.State(""),

		BackgroundColor = util.import(params.BackgroundColor) or fusion.State(params.BackgroundColor or Color3.new(0.8,0.8,0.8)),
		Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1)),
		LineColor = util.import(params.LineColor) or fusion.State(Color3.new(0.2,0.2,0.2)),
		TextColor = util.import(params.TextColor) or fusion.State(Color3.new(0.2,0.2,0.2)),
		ErrorColor = util.import(params.ErrorColor) or fusion.State(Color3.new(1,0,0)),

		Width = util.import(params.Width) or fusion.State(UDim.new(1, 0)),

		Options = util.import(params.Options) or fusion.State({}),

		Open = util.import(params.Open) or fusion.State(false),
		SynthClass = fusion.Computed(function()
			return script.Name
		end),
	}
	public.Value = fusion.Computed(function()
		return public.Input:get()
	end)

	--influencers
	local _Focused = fusion.State(false)
	local _Hovered = fusion.State(false)

	--properties
	maid:GiveTask(fusion.Compat(_Focused):onChange(function()
		if _Focused:get() == false then
			task.delay(0.6, function()
				menuMaid:DoCleaning()
			end)
		end
	end))
	local _Padding = fusion.Computed(function()
		return public.Typography:get().Padding
	end)
	local _TextSize = fusion.Computed(function()
		return public.Typography:get().TextSize
	end)
	local _LabelTextSize = fusion.Computed(function()
		return _TextSize:get()*0.7
	end)
	local _Font = fusion.Computed(function()
		return public.Typography:get().Font
	end)
	local _BackgroundColor = util.getInteractionColor(fusion.State(false), _Hovered, public.BackgroundColor)
	local _Color = util.getInteractionColor(_Focused, _Hovered, public.Color)
	local _TextColor = util.getInteractionColor(_Focused, _Hovered, public.TextColor)
	local _DetailColor = util.getInteractionColor(_Focused, _Hovered, public.LineColor)
	local _LineColor = fusion.Computed(function()
		if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
			return _BackgroundColor:get()
		elseif enums.Variant[public.Variant:get()] == enums.Variant.Filled then
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
		Size = UDim2.fromScale(0,0),
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
				Size = fusion.Computed(function()
					return UDim2.fromOffset(0, _LabelTextSize:get())
				end),
				AutomaticSize = Enum.AutomaticSize.X,
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
			synthetic.New 'Label' {
				BackgroundColor3 = Color3.new(1,1,1),
				Typography = public.Typography,
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromScale(0,0),
				Image = "rbxassetid://3926307971",
				Color = _TextColor,
				ImageRectOffset = fusion.Computed(function()
					if _Focused:get() then
						return Vector2.new(164, 482)
					else
						return Vector2.new(324, 524)
					end
				end),
				ImageRectSize = Vector2.new(36,36),
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
				LayoutOrder = 2,
				ClipsDescendants = true,
				BackgroundTransparency = util.tween(fusion.Computed(function()
					if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
						return 1
					else
						return 0
					end
				end)),
				[fusion.Children] = {
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
							if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
								return 0
							elseif enums.Variant[public.Variant:get()] == enums.Variant.Filled then
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
					-- fusion.New 'UIListLayout' {
					-- 	FillDirection = Enum.FillDirection.Horizontal,
					-- 	HorizontalAlignment = Enum.HorizontalAlignment.Center,
					-- 	VerticalAlignment = Enum.VerticalAlignment.Center,
					-- 	SortOrder = Enum.SortOrder.LayoutOrder,
					-- 	Padding = fusion.Computed(function()
					-- 		return UDim.new(0,_Padding:get().Offset*0.5)
					-- 	end),
					-- },
					fusion.New 'UICorner' {
						CornerRadius = fusion.Computed(function()
							return UDim.new(0, _Padding:get().Offset*0.5)
						end),
					},
					fusion.New 'UIPadding' {
						PaddingBottom = fusion.Computed(function()
							local padding = _Padding:get()
							if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
								return padding
							else
								return UDim.new(0, padding.Offset + 2)
							end
						end),
						PaddingTop = fusion.Computed(function()
							local padding = _Padding:get()
							if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
								return padding
							else
								return UDim.new(0, padding.Offset - 2)
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

	local textLabel = label:WaitForChild("TextLabel")
	textLabel.LayoutOrder = 1

	local icon = label:WaitForChild("Icon")
	icon.LayoutOrder = 2

	local listLayout = label:WaitForChild("UIListLayout")
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

	label.Size = _LabelSize:get()

	maid:GiveTask(fusion.Compat(_LabelSize):onChange(function()
		label.Size = _LabelSize:get()
	end))

	return inst
end

return constructor