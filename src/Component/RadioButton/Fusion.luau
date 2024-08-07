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
	onSelect: FusionCanBeState<(isSelected: boolean) -> ()>,
	initialSelection: FusionCanBeState<boolean>,
	isEnabled: FusionCanBeState<boolean>,
	outlineColor: FusionCanBeState<Color3>,
	fillColor: FusionCanBeState<Color3>,
	iconColor: FusionCanBeState<Color3>,
	disabledColor: FusionCanBeState<Color3>,
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
		convert(onSelect, DEFAULTS.NEW.ON_SELECT),
		convert(initialSelection, DEFAULTS.NEW.INITIAL_SELECTION),
		convert(isEnabled, DEFAULTS.NEW.IS_ENABLED),
		convert(outlineColor, DEFAULTS.NEW.OUTLINE_COLOR),
		convert(fillColor, DEFAULTS.NEW.FILL_COLOR),
		convert(iconColor, DEFAULTS.NEW.ICON_COLOR),
		convert(disabledColor, DEFAULTS.NEW.DISABLED_COLOR),
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

function Interface.primary(
	style: FusionCanBeState<Style>,
	onSelect: FusionCanBeState<(isSelected: boolean) -> ()>,
	initialSelection: FusionCanBeState<boolean>,
	elevation: FusionCanBeState<number?>,
	isEnabled: FusionCanBeState<boolean?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>, default: V): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value, default)
	end
	local inst = Source.primary(
		convert(style, DEFAULTS.PRIMARY.STYLE),
		convert(onSelect, DEFAULTS.PRIMARY.ON_SELECT),
		convert(initialSelection, DEFAULTS.PRIMARY.INITIAL_SELECTION),
		convert(elevation, DEFAULTS.PRIMARY.ELEVATION),
		convert(isEnabled, DEFAULTS.PRIMARY.IS_ENABLED)
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

function Interface.secondary(
	style: FusionCanBeState<Style>,
	onSelect: FusionCanBeState<(isSelected: boolean) -> ()>,
	initialSelection: FusionCanBeState<boolean>,
	elevation: FusionCanBeState<number?>,
	isEnabled: FusionCanBeState<boolean?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>, default: V): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value, default)
	end
	local inst = Source.secondary(
		convert(style, DEFAULTS.SECONDARY.STYLE),
		convert(onSelect, DEFAULTS.SECONDARY.ON_SELECT),
		convert(initialSelection, DEFAULTS.SECONDARY.INITIAL_SELECTION),
		convert(elevation, DEFAULTS.SECONDARY.ELEVATION),
		convert(isEnabled, DEFAULTS.SECONDARY.IS_ENABLED)
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

function Interface.tertiary(
	style: FusionCanBeState<Style>,
	onSelect: FusionCanBeState<(isSelected: boolean) -> ()>,
	initialSelection: FusionCanBeState<boolean>,
	elevation: FusionCanBeState<number?>,
	isEnabled: FusionCanBeState<boolean?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>, default: V): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value, default)
	end
	local inst = Source.tertiary(
		convert(style, DEFAULTS.TERTIARY.STYLE),
		convert(onSelect, DEFAULTS.TERTIARY.ON_SELECT),
		convert(initialSelection, DEFAULTS.TERTIARY.INITIAL_SELECTION),
		convert(elevation, DEFAULTS.TERTIARY.ELEVATION),
		convert(isEnabled, DEFAULTS.TERTIARY.IS_ENABLED)
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

function Interface.primaryContainer(
	style: FusionCanBeState<Style>,
	onSelect: FusionCanBeState<(isSelected: boolean) -> ()>,
	initialSelection: FusionCanBeState<boolean>,
	elevation: FusionCanBeState<number?>,
	isEnabled: FusionCanBeState<boolean?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>, default: V): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value, default)
	end
	local inst = Source.primaryContainer(
		convert(style, DEFAULTS.PRIMARY_CONTAINER.STYLE),
		convert(onSelect, DEFAULTS.PRIMARY_CONTAINER.ON_SELECT),
		convert(initialSelection, DEFAULTS.PRIMARY_CONTAINER.INITIAL_SELECTION),
		convert(elevation, DEFAULTS.PRIMARY_CONTAINER.ELEVATION),
		convert(isEnabled, DEFAULTS.PRIMARY_CONTAINER.IS_ENABLED)
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

function Interface.secondaryContainer(
	style: FusionCanBeState<Style>,
	onSelect: FusionCanBeState<(isSelected: boolean) -> ()>,
	initialSelection: FusionCanBeState<boolean>,
	elevation: FusionCanBeState<number?>,
	isEnabled: FusionCanBeState<boolean?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>, default: V): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value, default)
	end
	local inst = Source.secondaryContainer(
		convert(style, DEFAULTS.SECONDARY_CONTAINER.STYLE),
		convert(onSelect, DEFAULTS.SECONDARY_CONTAINER.ON_SELECT),
		convert(initialSelection, DEFAULTS.SECONDARY_CONTAINER.INITIAL_SELECTION),
		convert(elevation, DEFAULTS.SECONDARY_CONTAINER.ELEVATION),
		convert(isEnabled, DEFAULTS.SECONDARY_CONTAINER.IS_ENABLED)
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

function Interface.tertiaryContainer(
	style: FusionCanBeState<Style>,
	onSelect: FusionCanBeState<(isSelected: boolean) -> ()>,
	initialSelection: FusionCanBeState<boolean>,
	elevation: FusionCanBeState<number?>,
	isEnabled: FusionCanBeState<boolean?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>, default: V): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value, default)
	end
	local inst = Source.tertiaryContainer(
		convert(style, DEFAULTS.TERTIARY_CONTAINER.STYLE),
		convert(onSelect, DEFAULTS.TERTIARY_CONTAINER.ON_SELECT),
		convert(initialSelection, DEFAULTS.TERTIARY_CONTAINER.INITIAL_SELECTION),
		convert(elevation, DEFAULTS.TERTIARY_CONTAINER.ELEVATION),
		convert(isEnabled, DEFAULTS.TERTIARY_CONTAINER.IS_ENABLED)
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

return Interface
