--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Base = require(script.Parent:WaitForChild("Base"))
local Util = require(_Package:WaitForChild("Util"))
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))

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
type Method = () -> ()
type OptionConstructor = Base.OptionConstructor

-- Constants
local PADDING_DP = 8
local CORNER_DP = 4

local TEXT_FONT_TYPE = Enums.FontType.LabelLarge
-- Variables
-- References
local Icons = MaterialIcons.default.dp_48.scale_1

-- Private Functions

-- Class
local Interface = {}

Interface.ColdFusion = {}

function Interface.ColdFusion.new(
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> {[number]: string}>,
	optionConstructor: CanBeState<OptionConstructor?>,
	textColor: CanBeState<Color3>,
	backgroundColor: CanBeState<Color3>,
	elevation: CanBeState<number>,
	style: CanBeState<Style>
): GuiObject

	return Base.newBar(
		true,
		onInputEntered,
		label,
		optionSolver,
		optionConstructor,
		textColor,
		backgroundColor,
		elevation,
		style
	)
end

return Interface
