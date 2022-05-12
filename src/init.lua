local module = script
local packages = module.Parent
return {
	Checkbox = require(packages:WaitForChild("checkbox")),
	RadioButton = require(packages:WaitForChild("radiobutton")),
	Switch = require(packages:WaitForChild("switch")),
	TextLabel = require(packages:WaitForChild("textlabel")),
	IconLabel = require(packages:WaitForChild("iconlabel")),
}