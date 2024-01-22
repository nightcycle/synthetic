--!strict
local _Package = script.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
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

-- Constants

-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

function newThemedComponent(
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

	local styleState: State<Style> = _import(style, nil :: any)

	local out = Interface.ColdFusion.new(
		onSubmit,
		_import(onInput, function(txt: string?): string?
			return txt
		end),
		initialText,
		_import(isEnabled, true),
		_import(isError, false),
		label,
		characterLimit,
		supportingText,
		icon,
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
		_import(elevation, 0),
		styleState
	)

	maid.bind(out)

	return out
end

Interface.ColdFusion = {}

function Interface.ColdFusion.primary(
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

function Interface.ColdFusion.secondary(
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

function Interface.ColdFusion.tertiary(
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

function Interface.ColdFusion.new(
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
	style: CanBeState<Style>
): GuiObject
	return Base.new(
		onSubmit,
		onInput,
		initialText,
		isEnabled,
		isError,
		label,
		characterLimit,
		supportingText,
		icon,
		textColor,
		labelColor,
		hightlightColor,
		errorColor,
		backgroundColor,
		borderColor,
		labelColor,
		elevation,
		style,
		false
	)
end

return Interface
