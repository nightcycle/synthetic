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

export type FilledWrapperDefinition = {
	OnInputEntered: (input: string) -> string,
	Label: string?,
	OptionSolver: (input: string) -> { string },
	OptionConstructor: ((key: string, onClick: (key: string) -> ()) -> GuiObject)?,
	TextColor: Color3,
	BackgroundColor: Color3,
	Elevation: number,
	SchemeType: Enums.SchemeType,
	FontData: FontData,
	Scale: number,
}
export type FilledWrapper = Wrapper<GuiObject, FilledWrapperDefinition, "Filled">

export type StyledFilledWrapperDefinition = {
	Style: Style,
	OnInputEntered: (input: string) -> string,
	Label: string?,
	OptionSolver: (input: string) -> { string },
	OptionConstructor: ((key: string, onClick: (key: string) -> ()) -> GuiObject)?,
	Elevation: number?,
}
export type StyledFilledWrapper = Wrapper<GuiObject, StyledFilledWrapperDefinition, "StyledFilled">
-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
-- Variables
-- References
-- Private Functions
-- Interface
local Interface = {}

function Interface.new(): StyledFilledWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		OnInputEntered = _Value(function(input: string)
			return input
		end),
		Label = _Value(""),
		OptionSolver = _Value(function(input: string)
			return {}
		end),
		OptionConstructor = _Value(nil),
		TextColor = _Value(Color3.new()),
		BackgroundColor = _Value(Color3.new()),
		Elevation = _Value(0),
		SchemeType = _Value(Enums.SchemeType.Light),
		FontData = _Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)),
		Scale = _Value(1),
	}
	local defaults: { [string]: unknown? } = {
		onInputEntered = DEFAULTS.NEW.ON_INPUT_ENTERED,
		label = DEFAULTS.NEW.LABEL,
		optionSolver = DEFAULTS.NEW.OPTION_SOLVER,
		optionConstructor = DEFAULTS.NEW.OPTION_CONSTRUCTOR,
		textColor = DEFAULTS.NEW.TEXT_COLOR,
		backgroundColor = DEFAULTS.NEW.BACKGROUND_COLOR,
		elevation = DEFAULTS.NEW.ELEVATION,
		schemeType = DEFAULTS.NEW.SCHEME_TYPE,
		fontData = DEFAULTS.NEW.FONT_DATA,
		scale = DEFAULTS.NEW.SCALE,
	}
	local inst: GuiObject = Source.new(
		definition.OnInputEntered,
		definition.Label,
		definition.OptionSolver,
		definition.OptionConstructor,
		definition.TextColor,
		definition.BackgroundColor,
		definition.Elevation,
		definition.SchemeType,
		definition.FontData,
		definition.Scale
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledFilled", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.primary(): StyledFilledWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		OnInputEntered = _Value(function(input: string)
			return input
		end),
		Label = _Value(""),
		OptionSolver = _Value(function(input: string)
			return {}
		end),
		OptionConstructor = _Value(nil),
		Elevation = _Value(0),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.PRIMARY.STYLE,
		onInputEntered = DEFAULTS.PRIMARY.ON_INPUT_ENTERED,
		label = DEFAULTS.PRIMARY.LABEL,
		optionSolver = DEFAULTS.PRIMARY.OPTION_SOLVER,
		optionConstructor = DEFAULTS.PRIMARY.OPTION_CONSTRUCTOR,
		elevation = DEFAULTS.PRIMARY.ELEVATION,
	}
	local inst: GuiObject = Source.primary(
		definition.Style,
		definition.OnInputEntered,
		definition.Label,
		definition.OptionSolver,
		definition.OptionConstructor,
		definition.Elevation
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledFilled", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.secondary(): StyledFilledWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		OnInputEntered = _Value(function(input: string)
			return input
		end),
		Label = _Value(""),
		OptionSolver = _Value(function(input: string)
			return {}
		end),
		OptionConstructor = _Value(nil),
		Elevation = _Value(0),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.SECONDARY.STYLE,
		onInputEntered = DEFAULTS.SECONDARY.ON_INPUT_ENTERED,
		label = DEFAULTS.SECONDARY.LABEL,
		optionSolver = DEFAULTS.SECONDARY.OPTION_SOLVER,
		optionConstructor = DEFAULTS.SECONDARY.OPTION_CONSTRUCTOR,
		elevation = DEFAULTS.SECONDARY.ELEVATION,
	}
	local inst: GuiObject = Source.secondary(
		definition.Style,
		definition.OnInputEntered,
		definition.Label,
		definition.OptionSolver,
		definition.OptionConstructor,
		definition.Elevation
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledFilled", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.tertiary(): StyledFilledWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		OnInputEntered = _Value(function(input: string)
			return input
		end),
		Label = _Value(""),
		OptionSolver = _Value(function(input: string)
			return {}
		end),
		OptionConstructor = _Value(nil),
		Elevation = _Value(0),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.TERTIARY.STYLE,
		onInputEntered = DEFAULTS.TERTIARY.ON_INPUT_ENTERED,
		label = DEFAULTS.TERTIARY.LABEL,
		optionSolver = DEFAULTS.TERTIARY.OPTION_SOLVER,
		optionConstructor = DEFAULTS.TERTIARY.OPTION_CONSTRUCTOR,
		elevation = DEFAULTS.TERTIARY.ELEVATION,
	}
	local inst: GuiObject = Source.tertiary(
		definition.Style,
		definition.OnInputEntered,
		definition.Label,
		definition.OptionSolver,
		definition.OptionConstructor,
		definition.Elevation
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledFilled", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.primaryContainer(): StyledFilledWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		OnInputEntered = _Value(function(input: string)
			return input
		end),
		Label = _Value(""),
		OptionSolver = _Value(function(input: string)
			return {}
		end),
		OptionConstructor = _Value(nil),
		Elevation = _Value(0),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.PRIMARY_CONTAINER.STYLE,
		onInputEntered = DEFAULTS.PRIMARY_CONTAINER.ON_INPUT_ENTERED,
		label = DEFAULTS.PRIMARY_CONTAINER.LABEL,
		optionSolver = DEFAULTS.PRIMARY_CONTAINER.OPTION_SOLVER,
		optionConstructor = DEFAULTS.PRIMARY_CONTAINER.OPTION_CONSTRUCTOR,
		elevation = DEFAULTS.PRIMARY_CONTAINER.ELEVATION,
	}
	local inst: GuiObject = Source.primaryContainer(
		definition.Style,
		definition.OnInputEntered,
		definition.Label,
		definition.OptionSolver,
		definition.OptionConstructor,
		definition.Elevation
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledFilled", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.secondaryContainer(): StyledFilledWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		OnInputEntered = _Value(function(input: string)
			return input
		end),
		Label = _Value(""),
		OptionSolver = _Value(function(input: string)
			return {}
		end),
		OptionConstructor = _Value(nil),
		Elevation = _Value(0),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.SECONDARY_CONTAINER.STYLE,
		onInputEntered = DEFAULTS.SECONDARY_CONTAINER.ON_INPUT_ENTERED,
		label = DEFAULTS.SECONDARY_CONTAINER.LABEL,
		optionSolver = DEFAULTS.SECONDARY_CONTAINER.OPTION_SOLVER,
		optionConstructor = DEFAULTS.SECONDARY_CONTAINER.OPTION_CONSTRUCTOR,
		elevation = DEFAULTS.SECONDARY_CONTAINER.ELEVATION,
	}
	local inst: GuiObject = Source.secondaryContainer(
		definition.Style,
		definition.OnInputEntered,
		definition.Label,
		definition.OptionSolver,
		definition.OptionConstructor,
		definition.Elevation
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledFilled", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

function Interface.tertiaryContainer(): StyledFilledWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value
	local definition = {
		Style = _Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))),
		OnInputEntered = _Value(function(input: string)
			return input
		end),
		Label = _Value(""),
		OptionSolver = _Value(function(input: string)
			return {}
		end),
		OptionConstructor = _Value(nil),
		Elevation = _Value(0),
	}
	local defaults: { [string]: unknown? } = {
		style = DEFAULTS.TERTIARY_CONTAINER.STYLE,
		onInputEntered = DEFAULTS.TERTIARY_CONTAINER.ON_INPUT_ENTERED,
		label = DEFAULTS.TERTIARY_CONTAINER.LABEL,
		optionSolver = DEFAULTS.TERTIARY_CONTAINER.OPTION_SOLVER,
		optionConstructor = DEFAULTS.TERTIARY_CONTAINER.OPTION_CONSTRUCTOR,
		elevation = DEFAULTS.TERTIARY_CONTAINER.ELEVATION,
	}
	local inst: GuiObject = Source.tertiaryContainer(
		definition.Style,
		definition.OnInputEntered,
		definition.Label,
		definition.OptionSolver,
		definition.OptionConstructor,
		definition.Elevation
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledFilled", inst, definition, defaults)
	maid:GiveTask(cleanUp)
	return wrapper
end

return Interface
