--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Base = require(script.Parent:WaitForChild("Base"))

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
Interface.ColdFusion = {}

function Interface.ColdFusion.new(
	onSubmit: (text: string?) -> string?,
	onInput: (text: string?) -> string?,
	initialText: CanBeState<string?>,
	isEnabled: CanBeState<boolean>,
	isError: CanBeState<boolean>,
	label: CanBeState<string>,
	isMultiLine: CanBeState<boolean>,
	characterLimit: CanBeState<number?>,
	supportingText: CanBeState<string?>,
	leadingIcon: CanBeState<ImageData?>,
	dropdownOptions: CanBeState<{[number]: string}?>,
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
		isMultiLine,
		characterLimit,
		supportingText,
		leadingIcon,
		dropdownOptions,
		textColor,
		labelColor,
		hightlightColor,
		errorColor,
		borderColor,
		borderColor,
		labelColor,
		elevation,
		style,
		true
	)
end

return Interface
