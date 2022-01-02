local runService = game:GetService("RunService")
local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local typographyConstructor = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))

local constructor = {}

function constructor.new(params)
	local maid = maidConstructor.new()
	--public states
	local public = {
		Variant = util.import(params.Variant) or fusion.State("Filled"),

		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Input = util.import(params.Input) or fusion.State(""),
		Context = util.import(params.Context) or fusion.State(""),
		Error = util.import(params.Error) or fusion.State(""),
		Label = util.import(params.Label) or fusion.State("Topic"),
		Prefix = util.import(params.Prefix) or fusion.State(""),
		Suffix = util.import(params.Suffix) or fusion.State(""),

		LeadingIconImage = util.import(params.LeadingIconImage) or fusion.State("rbxassetid://3926305904"),
		LeadingIconRectOffset = util.import(params.LeadingIconRectOffset) or fusion.State(Vector2.new(724, 964)),
		LeadingIconRectSize = util.import(params.LeadingIconRectSize) or fusion.State(Vector2.new(36,36)),

		TrailingIconImage = util.import(params.TrailingIconImage) or fusion.State("rbxassetid://3926307971"),
		TrailingIconRectOffset = util.import(params.TrailingIconRectOffset) or fusion.State(Vector2.new(44, 524)),
		TrailingIconRectSize = util.import(params.TrailingIconRectSize) or fusion.State(Vector2.new(36,36)),

		CharacterLimit = util.import(params.CharacterLimit) or fusion.State(params.CharacterLimit or 20),

		BackgroundColor = util.import(params.BackgroundColor) or fusion.State(params.BackgroundColor or Color3.new(0.8,0.8,0.8)),
		Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1)),
		LineColor = util.import(params.LineColor) or fusion.State(Color3.new(0.2,0.2,0.2)),
		TextColor = util.import(params.TextColor) or fusion.State(Color3.new(0.2,0.2,0.2)),
		ErrorColor = util.import(params.ErrorColor) or fusion.State(Color3.new(1,0,0)),
		LeadingIconColor = util.import(params.LeadingIconColor) or fusion.State(Color3.new(0.2,0.2,0.2)),
		TrailingIconColor = util.import(params.TrailingIconColor) or fusion.State(Color3.new(0.2,0.2,0.2)),

		MinimumTextWidth = util.import(params.MinimumWidth) or fusion.State(30),
		MaximumTextWidth = util.import(params.MinimumWidth) or fusion.State(175),

		CensorText = util.import(params.CensorText) or fusion.State(true),
		FilterNumber = util.import(params.FilterNumber) or fusion.State(false),
		FilterLetter = util.import(params.FilterLetter) or fusion.State(false),
		FilterSpacing = util.import(params.FilterSpacing) or fusion.State(false),
		FilterDuplicateSpacing = util.import(params.FilterDuplicateSpacing) or fusion.State(true),
		FilterSymbols = util.import(params.FilterSymbols) or fusion.State(false),
		FilterMaxLength = util.import(params.FilterMaxLength) or fusion.State(10000),
		ForceUpper = util.import(params.ForceUpper) or fusion.State(false),
		ForceLower = util.import(params.ForceLower) or fusion.State(false),
		ForceFirstUpper = util.import(params.ForceFirstUpper) or fusion.State(false),

		SynthClass = fusion.Computed(function()
			return script.Name
		end)
	}

	--read only properties & foundational variables
	local filter = filterConstructor.new(game.Players.LocalPlayer)
	maid:GiveTask(filter)
	local _FilteredText = fusion.Computed(function()
		filter.Configuration.Number = public.FilterNumber:get()
		filter.Configuration.Letter = public.FilterLetter:get()
		filter.Configuration.Spacing = public.FilterSpacing:get()
		filter.Configuration.DuplicateSpacing = public.FilterDuplicateSpacing:get()
		filter.Configuration.Symbols = public.FilterSymbols:get()
		filter.Configuration.Roblox = public.CensorText:get()
		filter.Configuration.MaxLength = public.FilterMaxLength:get()
		filter.Configuration.ForceUpper = public.ForceUpper:get()
		filter.Configuration.ForceLower = public.ForceLower:get()
		filter.Configuration.ForceFirstUpper = public.ForceFirstUpper:get()
		return filter:Get(public.Input:get())
	end)

	public.Value = fusion.Computed(function()
		return script.Name
	end)

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

	local _BackgroundColor = util.getInteractionColor(_Focused, _Hovered, public.BackgroundColor)
	local _Color = util.getInteractionColor(_Focused, _Hovered, public.Color)
	local _CursorPosition = fusion.State(1)
	local _Cursor = fusion.State(" ")

	maid:GiveTask(runService.RenderStepped:Connect(function()
		if math.round(tick())%2 == 0 then
			_Cursor:set(" ")
		else
			_Cursor:set("|")
		end
	end))

	local inst
	local content

	local _Filled = fusion.Computed(function()
		local focused = _Focused:get()
		local input = public.Input:get()

		if focused == true then return true end
		if string.len(input) > 0 then return true end

		return false
	end)

	content = fusion.New 'TextBox' {
		Name = "Content",
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = UDim2.fromScale(0,0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BorderSizePixel = 0,
		TextTransparency = 1,
		[fusion.OnChange "CursorPosition"] = function()
			_CursorPosition:set(content.CursorPosition)
		end,
		[fusion.OnEvent "Focused"] = function()
			_Focused:set(true)

			content.Text = ""
			public.Input:set("")

		end,
		[fusion.OnEvent "FocusLost"] = function()

			_Focused:set(false)

			local filteredText = _FilteredText:get()
			public.Input:set(filteredText)
		end,
		[fusion.OnChange "Text"] = function()
			public.Input:set(content.Text)
		end,

		[fusion.Children] = {
			fusion.New 'UISizeConstraint' {
				MaxSize = fusion.Computed(function()
					return Vector2.new(public.MaximumTextWidth:get(), math.huge)
				end),
				MinSize = fusion.Computed(function()
					return Vector2.new(public.MinimumTextWidth:get(), 0)
				end),
			},
			fusion.New 'UIListLayout' {
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			},
			fusion.New 'TextLabel' {
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Text = fusion.Computed(function()
					local input = public.Input:get()
					local filled = _Filled:get()
					local focused = _Focused:get()
					local placeholder = public.Label:get()
					local cursLoc = _CursorPosition:get()
					local cursor = _Cursor:get()
					if filled then
						if focused then
							local firstHalf = string.sub(input, 1, cursLoc)
							local secondHalf = string.sub(input, cursLoc+1, string.len(input))
							if cursLoc-1 == string.len(input) then
								input = firstHalf..cursor
							else
								input = firstHalf..cursor..secondHalf
							end
							return input
						else
							return input
						end
					else
						return placeholder
					end
				end),
				TextTransparency = fusion.Computed(function()
					local filled = _Filled:get()
					if filled then
						return 0
					else
						return 0.5
					end
				end),
			}
		},
	}

	local function constructIcon(key, layoutOrder)
		return fusion.New 'ImageButton' {
			Name = key.."Icon",
			Size = fusion.Computed(function()
				local ts = _TextSize:get()
				return UDim2.fromOffset(ts,ts)
			end),
			BackgroundTransparency = 1,
			ImageColor3 = public.TextColor,
			Image = public[key.."IconImage"],
			ImageRectOffset = public[key.."IconRectOffset"],
			ImageRectSize = public[key.."IconRectSize"],
			Visible = fusion.Computed(function()
				return public[key.."IconImage"]:get() ~= ""
			end),
			LayoutOrder = layoutOrder,
		}
	end
	local function constructLabel(key, layoutOrder)
		return fusion.New 'TextLabel' {
			Name = key,
			Size = UDim2.fromOffset(0,0),
			AutomaticSize = Enum.AutomaticSize.X,
			TextTransparency = 0.5,
			Text = public[key],
			Visible = fusion.Computed(function()
				return public[key]:get() ~= ""
			end),
			LayoutOrder = layoutOrder,
		}
	end

	--constructor
	inst = util.set(fusion.New "Frame", public, params, {
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
					if _Focused:get() then
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
			fusion.New 'TextButton' {
				BackgroundColor3 = Color3.new(1,1,1),
				TextColor3 = util.tween(public.TextColor),
				TextSize = _TextSize,
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
					if content:IsFocused() == false then
						content:CaptureFocus()
					else
						content:ReleaseFocus()
					end
				end,
				[fusion.Children] = {
					content,
					constructIcon("Leading", 1),
					constructIcon("Trailing", 5),
					constructLabel("Prefix", 2),
					constructLabel("Suffix", 4),
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