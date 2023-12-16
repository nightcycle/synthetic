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
local Style = require(_Package:WaitForChild("Style"))

-- Types
type Maid = Maid.Maid
type Style = Style.Style
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type ImageData = Types.ImageData
type OptionData = Types.OptionData
type Signal = Signal.Signal
type RenderData = Types.RenderData

-- Constants
local HEIGHT_DP = 40
local OUTLINE_WIDTH_DP = 1
local LABEL_ALIGNMENT = Enum.TextXAlignment.Center
local MIN_LEFT_RIGHT_PADDING_DP = 12
local ELEMENT_SEPARATION_PADDING_DP = 8
local TARGET_SIZE_DP = 48
local MAX_BUTTON_COUNT = 5
local ICON_SIZE_DP = 18
local CIRCLE_IMAGE_RECT = Rect.new(256, 256, 256, 256)
local RIGHT_CIRCLE_IMAGE = "rbxassetid://15562060748"
local LEFT_CIRCLE_IMAGE = "rbxassetid://15562057345"
local CENTER_IMAGE = "rbxassetid://14846394635"

-- Variables
-- References
-- Private Functions
function component(
	maid: Maid,
	options: CanBeState<{ [number]: OptionData }>,
	density: CanBeState<number>,
	isMultiSelect: CanBeState<boolean>,
	renderDatas: CanBeState<{ [Enums.ButtonStateType]: { [Enums.SelectionState]: RenderData } }>,
	style: CanBeState<Style>
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

	local renderDatasState: State<{ [Enums.ButtonStateType]: { [Enums.SelectionState]: RenderData } }> =
		_import(renderDatas, {})
	local styleState: State<Style> = _import(style, nil :: any)

	local scaleState = _Computed(function(st: Style): number
		return st.Scale
	end, styleState)

	local densityState: State<number> = _Computed(function(d: number)
		return math.clamp(d, -3, 0)
	end, _import(density, 0))

	local fontState: State<Font> = _Computed(function(st: Style): Font
		return st:GetFontData(Enums.FontType.LabelLarge).Font
	end, styleState)

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
			_new("UICorner")({
				CornerRadius = UDim.new(1, 0),
			}),
			_new("UIStroke")({
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = _Computed(
					function(rDatas: { [Enums.ButtonStateType]: { [Enums.SelectionState]: RenderData } }): Color3
						return rDatas[Enums.ButtonStateType.Enabled][Enums.SelectionState.Unselected].Border.Color3
					end,
					renderDatasState
				),
				LineJoinMode = Enum.LineJoinMode.Round,
				Thickness = _Computed(function(s: number): number
					return math.max(s * OUTLINE_WIDTH_DP * 1, 1)
				end, scaleState),
				Transparency = _Computed(
					function(rDatas: { [Enums.ButtonStateType]: { [Enums.SelectionState]: RenderData } }): number
						return rDatas[Enums.ButtonStateType.Enabled][Enums.SelectionState.Unselected].Border.Transparency
					end,
					renderDatasState
				),
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
		local optionDataState: State<OptionData?> = _Computed(function(options: { [number]: OptionData }): OptionData?
			return options[i]
		end, optionsState)

		local backgroundImageState = _Computed(function(options: { [number]: OptionData }): string
			if #options > MAX_BUTTON_COUNT then
				warn(`max of 5 buttons for segmented button bar, currently {#options} are defined`)
			end
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
			return if optionData then optionData.IsInitiallySelected else false
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
				rDatas: { [Enums.ButtonStateType]: { [Enums.SelectionState]: RenderData } }
			): RenderData
				local toggleStyle = rDatas[state]
				assert(toggleStyle ~= nil, `no style for {state}`)
				if isSelected then
					return toggleStyle[Enums.SelectionState.Selected]
				else
					return toggleStyle[Enums.SelectionState.Unselected]
				end
			end,
			currentStateState,
			isSelectedState,
			renderDatasState
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
				function(styleList: { [Enums.ButtonStateType]: { [Enums.SelectionState]: RenderData } }): number
					return styleList[Enums.ButtonStateType.Enabled][Enums.SelectionState.Unselected].Border.Transparency
				end,
				renderDatasState
			),
			BackgroundColor3 = _Computed(
				function(styleList: { [Enums.ButtonStateType]: { [Enums.SelectionState]: RenderData } }): Color3
					return styleList[Enums.ButtonStateType.Enabled][Enums.SelectionState.Unselected].Border.Color3
				end,
				renderDatasState
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
			ImageTransparency = _Computed(function(style: RenderData): number
				return style.Background.Transparency
			end, currentStyleState),
			ImageColor3 = _Computed(function(style: RenderData): Color3
				return style.Background.Color3
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

					do
						local cStyle: Types.RenderData = currentStyleState:Get()
						if cStyle.Sound then
							local sound = Instance.new("Sound")
							sound.Volume = cStyle.Sound.Volume
							sound.SoundId = cStyle.Sound.SoundId
							SoundService:PlayLocalSound(sound)
							sound:Destroy()
						end
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
					TextColor3 = _Computed(function(style: RenderData): Color3
						return if style.Text then style.Text.Color3 else Color3.new(1, 1, 1)
					end, currentStyleState),
					TextTransparency = _Computed(function(style: RenderData): number
						return if style.Text then style.Text.Transparency else 1
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
					ImageColor3 = _Computed(function(icon: ImageData?, style: RenderData?): Color3
						return if icon and style and style.Text then style.Text.Color3 else Color3.new(1, 1, 1)
					end, iconState, currentStyleState),
					ImageRectOffset = _Computed(function(icon: ImageData?): Vector2
						return if icon then icon.ImageRectOffset else Vector2.zero
					end, iconState),
					ImageRectSize = _Computed(function(icon: ImageData?): Vector2
						return if icon then icon.ImageRectSize else Vector2.zero
					end, iconState),
					ImageTransparency = _Computed(function(icon: ImageData?, style: RenderData?): number
						return if icon and style and style.Text then style.Text.Transparency else 1
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

function newThemedComponent(
	style: CanBeState<Style>,

	textColor: Enums.ColorRoleType,
	fillTextColor: Enums.ColorRoleType,
	fillBackgroundColor: Enums.ColorRoleType,
	outlineColor: Enums.ColorRoleType,

	options: CanBeState<{ [number]: OptionData }>,

	density: CanBeState<number?>,
	isMultiSelect: CanBeState<boolean?>,
	elevation: CanBeState<number?>
): GuiObject
	local maid = Maid.new()	

	local _fuse = ColdFusion.fuse(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, nil :: any)

	local out = Interface.ColdFusion.new(
		options,
		_import(density, 0),
		_import(isMultiSelect, false),
		_Computed(function(s: Style): Color3
			return s:GetColor(textColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(fillTextColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(fillBackgroundColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(outlineColor)
		end, styleState),
		_import(elevation, 0),
		styleState
	)

	maid.bind(out)

	return out
end

Interface.ColdFusion = {}


function Interface.ColdFusion.primaryContainer(
	style: CanBeState<Style>,
	options: CanBeState<{ [number]: OptionData }>,
	density: CanBeState<number?>,
	isMultiSelect: CanBeState<boolean?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		style,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnPrimaryContainer,
		Enums.ColorRoleType.PrimaryContainer,
		Enums.ColorRoleType.Outline,
		options,
		density, 
		isMultiSelect,
		elevation
	)
end


function Interface.ColdFusion.secondaryContainer(
	style: CanBeState<Style>,
	options: CanBeState<{ [number]: OptionData }>,
	density: CanBeState<number?>,
	isMultiSelect: CanBeState<boolean?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		style,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnSecondaryContainer,
		Enums.ColorRoleType.SecondaryContainer,
		Enums.ColorRoleType.Outline,
		options,
		density, 
		isMultiSelect,
		elevation
	)
end


function Interface.ColdFusion.tertiaryContainer(
	style: CanBeState<Style>,
	options: CanBeState<{ [number]: OptionData }>,
	density: CanBeState<number?>,
	isMultiSelect: CanBeState<boolean?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		style,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnTertiaryContainer,
		Enums.ColorRoleType.TertiaryContainer,
		Enums.ColorRoleType.Outline,
		options,
		density, 
		isMultiSelect,
		elevation
	)
end

function Interface.ColdFusion.new(
	options: CanBeState<{ [number]: OptionData }>,
	density: CanBeState<number>,
	isMultiSelect: CanBeState<boolean>,

	textColor: CanBeState<Color3>,
	fillTextColor: CanBeState<Color3>,
	fillBackgroundColor: CanBeState<Color3>,
	outlineColor: CanBeState<Color3>,

	elevation: CanBeState<number>,
	style: CanBeState<Style>
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, nil :: any)

	local elevationState: State<number> = _import(elevation, 0)
	local textColorState: State<Color3> = _import(textColor, Color3.new(1, 1, 1))
	local fillTextColorState: State<Color3> = _import(fillTextColor, Color3.new(1, 1, 1))
	local fillBackgroundColorState: State<Color3> = _import(fillBackgroundColor, Color3.new(1, 1, 1))
	local outlineColorState: State<Color3> = _import(outlineColor, Color3.new(1, 1, 1))

	local button = component(
		maid,
		options,
		density,
		isMultiSelect,
		_Computed(
			function(
				style: Style,
				e: number,
				tC: Color3,
				fTC: Color3,
				fBC: Color3,
				oC: Color3
			): { [Enums.ButtonStateType]: { [Enums.SelectionState]: RenderData } }
				e += 1
				return {
					[Enums.ButtonStateType.Enabled] = {
						[Enums.SelectionState.Selected] = Types.newRenderData(
							style.Scale,
							Types.newAppearanceData(style:GetElevatedColor(oC, e), 0),
							Types.newAppearanceData(style:GetElevatedColor(fBC, e), 0),
							Types.newAppearanceData(style:GetElevatedColor(fTC, e), 0),
							style:GetFontData(Enums.FontType.LabelLarge),
							nil,
							nil,
							nil
						),
						[Enums.SelectionState.Unselected] = Types.newRenderData(
							style.Scale,
							Types.newAppearanceData(style:GetElevatedColor(oC, e), 0),
							Types.newAppearanceData(style:GetElevatedColor(fBC, e), 1),
							Types.newAppearanceData(style:GetElevatedColor(tC, e), 0),
							style:GetFontData(Enums.FontType.LabelLarge),
							nil,
							nil,
							nil
						),
					},
					[Enums.ButtonStateType.Disabled] = {
						[Enums.SelectionState.Selected] = Types.newRenderData(
							style.Scale,
							Types.newAppearanceData(style:GetElevatedColor(tC, e), 1 - 0.38),
							Types.newAppearanceData(style:GetElevatedColor(tC, e), 1 - 0.12),
							Types.newAppearanceData(style:GetElevatedColor(tC, e), 1 - 0.38),
							style:GetFontData(Enums.FontType.LabelLarge),
							nil,
							nil,
							nil
						),
						[Enums.SelectionState.Unselected] = Types.newRenderData(
							style.Scale,
							Types.newAppearanceData(style:GetElevatedColor(tC, e), 1 - 0.38),
							Types.newAppearanceData(style:GetElevatedColor(tC, e), 1 - 0.12),
							Types.newAppearanceData(style:GetElevatedColor(tC, e), 1 - 0.38),
							style:GetFontData(Enums.FontType.LabelLarge),
							nil,
							nil,
							nil
						),
					},
					[Enums.ButtonStateType.Hovered] = {
						[Enums.SelectionState.Selected] = Types.newRenderData(
							style.Scale,
							Types.newAppearanceData(style:GetElevatedColor(oC, e + 1), 0),
							Types.newAppearanceData(style:GetElevatedColor(fBC, e + 1), 1 - 0.08),
							Types.newAppearanceData(style:GetElevatedColor(fTC, e + 1), 0),
							style:GetFontData(Enums.FontType.LabelLarge),
							nil,
							nil,
							nil
						),
						[Enums.SelectionState.Unselected] = Types.newRenderData(
							style.Scale,
							Types.newAppearanceData(style:GetElevatedColor(oC, e + 1), 0),
							Types.newAppearanceData(style:GetElevatedColor(fBC, e + 1), 1 - 0.08),
							Types.newAppearanceData(style:GetElevatedColor(tC, e + 1), 0),
							style:GetFontData(Enums.FontType.LabelLarge),
							nil,
							nil,
							nil
						),
					},
					[Enums.ButtonStateType.Focused] = {
						[Enums.SelectionState.Selected] = Types.newRenderData(
							style.Scale,
							Types.newAppearanceData(style:GetElevatedColor(oC, e + 1), 0),
							Types.newAppearanceData(style:GetElevatedColor(fBC, e + 1), 1 - 0.1),
							Types.newAppearanceData(style:GetElevatedColor(fTC, e + 1), 0),
							style:GetFontData(Enums.FontType.LabelLarge),
							nil,
							nil,
							nil
						),
						[Enums.SelectionState.Unselected] = Types.newRenderData(
							style.Scale,
							Types.newAppearanceData(style:GetElevatedColor(oC, e + 1), 0),
							Types.newAppearanceData(style:GetElevatedColor(fBC, e + 1), 1 - 0.1),
							Types.newAppearanceData(style:GetElevatedColor(tC, e + 1), 0),
							style:GetFontData(Enums.FontType.LabelLarge),
							nil,
							nil,
							nil
						),
					},
					[Enums.ButtonStateType.Pressed] = {
						[Enums.SelectionState.Selected] = Types.newRenderData(
							style.Scale,
							Types.newAppearanceData(style:GetElevatedColor(oC, e - 1), 0),
							Types.newAppearanceData(style:GetElevatedColor(fBC, e - 1), 1 - 0.1),
							Types.newAppearanceData(style:GetElevatedColor(fTC, e - 1), 0),
							style:GetFontData(Enums.FontType.LabelLarge),
							nil,
							Types.newSoundData(Sounds.Library[Enums.SoundType.ui_tap_variant_01], 1),
							nil
						),
						[Enums.SelectionState.Unselected] = Types.newRenderData(
							style.Scale,
							Types.newAppearanceData(style:GetElevatedColor(oC, e - 1), 0),
							Types.newAppearanceData(style:GetElevatedColor(fBC, e - 1), 1 - 0.1),
							Types.newAppearanceData(style:GetElevatedColor(tC, e - 1), 0),
							style:GetFontData(Enums.FontType.LabelLarge),
							nil,
							Types.newSoundData(Sounds.Library[Enums.SoundType.ui_tap_variant_01], 1),
							nil
						),
					},
				}
			end,
			styleState,
			elevationState,
			textColorState,
			fillTextColorState,
			fillBackgroundColorState,
			outlineColorState
		),
		style
	)
	maid.bind(button)

	return button
end

return Interface
