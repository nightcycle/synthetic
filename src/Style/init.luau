--!strict
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
-- Modules
local Typography = require(script:WaitForChild("Typography"))
local Theme = require(script:WaitForChild("Theme"))
local Enums = require(_Package:WaitForChild("Enums"))

-- Types
export type Theme = Theme.Theme
export type Typography = Typography.Typography
export type FontData = Typography.FontData
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
-- Types
export type Style = {
	__index: Style,
	Scale: number,
	SchemeType: Enums.SchemeType,
	_Theme: Theme,
	_Typography: Typography,
	GetElevatedColor: (self: Style, color: Color3, elevation: number) -> Color3,
	GetColor: (self: Style, role: Enums.ColorRoleType, elevation: number?) -> Color3,
	GetCustomColor: (self: Style, name: string, customType: Enums.CustomColorType, elevation: number?) -> Color3,
	GetFont: (self: Style, fontType: Enums.FontType) -> Font,
	GetFontData: (self: Style, fontType: Enums.FontType) -> FontData,

	GetTextSize: (self: Style, fontType: Enums.FontType) -> number,
	GetLineHeight: (self: Style, fontType: Enums.FontType) -> number,
	new: (
		scale: number,
		fontFamily: string,
		schemeType: Enums.SchemeType,
		source: Color3,
		custom: { [string]: Color3 }?
	) -> Style,
}

-- Class
local Style = {} :: Style
Style.__index = Style

function Style:GetColor(role: Enums.ColorRoleType, elevation: number?): Color3
	return self._Theme:Get(role, self.SchemeType, elevation)
end

function Style:GetElevatedColor(color: Color3, elevation: number): Color3
	return self._Theme.getElevatedColor(color, elevation, self.SchemeType)
end

function Style:GetCustomColor(name: string, customType: Enums.CustomColorType, elevation: number?): Color3
	return self._Theme:GetCustom(name, customType, self.SchemeType, elevation)
end

function Style:GetFont(fontType: Enums.FontType): Font
	return self._Typography:Get(fontType).Font
end

function Style:GetFontData(fontType: Enums.FontType): FontData
	return table.clone(self._Typography:Get(fontType))
end

function Style:GetTextSize(fontType: Enums.FontType): number
	return self._Typography:Get(fontType).Size * self.Scale
end

function Style:GetLineHeight(fontType: Enums.FontType): number
	return self._Typography:Get(fontType).LineHeight / self._Typography:Get(fontType).Size
end

function Style.new(
	scale: number,
	fontFamily: string,
	schemeType: Enums.SchemeType,
	source: Color3,
	additions: { [string]: Color3 }?
): Style
	local self: Style = setmetatable({}, Style) :: any
	self.Scale = scale
	self.SchemeType = schemeType
	self._Theme = Theme.new(source, additions)
	self._Typography = Typography.new(fontFamily)

	table.freeze(self)
	return self
end

return Style
