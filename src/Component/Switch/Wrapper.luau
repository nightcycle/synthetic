--!strict
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
type CanBeState<V> = ColdFusion.CanBeState<V>
type ValueState<V> = ColdFusion.ValueState<V>
type Wrapper<BaseInstance, Definition, ClassName> = Translators.Wrapper<BaseInstance, Definition, ClassName>
export type StyledSwitchWrapperDefinition = {
	Style: Style,
	OnSelect: (isSelected: boolean) -> (),
	InitialSelection: boolean,
	IncludeIconOnSelected: boolean,
	IncludeIconOnDeselected: boolean,
	Elevation: number,
	IsEnabled: boolean,
}
export type StyledSwitchWrapper = Wrapper<GuiObject, StyledSwitchWrapperDefinition, "StyledSwitch">
export type SwitchWrapperDefinition = {
	OnSelect: (isSelected: boolean) -> (),
	InitialSelection: boolean,
	IsEnabled: boolean,
	IncludeIconOnSelected: boolean,
	IncludeIconOnDeselected: boolean,
	BackgroundColor: Color3,
	OnBackgroundColor: Color3,
	FillColor: Color3,
	ButtonColor: Color3,
	OnButtonColor: Color3,
	DisabledColor: Color3,
	OnDisabledColor: Color3,
	Elevation: number,
	SchemeType: Enums.SchemeType,
	FontData: FontData,
	Scale: number,
}
export type SwitchWrapper = Wrapper<GuiObject, SwitchWrapperDefinition, "Switch">

-- Constants
-- Variables
-- References
-- Private Functions
function styleWrapperConstructor(constructor: typeof(Source.primary)): StyledSwitchWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value

	local definition = {
		Style = _Value(Style.new(1, "Arial", "Light", Color3.new(0, 0.4, 0.7))),
		OnSelect = _Value(function(isSelected: boolean) end),
		InitialSelection = _Value(false),
		IncludeIconOnSelected = _Value(false),
		IncludeIconOnDeselected = _Value(false),
		Elevation = _Value(0),
		IsEnabled = _Value(true),
	}

	local inst: GuiObject = constructor(
		definition.Style,
		definition.OnSelect,
		definition.InitialSelection,
		definition.IncludeIconOnSelected,
		definition.IncludeIconOnDeselected,
		definition.Elevation,
		definition.IsEnabled
	)

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("StyledSwitch", inst, definition)
	maid:GiveTask(cleanUp)

	return wrapper
end


-- Class
local Interface = {}

function Interface.primary(): StyledSwitchWrapper
	return styleWrapperConstructor(Source.primary)
end

function Interface.secondary(): StyledSwitchWrapper 
	return styleWrapperConstructor(Source.secondary)
end

function Interface.tertiary(): StyledSwitchWrapper 
	return styleWrapperConstructor(Source.tertiary)
end

function Interface.new(): SwitchWrapper
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _Value = _fuse.Value

	local definition = {
		OnSelect = _Value(function(isSelected: boolean) end),
		InitialSelection = _Value(false),
		IsEnabled = _Value(true),
		IncludeIconOnSelected = _Value(false),
		IncludeIconOnDeselected = _Value(false),
		BackgroundColor = Color3.new(),
		OnBackgroundColor = Color3.new(),
		FillColor = Color3.new(),
		ButtonColor = Color3.new(),
		OnButtonColor = Color3.new(),
		DisabledColor = Color3.new(),
		OnDisabledColor = Color3.new(),
		Elevation = 0,
		SchemeType = Enums.SchemeType.Light,
		FontData = Types.newFontData(Font.fromEnum(Enum.Font.ArialBold), 14),
		Scale = 1,
	}

	local inst: GuiObject = Source.new(
		definition.OnSelect,
		definition.InitialSelection,
		definition.IsEnabled,
		definition.IncludeIconOnSelected,
		definition.IncludeIconOnDeselected,
		definition.BackgroundColor,
		definition.OnBackgroundColor,
		definition.FillColor,
		definition.ButtonColor,
		definition.OnButtonColor,
		definition.DisabledColor,
		definition.OnDisabledColor,
		definition.Elevation,
		definition.SchemeType,
		definition.FontData,
		definition.Scale
	)

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	local wrapper, cleanUp = Translators.ColdFusion.toWrapper("Switch", inst, definition)
	maid:GiveTask(cleanUp)

	return wrapper
end

return Interface
