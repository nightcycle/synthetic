--!strict
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
-- Modules
local Typography = require(_Package:WaitForChild("Typography"))
local Theme = require(_Package:WaitForChild("Theme"))
local Enums = require(_Package:WaitForChild("Enums"))

-- Types
type Theme = Theme.Theme
type Typography = Typography.Typography
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
	Typography: Typography,
	GetElevatedColor: (self: Style, color: Color3, elevation: number) -> Color3,
	GetColor: (self: Style, role: Enums.ColorRoleType, elevation: number?) -> Color3,
	GetCustom: (self: Style, name: string, customType: Enums.CustomColorType, elevation: number?) -> Color3,
	new: (scale: number, fontFamily: string, schemeType: Enums.SchemeType, source: Color3, custom: { [string]: Color3 }?) -> Style,
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

function Style:GetCustom(name: string, customType: Enums.CustomColorType, elevation: number?): Color3
	return self._Theme:GetCustom(name, customType, self.SchemeType, elevation)
end

function Style.new(scale: number, fontFamily: string, schemeType: Enums.SchemeType, source: Color3, additions: { [string]: Color3 }?): Style
	local self: Style = setmetatable({}, Style) :: any
	self.Scale = scale
	self.SchemeType = schemeType
	self._Theme = Theme.new(source, additions)
	self.Typography = Typography.new(fontFamily)

	table.freeze(self)
	return self
end

return Style
