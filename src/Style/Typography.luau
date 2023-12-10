--!strict
local _Package = script.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
-- Modules
local Enums = require(_Package:WaitForChild("Enums"))
local Types = require(_Package:WaitForChild("Types"))

-- Types
-- Constants
local DEFAULT_FONT_FAMILY = "Roboto"
local WEIGHT = {
	[100] = Enum.FontWeight.Thin,
	[200] = Enum.FontWeight.ExtraLight,
	[300] = Enum.FontWeight.Light,
	[400] = Enum.FontWeight.Regular,
	[500] = Enum.FontWeight.Medium,
	[600] = Enum.FontWeight.SemiBold,
	[700] = Enum.FontWeight.Bold,
	[800] = Enum.FontWeight.ExtraBold,
	[900] = Enum.FontWeight.Heavy,
}
-- Variables
-- References
-- Private Functions
-- Class
-- Types
export type FontData = Types.FontData
export type Typography = {
	__index: Typography,
	_Styles: { [Enums.FontType]: FontData },
	Get: (self: Typography, style: Enums.FontType) -> FontData,
	new: (fontFamily: string?) -> Typography,
}

-- Class
local Typography = {} :: Typography
Typography.__index = Typography

function Typography:Get(style: Enums.FontType): FontData
	return self._Styles[style]
end

function Typography.new(fontFamily: string?)
	fontFamily = fontFamily or DEFAULT_FONT_FAMILY
	assert(fontFamily)
	local self: Typography = setmetatable({}, Typography) :: any
	self._Styles = table.freeze({
		[Enums.FontType.DisplayLarge] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 57,
			Tracking = -0.25,
			LineHeight = 64,
		}),
		[Enums.FontType.DisplayMedium] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 45,
			Tracking = 0,
			LineHeight = 52,
		}),
		[Enums.FontType.DisplaySmall] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 36,
			Tracking = 0,
			LineHeight = 44,
		}),
		[Enums.FontType.HeadlineLarge] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 32,
			Tracking = 0,
			LineHeight = 40,
		}),
		[Enums.FontType.HeadlineMedium] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 28,
			Tracking = 0,
			LineHeight = 36,
		}),
		[Enums.FontType.HeadlineSmall] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 24,
			Tracking = 0,
			LineHeight = 32,
		}),
		[Enums.FontType.TitleLarge] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 22,
			Tracking = 0,
			LineHeight = 28,
		}),
		[Enums.FontType.TitleMedium] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[500], Enum.FontStyle.Normal),
			Size = 16,
			Tracking = 0.15,
			LineHeight = 24,
		}),
		[Enums.FontType.TitleSmall] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[500], Enum.FontStyle.Normal),
			Size = 14,
			Tracking = 0.1,
			LineHeight = 20,
		}),
		[Enums.FontType.BodyLarge] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 16,
			Tracking = 0.5,
			LineHeight = 24,
		}),
		[Enums.FontType.BodyMedium] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 14,
			Tracking = 0.25,
			LineHeight = 20,
		}),
		[Enums.FontType.BodySmall] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[400], Enum.FontStyle.Normal),
			Size = 12,
			Tracking = 0.4,
			LineHeight = 16,
		}),
		[Enums.FontType.LabelLarge] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[500], Enum.FontStyle.Normal),
			Size = 14,
			Tracking = 0.1,
			LineHeight = 20,
		}),
		[Enums.FontType.LabelMedium] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[700], Enum.FontStyle.Normal),
			Size = 12,
			Tracking = 0.5,
			LineHeight = 16,
		}),
		[Enums.FontType.LabelSmall] = table.freeze({
			Font = Font.new(fontFamily, WEIGHT[500], Enum.FontStyle.Normal),
			Size = 11,
			Tracking = 0.5,
			LineHeight = 16,
		}),
	})

	table.freeze(self)

	return self
end

return Typography
