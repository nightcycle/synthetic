--!strict
local _Package = script.Parent.Parent.Parent
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
local Theme = require(_Package:WaitForChild("Theme"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type ImageData = Types.ImageData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type Style = Style.Style
type FontData = Types.FontData

-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
local ICONS = MaterialIcons.default.dp_48.scale_1
local CHECK_ICON = ICONS.check
local DASH_ICON = ICONS.remove
local LAYER_SIZE_DP = 40
local CHECKBOX_SIZE_DP = 18
local CHECKBOX_SHAPE_DP = 2
local UNSELECT_OUTLINE_WIDTH_DP = 2
-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

function newThemedComponent(
	themeDefaults: typeof(DEFAULTS.PRIMARY),
	style: CanBeState<Style>,
	outlineColor: Enums.ColorRoleType,
	fillColor: Enums.ColorRoleType,
	iconColor: Enums.ColorRoleType,
	disabledColor: Enums.ColorRoleType,
	onSelect: CanBeState<(isSelected: boolean?) -> ()>,
	initialSelection: CanBeState<boolean?>,
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

	local styleState: State<Style> = _import(style, themeDefaults.STYLE)

	local out = Interface.new(
		_import(onSelect, themeDefaults.ON_SELECT or function(isSelected: boolean?) end),
		_import(initialSelection, themeDefaults.INITIAL_SELECTION),
		_import(isEnabled, themeDefaults.IS_ENABLED),
		_Computed(function(s: Style): Color3
			return s:GetColor(outlineColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(fillColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(iconColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(disabledColor)
		end, styleState),
		_import(elevation, themeDefaults.ELEVATION),
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)

	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.primary(
	style: CanBeState<Style>,
	onSelect: CanBeState<(isSelected: boolean?) -> ()>,
	initialSelection: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.PRIMARY,
		style,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.Primary,
		Enums.ColorRoleType.OnPrimary,
		Enums.ColorRoleType.OnSurface,
		onSelect,
		initialSelection,
		elevation,
		isEnabled
	)
end

function Interface.secondary(
	style: CanBeState<Style>,
	onSelect: CanBeState<(isSelected: boolean?) -> ()>,
	initialSelection: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.SECONDARY,
		style,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.Secondary,
		Enums.ColorRoleType.OnSecondary,
		Enums.ColorRoleType.OnSurface,
		onSelect,
		initialSelection,
		elevation,
		isEnabled
	)
end

function Interface.tertiary(
	style: CanBeState<Style>,
	onSelect: CanBeState<(isSelected: boolean?) -> ()>,
	initialSelection: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.TERTIARY,
		style,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.Tertiary,
		Enums.ColorRoleType.OnTertiary,
		Enums.ColorRoleType.OnSurface,
		onSelect,
		initialSelection,
		elevation,
		isEnabled
	)
end

function Interface.primaryContainer(
	style: CanBeState<Style>,
	onSelect: CanBeState<(isSelected: boolean?) -> ()>,
	initialSelection: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.PRIMARY_CONTAINER,
		style,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.PrimaryContainer,
		Enums.ColorRoleType.OnPrimaryContainer,
		Enums.ColorRoleType.OnSurface,
		onSelect,
		initialSelection,
		elevation,
		isEnabled
	)
end

function Interface.secondaryContainer(
	style: CanBeState<Style>,
	onSelect: CanBeState<(isSelected: boolean?) -> ()>,
	initialSelection: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.SECONDARY_CONTAINER,
		style,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SecondaryContainer,
		Enums.ColorRoleType.OnSecondaryContainer,
		Enums.ColorRoleType.OnSurface,
		onSelect,
		initialSelection,
		elevation,
		isEnabled
	)
end

function Interface.tertiaryContainer(
	style: CanBeState<Style>,
	onSelect: CanBeState<(isSelected: boolean?) -> ()>,
	initialSelection: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.TERTIARY_CONTAINER,
		style,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.TertiaryContainer,
		Enums.ColorRoleType.OnTertiaryContainer,
		Enums.ColorRoleType.OnSurface,
		onSelect,
		initialSelection,
		elevation,
		isEnabled
	)
end

function Interface.new(
	onSelect: CanBeState<(isSelected: boolean?) -> ()>,
	initialSelection: CanBeState<boolean?>,
	isEnabled: CanBeState<boolean>,
	outlineColor: CanBeState<Color3>,
	fillColor: CanBeState<Color3>,
	iconColor: CanBeState<Color3>,
	disabledColor: CanBeState<Color3>,
	elevation: CanBeState<number>,
	schemeType: CanBeState<Enums.SchemeType>,
	fontData: CanBeState<FontData>,
	scale: CanBeState<number>
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local scaleState: State<number> = _import(scale, DEFAULTS.NEW.SCALE)
	local schemeTypeState: State<Enums.SchemeType> = _import(schemeType, DEFAULTS.NEW.SCHEME_TYPE)
	local fontDataState: State<FontData> = _import(fontData, DEFAULTS.NEW.FONT_DATA)

	local initialSelectionState = _import(initialSelection, DEFAULTS.NEW.INITIAL_SELECTION)
	local outlineColorState = _import(outlineColor, DEFAULTS.NEW.OUTLINE_COLOR)
	local fillColorState = _import(fillColor, DEFAULTS.NEW.FILL_COLOR)
	local disabledColorState = _import(disabledColor, DEFAULTS.NEW.DISABLED_COLOR)
	local iconColorState = _import(iconColor, DEFAULTS.NEW.ICON_COLOR)
	local elevationState = _import(elevation, DEFAULTS.NEW.ELEVATION)
	local isEnabledState = _import(isEnabled, DEFAULTS.NEW.IS_ENABLED)
	local onSelectState = _import(onSelect, DEFAULTS.NEW.ON_SELECT)

	local clickCountState = _Value(0)
	local hasClicked = _Value(false)

	initialSelectionState:Connect(function()
		hasClicked:Set(false)
	end)

	local valueState = _Computed(function(initial: boolean?, count: number, hasClick: boolean): boolean?
		if initial == nil then
			initial = false
			if count == 0 and hasClick == false then
				return nil
			end
		end
		if count % 2 == 0 then
			return initial
		else
			return not initial
		end
	end, initialSelectionState, clickCountState, hasClicked)

	local renderDatasState = _Computed(
		function(
			st: Enums.SchemeType,
			sc: number,
			f: FontData,
			oC: Color3,
			fC: Color3,
			iC: Color3,
			dC: Color3,
			e: number
		): { [Enums.ButtonStateType]: RenderData }
			return {
				[Enums.ButtonStateType.Enabled] = Types._RenderData.new(
					sc,
					Types._AppearanceData.new(Theme.getElevatedColor(oC, e, st), 0),
					Types._AppearanceData.new(Theme.getElevatedColor(fC, e, st), 1),
					Types._AppearanceData.new(Theme.getElevatedColor(iC, e, st), 0),
					nil,
					nil,
					nil,
					nil
				),
				[Enums.ButtonStateType.Disabled] = Types._RenderData.new(
					sc,
					Types._AppearanceData.new(Theme.getElevatedColor(dC, e, st), 1 - 0.38),
					Types._AppearanceData.new(Theme.getElevatedColor(dC, e, st), 1),
					Types._AppearanceData.new(Theme.getElevatedColor(dC, e, st), 1 - 0.38),
					nil,
					nil,
					nil,
					nil
				),
				[Enums.ButtonStateType.Hovered] = Types._RenderData.new(
					sc,
					Types._AppearanceData.new(Theme.getElevatedColor(oC, e + 1, st), 0),
					Types._AppearanceData.new(Theme.getElevatedColor(fC, e + 1, st), 1 - 0.08),
					Types._AppearanceData.new(Theme.getElevatedColor(iC, e + 1, st), 0),
					nil,
					nil,
					nil,
					nil
				),
				[Enums.ButtonStateType.Focused] = Types._RenderData.new(
					sc,
					Types._AppearanceData.new(Theme.getElevatedColor(oC, e, st), 0),
					Types._AppearanceData.new(Theme.getElevatedColor(fC, e, st), 1 - 0.1),
					Types._AppearanceData.new(Theme.getElevatedColor(iC, e, st), 0),
					nil,
					nil,
					nil,
					nil
				),
				[Enums.ButtonStateType.Pressed] = Types._RenderData.new(
					sc,
					Types._AppearanceData.new(Theme.getElevatedColor(oC, e - 1, st), 0),
					Types._AppearanceData.new(Theme.getElevatedColor(fC, e - 1, st), 1 - 0.1),
					Types._AppearanceData.new(Theme.getElevatedColor(iC, e - 1, st), 0),
					nil,
					nil,
					nil,
					nil
				),
			}
		end,
		schemeTypeState,
		scaleState,
		fontDataState,
		outlineColorState,
		fillColorState,
		iconColorState,
		disabledColorState,
		elevationState
	)

	local isFocusedState = _Value(false)
	local isPressedState = _Value(false)
	local isHoveredState = _Value(false)

	local iconImageState = _Computed(function(v: boolean?): ImageData
		if v == nil then
			return DASH_ICON
		elseif v == true then
			return CHECK_ICON
		else
			return Types.ImageData.new("")
		end
	end, valueState)

	local currentStateState = _Computed(
		function(
			isEnab: boolean,
			isFocused: boolean,
			isPressed: boolean,
			isHovered: boolean
		): Enums.ButtonStateType
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
			renderDatas: { [Enums.ButtonStateType]: RenderData },
			bState: Enums.ButtonStateType
		): RenderData
			return renderDatas[bState]
		end,
		renderDatasState,
		currentStateState
	)

	local inst = _new("ImageButton")({
		Name = "Checkbox",
		Size = _Computed(function(sc: number): UDim2
			return UDim2.fromOffset(sc * LAYER_SIZE_DP, sc * LAYER_SIZE_DP)
		end, scaleState),
		BackgroundColor3 = _Computed(function(data: RenderData): Color3
			return data.Background.Color3
		end, renderDataState),
		BackgroundTransparency = _Computed(function(data: RenderData): number
			return data.Background.Transparency
		end, renderDataState),
		Events = {
			Activated = function()
				if isEnabledState:Get() == false then
					return
				end
				hasClicked:Set(true)
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
			MouseButton1Down = function()
				if isEnabledState:Get() == false then
					return
				end
				isPressedState:Set(true)
			end,
			MouseButton1Up = function()
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
			_new("UICorner")({
				CornerRadius = UDim.new(0.5, 0),
			}),
			_new("UIListLayout")({
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			_new("ImageLabel")({
				Size = _Computed(function(sc: number): UDim2
					local dpWidth = CHECKBOX_SIZE_DP - (UNSELECT_OUTLINE_WIDTH_DP * 2)
					return UDim2.fromOffset(sc * dpWidth, sc * dpWidth)
				end, scaleState),
				BackgroundTransparency = _Computed(function(v: boolean?, enab: boolean): number
					return if enab then if v == false then 1 else 0 else 1
				end, valueState, isEnabledState),
				ImageTransparency = _Computed(function(v: boolean?): number
					return if v == false then 1 else 0
				end, valueState),
				BackgroundColor3 = _Computed(function(renderData: RenderData): Color3
					return renderData.Background.Color3
				end, renderDataState),
				ImageColor3 = _Computed(function(renderData: RenderData, enab: boolean): Color3
					return if not enab
						then renderData.Border.Color3
						else if renderData.Text then renderData.Text.Color3 else Color3.new(1, 1, 1)
				end, renderDataState, isEnabledState),
				Image = _Computed(function(i: ImageData?): string
					if i then
						return i.Image
					else
						return ""
					end
				end, iconImageState),
				ImageRectOffset = _Computed(function(i: ImageData?): Vector2
					return if i then i.ImageRectOffset else Vector2.zero
				end, iconImageState),
				ImageRectSize = _Computed(function(i: ImageData?): Vector2
					return if i then i.ImageRectSize else Vector2.zero
				end, iconImageState),
				Children = {
					_new("UICorner")({
						CornerRadius = _Computed(function(sc: number): UDim
							return UDim.new(0, sc * CHECKBOX_SHAPE_DP)
						end, scaleState),
					}),
					_new("UIStroke")({
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = _Computed(function(renderData: RenderData, v: boolean?): Color3
							return if v == false
								then renderData.Border.Color3
								else renderData.Background.Color3
						end, renderDataState, valueState),
						LineJoinMode = Enum.LineJoinMode.Round,
						Thickness = _Computed(function(sc: number): number
							return sc * UNSELECT_OUTLINE_WIDTH_DP
						end, scaleState),
						Transparency = _Computed(function(renderData: RenderData): number
							return renderData.Border.Transparency
						end, renderDataState),
					}),
				},
			}),
		},
	}) :: GuiObject

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	return inst
end

return Interface
