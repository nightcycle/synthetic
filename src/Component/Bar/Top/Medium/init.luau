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
local TopBase = require(script.Parent:WaitForChild("Base"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
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
	title: CanBeState<string>,
	buttons: CanBeState<{
		[number]: ButtonData
	}>,
	navigation: CanBeState<ButtonData?>,
	backgroundColor: CanBeState<Color3>,
	textColor: CanBeState<Color3>,
	elevation: CanBeState<number>,
	style: CanBeState<Style>
): GuiObject

	return TopBase.component(
		title,
		buttons,
		navigation,
		"Medium",
		backgroundColor,
		textColor,
		elevation,
		style
	)
end

return Interface
