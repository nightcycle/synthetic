--- @interface SynthEnums
--- @within Synthetic
---	.DividerDirection {SynthEnum}
---	.Typography {SynthEnum}
---	.Variant {SynthEnum}
---	.SystemFont {SynthEnum}
---	.ColorPallete {SynthEnum}
--- .ColorShade {SynthEnum}
---
--- A set of enums used throughout code

local config = {
	--- @type DividerDirection SynthEnum
	--- @within Synthetic
	--- used to determine what direction the divider is located
	DividerDirection = {
		Unknown = 0,
		Vertical = 1,
		Horizontal = 2,
	},
	--- @type Typography SynthEnum
	--- @within Synthetic
	--- used to determine the font, text size constraints, and padding
	Typography = {
		Unknown = 0,
		Headline = 1,
		Subtitle = 2,
		Button = 3,
		Body = 4,
		Caption = 5,
	},
	Variant = {
		Unknown = 0,
		Filled = 1,
		Outlined = 2,
		Text = 3, --doesn't always get used
	},
	SystemFont = {
		Unknown = 0,
		Gotham = 1,
		SourceSans = 2,
	},
	ColorPallete = {
		Unknown = 0,
		["Amber"] = 1,
		["Blue Grey"] = 2,
		["Blue"] = 3,
		["Brown"] = 4,
		["Cyan"] = 5,
		["Deep Orange"] = 6,
		["Deep Purple"] = 7,
		["Green"] = 8,
		["Grey"] = 9,
		["Indigo"] = 10,
		["Light Blue"] = 11,
		["Light Green"] = 12,
		["Lime"] = 13,
		["Orange"] = 14,
		["Pink"] = 15,
		["Purple"] = 16,
		["Red"] = 17,
		["Teal"] = 18,
		["Yellow"] = 19,
	},
	ColorShade = {
		Unknown = 0,
		["50"] = 1,
		["100"] = 2,
		["200"] = 3,
		["300"] = 4,
		["400"] = 5,
		["500"] = 6,
		["600"] = 7,
		["700"] = 8,
		["800"] = 9,
		["900"] = 10,
	},
}



for _, enumGroup in pairs(config) do
	local vals = {}
	local meta = {}

	meta.__index = function(s, k)
		if type(k) ~= "string" then k = tostring(k) end
		if vals[k] == nil then
			warn("Couldn't find valid enum for "..tostring(k))
			return vals.Unknown
		end
		return vals[k]
	end
	for k, val in pairs(enumGroup) do
		vals[k] = val
	end
	setmetatable(enumGroup, meta)
end

return config