--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
local SoundService = game:GetService("SoundService")

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Signal = require(_Packages:WaitForChild("Signal"))

-- Modules
local Sounds = require(_Package:WaitForChild("Sounds"))
local Enums = require(_Package:WaitForChild("Enums"))
local Types = require(_Package:WaitForChild("Types"))
local Config = require(_Package:WaitForChild("Config"))
local Util = require(_Package:WaitForChild("Util"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type TextStyle = Types.TextStyle
type ToggleTextStyle = Types.ToggleTextStyle
type ImageData = Types.ImageData
type ThemeData = Types.ThemeData
type OptionData = Types.OptionData
type Signal = Signal.Signal

-- Constants
local HEIGHT_DP = 40
local OUTLINE_WIDTH_DP = 1
local LABEL_ALIGNMENT = Enum.TextXAlignment.Center
local MIN_LEFT_RIGHT_PADDING_DP = 12
local ELEMENT_SEPARATION_PADDING_DP = 8
local TARGET_SIZE_DP = 48
local MAX_BUTTON_COUNT = 5
local ICON_SIZE_DP = 18
local DEFAULT_VOLUME = Config.Sound.Volume
local HOVER_TRANSPARENCY = Config.Transparency.Background.Hovered
local FOCUS_TRANSPARENCY = Config.Transparency.Background.Focused
local PRESS_TRANSPARENCY = Config.Transparency.Background.Pressed
local DISABLE_TRANSPARENCY = Config.Transparency.Text.Disabled
local CIRCLE_IMAGE_RECT = Rect.new(256, 256, 256, 256)
local RIGHT_CIRCLE_IMAGE = "rbxassetid://15562060748"
local LEFT_CIRCLE_IMAGE = "rbxassetid://15562057345"
local CENTER_IMAGE = "rbxassetid://14846394635"

-- Variables
-- References
-- Private Functions

function new(
	maid: Maid,
	options: CanBeState<{ [number]: OptionData }>,
	isMultiSelect: CanBeState<boolean>,
	styles: CanBeState<{ [Enums.ButtonStateType]: ToggleTextStyle }>,
	scale: CanBeState<number>,
	font: CanBeState<Font>,
	density: CanBeState<number>,
	sound: CanBeState<Sound?>
): Frame
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local optionsState: State<{ [number]: OptionData }> = _import(options, {})

	local isMultiSelectState: State<boolean> = _import(isMultiSelect, false)

	local stylesState: State<{ [Enums.ButtonStateType]: ToggleTextStyle }> = _import(styles, {})

	local soundState: State<Sound> = _import(sound, nil :: Sound?)

	local scaleState: State<number> = _import(scale, 1)
	local densityState: State<number> = _Computed(function(d: number)
		return math.clamp(d, -3, 0)
	end, _import(density, 0))

	local fontState: State<Font> = _import(font, Font.fromEnum(Enum.Font.SourceSansSemibold))

	local heightState = _Computed(function(s: number, d: number): number
		return s * (HEIGHT_DP + (d * 4))
	end, scaleState, densityState)

	local ratioState = _Computed(function(d: number): number
		return 3 * ((HEIGHT_DP - (d * 4)) / HEIGHT_DP)
	end, densityState)

	local inst = _new("Frame")({
		Size = _Computed(function(h: number): UDim2
			return UDim2.fromOffset(0, h)
		end, heightState),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Children = {
			_new("UIListLayout")({
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				VerticalFlex = Enum.UIFlexAlignment.None,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			-- _new("UIGridLayout")({
			-- 	FillDirection = Enum.FillDirection.Horizontal,
			-- 	FillDirectionMaxCells = 100000,
			-- 	SortOrder = Enum.SortOrder.LayoutOrder,
			-- 	StartCorner = Enum.StartCorner.TopLeft,
			-- 	CellPadding = UDim2.fromScale(0,0),
			-- 	CellSize = _Computed(function(options: {[number]: OptionData}): UDim2
			-- 		return UDim2.fromScale(1/math.min(#options, MAX_BUTTON_COUNT), 1)
			-- 	end, optionsState)
			-- }),
			_new("UICorner")({
				CornerRadius = UDim.new(1, 0),
			}),
			_new("UIStroke")({
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = _Computed(function(styles: { [Enums.ButtonStateType]: ToggleTextStyle }): Color3
					return styles[Enums.ButtonStateType.Enabled].Unselected.BorderColor3
				end, stylesState),
				LineJoinMode = Enum.LineJoinMode.Round,
				Thickness = _Computed(function(s: number): number
					return math.max(s * OUTLINE_WIDTH_DP * 1, 1)
				end, scaleState),
				Transparency = _Computed(function(styles: { [Enums.ButtonStateType]: ToggleTextStyle }): number
					return styles[Enums.ButtonStateType.Enabled].Unselected.BorderTransparency
				end, stylesState),
			}),
			_new("UISizeConstraint")({
				MaxSize = Vector2.new(math.huge, math.huge),
				MinSize = _Computed(function(s: number): Vector2
					return Vector2.new(s * MIN_LEFT_RIGHT_PADDING_DP * 2, 0)
				end, scaleState),
			}),
		},
	}) :: Frame

	local deselectAll = maid:GiveTask(Signal.new())

	for i = 1, MAX_BUTTON_COUNT do
		local optionDataState: State<OptionData?> = _Computed(
			function(options: { [number]: OptionData }): OptionData?
				return options[i]
			end,
			optionsState
		)

		local backgroundImageState = _Computed(function(options: { [number]: OptionData }): string
			if #options == i then
				return RIGHT_CIRCLE_IMAGE
			elseif i == 1 then
				return LEFT_CIRCLE_IMAGE
			else
				return CENTER_IMAGE
			end
		end, optionsState)
		local isEnabledState = _Computed(function(optionData: OptionData?): boolean
			return if optionData then not optionData.Disabled else false
		end, optionDataState)

		local onClickState = _Computed(function(optionData: OptionData?): (boolean) -> ()
			return if optionData then optionData.OnSelect else function(isSelected: boolean) end
		end, optionDataState)

		local isFocusedState = _Value(false)
		local isPressedState = _Value(false)
		local isHoveredState = _Value(false)
		local clickCount = _Value(0)
		local isInitiallySelected = _Computed(function(optionData: OptionData?)
			clickCount:Set(0)
			return if optionData then not optionData.IsInitiallySelected else false
		end, optionDataState)

		local isSelectedState = _Computed(function(count: number, initial: boolean): boolean
			return if count % 2 == 0 then initial else not initial
		end, clickCount, isInitiallySelected)

		maid:GiveTask(deselectAll:Connect(function(j: number)
			if j ~= i then
				if isSelectedState:Get() then
					clickCount:Set(clickCount:Get() + 1)
				end
			end
		end))

		local currentStateState = _Computed(
			function(
				isEnabled: boolean,
				isFocused: boolean,
				isPressed: boolean,
				isHovered: boolean
			): Enums.ButtonStateType
				if isEnabled then
					if isPressed then
						return Enums.ButtonStateType.Pressed
					else
						if isHovered then
							return Enums.ButtonStateType.Hovered
						else
							if isFocused then
								return Enums.ButtonStateType.Focused
							else
								return Enums.ButtonStateType.Enabled
							end
						end
					end
				else
					return Enums.ButtonStateType.Disabled
				end
			end,
			isEnabledState,
			isFocusedState,
			isPressedState,
			isHoveredState
		) :: State<any>

		local iconState = _Computed(function(optionData: OptionData?, isSelected: boolean): ImageData?
			return if optionData then if isSelected then optionData.SelectedIcon else optionData.Icon else nil
		end, optionDataState, isSelectedState)

		local textState = _Computed(function(optionData: OptionData?, isSelected: boolean): string
			return if optionData then if isSelected then optionData.SelectedText else optionData.Text else ""
		end, optionDataState, isSelectedState)

		local currentStyleState = _Computed(
			function(
				state: Enums.ButtonStateType,
				isSelected: boolean,
				styles: { [Enums.ButtonStateType]: ToggleTextStyle }
			): TextStyle
				local toggleStyle = styles[state]
				assert(toggleStyle ~= nil, `no style for {state}`)
				if isSelected then
					return toggleStyle.Selected
				else
					return toggleStyle.Unselected
				end
			end,
			currentStateState,
			isSelectedState,
			stylesState
		)

		local barSizeState = _Computed(function(s: number): UDim2
			return UDim2.new(0, s * OUTLINE_WIDTH_DP, 1, 0)
		end, scaleState)

		_new("Frame")({
			Visible = _Computed(function(data: OptionData?): boolean
				return i > 1 and data ~= nil
			end, optionDataState),
			LayoutOrder = i - 0.5,
			Size = barSizeState,
			BorderSizePixel = 0,
			BackgroundTransparency = _Computed(
				function(styleList: { [Enums.ButtonStateType]: ToggleTextStyle }): number
					return styleList[Enums.ButtonStateType.Enabled].Unselected.BorderTransparency
				end,
				stylesState
			),
			BackgroundColor3 = _Computed(
				function(styleList: { [Enums.ButtonStateType]: ToggleTextStyle }): Color3
					return styleList[Enums.ButtonStateType.Enabled].Unselected.BorderColor3
				end,
				stylesState
			),
			Parent = inst,
		})

		_new("ImageButton")({
			Visible = _Computed(function(data: OptionData?): boolean
				return data ~= nil
			end, optionDataState),
			Size = _Computed(function(options: { [number]: OptionData }, barSize: UDim2): UDim2
				local buttonCount = #options
				local avgBarReduction = barSize.X.Offset * (buttonCount - 1) / buttonCount
				return UDim2.new(1 / buttonCount, -avgBarReduction, 1, 0)
			end, optionsState, barSizeState),
			LayoutOrder = i,
			Parent = inst,
			BackgroundTransparency = 1,
			Image = backgroundImageState,
			ImageTransparency = _Computed(function(style: TextStyle): number
				return style.BackgroundTransparency
			end, currentStyleState),
			ImageColor3 = _Computed(function(style: TextStyle): Color3
				return style.BackgroundColor3
			end, currentStyleState),
			SliceCenter = CIRCLE_IMAGE_RECT,
			SliceScale = 1,
			ScaleType = Enum.ScaleType.Slice,
			AutomaticSize = Enum.AutomaticSize.None,
			Events = {
				Activated = function()
					if isEnabledState:Get() == false then
						return
					end
					local onClick = onClickState:Get()
					local count = clickCount:Get() + 1
					clickCount:Set(count)
					local initialSelect: boolean = isInitiallySelected:Get()

					local s = soundState:Get()
					if s then
						SoundService:PlayLocalSound(s)
					end

					if isMultiSelectState:Get() == false then
						deselectAll:Fire(i)
					end

					if count % 2 == 0 then
						onClick(initialSelect)
					else
						onClick(not initialSelect)
					end
				end,
				MouseButton1Down = function(x: number, y: number)
					if isEnabledState:Get() == false then
						return
					end
					isPressedState:Set(true)
				end,
				MouseButton1Up = function(x: number, y: number)
					if isEnabledState:Get() == false then
						return
					end
					isPressedState:Set(false)
				end,
				MouseEnter = function()
					isHoveredState:Set(true)
				end,
				MouseLeave = function()
					isHoveredState:Set(false)
				end,
				SelectionGained = function()
					isFocusedState:Set(true)
				end,
				SelectionLost = function()
					isFocusedState:Set(false)
				end,
			},
			Children = {
				_new("UIAspectRatioConstraint")({
					AspectRatio = ratioState,
					AspectType = Enum.AspectType.ScaleWithParentSize,
					DominantAxis = Enum.DominantAxis.Height,
				}),
				_new("UIListLayout")({
					Padding = _Computed(function(s: number): UDim
						return UDim.new(0, s * ELEMENT_SEPARATION_PADDING_DP)
					end, scaleState),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					ItemLineAlignment = Enum.ItemLineAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				}),
				_new("TextLabel")({
					Text = textState,
					Visible = _Computed(function(txt: string): boolean
						return txt:len() > 0
					end, textState),
					TextScaled = true,
					TextXAlignment = LABEL_ALIGNMENT,
					TextYAlignment = Enum.TextYAlignment.Center,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					FontFace = fontState,
					LayoutOrder = 2,
					TextColor3 = _Computed(function(style: TextStyle): Color3
						return style.TextColor3
					end, currentStyleState),
					TextTransparency = _Computed(function(style: TextStyle): number
						return style.TextTransparency
					end, currentStyleState),

					SizeConstraint = Enum.SizeConstraint.RelativeYY,

					Size = _Computed(function(s: number): UDim2
						return UDim2.fromScale(0, 1) --s * ICON_SIZE_DP)
					end, scaleState),
				}),
				_new("ImageLabel")({
					Name = "Icon",
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Visible = _Computed(function(icon: ImageData?): boolean
						return icon ~= nil
					end, iconState),
					Image = _Computed(function(icon: ImageData?): string
						return if icon then icon.Image else ""
					end, iconState),
					ImageColor3 = _Computed(function(icon: ImageData?, style: TextStyle?): Color3
						return if icon and style then style.TextColor3 else Color3.new(1, 1, 1)
					end, iconState, currentStyleState),
					ImageRectOffset = _Computed(function(icon: ImageData?): Vector2
						return if icon then icon.ImageRectOffset else Vector2.zero
					end, iconState),
					ImageRectSize = _Computed(function(icon: ImageData?): Vector2
						return if icon then icon.ImageRectSize else Vector2.zero
					end, iconState),
					ImageTransparency = _Computed(function(icon: ImageData?, style: TextStyle?): number
						return if icon and style then style.TextTransparency else 1
					end, iconState, currentStyleState),
					SizeConstraint = Enum.SizeConstraint.RelativeYY,
					Size = _Computed(function(s: number): UDim2
						return UDim2.fromScale(1, 1)
						-- return UDim2.fromOffset(s * ICON_SIZE_DP, s * ICON_SIZE_DP)
					end, scaleState),
				}),
				-- _new("UICorner")({
				-- 	CornerRadius = UDim.new(1, 0),
				-- }),
				_new("UISizeConstraint")({
					MaxSize = Vector2.new(math.huge, math.huge),
					MinSize = _Computed(function(s: number): Vector2
						return Vector2.new(s * TARGET_SIZE_DP, 0)
					end, scaleState),
				}),
				_new("UIPadding")({
					PaddingLeft = _Computed(function(s: number): UDim
						return UDim.new(0, s * (MIN_LEFT_RIGHT_PADDING_DP + ELEMENT_SEPARATION_PADDING_DP))
					end, scaleState),
					PaddingRight = _Computed(function(s: number): UDim
						return UDim.new(0, s * (MIN_LEFT_RIGHT_PADDING_DP + ELEMENT_SEPARATION_PADDING_DP))
					end, scaleState),
					PaddingTop = _Computed(function(s: number, h: number): UDim
						return UDim.new(0, (h - s * ICON_SIZE_DP) / 2)
					end, scaleState, heightState),
					PaddingBottom = _Computed(function(s: number, h: number): UDim
						return UDim.new(0, (h - s * ICON_SIZE_DP) / 2)
					end, scaleState, heightState),
				}),
			},
		})
	end

	return inst
end
-- Class
local Interface = {}

function Interface.cfusion(
	options: CanBeState<{ [number]: OptionData }>,
	isMultiSelect: CanBeState<boolean>,
	theme: CanBeState<ThemeData>,
	density: CanBeState<number>
): Frame
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local themeState = _import(
		theme,
		Types.newThemeData(
			1,
			false,
			1,
			Font.fromEnum(Enum.Font.SourceSansSemibold),
			Color3.fromHSV(0.8, 0.4, 0.8)
		)
	)

	local sound = maid:GiveTask(Instance.new("Sound"))
	sound.Volume = DEFAULT_VOLUME
	sound.SoundId = Sounds.ui_tap_variant_01

	local styles = _Computed(function(thm: ThemeData): { [Enums.ButtonStateType]: ToggleTextStyle }
		local unselectedColor = thm.Color3
		local selectedColor = thm.SelectionColor3

		local selectedTextColor: Color3
		local unselectedTextColor: Color3

		if thm.IsDarkMode == false then
			selectedTextColor = Util.getElevatedColor(Util.DARK_SURFACE, thm.Elevation, thm.IsDarkMode) --Util.getReadableColor(Util.DARK_SURFACE, selectedColor)
			unselectedTextColor = Util.getElevatedColor(Util.DARK_SURFACE, thm.Elevation, thm.IsDarkMode) --Util.getReadableColor(Util.DARK_SURFACE, unselectedColor)
		else
			selectedTextColor = Util.getElevatedColor(Util.LIGHT_SURFACE, thm.Elevation, thm.IsDarkMode) --Util.getReadableColor(Util.LIGHT_SURFACE, selectedColor)
			unselectedTextColor = Util.getElevatedColor(Util.LIGHT_SURFACE, thm.Elevation, thm.IsDarkMode) --Util.getReadableColor(Util.LIGHT_SURFACE, unselectedColor)
		end

		selectedColor = Util.getReadableColor(selectedColor, selectedTextColor)
		unselectedColor = Util.getReadableColor(unselectedColor, unselectedTextColor)

		unselectedColor = Util.getElevatedColor(unselectedColor, thm.Elevation, thm.IsDarkMode)
		selectedColor = Util.getElevatedColor(selectedColor, thm.Elevation, thm.IsDarkMode)

		local selectedBorderColor = selectedTextColor
		local unselectedBorderColor = unselectedTextColor

		local data = {
			[Enums.ButtonStateType.Enabled] = Types.newToggleTextStyle(
				Types.newTextStyle(selectedTextColor, 0, selectedColor, 0.35, selectedBorderColor, 0),
				Types.newTextStyle(unselectedTextColor, 0, unselectedColor, 1, unselectedBorderColor, 0)
			),
			[Enums.ButtonStateType.Disabled] = Types.newToggleTextStyle(
				Types.newTextStyle(
					(function(): Color3
						if thm.IsDarkMode then
							local h, _s, v = selectedTextColor:ToHSV()
							return Util.getReadableColor(
								Color3.fromHSV(h, 0, v),
								if thm.BackgroundColor3 then thm.BackgroundColor3 else Color3.new(0.15, 0.15, 0.15)
							)
						else
							local h, _s, v = unselectedTextColor:ToHSV()
							return Util.getReadableColor(
								Color3.fromHSV(h, 0, v),
								if thm.BackgroundColor3 then thm.BackgroundColor3 else Color3.new(0.85, 0.85, 0.85)
							)
						end
					end)(),
					DISABLE_TRANSPARENCY,
					selectedColor,
					1,
					selectedBorderColor,
					1
				),
				Types.newTextStyle(
					(function(): Color3
						if thm.IsDarkMode then
							local h, _s, v = selectedTextColor:ToHSV()
							return Util.getReadableColor(
								Color3.fromHSV(h, 0, v),
								if thm.BackgroundColor3 then thm.BackgroundColor3 else Color3.new(0.15, 0.15, 0.15)
							)
						else
							local h, _s, v = unselectedTextColor:ToHSV()
							return Util.getReadableColor(
								Color3.fromHSV(h, 0, v),
								if thm.BackgroundColor3 then thm.BackgroundColor3 else Color3.new(0.85, 0.85, 0.85)
							)
						end
					end)(),
					DISABLE_TRANSPARENCY,
					unselectedColor,
					1,
					unselectedBorderColor,
					1
				)
			),
			[Enums.ButtonStateType.Focused] = Types.newToggleTextStyle(
				Types.newTextStyle(
					selectedTextColor,
					0,
					selectedColor,
					FOCUS_TRANSPARENCY,
					selectedBorderColor,
					0
				),
				Types.newTextStyle(
					unselectedTextColor,
					0,
					unselectedColor,
					FOCUS_TRANSPARENCY,
					unselectedBorderColor,
					0
				)
			),
			[Enums.ButtonStateType.Hovered] = Types.newToggleTextStyle(
				Types.newTextStyle(
					selectedTextColor,
					0,
					selectedColor,
					HOVER_TRANSPARENCY,
					selectedBorderColor,
					0
				),
				Types.newTextStyle(
					unselectedTextColor,
					0,
					unselectedColor,
					HOVER_TRANSPARENCY,
					unselectedBorderColor,
					0
				)
			),
			[Enums.ButtonStateType.Pressed] = Types.newToggleTextStyle(
				Types.newTextStyle(
					selectedTextColor,
					0,
					selectedColor,
					PRESS_TRANSPARENCY,
					selectedBorderColor,
					0
				),
				Types.newTextStyle(
					unselectedTextColor,
					0,
					unselectedColor,
					PRESS_TRANSPARENCY,
					unselectedBorderColor,
					0
				)
			),
		}

		return data
	end, themeState)

	local buttonRow = new(
		maid,
		options,
		isMultiSelect,
		styles,
		_Computed(function(t: ThemeData): number
			return t.Scale
		end, themeState),
		_Computed(function(t: ThemeData): Font
			return t.Font
		end, themeState),
		density,
		sound
	)
	maid.bind(buttonRow)
	return buttonRow
end

return Interface
