--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _Package = script
local _Packages = _Package.Parent
-- Services
-- Packages
-- Modules
local Util = require(ReplicatedStorage.Packages.synthetic.Util)
local Types = require(_Package:WaitForChild("Types"))

-- Types
export type ThemeData = Types.ThemeData
export type ImageData = Types.ImageData
export type Style = Types.Style
export type TextStyle = Types.TextStyle
export type ToggleTextStyle = Types.ToggleTextStyle
export type OptionData = Types.OptionData
-- Constants
-- Variables
-- References
local Component = _Package:WaitForChild("Component")
-- Private Functions
-- Class
local Synthetic = {}

Synthetic.Enums = require(_Package:WaitForChild("Enums"))
Synthetic.Sounds = require(_Package:WaitForChild("Sounds"))
Synthetic.Types = Types
Synthetic.Util = require(_Package:WaitForChild("Util"))
Synthetic.Components = {
	Bar = {
		Bottom = require(Component:WaitForChild("Bar"):WaitForChild("Bottom")),
	},
	Button = {
		Badge = require(Component:WaitForChild("Button"):WaitForChild("Badge")),
		ElevatedButton = require(Component:WaitForChild("Button"):WaitForChild("ElevatedButton")),
		ExtendedFAB = require(Component:WaitForChild("Button"):WaitForChild("ExtendedFAB")),
		FAB = require(Component:WaitForChild("Button"):WaitForChild("FAB")),
		FilledButton = require(Component:WaitForChild("Button"):WaitForChild("FilledButton")),
		FilledIconButton = require(Component:WaitForChild("Button"):WaitForChild("FilledIconButton")),
		IconButton = require(Component:WaitForChild("Button"):WaitForChild("IconButton")),
		Outlined = require(Component:WaitForChild("Button"):WaitForChild("OutlinedButton")),
		OutlinedIcon = require(Component:WaitForChild("Button"):WaitForChild("OutlinedIconButton")),
		Segmented = require(Component:WaitForChild("Button"):WaitForChild("Segmented")),
		Text = require(Component:WaitForChild("Button"):WaitForChild("TextButton")),
	},
}


return Synthetic
