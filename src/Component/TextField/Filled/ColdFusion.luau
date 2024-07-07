--!strict
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Base = require(script.Parent.Parent:WaitForChild("Base"))
local Enums = require(_Package:WaitForChild("Enums"))

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
	hightlightColor: Enums.ColorRoleType,
	errorColor: Enums.ColorRoleType,
	borderColor: Enums.ColorRoleType,
	textColor: Enums.ColorRoleType,
	labelColor: Enums.ColorRoleType,

	onSubmit: CanBeState<(text: string?) -> string?>,
	onInput: CanBeState<(((text: string?) -> string?)?)>,
	label: CanBeState<string>,
	initialText: CanBeState<string?>,
	supportingText: CanBeState<string?>,
	icon: CanBeState<ImageData?>,

	characterLimit: CanBeState<number?>,

	isError: CanBeState<boolean?>,
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
		_import(onSubmit, themeDefaults.ON_SUBMIT),
		_import(onInput, themeDefaults.ON_INPUT or function(txt: string?): string?
			return txt
		end),
		_import(initialText, themeDefaults.INITIAL_TEXT),
		_import(isEnabled, if themeDefaults.IS_ENABLED ~= nil then themeDefaults.IS_ENABLED else true),
		_import(isError, if themeDefaults.IS_ERROR ~= nil then themeDefaults.IS_ERROR else true),
		_import(label, themeDefaults.LABEL),
		_import(characterLimit, themeDefaults.CHARACTER_LIMIT),
		_import(supportingText, themeDefaults.SUPPORTING_TEXT),
		_import(icon, themeDefaults.ICON),
		_Computed(function(s: Style): Color3
			return s:GetColor(backgroundColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(hightlightColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(errorColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(borderColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(textColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(labelColor)
		end, styleState),
		_import(elevation, themeDefaults.ELEVATION),
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.BodyLarge)
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.BodySmall)
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
	onSubmit: CanBeState<(text: string?) -> string?>,
	label: CanBeState<string>,
	initialText: CanBeState<string?>,
	onInput: CanBeState<(((text: string?) -> string?)?)>,
	supportingText: CanBeState<string?>,
	icon: CanBeState<ImageData?>,
	characterLimit: CanBeState<number?>,
	isError: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.PRIMARY,
		style,
		Enums.ColorRoleType.SurfaceContainerHighest,
		Enums.ColorRoleType.Primary,
		Enums.ColorRoleType.Error,
		Enums.ColorRoleType.Outline,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnSurfaceVariant,
		onSubmit,
		onInput,
		label,
		initialText,
		supportingText,
		icon,
		characterLimit,
		isError,
		elevation,
		isEnabled
	)
end

function Interface.secondary(
	style: CanBeState<Style>,
	onSubmit: CanBeState<(text: string?) -> string?>,
	label: CanBeState<string>,
	initialText: CanBeState<string?>,
	onInput: CanBeState<(((text: string?) -> string?)?)>,
	supportingText: CanBeState<string?>,
	icon: CanBeState<ImageData?>,
	characterLimit: CanBeState<number?>,
	isError: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.SECONDARY,
		style,
		Enums.ColorRoleType.SurfaceContainerHighest,
		Enums.ColorRoleType.Secondary,
		Enums.ColorRoleType.Error,
		Enums.ColorRoleType.Outline,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnSurfaceVariant,
		onSubmit,
		onInput,
		label,
		initialText,
		supportingText,
		icon,
		characterLimit,
		isError,
		elevation,
		isEnabled
	)
end

function Interface.tertiary(
	style: CanBeState<Style>,
	onSubmit: CanBeState<(text: string?) -> string?>,
	label: CanBeState<string>,
	initialText: CanBeState<string?>,
	onInput: CanBeState<(((text: string?) -> string?)?)>,
	supportingText: CanBeState<string?>,
	icon: CanBeState<ImageData?>,
	characterLimit: CanBeState<number?>,
	isError: CanBeState<boolean?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.TERTIARY,
		style,
		Enums.ColorRoleType.SurfaceContainerHighest,
		Enums.ColorRoleType.Tertiary,
		Enums.ColorRoleType.Error,
		Enums.ColorRoleType.Outline,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnSurfaceVariant,
		onSubmit,
		onInput,
		label,
		initialText,
		supportingText,
		icon,
		characterLimit,
		isError,
		elevation,
		isEnabled
	)
end

function Interface.new(
	onSubmit: CanBeState<(text: string?) -> string?>,
	onInput: CanBeState<(text: string?) -> string?>,
	initialText: CanBeState<string?>,
	isEnabled: CanBeState<boolean>,
	isError: CanBeState<boolean>,
	label: CanBeState<string>,
	characterLimit: CanBeState<number?>,
	supportingText: CanBeState<string?>,
	icon: CanBeState<ImageData?>,
	backgroundColor: CanBeState<Color3>,
	hightlightColor: CanBeState<Color3>,
	errorColor: CanBeState<Color3>,
	borderColor: CanBeState<Color3>,
	textColor: CanBeState<Color3>,
	labelColor: CanBeState<Color3>,
	elevation: CanBeState<number>,
	schemeType: CanBeState<Enums.SchemeType>,
	bodyFontData: CanBeState<FontData>,
	supportFontData: CanBeState<FontData>,
	scale: CanBeState<number>
): GuiObject
	return Base.new(
		if onSubmit ~= nil then onSubmit else DEFAULTS.NEW.ON_SUBMIT,
		if onInput ~= nil then onInput else DEFAULTS.NEW.ON_INPUT,
		if initialText ~= nil then initialText else DEFAULTS.NEW.INITIAL_TEXT,
		if isEnabled ~= nil
			then isEnabled
			elseif DEFAULTS.NEW.IS_ENABLED ~= nil then DEFAULTS.NEW.IS_ENABLED
			else true,
		if isError ~= nil
			then isError
			elseif DEFAULTS.NEW.IS_ERROR ~= nil then DEFAULTS.NEW.IS_ERROR
			else false,
		if label ~= nil then label else DEFAULTS.NEW.LABEL,
		if characterLimit ~= nil then characterLimit else DEFAULTS.NEW.CHARACTER_LIMIT,
		if supportingText ~= nil then supportingText else DEFAULTS.NEW.SUPPORTING_TEXT,
		if icon ~= nil then icon else DEFAULTS.NEW.ICON,
		if textColor ~= nil then textColor else DEFAULTS.NEW.TEXT_COLOR,
		if labelColor ~= nil then labelColor else DEFAULTS.NEW.LABEL_COLOR,
		if hightlightColor ~= nil then hightlightColor else DEFAULTS.NEW.HIGHTLIGHT_COLOR,
		if errorColor ~= nil then errorColor else DEFAULTS.NEW.ERROR_COLOR,
		if backgroundColor ~= nil then backgroundColor else DEFAULTS.NEW.BACKGROUND_COLOR,
		if borderColor ~= nil then borderColor else DEFAULTS.NEW.BORDER_COLOR,
		if labelColor ~= nil then labelColor else DEFAULTS.NEW.LABEL_COLOR,
		if elevation ~= nil then elevation else DEFAULTS.NEW.ELEVATION,
		false,
		if schemeType ~= nil then schemeType else DEFAULTS.NEW.SCHEME_TYPE,
		if bodyFontData ~= nil then bodyFontData else DEFAULTS.NEW.BODY_FONT_DATA,
		if supportFontData ~= nil then supportFontData else DEFAULTS.NEW.SUPPORT_FONT_DATA,
		if scale ~= nil then scale else DEFAULTS.NEW.SCALE
	)
end

return Interface
