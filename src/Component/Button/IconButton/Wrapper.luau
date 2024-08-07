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
type Wrapper<BaseInstance, Definition, ClassName> = Translators.Wrapper<BaseInstance, Definition, ClassName>

export type IconButtonWrapperDefinition = {
	OnClick: () -> (),
	Icon: ImageData,
	TextColor: Color3,
	DisabledTextColor: Color3,
	IsEnabled: boolean,
	Elevation: number,
	SchemeType: Enums.SchemeType,
	FontData: FontData,
	Scale: number,
}
export type IconButtonWrapper = Wrapper<GuiObject, IconButtonWrapperDefinition, "IconButton">

export type StyledIconButtonWrapperDefinition = {
	Style: Style,
	OnClick: () -> (),
	Icon: ImageData,
	Elevation: number,
	IsEnabled: boolean,
}
export type StyledIconButtonWrapper = Wrapper<
	GuiObject,
	StyledIconButtonWrapperDefinition,
	"StyledIconButton"
>
-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
-- Variables
-- References
-- Private Functions
-- Interface
local Interface = {}

function Interface.new(): StyledIconButtonWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		OnClick = _Value(function() end),
		Icon = _Value(Types.ImageData.new("")),
		TextColor = _Value(Color3.new()),
		DisabledTextColor = _Value(Color3.new()),
		IsEnabled = _Value(true),
		Elevation = _Value(0),
		SchemeType = _Value(Enums.SchemeType.Light),
		FontData = _Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)),
		Scale = _Value(1),
	}
	local defaults: { [string]: unknown? } = {
		onClick = DEFAULTS.NEW.ON_CLICK,
		icon = DEFAULTS.NEW.ICON,
		textColor = DEFAULTS.NEW.TEXT_COLOR,
		disabledTextColor = DEFAULTS.NEW.DISABLED_TEXT_COLOR,
		isEnabled = DEFAULTS.NEW.IS_ENABLED,
		elevation = DEFAULTS.NEW.ELEVATION,
		schemeType = DEFAULTS.NEW.SCHEME_TYPE,
		fontData = DEFAULTS.NEW.FONT_DATA,
		scale = DEFAULTS.NEW.SCALE,
	}
	local inst: GuiObject = Source.new(
		definition.OnClick,
		definition.Icon,
		definition.TextColor,
		definition.DisabledTextColor,
		definition.IsEnabled,
		definition.Elevation,
		definition.SchemeType,
		definition.FontData,
		definition.Scale
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledIconButton", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.primary(): StyledIconButtonWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		OnClick = _Value(function() end),
		Icon = _Value(Types.ImageData.new("")),
		Elevation = _Value(0),
		IsEnabled = _Value(true),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.PRIMARY.STYLE,
		onClick = DEFAULTS.PRIMARY.ON_CLICK,
		icon = DEFAULTS.PRIMARY.ICON,
		elevation = DEFAULTS.PRIMARY.ELEVATION,
		isEnabled = DEFAULTS.PRIMARY.IS_ENABLED,
	}
	local inst: GuiObject = Source.primary(
		definition.Style,
		definition.OnClick,
		definition.Icon,
		definition.Elevation,
		definition.IsEnabled
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledIconButton", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.secondary(): StyledIconButtonWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		OnClick = _Value(function() end),
		Icon = _Value(Types.ImageData.new("")),
		Elevation = _Value(0),
		IsEnabled = _Value(true),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.SECONDARY.STYLE,
		onClick = DEFAULTS.SECONDARY.ON_CLICK,
		icon = DEFAULTS.SECONDARY.ICON,
		elevation = DEFAULTS.SECONDARY.ELEVATION,
		isEnabled = DEFAULTS.SECONDARY.IS_ENABLED,
	}
	local inst: GuiObject = Source.secondary(
		definition.Style,
		definition.OnClick,
		definition.Icon,
		definition.Elevation,
		definition.IsEnabled
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledIconButton", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.tertiary(): StyledIconButtonWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		OnClick = _Value(function() end),
		Icon = _Value(Types.ImageData.new("")),
		Elevation = _Value(0),
		IsEnabled = _Value(true),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.TERTIARY.STYLE,
		onClick = DEFAULTS.TERTIARY.ON_CLICK,
		icon = DEFAULTS.TERTIARY.ICON,
		elevation = DEFAULTS.TERTIARY.ELEVATION,
		isEnabled = DEFAULTS.TERTIARY.IS_ENABLED,
	}
	local inst: GuiObject = Source.tertiary(
		definition.Style,
		definition.OnClick,
		definition.Icon,
		definition.Elevation,
		definition.IsEnabled
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledIconButton", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.primaryContainer(): StyledIconButtonWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		OnClick = _Value(function() end),
		Icon = _Value(Types.ImageData.new("")),
		Elevation = _Value(0),
		IsEnabled = _Value(true),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.PRIMARY_CONTAINER.STYLE,
		onClick = DEFAULTS.PRIMARY_CONTAINER.ON_CLICK,
		icon = DEFAULTS.PRIMARY_CONTAINER.ICON,
		elevation = DEFAULTS.PRIMARY_CONTAINER.ELEVATION,
		isEnabled = DEFAULTS.PRIMARY_CONTAINER.IS_ENABLED,
	}
	local inst: GuiObject = Source.primaryContainer(
		definition.Style,
		definition.OnClick,
		definition.Icon,
		definition.Elevation,
		definition.IsEnabled
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledIconButton", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.secondaryContainer(): StyledIconButtonWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		OnClick = _Value(function() end),
		Icon = _Value(Types.ImageData.new("")),
		Elevation = _Value(0),
		IsEnabled = _Value(true),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.SECONDARY_CONTAINER.STYLE,
		onClick = DEFAULTS.SECONDARY_CONTAINER.ON_CLICK,
		icon = DEFAULTS.SECONDARY_CONTAINER.ICON,
		elevation = DEFAULTS.SECONDARY_CONTAINER.ELEVATION,
		isEnabled = DEFAULTS.SECONDARY_CONTAINER.IS_ENABLED,
	}
	local inst: GuiObject = Source.secondaryContainer(
		definition.Style,
		definition.OnClick,
		definition.Icon,
		definition.Elevation,
		definition.IsEnabled
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledIconButton", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.tertiaryContainer(): StyledIconButtonWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		OnClick = _Value(function() end),
		Icon = _Value(Types.ImageData.new("")),
		Elevation = _Value(0),
		IsEnabled = _Value(true),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.TERTIARY_CONTAINER.STYLE,
		onClick = DEFAULTS.TERTIARY_CONTAINER.ON_CLICK,
		icon = DEFAULTS.TERTIARY_CONTAINER.ICON,
		elevation = DEFAULTS.TERTIARY_CONTAINER.ELEVATION,
		isEnabled = DEFAULTS.TERTIARY_CONTAINER.IS_ENABLED,
	}
	local inst: GuiObject = Source.tertiaryContainer(
		definition.Style,
		definition.OnClick,
		definition.Icon,
		definition.Elevation,
		definition.IsEnabled
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledIconButton", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

return Interface
