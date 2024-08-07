--!strict
local _Package = script.Parent.Parent.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Icons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local IconButton = require(
	_Package
		:WaitForChild("Component")
		:WaitForChild("Button")
		:WaitForChild("IconButton")
		:WaitForChild("ColdFusion")
)
local FAB = require(
	_Package:WaitForChild("Component"):WaitForChild("Button"):WaitForChild("FAB"):WaitForChild("ColdFusion")
)
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
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
local MAX_BUTTONS = 4
local ERROR_ICON = Icons.error
local BUTTON_SEPARATION_DP = 10
local BAR_TOP_BOTTOM_PADDING_DP = 6
local BAR_LEFT_RIGHT_PADDING_DP = 10
-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

function newThemedComponent(
	themeDefaults: typeof(DEFAULTS.PRIMARY),
	style: CanBeState<Style>,

	backgroundColor: Enums.ColorRoleType,
	iconColor: Enums.ColorRoleType,
	fabColor: Enums.ColorRoleType,
	fabIconColor: Enums.ColorRoleType,

	buttons: CanBeState<{ ButtonData }>,
	fab: CanBeState<ButtonData?>,
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

	local styleState: State<Style> = _import(style, themeDefaults.STYLE)

	local out = Interface.new(
		_import(buttons, themeDefaults.BUTTONS),
		_import(fab, themeDefaults.FAB),
		_Computed(function(s: Style): Color3
			return s:GetColor(backgroundColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(iconColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(fabColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(fabIconColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Shadow)
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

Interface = {}

function Interface.primary(
	style: CanBeState<Style>,
	buttons: CanBeState<{ ButtonData }>,
	fab: CanBeState<ButtonData?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.PRIMARY,
		style,
		Enums.ColorRoleType.Primary,
		Enums.ColorRoleType.OnPrimary,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.PrimaryContainer,
		buttons,
		fab,
		elevation
	)
end

function Interface.secondary(
	style: CanBeState<Style>,
	buttons: CanBeState<{ ButtonData }>,
	fab: CanBeState<ButtonData?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.SECONDARY,
		style,
		Enums.ColorRoleType.Secondary,
		Enums.ColorRoleType.OnSecondary,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.SecondaryContainer,
		buttons,
		fab,
		elevation
	)
end

function Interface.tertiary(
	style: CanBeState<Style>,
	buttons: CanBeState<{ ButtonData }>,
	fab: CanBeState<ButtonData?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.TERTIARY,
		style,
		Enums.ColorRoleType.Tertiary,
		Enums.ColorRoleType.OnTertiary,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.TertiaryContainer,
		buttons,
		fab,
		elevation
	)
end

function Interface.new(
	buttons: CanBeState<{ ButtonData }>,
	fab: CanBeState<ButtonData?>,
	backgroundColor: CanBeState<Color3>,
	iconColor: CanBeState<Color3>,
	fabColor: CanBeState<Color3>,
	fabIconColor: CanBeState<Color3>,
	fabShadowColor: CanBeState<Color3>,
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

	local buttonsState: State<{ ButtonData }> = _import(buttons, DEFAULTS.NEW.BUTTONS)

	local scaleState: State<number> = _import(scale, DEFAULTS.NEW.SCALE)
	local schemeTypeState: State<Enums.SchemeType> = _import(schemeType, DEFAULTS.NEW.SCHEME_TYPE)
	local fontDataState: State<FontData> = _import(fontData, DEFAULTS.NEW.FONT_DATA)

	local backgroundColorState: State<Color3> = _import(backgroundColor, DEFAULTS.NEW.BACKGROUND_COLOR)
	local elevationState: State<number> = _import(elevation, DEFAULTS.NEW.ELEVATION)

	local fabState: State<ButtonData?> = _import(fab, DEFAULTS.NEW.FAB)

	local inst = _new("Frame")({
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = _Computed(function(color: Color3, e: number, st: Enums.SchemeType): Color3
			return Theme.getElevatedColor(color, e, st)
		end, backgroundColorState, elevationState, schemeTypeState),
		Children = {
			_new("UIListLayout")({
				Padding = _Computed(function(s: number): UDim
					return UDim.new(0, 0)
				end, scaleState),
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			_new("UIPadding")({
				PaddingLeft = _Computed(function(s: number): UDim
					return UDim.new(0, BAR_LEFT_RIGHT_PADDING_DP * s)
				end, scaleState),
				PaddingRight = _Computed(function(s: number): UDim
					return UDim.new(0, BAR_LEFT_RIGHT_PADDING_DP * s)
				end, scaleState),
				PaddingTop = _Computed(function(s: number): UDim
					return UDim.new(0, BAR_TOP_BOTTOM_PADDING_DP * s)
				end, scaleState),
				PaddingBottom = _Computed(function(s: number): UDim
					return UDim.new(0, BAR_TOP_BOTTOM_PADDING_DP * s)
				end, scaleState),
			}),
		},
	}) :: Frame

	_new("Frame")({
		AutomaticSize = Enum.AutomaticSize.XY,
		Parent = inst,
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		Children = {
			_new("UIListLayout")({
				Padding = _Computed(function(s: number): UDim
					return UDim.new(0, s * BUTTON_SEPARATION_DP)
				end, scaleState),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
			}),
			_bind(FAB.new(
				_Computed(function(fData: ButtonData?)
					return if fData then fData.OnClick else function() end
				end, fabState),
				_Computed(function(fData: ButtonData?): ImageData
					return if fData and fData.Icon then fData.Icon else ERROR_ICON
				end, fabState),
				fabIconColor,
				fabColor,
				fabIconColor,
				fabColor,
				fabShadowColor,
				_Computed(function(fData: ButtonData?): boolean
					return if fData then fData.Enabled else false
				end, fabState),
				_Computed(function(e: number): number
					return e + 1
				end, elevationState),
				schemeTypeState,
				fontDataState,
				scaleState
			))({
				Visible = _Computed(function(fData: ButtonData?): boolean
					return if fData then fData.Enabled else false
				end, fabState),
				Parent = inst,
			}),
		},
	})

	local buttonContainer = _new("Frame")({
		AutomaticSize = Enum.AutomaticSize.XY,
		Parent = inst,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Children = {
			_new("UIListLayout")({
				Padding = _Computed(function(s: number): UDim
					return UDim.new(0, s * BUTTON_SEPARATION_DP)
				end, scaleState),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
			}),
		},
	}) :: Frame

	for i = 1, MAX_BUTTONS do
		local buttonData = _Computed(function(bs: { ButtonData }): ButtonData?
			return bs[i]
		end, buttonsState)

		_bind(IconButton.new(
			_Computed(function(bData: ButtonData?)
				return if bData then bData.OnClick else function() end
			end, buttonData),
			_Computed(function(bData: ButtonData?): ImageData
				return if bData and bData.Icon then bData.Icon else ERROR_ICON
			end, buttonData),
			iconColor,
			iconColor,
			_Computed(function(bData: ButtonData?): boolean
				return if bData then bData.Enabled else false
			end, buttonData),
			elevationState,
			schemeTypeState,
			fontDataState,
			scaleState
		))({
			LayoutOrder = i,
			Visible = _Computed(function(bData: ButtonData?): boolean
				return if bData then bData.Enabled else false
			end, buttonData),
			Parent = buttonContainer,
		})
	end

	return inst
end

return Interface
