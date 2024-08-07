--!strict
-- this script was generated by the build system, please do not make manual edits
local _Package = script.Parent.Parent.Parent.Parent.Parent
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
type Wrapper<BaseInstance, Definition, ClassName> = Translators.Wrapper<BaseInstance, Definition, ClassName>

export type SegmentedWrapperDefinition = {
	Options: { OptionData },
	Density: number,
	IsMultiSelect: boolean,
	TextColor: Color3,
	FillTextColor: Color3,
	FillBackgroundColor: Color3,
	OutlineColor: Color3,
	Elevation: number,
	SchemeType: Enums.SchemeType,
	FontData: FontData,
	Scale: number,
}
export type SegmentedWrapper = Wrapper<GuiObject, SegmentedWrapperDefinition, "Segmented">

export type StyledSegmentedWrapperDefinition = {
	Style: Style,
	Options: { OptionData },
	Density: number?,
	IsMultiSelect: boolean?,
	Elevation: number?,
}
export type StyledSegmentedWrapper = Wrapper<GuiObject, StyledSegmentedWrapperDefinition, "StyledSegmented">
-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
-- Variables
-- References
-- Private Functions
-- Interface
local Interface = {}

function Interface.new(): StyledSegmentedWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Options = _Value({}),
		Density = _Value(0),
		IsMultiSelect = _Value(false),
		TextColor = _Value(Color3.new()),
		FillTextColor = _Value(Color3.new()),
		FillBackgroundColor = _Value(Color3.new()),
		OutlineColor = _Value(Color3.new()),
		Elevation = _Value(0),
		SchemeType = _Value(Enums.SchemeType.Light),
		FontData = _Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)),
		Scale = _Value(1),
	}
	local defaults: { [string]: unknown? } = {
		options = DEFAULTS.NEW.OPTIONS,
		density = DEFAULTS.NEW.DENSITY,
		isMultiSelect = DEFAULTS.NEW.IS_MULTI_SELECT,
		textColor = DEFAULTS.NEW.TEXT_COLOR,
		fillTextColor = DEFAULTS.NEW.FILL_TEXT_COLOR,
		fillBackgroundColor = DEFAULTS.NEW.FILL_BACKGROUND_COLOR,
		outlineColor = DEFAULTS.NEW.OUTLINE_COLOR,
		elevation = DEFAULTS.NEW.ELEVATION,
		schemeType = DEFAULTS.NEW.SCHEME_TYPE,
		fontData = DEFAULTS.NEW.FONT_DATA,
		scale = DEFAULTS.NEW.SCALE,
	}
	local inst: GuiObject = Source.new(
		definition.Options,
		definition.Density,
		definition.IsMultiSelect,
		definition.TextColor,
		definition.FillTextColor,
		definition.FillBackgroundColor,
		definition.OutlineColor,
		definition.Elevation,
		definition.SchemeType,
		definition.FontData,
		definition.Scale
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledSegmented", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.primaryContainer(): StyledSegmentedWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		Options = _Value({}),
		Density = _Value(0),
		IsMultiSelect = _Value(false),
		Elevation = _Value(0),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.PRIMARY_CONTAINER.STYLE,
		options = DEFAULTS.PRIMARY_CONTAINER.OPTIONS,
		density = DEFAULTS.PRIMARY_CONTAINER.DENSITY,
		isMultiSelect = DEFAULTS.PRIMARY_CONTAINER.IS_MULTI_SELECT,
		elevation = DEFAULTS.PRIMARY_CONTAINER.ELEVATION,
	}
	local inst: GuiObject = Source.primaryContainer(
		definition.Style,
		definition.Options,
		definition.Density,
		definition.IsMultiSelect,
		definition.Elevation
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledSegmented", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.secondaryContainer(): StyledSegmentedWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		Options = _Value({}),
		Density = _Value(0),
		IsMultiSelect = _Value(false),
		Elevation = _Value(0),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.SECONDARY_CONTAINER.STYLE,
		options = DEFAULTS.SECONDARY_CONTAINER.OPTIONS,
		density = DEFAULTS.SECONDARY_CONTAINER.DENSITY,
		isMultiSelect = DEFAULTS.SECONDARY_CONTAINER.IS_MULTI_SELECT,
		elevation = DEFAULTS.SECONDARY_CONTAINER.ELEVATION,
	}
	local inst: GuiObject = Source.secondaryContainer(
		definition.Style,
		definition.Options,
		definition.Density,
		definition.IsMultiSelect,
		definition.Elevation
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledSegmented", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.tertiaryContainer(): StyledSegmentedWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		Options = _Value({}),
		Density = _Value(0),
		IsMultiSelect = _Value(false),
		Elevation = _Value(0),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.TERTIARY_CONTAINER.STYLE,
		options = DEFAULTS.TERTIARY_CONTAINER.OPTIONS,
		density = DEFAULTS.TERTIARY_CONTAINER.DENSITY,
		isMultiSelect = DEFAULTS.TERTIARY_CONTAINER.IS_MULTI_SELECT,
		elevation = DEFAULTS.TERTIARY_CONTAINER.ELEVATION,
	}
	local inst: GuiObject = Source.tertiaryContainer(
		definition.Style,
		definition.Options,
		definition.Density,
		definition.IsMultiSelect,
		definition.Elevation
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledSegmented", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

return Interface
