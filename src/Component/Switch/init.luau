--!strict
local _Package = script.Parent.Parent
local _Packages = _Package.Parent
-- Services
local SoundService = game:GetService("SoundService")
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Sounds = require(_Package:WaitForChild("Sounds"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type AppearanceData = Types.AppearanceData
type ImageData = Types.ImageData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type Style = Style.Style
type SwitchRenderData = {
	Text: AppearanceData,
	Button: AppearanceData,
	Background: AppearanceData,
	Outline: AppearanceData,
}

-- Constants
local ICONS = MaterialIcons.default.dp_48.scale_1
local SWITCH_HEIGHT_DP = 32
local SWITCH_WIDTH_DP = 52
local INNER_BUTTON_YES_ICON_SIZE_DP = 28
local INNER_BUTTON_NO_ICON_SELECTED_SIZE_DP = 24
local INNER_BUTTON_NO_ICON_UNSELECTED_SIZE_DP = 16
local ICON_SIZE_DP = 16
local OUTLINE_WIDTH_DP = 2
-- Variables
-- References
-- Private Functions
function newSwitchRenderData(
	text: AppearanceData,
	button: AppearanceData,
	background: AppearanceData,
	outline: AppearanceData
): SwitchRenderData
	return {
		Text = text,
		Button = button,
		Background = background,
		Outline = outline,
	}
end

-- Class
local Interface = {}

function newThemedComponent(
	style: CanBeState<Style>,
	backgroundColor: Enums.ColorRoleType,
	onBackgroundColor: Enums.ColorRoleType,
	fillColor: Enums.ColorRoleType,
	buttonColor: Enums.ColorRoleType,
	onButtonColor: Enums.ColorRoleType,
	disabledColor: Enums.ColorRoleType,
	onDisabledColor: Enums.ColorRoleType,
	onSelect: CanBeState<(isSelected: boolean) -> ()>,
	initialSelection: CanBeState<boolean>,
	includeIconOnSelected: CanBeState<boolean?>,
	includeIconOnDeselected: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
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
		onSelect,
		initialSelection,
		_import(isEnabled, true),
		_import(includeIconOnSelected, true),
		_import(includeIconOnDeselected, true),
		_Computed(function(s: Style): Color3
			return s:GetColor(backgroundColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(onBackgroundColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(fillColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(buttonColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(onButtonColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(disabledColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(onDisabledColor)
		end, styleState),
		_import(elevation, 0),
		styleState
	)

	maid.bind(out)

	return out
end

Interface.ColdFusion = {}

function Interface.ColdFusion.primary(
	style: CanBeState<Style>,
	onSelect: CanBeState<(isSelected: boolean) -> ()>,
	initialSelection: CanBeState<boolean>,
	includeIconOnSelected: CanBeState<boolean?>,
	includeIconOnDeselected: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		style,
		Enums.ColorRoleType.SurfaceContainerHighest,
		Enums.ColorRoleType.Outline,
		Enums.ColorRoleType.Primary,
		Enums.ColorRoleType.PrimaryContainer,
		Enums.ColorRoleType.OnPrimaryContainer,
		Enums.ColorRoleType.Surface,
		Enums.ColorRoleType.OnSurface,
		onSelect,
		initialSelection,
		includeIconOnSelected,
		includeIconOnDeselected,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.secondary(
	style: CanBeState<Style>,
	onSelect: CanBeState<(isSelected: boolean) -> ()>,
	initialSelection: CanBeState<boolean>,
	includeIconOnSelected: CanBeState<boolean?>,
	includeIconOnDeselected: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		style,
		Enums.ColorRoleType.SurfaceContainerHighest,
		Enums.ColorRoleType.Outline,
		Enums.ColorRoleType.Secondary,
		Enums.ColorRoleType.SecondaryContainer,
		Enums.ColorRoleType.OnSecondaryContainer,
		Enums.ColorRoleType.Surface,
		Enums.ColorRoleType.OnSurface,
		onSelect,
		initialSelection,
		includeIconOnSelected,
		includeIconOnDeselected,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.tertiary(
	style: CanBeState<Style>,
	onSelect: CanBeState<(isSelected: boolean) -> ()>,
	initialSelection: CanBeState<boolean>,
	includeIconOnSelected: CanBeState<boolean?>,
	includeIconOnDeselected: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		style,
		Enums.ColorRoleType.SurfaceContainerHighest,
		Enums.ColorRoleType.Outline,
		Enums.ColorRoleType.Tertiary,
		Enums.ColorRoleType.TertiaryContainer,
		Enums.ColorRoleType.OnTertiaryContainer,
		Enums.ColorRoleType.Surface,
		Enums.ColorRoleType.OnSurface,
		onSelect,
		initialSelection,
		includeIconOnSelected,
		includeIconOnDeselected,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.new(
	onSelect: CanBeState<(isSelected: boolean) -> ()>,
	initialSelection: CanBeState<boolean>,
	isEnabled: CanBeState<boolean>,
	includeIconOnSelected: CanBeState<boolean>,
	includeIconOnDeselected: CanBeState<boolean>,
	backgroundColor: CanBeState<Color3>,
	onBackgroundColor: CanBeState<Color3>,
	fillColor: CanBeState<Color3>,
	buttonColor: CanBeState<Color3>,
	onButtonColor: CanBeState<Color3>,
	disabledColor: CanBeState<Color3>,
	onDisabledColor: CanBeState<Color3>,
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

	local disabledColorState = _import(disabledColor, Color3.new(1, 1, 1))
	local onDisabledColorState = _import(onDisabledColor, Color3.new(1, 1, 1))

	local initialSelectionState = _import(initialSelection, false)
	local fillColorState = _import(fillColor, Color3.new(1, 1, 1))

	local backgroundColorState = _import(backgroundColor, Color3.new(1, 1, 1))
	local onBackgroundColorState = _import(onBackgroundColor, Color3.new(1, 1, 1))

	local buttonColorState = _import(buttonColor, Color3.new(1, 1, 1))
	local onButtonColorState = _import(onButtonColor, Color3.new(1, 1, 1))

	local elevationState = _import(elevation, 0)
	local isEnabledState = _import(isEnabled, true)
	local includeSelectedIconState = _import(includeIconOnSelected, true)
	local includeDeselectedIconState = _import(includeIconOnDeselected, true)

	local onSelectState = _import(onSelect, function(isSelected: boolean?) end)

	local clickCountState = _Value(0)

	local valueState = _Computed(function(initial: boolean, count: number): boolean
		if count % 2 == 0 then
			return initial
		else
			return not initial
		end
	end, initialSelectionState, clickCountState)

	local iconState = _Computed(function(includeSel: boolean, includeDes: boolean, isSelected: boolean?): ImageData?
		if isSelected == true then
			if includeSel then
				return ICONS.check
			end
		elseif isSelected == false then
			if includeDes then
				return ICONS.close
			end
		end
		return nil
	end, includeSelectedIconState, includeDeselectedIconState, valueState)

	local styleState: State<Style> = _import(style, nil :: any)

	local unselectedRenderDatasState = _Computed(
		function(
			s: Style,
			fC: Color3,
			oC: Color3,
			oOC: Color3,
			bC: Color3,
			oBC: Color3,
			dC: Color3,
			oDC: Color3,
			e: number
		): { [Enums.ButtonStateType]: SwitchRenderData }
			return {
				[Enums.ButtonStateType.Enabled] = newSwitchRenderData(
					Types.newAppearanceData(s:GetElevatedColor(oC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(oOC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(oC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(oOC, e), 0)
				),
				[Enums.ButtonStateType.Disabled] = newSwitchRenderData(
					Types.newAppearanceData(s:GetElevatedColor(oOC, e), 1 - 0.38),
					Types.newAppearanceData(s:GetElevatedColor(oOC, e), 1 - 0.38),
					Types.newAppearanceData(s:GetElevatedColor(oOC, e), 1),
					Types.newAppearanceData(s:GetElevatedColor(oOC, e), 1 - 0.38)
				),
				[Enums.ButtonStateType.Hovered] = newSwitchRenderData(
					Types.newAppearanceData(s:GetElevatedColor(oC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(oOC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(oC, e), 1 - 0.08),
					Types.newAppearanceData(s:GetElevatedColor(oOC, e), 0)
				),
				[Enums.ButtonStateType.Focused] = newSwitchRenderData(
					Types.newAppearanceData(s:GetElevatedColor(oC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(oOC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(oC, e), 1 - 0.1),
					Types.newAppearanceData(s:GetElevatedColor(oOC, e), 0)
				),
				[Enums.ButtonStateType.Pressed] = newSwitchRenderData(
					Types.newAppearanceData(s:GetElevatedColor(oC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(oOC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(oC, e), 1 - 0.1),
					Types.newAppearanceData(s:GetElevatedColor(oOC, e), 0)
				),
			}
		end,
		styleState,
		fillColorState,
		backgroundColorState,
		onBackgroundColorState,
		buttonColorState,
		onButtonColorState,
		disabledColorState,
		onDisabledColorState,
		elevationState
	)

	local selectedRenderDatasState = _Computed(
		function(
			s: Style,
			fC: Color3,
			oC: Color3,
			oOC: Color3,
			bC: Color3,
			oBC: Color3,
			dC: Color3,
			oDC: Color3,
			e: number
		): { [Enums.ButtonStateType]: SwitchRenderData }
			return {
				[Enums.ButtonStateType.Enabled] = newSwitchRenderData(
					Types.newAppearanceData(s:GetElevatedColor(oBC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(bC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(fC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(fC, e), 0)
				),
				[Enums.ButtonStateType.Disabled] = newSwitchRenderData(
					Types.newAppearanceData(s:GetElevatedColor(oDC, e), 1 - 0.38),
					Types.newAppearanceData(s:GetElevatedColor(dC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(oDC, e), 1 - 0.38),
					Types.newAppearanceData(s:GetElevatedColor(oDC, e), 1 - 0.38)
				),
				[Enums.ButtonStateType.Hovered] = newSwitchRenderData(
					Types.newAppearanceData(s:GetElevatedColor(oBC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(bC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(fC, e), 0.08),
					Types.newAppearanceData(s:GetElevatedColor(fC, e), 0)
				),
				[Enums.ButtonStateType.Focused] = newSwitchRenderData(
					Types.newAppearanceData(s:GetElevatedColor(oBC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(bC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(fC, e), 0.1),
					Types.newAppearanceData(s:GetElevatedColor(fC, e), 0)
				),
				[Enums.ButtonStateType.Pressed] = newSwitchRenderData(
					Types.newAppearanceData(s:GetElevatedColor(oBC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(bC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(fC, e), 0.1),
					Types.newAppearanceData(s:GetElevatedColor(fC, e), 0)
				),
			}
		end,
		styleState,
		fillColorState,
		backgroundColorState,
		onBackgroundColorState,
		buttonColorState,
		onButtonColorState,
		disabledColorState,
		onDisabledColorState,
		elevationState
	)

	local isFocusedState = _Value(false)
	local isPressedState = _Value(false)
	local isHoveredState = _Value(false)

	local currentStateState = _Computed(
		function(isEnab: boolean, isFocused: boolean, isPressed: boolean, isHovered: boolean): Enums.ButtonStateType
			if isEnab then
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

	local renderDataState = _Computed(
		function(
			selRenderDatas: { [Enums.ButtonStateType]: SwitchRenderData },
			unselRenderDatas: { [Enums.ButtonStateType]: SwitchRenderData },
			v: boolean?,
			bState: Enums.ButtonStateType
		): SwitchRenderData
			if v then
				return selRenderDatas[bState]
			else
				return unselRenderDatas[bState]
			end
		end,
		selectedRenderDatasState,
		unselectedRenderDatasState,
		valueState,
		currentStateState
	)

	local buttonSizeState = _Computed(function(s: Style, i: ImageData?, v: boolean): number
		local size = if i
			then INNER_BUTTON_YES_ICON_SIZE_DP
			else if v then INNER_BUTTON_NO_ICON_SELECTED_SIZE_DP else INNER_BUTTON_NO_ICON_UNSELECTED_SIZE_DP
		return size
	end, styleState, iconState, valueState)

	local inst = _new("ImageButton")({
		Size = _Computed(function(s: Style): UDim2
			return UDim2.fromOffset(
				s.Scale * SWITCH_WIDTH_DP - (OUTLINE_WIDTH_DP * 2),
				s.Scale * SWITCH_HEIGHT_DP - (OUTLINE_WIDTH_DP * 2)
			)
		end, styleState),
		BackgroundColor3 = _Computed(function(data: SwitchRenderData): Color3
			return data.Background.Color3
		end, renderDataState),
		BackgroundTransparency = _Computed(function(data: SwitchRenderData): number
			return data.Background.Transparency
		end, renderDataState),
		Events = {
			Activated = function()
				if isEnabledState:Get() == false then
					return
				end
				local onClick = onSelectState:Get()

				local count = clickCountState:Get() + 1
				clickCountState:Set(count)

				do
					local sound = Instance.new("Sound")
					sound.Volume = 1
					if valueState:Get() == true then
						sound.SoundId = Sounds.Library[Enums.SoundType.navigation_forward_selection_minimal]
					else
						sound.SoundId = Sounds.Library[Enums.SoundType.navigation_backward_selection_minimal]
					end
					SoundService:PlayLocalSound(sound)
					sound:Destroy()
				end

				onClick(valueState:Get())
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
			_new("UIStroke")({
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = _Computed(function(renderData: SwitchRenderData): Color3
					return renderData.Outline.Color3
				end, renderDataState),
				LineJoinMode = Enum.LineJoinMode.Round,
				Thickness = _Computed(function(s: Style): number
					return s.Scale * OUTLINE_WIDTH_DP
				end, styleState),
				Transparency = _Computed(function(renderData: SwitchRenderData): number
					return renderData.Outline.Transparency
				end, renderDataState),
			}),
			_new("UICorner")({
				CornerRadius = UDim.new(0.5, 0),
			}),
			_new("UIPadding")({
				PaddingTop = _Computed(function(s: Style, buttonSize: number): UDim
					local size = SWITCH_HEIGHT_DP - (OUTLINE_WIDTH_DP * 2) - buttonSize
					return UDim.new(0, s.Scale * size / 2)
				end, styleState, buttonSizeState),
				PaddingBottom = _Computed(function(s: Style, buttonSize: number): UDim
					local size = SWITCH_HEIGHT_DP - (OUTLINE_WIDTH_DP * 2) - buttonSize
					return UDim.new(0, s.Scale * size / 2)
				end, styleState, buttonSizeState),
				PaddingLeft = _Computed(function(s: Style, buttonSize: number): UDim
					local size = SWITCH_HEIGHT_DP - (OUTLINE_WIDTH_DP * 2) - buttonSize
					return UDim.new(0, s.Scale * size / 2)
				end, styleState, buttonSizeState),
				PaddingRight = _Computed(function(s: Style, buttonSize: number): UDim
					local size = SWITCH_HEIGHT_DP - (OUTLINE_WIDTH_DP * 2) - buttonSize
					return UDim.new(0, s.Scale * size / 2)
				end, styleState, buttonSizeState),
			}),
			_new("Frame")({
				Size = _Computed(function(s: Style, size: number): UDim2
					return UDim2.fromOffset(s.Scale * size, s.Scale * size)
				end, styleState, buttonSizeState),
				Position = _Computed(function(v: boolean): UDim2
					return if v then UDim2.fromScale(1, 0.5) else UDim2.fromScale(0, 0.5)
				end, valueState),
				AnchorPoint = _Computed(function(v: boolean): Vector2
					return if v then Vector2.new(1, 0.5) else Vector2.new(0, 0.5)
				end, valueState),
				BackgroundTransparency = _Computed(function(renderData: SwitchRenderData, v: boolean?): number
					return renderData.Button.Transparency
				end, renderDataState, valueState),
				BorderSizePixel = 0,
				BackgroundColor3 = _Computed(function(renderData: SwitchRenderData, v: boolean?): Color3
					return renderData.Button.Color3
				end, renderDataState, valueState),
				Children = {
					_new("UIListLayout")({
						Padding = UDim.new(0, 0),
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						ItemLineAlignment = Enum.ItemLineAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					}),
					_new("UICorner")({
						CornerRadius = UDim.new(0.5, 0),
					}),
					_new("ImageLabel")({
						Size = _Computed(function(s: Style, i: ImageData?): UDim2
							return UDim2.fromOffset(s.Scale * ICON_SIZE_DP, s.Scale * ICON_SIZE_DP)
						end, styleState, iconState),
						BackgroundTransparency = 1,
						ImageTransparency = _Computed(function(renderData: SwitchRenderData): number
							return renderData.Text.Transparency
						end, renderDataState),
						Visible = _Computed(function(i: ImageData?): boolean
							return i ~= nil
						end, iconState),
						ImageColor3 = _Computed(function(renderData: SwitchRenderData): Color3
							return renderData.Text.Color3
						end, renderDataState),
						Image = _Computed(function(i: ImageData?): string
							if i then
								return i.Image
							else
								return ""
							end
						end, iconState),
						ImageRectOffset = _Computed(function(i: ImageData?): Vector2
							return if i then i.ImageRectOffset else Vector2.zero
						end, iconState),
						ImageRectSize = _Computed(function(i: ImageData?): Vector2
							return if i then i.ImageRectSize else Vector2.zero
						end, iconState),
						Children = {
							_new("UICorner")({
								CornerRadius = UDim.new(0.5, 0),
							}),
						},
					}),
				},
			}),
		},
	}) :: GuiObject

	maid.bind(inst)

	return inst
end

return Interface
