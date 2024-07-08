--!strict
local _Package = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local TopBase = require(script.Parent.Parent:WaitForChild("Base"))
local Enums = require(_Package:WaitForChild("Enums"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type ImageData = Types.ImageData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type Style = Style.Style
type FontData = Types.FontData
-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))

-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

function newThemedComponent(
	themeDefaults: typeof(DEFAULTS.PRIMARY),
	style: CanBeState<Style>,

	backgroundColor: Enums.ColorRoleType,
	textColor: Enums.ColorRoleType,

	title: CanBeState<string>,
	buttons: CanBeState<{ ButtonData }>,
	navigation: CanBeState<ButtonData?>,
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
		_import(title, themeDefaults.TITLE),
		_import(buttons, themeDefaults.BUTTONS),
		_import(navigation, themeDefaults.NAVIGATION),
		_Computed(function(s: Style): Color3
			return s:GetColor(backgroundColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(textColor)
		end, styleState),
		_import(elevation, themeDefaults.ELEVATION or 0),
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.TitleLarge)
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.HeadlineMedium)
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
	title: CanBeState<string>,
	buttons: CanBeState<{ ButtonData }>,
	navigation: CanBeState<ButtonData?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.PRIMARY,
		style,
		Enums.ColorRoleType.Primary,
		Enums.ColorRoleType.OnPrimary,
		title,
		buttons,
		navigation,
		elevation
	)
end

function Interface.secondary(
	style: CanBeState<Style>,
	title: CanBeState<string>,
	buttons: CanBeState<{ ButtonData }>,
	navigation: CanBeState<ButtonData?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.SECONDARY,
		style,
		Enums.ColorRoleType.Secondary,
		Enums.ColorRoleType.OnSecondary,
		title,
		buttons,
		navigation,
		elevation
	)
end

function Interface.tertiary(
	style: CanBeState<Style>,
	title: CanBeState<string>,
	buttons: CanBeState<{ ButtonData }>,
	navigation: CanBeState<ButtonData?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.TERTIARY,
		style,
		Enums.ColorRoleType.Tertiary,
		Enums.ColorRoleType.OnTertiary,
		title,
		buttons,
		navigation,
		elevation
	)
end

function Interface.new(
	title: CanBeState<string>,
	buttons: CanBeState<{ ButtonData }>,
	navigation: CanBeState<ButtonData?>,
	backgroundColor: CanBeState<Color3>,
	textColor: CanBeState<Color3>,
	elevation: CanBeState<number>,
	schemeType: CanBeState<Enums.SchemeType>,
	titleFontData: CanBeState<FontData>,
	subHeadingFontData: CanBeState<FontData>,
	buttonFontData: CanBeState<FontData>,
	scale: CanBeState<number>
): GuiObject
	return TopBase.new(
		if title then title else DEFAULTS.NEW.TITLE,
		if buttons then buttons else DEFAULTS.NEW.BUTTONS,
		if navigation then navigation else DEFAULTS.NEW.NAVIGATION,
		"Center",
		if backgroundColor then backgroundColor else DEFAULTS.NEW.BACKGROUND_COLOR,
		if textColor then textColor else DEFAULTS.NEW.TEXT_COLOR,
		if elevation then elevation elseif DEFAULTS.NEW.ELEVATION then DEFAULTS.NEW.ELEVATION else 0,
		if schemeType then schemeType else DEFAULTS.NEW.SCHEME_TYPE,
		if titleFontData then titleFontData else DEFAULTS.NEW.TITLE_FONT_DATA,
		if subHeadingFontData then subHeadingFontData else DEFAULTS.NEW.SUB_HEADING_FONT_DATA,
		if buttonFontData then buttonFontData else DEFAULTS.NEW.BUTTON_FONT_DATA,
		if scale then scale else DEFAULTS.NEW.SCALE
	)
end

return Interface
