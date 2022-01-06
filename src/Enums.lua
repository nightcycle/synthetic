local packages = script.Parent.Parent
local enum = require(packages:WaitForChild("enumerator"))

return {
	DividerDirection = enum("DividerDirection", {
		Unknown = 0,
		Vertical = 1,
		Horizontal = 2,
	}),
	Variant = enum("Variant", {
		Unknown = 0,
		Filled = 1,
		Outlined = 2,
		Text = 3, --doesn't always get used
	}),
}
