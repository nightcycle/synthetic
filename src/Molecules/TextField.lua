local runService = game:GetService("RunService")
local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local typographyConstructor = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))

local constructor = {}

function constructor.new(params)
	local maid = maidConstructor.new()
	--public states
	local public = {
		Variant = util.import(params.Variant) or f.v("Filled"),

		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Input = util.import(params.Input) or f.v(""),
		Context = util.import(params.Context) or f.v(""),
		Error = util.import(params.Error) or f.v(""),
		Label = util.import(params.Label) or f.v(""),
		Prefix = util.import(params.Prefix) or f.v(""),
		Suffix = util.import(params.Suffix) or f.v(""),

		LeadingIconImage = util.import(params.LeadingIconImage) or f.v(""),
		LeadingIconRectOffset = util.import(params.LeadingIconRectOffset) or f.v(Vector2.new(724, 964)),
		LeadingIconRectSize = util.import(params.LeadingIconRectSize) or f.v(Vector2.new(36,36)),

		TrailingIconImage = util.import(params.TrailingIconImage) or f.v(""),
		TrailingIconRectOffset = util.import(params.TrailingIconRectOffset) or f.v(Vector2.new(44, 524)),
		TrailingIconRectSize = util.import(params.TrailingIconRectSize) or f.v(Vector2.new(36,36)),

		CharacterLimit = util.import(params.CharacterLimit) or f.v(params.CharacterLimit or 20),

		BackgroundColor = util.import(params.BackgroundColor) or f.v(params.BackgroundColor or Color3.new(0.8,0.8,0.8)),
		Color = util.import(params.Color) or f.v(Color3.new(0.5,0,1)),
		LineColor = util.import(params.LineColor) or f.v(Color3.new(0.2,0.2,0.2)),
		TextColor = util.import(params.TextColor) or f.v(Color3.new(0.2,0.2,0.2)),
		ErrorColor = util.import(params.ErrorColor) or f.v(Color3.new(1,0,0)),
		LeadingIconColor = util.import(params.LeadingIconColor) or f.v(Color3.new(0.2,0.2,0.2)),
		TrailingIconColor = util.import(params.TrailingIconColor) or f.v(Color3.new(0.2,0.2,0.2)),

		MinimumTextWidth = util.import(params.MinimumWidth) or f.v(30),
		MaximumTextWidth = util.import(params.MinimumWidth) or f.v(175),

		CensorText = util.import(params.CensorText) or f.v(true),
		FilterNumber = util.import(params.FilterNumber) or f.v(false),
		FilterLetter = util.import(params.FilterLetter) or f.v(false),
		FilterSpacing = util.import(params.FilterSpacing) or f.v(false),
		FilterDuplicateSpacing = util.import(params.FilterDuplicateSpacing) or f.v(true),
		FilterSymbols = util.import(params.FilterSymbols) or f.v(false),
		FilterMaxLength = util.import(params.FilterMaxLength) or f.v(10000),
		ForceUpper = util.import(params.ForceUpper) or f.v(false),
		ForceLower = util.import(params.ForceLower) or f.v(false),
		ForceFirstUpper = util.import(params.ForceFirstUpper) or f.v(false),

		Enabled = util.import(params.Enabled) or f.v(true),

		SynthClassName = f.get(function()
			return script.Name
		end)
	}

	--read only properties & foundational variables
	local filter = filterConstructor.new(game.Players.LocalPlayer)
	maid:GiveTask(filter)
	local _FilteredText = f.get(function()
		local input = public.Input:get()

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
		return filter:Get(input)
	end)

	public.Value = f.get(function()
		return script.Name
	end)

	--influencers
	local _Focused = f.v(false)
	local _Hovered = f.v(false)

	--properties
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)
	local _LabelTextSize = f.get(function()
		return _TextSize:get()*0.7
	end)

	local _BackgroundColor = util.getInteractionColor(_Focused, _Hovered, public.BackgroundColor)
	local _Color = util.getInteractionColor(_Focused, _Hovered, public.Color)
	local _CursorPosition = f.v(1)
	local _Cursor = f.v(" ")

	maid:GiveTask(runService.RenderStepped:Connect(function()
		if not public.Enabled:get() or math.round(tick())%2 == 0 then
			_Cursor:set(" ")
		else
			_Cursor:set("|")
		end
	end))

	local inst
	local content

	local _Filled = f.get(function()
		local focused = _Focused:get()
		local input = public.Input:get()

		if focused == true then return true end
		if string.len(input) > 0 then return true end

		return false
	end)
	content = f.new 'TextBox' {
		Name = "Content",
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Size = UDim2.fromScale(0,0),
		AutomaticSize = Enum.AutomaticSize.XY,
		TextEditable = public.Enabled,
		Active = public.Enabled,
		Selectable = false,
		BorderSizePixel = 0,
		Font = _Font,
		TextTransparency = 1,
		[f.dt "CursorPosition"] = function()
			_CursorPosition:set(content.CursorPosition)
		end,
		[f.e "Focused"] = function()
			if not public.Enabled:get() then content:ReleaseFocus() return end
			_Focused:set(true)

			content.Text = ""
			public.Input:set("")

		end,
		[f.e "FocusLost"] = function()
			if not public.Enabled:get() then return end
			_Focused:set(false)

			local filteredText = _FilteredText:get()
			public.Input:set(filteredText)
		end,
		[f.dt "Text"] = function()
			public.Input:set(content.Text)
		end,

		[f.c] = {
			f.new 'UISizeConstraint' {
				MaxSize = f.get(function()
					return Vector2.new(public.MaximumTextWidth:get(), math.huge)
				end),
				MinSize = f.get(function()
					return Vector2.new(public.MinimumTextWidth:get(), 0)
				end),
			},
			f.new 'UIListLayout' {
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			},
			f.new 'TextLabel' {
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				Font = _Font,
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Text = f.get(function()
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
				TextTransparency = f.get(function()
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
		return f.new 'ImageButton' {
			Name = key.."Icon",
			Size = f.get(function()
				local ts = _TextSize:get()
				return UDim2.fromOffset(ts,ts)
			end),
			BackgroundTransparency = 1,
			ImageColor3 = public[key.."IconColor"],
			Image = public[key.."IconImage"],
			ImageRectOffset = public[key.."IconRectOffset"],
			ImageRectSize = public[key.."IconRectSize"],
			Visible = f.get(function()
				return public[key.."IconImage"]:get() ~= ""
			end),
			LayoutOrder = layoutOrder,
		}
	end
	local function constructLabel(key, layoutOrder)
		return f.new 'TextLabel' {
			Name = key,
			Size = UDim2.fromOffset(0,0),
			AutomaticSize = Enum.AutomaticSize.X,
			TextTransparency = 0.5,
			Text = public[key],
			Visible = f.get(function()
				return public[key]:get() ~= ""
			end),
			LayoutOrder = layoutOrder,
		}
	end

	--constructor
	inst = util.set(f.new "Frame", public, params, {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(0,0),
		[f.c] = {
			f.new 'UIListLayout' {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = f.get(function()
					return UDim.new(0,_Padding:get().Offset*0.25)
				end),
			},
			f.new 'TextLabel' {
				Name = "UpperLabel",
				Text = public.Label,
				Font = _Font,
				TextSize = f.get(function()
					return _LabelTextSize:get()
				end),
				Size = f.get(function()
					return UDim2.fromOffset(0, _LabelTextSize:get())
				end),
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				TextColor3 = util.tween(f.get(function()

					local focusedColor = public.Color:get()
					local textColor = public.TextColor:get()
					local focused = _Focused:get()

					if focused then
						return focusedColor
					else
						return textColor
					end
				end)),
				TextTransparency = util.tween(f.get(function()
					if _Filled:get() then
						return 0
					else
						return 1
					end
				end)),
				LayoutOrder = 1,
				BackgroundTransparency = 1,
			},
			f.new 'TextButton' {
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
				BackgroundTransparency = util.tween(f.get(function()
					if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
						return 1
					else
						return 0
					end
				end)),
				[f.e "InputBegan"] = function()
					_Hovered:set(true)
				end,
				[f.e "InputEnded"] = function()
					_Hovered:set(false)
				end,
				[f.e "Activated"] = function()
					local enabled = public.Enabled:get()
					if not enabled then return end
					print("E: ", enabled)
					if content:IsFocused() == false then
						content:CaptureFocus()
					else
						content:ReleaseFocus()
					end
				end,
				[f.c] = {
					content,
					constructIcon("Leading", 1),
					constructIcon("Trailing", 5),
					constructLabel("Prefix", 2),
					constructLabel("Suffix", 4),
					f.new 'UIStroke' {
						Color = util.tween(f.get(function()
							local lineColor = public.LineColor:get()
							local color = public.Color:get()
							if _Focused:get() then
								return color
							else
								return lineColor
							end
						end)),
						Transparency = util.tween(f.get(function()
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
					f.new 'UIGradient' {
						Rotation = 90,
						Color = f.get(function()
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
					f.new 'UIListLayout' {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = f.get(function()
							return UDim.new(0,_Padding:get().Offset*0.5)
						end),
					},
					f.new 'UICorner' {
						CornerRadius = util.cornerRadius,
					},
					f.new 'UIPadding' {
						PaddingBottom = f.get(function()
							local padding = _Padding:get()
							if enums.Variant[public.Variant:get()] == enums.Variant.Outlined then
								return padding
							else
								return UDim.new(0, padding.Offset + 2)
							end
						end),
						PaddingTop = f.get(function()
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
			f.new 'TextLabel' {
				Name = "ContextLabel",
				Text = f.get(function()
					local errorTxt = public.Error:get()
					local contextTxt = public.Context:get()
					if errorTxt ~= "" then
						return errorTxt
					else
						return contextTxt
					end
				end),
				TextSize = f.get(function()
					return _LabelTextSize:get()
				end),
				Size = f.get(function()
					return UDim2.fromOffset(0, _LabelTextSize:get())
				end),
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Font = _Font,
				TextColor3 = util.tween(f.get(function()
					local errorColor = public.ErrorColor:get()
					local textColor = public.TextColor:get()
					if public.Error:get() == "" then
						return textColor
					else
						return errorColor
					end
				end)),
				TextTransparency = util.tween(f.get(function()
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