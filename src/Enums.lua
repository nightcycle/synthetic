local packages = script.Parent.Parent
local enum = require(packages:WaitForChild("enumerator"))

local synthEnums = {}

--[=[
	@class SynthEnum
]=]

--[=[
	@interface DividerDirection
	The SynthEnum used when deciding how to display a divider component
	@within SynthEnum
	.Unknown 0
	.Vertical 1
	.Horizontal 2
]=]
synthEnums.DividerDirection = enum("DividerDirection", {
	Unknown = 0,
	Vertical = 1,
	Horizontal = 2,
})

--[=[
	@interface ButtonVariant
	The SynthEnum used when deciding how to display a button component
	@within SynthEnum
	.Unknown 0
	.Filled 1
	.Outlined 2
	.Text 3 -- Text doesn't always get used
]=]
synthEnums.ButtonVariant = enum("ButtonVariant", {
	Unknown = 0,
	Filled = 1,
	Outlined = 2,
	Text = 3, --doesn't always get used
})

--[=[
	@interface ToggleVariant
	The SynthEnum used for deciding what toggle element to use within a component
	@within SynthEnum
	.Unknown 0
	.RadioButton 1 -- When used in toggle lists only one can be selected at a time
	.Switch 2
	.Checkbox 3
]=]
synthEnums.ToggleVariant = enum("ToggleVariant", {
	Unknown = 0,
	RadioButton = 1, --only one can be selected
	Switch = 2,
	Checkbox = 3,
})

return synthEnums