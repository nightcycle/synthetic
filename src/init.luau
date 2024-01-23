--!strict
local _Package = script
local _Packages = _Package.Parent
-- Services
-- Packages
-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))

-- Types
export type ImageData = Types.ImageData
export type OptionData = Types.OptionData
export type Style = Style.Style
export type Typography = Style.Typography
-- Constants
-- Variables
-- References
local Component = _Package:WaitForChild("Component")
-- Private Functions
-- Class
local Synthetic = {}

Synthetic.Enums = require(_Package:WaitForChild("Enums"))
Synthetic.Sounds = require(_Package:WaitForChild("Sounds"))
Synthetic.Util = require(_Package:WaitForChild("Util"))
Synthetic.Transition = require(_Package:WaitForChild("Transition"))
Synthetic.Types = {
	newButtonData = Types.newButtonData,
	newOptionData = Types.newOptionData,
	newImageData = Types.newImageData,
}
Synthetic.Style = Style
Synthetic.Component = {
	Dialog = require(Component:WaitForChild("Dialog")),
	Menu = {
		Row = {
			Tabs = nil,
			Segmented = require(Component:WaitForChild("Menu"):WaitForChild("Row"):WaitForChild("Segmented")),
			Bar = {
				Bottom = require(Component:WaitForChild("Menu"):WaitForChild("Row"):WaitForChild("Bar"):WaitForChild("Bottom")),
				Navigation = nil,
				Top = {
					Center = require(Component:WaitForChild("Menu"):WaitForChild("Row"):WaitForChild("Bar"):WaitForChild("Top"):WaitForChild("Center")),
					Large = require(Component:WaitForChild("Menu"):WaitForChild("Row"):WaitForChild("Bar"):WaitForChild("Top"):WaitForChild("Large")),
					Medium = require(Component:WaitForChild("Menu"):WaitForChild("Row"):WaitForChild("Bar"):WaitForChild("Top"):WaitForChild("Medium")),
					Small = require(Component:WaitForChild("Menu"):WaitForChild("Row"):WaitForChild("Bar"):WaitForChild("Top"):WaitForChild("Small")),
				},
			},
		},
		Column = {
			Drawer = nil,
			Rail = nil,
			PopUp = nil,
		},
	},
	ProgressIndicator = {
		Circular = require(Component:WaitForChild("ProgressIndicator"):WaitForChild("Circular")),
		Linear = nil,
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
		Text = require(Component:WaitForChild("Button"):WaitForChild("TextButton")),
		Chip = {
			Filter = require(Component:WaitForChild("Button"):WaitForChild("Chip"):WaitForChild("Filter")),
			Assist = require(Component:WaitForChild("Button"):WaitForChild("Chip"):WaitForChild("Assist")),
		},
	},
	Checkbox = require(Component:WaitForChild("Checkbox")),
	RadioButton = require(Component:WaitForChild("RadioButton")),
	Switch = require(Component:WaitForChild("Switch")),
	Slider = nil,
	TextField = {
		Filled = require(Component:WaitForChild("TextFields"):WaitForChild("Filled")),
		Outlined = require(Component:WaitForChild("TextFields"):WaitForChild("Outlined")),
	},
}

return Synthetic
