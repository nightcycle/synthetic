--!strict
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)

local RunService = game:GetService("RunService")

local Util = require(Package:WaitForChild("Util"))
local Types = require(Package:WaitForChild("Types"))

local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>
type CanBeState<T> = ColdFusion.CanBeState<T>

local Maid = require(Packages:WaitForChild("Maid"))
type Maid = Maid.Maid

local Signal = require(Packages:WaitForChild("Signal"))

local IconLabel = require(Package:WaitForChild("IconLabel"))

export type TextFieldParameters = Types.TextBoxParameters & {
	Value: ValueState<string>,
	LowerText: CanBeState<string>?,
	LowerTextColor3: CanBeState<Color3>?,
	Width: CanBeState<UDim>?,
	CornerRadius: CanBeState<number>?,
	CharacterLimit: CanBeState<number>?,
	MaintainLowerSpacing: CanBeState<boolean>?,
	FocusedBackgroundColor3: CanBeState<Color3>?,
	HoverBackgroundColor3: CanBeState<Color3>?,
	IconScale: CanBeState<number>?,
	LeftIcon: CanBeState<string>?,
	RightIcon: CanBeState<string>?,
}

export type TextField = Frame

function Constructor(config: TextFieldParameters): TextField
	-- init workspace
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	-- unload config states
	local Name = _import(config.Name, script.Name)
	local Value = config.Value
	local TextSize = _import(config.TextSize, 14)
	local Parent = _import(config.Parent, nil)
	local LowerText: State<string> = _import(config.LowerText, "")
	local LowerTextColor3: State<Color3> = _import(config.LowerTextColor3, Color3.new(1, 0, 0))
	local Width = _import(config.Width, UDim.new(0, 250))
	local CornerRadius = _import(config.CornerRadius, UDim.new(0, 3))
	local CharacterLimit: State<number?> = _import(config.CharacterLimit, nil :: number?)
	local BackgroundTransparency = _import(config.BackgroundTransparency, 0)
	local ClearTextOnFocus = _import(config.ClearTextOnFocus, false)
	local TextColor3 = _import(config.TextColor3, Color3.new(1, 1, 1))
	local TextTransparency = _import(config.TextTransparency, 0)
	local Text = _import(config.Text, "Text")
	local FontFace = _import(config.Font, Font.fromEnum(Enum.Font.Gotham))
	local MaintainLowerSpacing = _import(config.MaintainLowerSpacing, false)
	local BackgroundColor3 = _import(config.BackgroundColor3, Color3.fromHSV(0, 0, 0.2))
	local FocusedBackgroundColor3 = _import(config.FocusedBackgroundColor3, Color3.fromHSV(0, 0, 0.4))
	local HoverBackgroundColor3: State<Color3> = _import(
		config.HoverBackgroundColor3,
		_Computed(function(sCol: Color3, bCol: Color3): Color3
			local h1, s1, v1 = sCol:ToHSV()
			local _, s2, v2 = bCol:ToHSV()
			return Color3.fromHSV(h1, s1 + (s2 - s1) * 0.5, v1 + (v2 - v1) * 0.5)
		end, FocusedBackgroundColor3, BackgroundColor3)
	)
	local BorderSizePixel = _import(config.BorderSizePixel, 2)
	local BorderColor3 = _import(config.BorderColor3, Color3.fromHSV(0.6, 1, 1))
	local IconScale = _import(config.IconScale, 1.25)
	local LeftIcon: State<string?> = _import(config.LeftIcon, nil :: string?)
	local RightIcon: State<string?> = _import(config.RightIcon, nil :: string?)

	-- construct signals
	local OnInputChanged = Signal.new()
	maid:GiveTask(OnInputChanged)
	local OnInputComplete = Signal.new()
	maid:GiveTask(OnInputComplete)

	-- init internal states
	local TextBoxValue: ValueState<string> = _Value(Value:Get())
	local IsFocused: ValueState<boolean> = _Value(false)
	local CursorPosition = _Value(0)
	local TextBox = _Value(nil :: TextBox?)
	local IsHovering: ValueState<boolean> = _Value(false)
	local IconSize = _Computed(function(textSize: number, scale: number)
		return math.round(textSize * scale)
	end, TextSize, IconScale)
	local LeftOffset = _Computed(function(leftIcon: string?, iconSize: number, textSize: number)
		if leftIcon then
			return iconSize + textSize
		else
			return 0
		end
	end, LeftIcon, IconSize, TextSize)
	local RightOffset = _Computed(function(rightIcon: string?, iconSize: number, textSize: number)
		if rightIcon then
			return iconSize + textSize
		else
			return 0
		end
	end, RightIcon, IconSize, TextSize)
	local CenterOffset = _Computed(function(leftOff: number, rightOff: number)
		return leftOff - rightOff
	end, LeftOffset, RightOffset)
	local IsEmpty = _Computed(function(input, focused)
		return input == "" and not focused
	end, Value, IsFocused)
	local LowerTextSize = _Computed(function(textSize: number, isEmpty)
		return textSize * 0.75
	end, TextSize, IsEmpty)
	local LowerTextFrameHeight = _Computed(function(txtSize: number)
		return UDim.new(0, txtSize)
	end, LowerTextSize)
	local CharacterCount = _Computed(function(input: string)
		if not input then
			return 0
		end
		assert(input ~= nil)
		return string.len(input)
	end, Value)

	-- bind states
	maid:GiveTask(Value:Connect(function(cur)
		OnInputChanged:Fire(cur)
	end))
	maid:GiveTask(IsFocused:Connect(function(v)
		if v == false then
			OnInputComplete:Fire(Value:Get())
		end
	end))

	-- constructing instances
	local textBox = _new("TextBox")({
		BackgroundTransparency = 1,
		Text = Value,
		ClearTextOnFocus = ClearTextOnFocus,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = _Computed(function(txtSize, cOff)
			return UDim2.new(UDim.new(0.5, 0.5 * cOff), UDim.new(1, -txtSize * 0.5))
		end, TextSize, CenterOffset),
		TextColor3 = TextColor3,
		TextSize = TextSize,
		FontFace = FontFace,
		MultiLine = false,
		PlaceholderText = "",
		RichText = false,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTransparency = TextTransparency,
		Size = _Computed(function(textSize, lOff, rOff)
			return UDim2.new(UDim.new(1, -textSize * 1.25 - lOff - rOff), UDim.new(0, textSize))
		end, TextSize, LeftOffset, RightOffset),
		Events = {
			Focused = function()
				local txtBox = TextBox:Get()
				if not txtBox then
					return
				end
				assert(txtBox ~= nil)
				IsFocused:Set(txtBox:IsFocused())
			end,
			FocusLost = function()
				local txtBox = TextBox:Get()
				if not txtBox then
					return
				end
				assert(txtBox ~= nil)
				Value:Set(TextBoxValue:Get())
				IsFocused:Set(txtBox:IsFocused())
			end,
		},

	} :: { [any]: any }) :: TextBox
	TextBox:Set(textBox)
	maid:GiveTask(RunService.RenderStepped:Connect(function()
		TextBoxValue:Set(textBox.Text)
		CursorPosition:Set(textBox.CursorPosition)
	end))

	local Label = _new("TextLabel")({
		Name = "Label",
		BackgroundTransparency = 1,
		Text = Text,
		FontFace = FontFace,
		TextTransparency = TextTransparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextSize = _Computed(function(textSize: number, isEmpty)
			if isEmpty then
				return textSize * 1
			else
				return textSize * 0.75
			end
		end, TextSize, IsEmpty):Tween(),
		TextColor3 = _Computed(function(col, textCol, isEmpty)
			if not isEmpty then
				return col
			else
				return textCol
			end
		end, BorderColor3, TextColor3, IsEmpty):Tween(),
		Size = _Computed(function(textSize, leftOffset, rightOffset)
			return UDim2.new(UDim.new(1, -textSize * 2 - leftOffset - rightOffset), UDim.new(0, textSize * 0.75))
		end, TextSize, LeftOffset, RightOffset):Tween(),
		Position = _Computed(function(isEmpty, textSize: number, lOff: number, rOff: number, cOff: number)
			if not isEmpty then
				return UDim2.new(UDim.new(0, textSize * 0.75 + lOff), UDim.new(0, textSize * 0.5))
			else
				return UDim2.new(UDim.new(0.5, (lOff - rOff) * 0.5), UDim.new(0.5, 0))
			end
		end, IsEmpty, TextSize, LeftOffset, RightOffset, CenterOffset):Tween(),
		AnchorPoint = _Computed(function(isEmpty): Vector2
			if not isEmpty then
				return Vector2.new(0, 0)
			else
				return Vector2.new(0.5, 0.5)
			end
		end, IsEmpty):Tween(),
	})

	local Frame = _new("Frame")({
		Name = "Container",
		BackgroundTransparency = BackgroundTransparency,
		BackgroundColor3 = _Computed(
			function(isFocused: boolean, isHovering: boolean, backColor: Color3, focusColor: Color3, hoverColor: Color3): Color3
				if isFocused then
					return focusColor
				elseif isHovering then
					return hoverColor
				else
					return backColor
				end
			end,
			IsFocused,
			IsHovering,
			BackgroundColor3,
			FocusedBackgroundColor3,
			HoverBackgroundColor3
		),
		Size = _Computed(function(textSize: number, width)
			return UDim2.new(width, UDim.new(0, textSize * 3))
		end, TextSize, Width),
		Children = {
			_new("Frame")({
				AnchorPoint = Vector2.new(0.5, 1),
				Size = _Computed(function(pix: number, focused)
					if focused then
						return UDim2.new(UDim.new(1, 0), UDim.new(0, pix))
					else
						return UDim2.new(UDim.new(1, 0), UDim.new(0, pix * 0.5))
					end
				end, BorderSizePixel, IsFocused):Tween(),
				Position = UDim2.fromScale(0.5, 1),
				BackgroundTransparency = _Computed(function(trans)
					if trans == 0 then
						return 0
					else
						return 1
					end
				end, BackgroundTransparency):Tween(),
				BackgroundColor3 = _Computed(function(isFocused: boolean, borderCol: Color3, textCol: Color3)
					if isFocused then
						return borderCol
					else
						return textCol
					end
				end, IsFocused, BorderColor3, TextColor3):Tween(),
			}),
			_new("UIStroke")({
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = BorderSizePixel,
				Color = _Computed(function(bCol: Color3, tCol: Color3, isFoc: boolean)
					if isFoc then
						return bCol
					else
						return tCol
					end
				end, BorderColor3, TextColor3, IsFocused):Tween(),
				Transparency = _Computed(function(trans: number)
					if trans == 0 then
						return 1
					else
						return 0
					end
				end, BackgroundTransparency):Tween(),
			}),
			_new("UICorner")({
				CornerRadius = CornerRadius,
			}),
			_new("TextButton")({
				Text = "",
				TextTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				ZIndex = 10,
				BackgroundTransparency = 1,
				Events = {
					Activated = function()
						local txtBox = TextBox:Get()
						if not txtBox then
							return
						end
						assert(txtBox ~= nil)
						if txtBox:IsFocused() then
							txtBox:ReleaseFocus()
						else
							txtBox:CaptureFocus()
						end
					end,
					InputChanged = function()
						IsHovering:Set(true)
					end,
					MouseLeave = function()
						IsHovering:Set(false)
					end,
				},
			}),
			IconLabel(maid)({
				Name = "Right",
				IconTransparency = 0,
				IconColor3 = TextColor3,
				Icon = RightIcon :: any,
				Position = _Computed(function(txtSize): UDim2
					return UDim2.new(UDim.new(1, -txtSize), UDim.new(0.5, 0))
				end, TextSize),
				Size = _Computed(function(iconSize): UDim2
					return UDim2.fromOffset(iconSize, iconSize)
				end, IconSize),
				AnchorPoint = Vector2.new(1, 0.5),
			}) :: any,
			IconLabel(maid)({
				Name = "Left",
				Position = _Computed(function(txtSize: number)
					return UDim2.new(UDim.new(0, txtSize), UDim.new(0.5, 0))
				end, TextSize),
				Size = _Computed(function(iconSize)
					return UDim2.fromOffset(iconSize, iconSize)
				end, IconSize),
				AnchorPoint = Vector2.new(0, 0.5),
				IconTransparency = 0,
				IconColor3 = TextColor3,
				Icon = LeftIcon :: any,
			}),
			TextBox,
			Label,
		} :: { any },
	})

	local CharLimitLabel = _new("TextLabel")({
		Name = "CharLimit",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Text = _Computed(function(lim: number?, count: number)
			if lim and count then
				return count .. " / " .. lim
			else
				return ""
			end
		end, CharacterLimit, CharacterCount),
		FontFace = FontFace,
		TextTransparency = TextTransparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextSize = LowerTextSize,
		TextColor3 = _Computed(function(col: Color3, textCol: Color3, isEmpty: boolean)
			if not isEmpty then
				return col
			else
				return textCol
			end
		end, BorderColor3, TextColor3, IsEmpty),
	})

	local LowerTextLabel = _new("TextLabel")({
		Name = "TextLabel",
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Text = LowerText,
		FontFace = FontFace,
		TextTransparency = TextTransparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextSize = LowerTextSize,
		TextColor3 = LowerTextColor3,
	})

	local LowerTextFrame = _new("Frame")({
		Name = "LowerTextFrame",
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = 2,
		Size = _Computed(function(width, height)
			return UDim2.new(width, height)
		end, Width, LowerTextFrameHeight),
		Visible = _Computed(function(charLim, lowerText, lowerSpacing)
			local isFilled = not (charLim == nil and (lowerText == nil or lowerText == ""))
			return lowerSpacing == true or isFilled
		end, CharacterLimit, LowerText, MaintainLowerSpacing),
		Children = {
			CharLimitLabel,
			LowerTextLabel,
		} :: { Instance },
	})

	-- assemble final parameters
	local parameters: any = {
		Name = Name,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = _Computed(function(width)
			return UDim2.new(width, UDim.new(0, 0))
		end, Width),
		Parent = Parent,
		Children = {
			_new("UIListLayout")({
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = _Computed(function(txtSize: number)
					return UDim.new(0, txtSize * 0.25)
				end, TextSize),
			}),
			Frame,
			LowerTextFrame,
		} :: { Instance },
	}

	config.LowerText = nil
	config.LowerTextColor3 = nil
	config.TextColor3 = nil
	config.TextTransparency = nil
	config.TextStrokeColor3 = nil
	config.TextScaled = nil
	config.FontFace = nil
	config.Text = nil
	config.TextSize = nil
	config.Width = nil
	config.CornerRadius = nil
	config.CharacterLimit = nil
	config.MaintainLowerSpacing = nil
	config.FocusedBackgroundColor3 = nil
	config.HoverBackgroundColor3 = nil
	config.ClearTextOnFocus = nil
	config.IconScale = nil
	config.LeftIcon = nil
	config.Value = nil :: any
	config.RightIcon = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- construct output instance
	local Output: Frame = _new("Frame")(parameters) :: any
	Util.cleanUpPrep(maid, Output)

	-- bind functions to output
	local _setInput = Util.bindFunction(Output, maid, "SetInput", function(txt, cursorOffset: number?)
		Value:Set(txt)
		-- assert(typeof(TextBox.CursorPosition) == "number")
		CursorPosition:Set(cursorOffset or CursorPosition:Get() or 0)
		return nil
	end)
	local _clear = Util.bindFunction(Output, maid, "Clear", function()
		Value:Set("")
		CursorPosition:Set(1)
		return nil
	end)
	_Computed(function(input: string, count: number, lim: number?): nil
		if lim and input then
			if lim < count then
				_setInput:Invoke(string.sub(input, 1, lim))
			end
		end
		return nil
	end, Value, CharacterCount, CharacterLimit)
	Util.bindSignal(Output, maid, "OnInputChanged", OnInputChanged)
	Util.bindSignal(Output, maid, "OnInputComplete", OnInputComplete)

	return Output
end

return function(maid: Maid?)
	return function(params: TextFieldParameters): TextField
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
