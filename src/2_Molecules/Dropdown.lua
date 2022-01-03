local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild('Util'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))

local constructor = {}

function constructor.new(params)
	local maid = maidConstructor.new()

	--public states
	local public = {
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

		Open = util.import(params.Open) or fusion.State(false),
		SynthClass = fusion.Computed(function()
			return script.Name
		end),
	}

	--influencers
	local _Focused = fusion.State(false)
	local _Hovered = fusion.State(false)

	--properties
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

	--construct
	local inst
	inst = util.set(synthetic.New "Frame", public, params, {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(0,0),
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
					if _Filled:get() then
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
				TextColor3 = util.tween(public.TextColor),
				TextSize = _TextSize,
				Font = _Font,
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromScale(0,0),
				TextTransparency = 1,
				LayoutOrder = 2,
				TextXAlignment = Enum.TextXAlignment.Left,
				ClipsDescendants = true,
				BackgroundTransparency = util.tween(fusion.Computed(function()
					if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
						return 1
					else
						return 0
					end
				end)),
				[fusion.OnEvent "InputBegan"] = function()
					_Hovered:set(true)
				end,
				[fusion.OnEvent "InputEnded"] = function()
					_Hovered:set(false)
				end,
				[fusion.OnEvent "Activated"] = function()

				end,
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
					fusion.New 'UIListLayout' {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = fusion.Computed(function()
							return UDim.new(0,_Padding:get().Offset*0.5)
						end),
					},
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

	return inst
end

return constructor