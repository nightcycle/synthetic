--!strict
local _Package = script.Parent.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Icons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Base = require(script.Parent.Parent:WaitForChild("Base"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type Style = Style.Style
type ImageData = Types.ImageData
type FontData = Types.FontData

-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
-- Variables
-- References

-- Private Functions

-- Class
local Interface = {}
Interface = {}

function newThemedComponent(
	themeDefaults: typeof(DEFAULTS.PRIMARY),
	style: CanBeState<Style>,
	textColor: Enums.ColorRoleType,
	disabledTextColor: Enums.ColorRoleType,
	fillTextColor: Enums.ColorRoleType,
	disabledFillTextColor: Enums.ColorRoleType,
	disabledFillColor: Enums.ColorRoleType,
	onClick: CanBeState<(isSelected: boolean) -> ()>,
	isInitiallySelected: CanBeState<boolean>,
	text: CanBeState<string>,
	isEnabled: CanBeState<boolean?>,
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
		_import(onClick, themeDefaults.ON_CLICK),
		_import(isInitiallySelected, themeDefaults.IS_INITIALLY_SELECTED),
		_import(text, themeDefaults.TEXT),
		_Computed(function(s: Style): Color3
			return s:GetColor(textColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(disabledTextColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(fillTextColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(disabledFillTextColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(disabledFillColor)
		end, styleState),
		_import(isEnabled, themeDefaults.IS_ENABLED),
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
	onClick: CanBeState<(isSelected: boolean) -> ()>,
	text: CanBeState<string>,
	isInitiallySelected: CanBeState<boolean>,
	isEnabled: CanBeState<boolean?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.PRIMARY,
		style,
		Enums.ColorRoleType.Primary,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnPrimary,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SurfaceVariant,
		onClick,
		isInitiallySelected,
		text,
		isEnabled,
		elevation
	)
end

function Interface.secondary(
	style: CanBeState<Style>,
	onClick: CanBeState<(isSelected: boolean) -> ()>,
	text: CanBeState<string>,
	isInitiallySelected: CanBeState<boolean>,
	isEnabled: CanBeState<boolean?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.SECONDARY,
		style,
		Enums.ColorRoleType.Secondary,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnSecondary,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SurfaceVariant,
		onClick,
		isInitiallySelected,
		text,
		isEnabled,
		elevation
	)
end

function Interface.tertiary(
	style: CanBeState<Style>,
	onClick: CanBeState<(isSelected: boolean) -> ()>,
	text: CanBeState<string>,
	isInitiallySelected: CanBeState<boolean>,
	isEnabled: CanBeState<boolean?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.TERTIARY,
		style,
		Enums.ColorRoleType.Tertiary,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnTertiary,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SurfaceVariant,
		onClick,
		isInitiallySelected,
		text,
		isEnabled,
		elevation
	)
end

function Interface.new(
	onClick: CanBeState<(isSelected: boolean) -> ()>,
	isInitiallySelected: CanBeState<boolean>,
	text: CanBeState<string>,
	textColor: CanBeState<Color3>,
	disabledTextColor: CanBeState<Color3>,
	fillTextColor: CanBeState<Color3>,
	disabledFillTextColor: CanBeState<Color3>,
	disabledFillColor: CanBeState<Color3>,
	isEnabled: CanBeState<boolean>,
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

	local isInitiallySelectedState = _import(isInitiallySelected, DEFAULTS.NEW.IS_INITIALLY_SELECTED)
	local isSelectedState = _Value(isInitiallySelectedState:Get())
	local onClickState = _import(onClick, DEFAULTS.NEW.ON_CLICK)
	local button = Base.new(
		function(isSelected: boolean)
			local click = onClickState:Get()
			isSelectedState:Set(isSelected)
			click(isSelected)
		end,
		isInitiallySelectedState,
		_import(text, DEFAULTS.NEW.TEXT),
		_Computed(function(isSel: boolean): ImageData?
			return if isSel then Icons.check else nil
		end, isSelectedState),
		_import(scale, DEFAULTS.NEW.SCALE),
		_import(fontData, DEFAULTS.NEW.FONT_DATA),
		_import(schemeType, DEFAULTS.NEW.SCHEME_TYPE),
		_import(textColor, DEFAULTS.NEW.TEXT_COLOR),
		_import(disabledTextColor, DEFAULTS.NEW.DISABLED_TEXT_COLOR),
		_import(fillTextColor, DEFAULTS.NEW.FILL_TEXT_COLOR),
		_import(disabledFillTextColor, DEFAULTS.NEW.DISABLED_FILL_TEXT_COLOR),
		_import(textColor, DEFAULTS.NEW.TEXT_COLOR),
		_import(disabledFillColor, DEFAULTS.NEW.DISABLED_FILL_COLOR),
		_import(isEnabled, DEFAULTS.NEW.IS_ENABLED),
		_import(elevation, DEFAULTS.NEW.ELEVATION)
	)

	maid:GiveTask(button.Destroying:Connect(function()
		maid:Destroy()
	end))

	return button
end

return Interface
