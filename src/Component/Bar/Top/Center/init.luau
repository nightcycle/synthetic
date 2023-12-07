--!strict
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local TopBase = require(script.Parent:WaitForChild("Base"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type TextStyle = Types.TextStyle
type ToggleTextStyle = Types.ToggleTextStyle
type ImageData = Types.ImageData
type ThemeData = Types.ThemeData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
-- Constants
-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

function Interface.cfusion(
	title: CanBeState<string>,
	buttons: CanBeState<{
		[number]: ButtonData
	}>,
	fab: CanBeState<ButtonData>,
	theme: CanBeState<ThemeData>
): Frame

	return TopBase.cfusion(
		title,
		buttons,
		fab,
		theme,
		"Center"
	)
end

return Interface
