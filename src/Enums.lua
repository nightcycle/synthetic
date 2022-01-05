local packages = script.Parent.Parent
local enumerator = require(packages:WaitForChild("enumerator"))
local enum = enumerator.enumerate

return {
	enum("DividerDirection", {
		Unknown = 0,
		Vertical = 1,
		Horizontal = 2,
	}),
	enum("Variant", {
		Unknown = 0,
		Filled = 1,
		Outlined = 2,
		Text = 3, --doesn't always get used
	}),
}