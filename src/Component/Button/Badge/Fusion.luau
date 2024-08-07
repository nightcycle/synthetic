--!strict
-- this script was generated by the build system, please do not make manual edits
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))

local Translators = require(_Package:WaitForChild("Translators"))

local Source = require(script.Parent:WaitForChild("ColdFusion"))

-- Types
type Maid = Maid.Maid
type Style = Style.Style
type FontData = Types.FontData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type ImageData = Types.ImageData
type CanBeState<V> = ColdFusion.CanBeState<V>
type FusionCanBeState<V> = Translators.FusionCanBeState<V>

-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
-- Variables
-- References
-- Private Functions
-- Class
local Interface = {}

function Interface.new(
	onClick: FusionCanBeState<() -> ()>,
	icon: FusionCanBeState<ImageData>,
	label: FusionCanBeState<string?>,
	count: FusionCanBeState<number?>,
	textColor: FusionCanBeState<Color3>,
	hoverColor: FusionCanBeState<Color3>,
	errorTextColor: FusionCanBeState<Color3>,
	errorBackgroundColor: FusionCanBeState<Color3>,
	elevation: FusionCanBeState<number>,
	schemeType: FusionCanBeState<Enums.SchemeType>,
	fontData: FusionCanBeState<FontData>,
	scale: FusionCanBeState<number>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>, default: V): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value, default)
	end
	local inst = Source.new(
		convert(onClick, DEFAULTS.NEW.ON_CLICK),
		convert(icon, DEFAULTS.NEW.ICON),
		convert(label, DEFAULTS.NEW.LABEL),
		convert(count, DEFAULTS.NEW.COUNT),
		convert(textColor, DEFAULTS.NEW.TEXT_COLOR),
		convert(hoverColor, DEFAULTS.NEW.HOVER_COLOR),
		convert(errorTextColor, DEFAULTS.NEW.ERROR_TEXT_COLOR),
		convert(errorBackgroundColor, DEFAULTS.NEW.ERROR_BACKGROUND_COLOR),
		convert(elevation, DEFAULTS.NEW.ELEVATION),
		convert(schemeType, DEFAULTS.NEW.SCHEME_TYPE),
		convert(fontData, DEFAULTS.NEW.FONT_DATA),
		convert(scale, DEFAULTS.NEW.SCALE)
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

function Interface.onPrimary(
	style: FusionCanBeState<Style>,
	onClick: FusionCanBeState<() -> ()>,
	icon: FusionCanBeState<ImageData>,
	label: FusionCanBeState<string?>,
	count: FusionCanBeState<number?>,
	elevation: FusionCanBeState<number?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>, default: V): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value, default)
	end
	local inst = Source.onPrimary(
		convert(style, DEFAULTS.ON_PRIMARY.STYLE),
		convert(onClick, DEFAULTS.ON_PRIMARY.ON_CLICK),
		convert(icon, DEFAULTS.ON_PRIMARY.ICON),
		convert(label, DEFAULTS.ON_PRIMARY.LABEL),
		convert(count, DEFAULTS.ON_PRIMARY.COUNT),
		convert(elevation, DEFAULTS.ON_PRIMARY.ELEVATION)
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

function Interface.onSurface(
	style: FusionCanBeState<Style>,
	onClick: FusionCanBeState<() -> ()>,
	icon: FusionCanBeState<ImageData>,
	label: FusionCanBeState<string?>,
	count: FusionCanBeState<number?>,
	elevation: FusionCanBeState<number?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>, default: V): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value, default)
	end
	local inst = Source.onSurface(
		convert(style, DEFAULTS.ON_SURFACE.STYLE),
		convert(onClick, DEFAULTS.ON_SURFACE.ON_CLICK),
		convert(icon, DEFAULTS.ON_SURFACE.ICON),
		convert(label, DEFAULTS.ON_SURFACE.LABEL),
		convert(count, DEFAULTS.ON_SURFACE.COUNT),
		convert(elevation, DEFAULTS.ON_SURFACE.ELEVATION)
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

return Interface
