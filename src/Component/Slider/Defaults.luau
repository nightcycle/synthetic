--!strict
-- this script was generated by the build system, please do not make manual edits
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))

-- Types
type Maid = Maid.Maid
type Style = Style.Style
type FontData = Types.FontData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type ImageData = Types.ImageData
type CanBeState<V> = ColdFusion.CanBeState<V>

return {
	NEW = {
		ON_CHANGE = function(onChange: number) end,
		INITIAL_VALUE = 50,
		MINIMUM = 0,
		MAXIMUM = 100,
		INCREMENT = nil :: number?,
		LEFT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		RIGHT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		ON_BACKGROUND_COLOR = Color3.new(),
		ON_BACKGROUND_TEXT_COLOR = Color3.new(),
		FILL_COLOR = Color3.new(),
		FILL_CONTAINER_COLOR = Color3.new(),
		ELEVATION = 0,
		SCHEME_TYPE = Enums.SchemeType.Light,
		FONT_DATA = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14),
		SCALE = 1,
	},
	PRIMARY = {
		STYLE = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)),
		ON_CHANGE = function(onChange: number) end,
		INITIAL_VALUE = 50,
		MINIMUM = 0,
		MAXIMUM = 100,
		INCREMENT = nil :: number?,
		LEFT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		RIGHT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		ELEVATION = 0,
	},
	SECONDARY = {
		STYLE = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)),
		ON_CHANGE = function(onChange: number) end,
		INITIAL_VALUE = 50,
		MINIMUM = 0,
		MAXIMUM = 100,
		INCREMENT = nil :: number?,
		LEFT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		RIGHT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		ELEVATION = 0,
	},
	TERTIARY = {
		STYLE = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)),
		ON_CHANGE = function(onChange: number) end,
		INITIAL_VALUE = 50,
		MINIMUM = 0,
		MAXIMUM = 100,
		INCREMENT = nil :: number?,
		LEFT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		RIGHT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		ELEVATION = 0,
	},
	ON_PRIMARY = {
		STYLE = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)),
		ON_CHANGE = function(onChange: number) end,
		INITIAL_VALUE = 50,
		MINIMUM = 0,
		MAXIMUM = 100,
		INCREMENT = nil :: number?,
		LEFT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		RIGHT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		ELEVATION = 0,
	},
	ON_SECONDARY = {
		STYLE = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)),
		ON_CHANGE = function(onChange: number) end,
		INITIAL_VALUE = 50,
		MINIMUM = 0,
		MAXIMUM = 100,
		INCREMENT = nil :: number?,
		LEFT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		RIGHT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		ELEVATION = 0,
	},
	ON_TERTIARY = {
		STYLE = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)),
		ON_CHANGE = function(onChange: number) end,
		INITIAL_VALUE = 50,
		MINIMUM = 0,
		MAXIMUM = 100,
		INCREMENT = nil :: number?,
		LEFT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		RIGHT_TEXT_OR_ICON = nil :: (string | ImageData)?,
		ELEVATION = 0,
	},
}
