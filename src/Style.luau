--!strict
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
-- Modules
local Typography = require(_Package:WaitForChild("Typography"))
local Theme = require(_Package:WaitForChild("Theme"))
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
	Theme: Theme,
	Typography: Typography,
	new: (
		fontFamily: string,
		source: Color3,
		custom: {[string]: Color3}?
	) -> Style,
}

-- Class
local Style = {} :: Style
Style.__index = Style

function Style.new(
	fontFamily: string,
	source: Color3,
	additions: {[string]: Color3}?
)

	local self: Style = setmetatable({}, Style) :: any

	self.Theme = Theme.new(source, additions)
	self.Typography = Typography.new(fontFamily)

	return self
end

return Style