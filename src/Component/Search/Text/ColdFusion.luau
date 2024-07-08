--!strict
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Base = require(script.Parent.Parent:WaitForChild("Base"))
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type ImageData = Types.ImageData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type Style = Style.Style
type Method = () -> ()
type OptionConstructor = Base.OptionConstructor
type FontData = Types.FontData

-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

Interface = {}

function Interface.onTertiaryContainer(
	style: CanBeState<Style>,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { string }>,
	optionConstructor: CanBeState<OptionConstructor?>,
	elevation: CanBeState<number?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, DEFAULTS.ON_TERTIARY_CONTAINER.STYLE)
	local elevationState = _import(elevation, DEFAULTS.ON_TERTIARY_CONTAINER.ELEVATION or 0)

	local out = Base.newBar(
		false,
		_import(onInputEntered, DEFAULTS.ON_TERTIARY_CONTAINER.ON_INPUT_ENTERED),
		_import(label, DEFAULTS.ON_TERTIARY_CONTAINER.LABEL),
		_import(optionSolver, DEFAULTS.ON_TERTIARY_CONTAINER.OPTION_SOLVER),
		_import(optionConstructor, DEFAULTS.ON_TERTIARY_CONTAINER.OPTION_CONSTRUCTOR),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnTertiaryContainer)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.TertiaryContainer)
		end, styleState),
		elevationState,
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.onTertiary(
	style: CanBeState<Style>,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { string }>,
	optionConstructor: CanBeState<OptionConstructor?>,
	elevation: CanBeState<number?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, DEFAULTS.ON_TERTIARY.STYLE)
	local elevationState = _import(elevation, DEFAULTS.ON_TERTIARY.ELEVATION)

	local out = Base.newBar(
		false,
		_import(onInputEntered, DEFAULTS.ON_TERTIARY.ON_INPUT_ENTERED),
		_import(label, DEFAULTS.ON_TERTIARY.LABEL),
		_import(optionSolver, DEFAULTS.ON_TERTIARY.OPTION_SOLVER),
		_import(optionConstructor, DEFAULTS.ON_TERTIARY.OPTION_CONSTRUCTOR),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnTertiary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Tertiary)
		end, styleState),
		elevationState,
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.onSecondaryContainer(
	style: CanBeState<Style>,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { string }>,
	optionConstructor: CanBeState<OptionConstructor?>,
	elevation: CanBeState<number?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, DEFAULTS.ON_SECONDARY_CONTAINER.STYLE)
	local elevationState = _import(elevation, DEFAULTS.ON_SECONDARY_CONTAINER.ELEVATION)

	local out = Base.newBar(
		false,
		_import(onInputEntered, DEFAULTS.ON_SECONDARY_CONTAINER.ON_INPUT_ENTERED),
		_import(label, DEFAULTS.ON_SECONDARY_CONTAINER.LABEL),
		_import(optionSolver, DEFAULTS.ON_SECONDARY_CONTAINER.OPTION_SOLVER),
		_import(optionConstructor, DEFAULTS.ON_SECONDARY_CONTAINER.OPTION_CONSTRUCTOR),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnSecondaryContainer)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.SecondaryContainer)
		end, styleState),
		elevationState,
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.onSecondary(
	style: CanBeState<Style>,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { string }>,
	optionConstructor: CanBeState<OptionConstructor?>,
	elevation: CanBeState<number?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, DEFAULTS.ON_SECONDARY.STYLE)
	local elevationState = _import(elevation, DEFAULTS.ON_SECONDARY.ELEVATION)

	local out = Base.newBar(
		false,
		_import(onInputEntered, DEFAULTS.ON_SECONDARY.ON_INPUT_ENTERED),
		_import(label, DEFAULTS.ON_SECONDARY.LABEL),
		_import(optionSolver, DEFAULTS.ON_SECONDARY.OPTION_SOLVER),
		_import(optionConstructor, DEFAULTS.ON_SECONDARY.OPTION_CONSTRUCTOR),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnSecondary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Secondary)
		end, styleState),
		elevationState,
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.onPrimaryContainer(
	style: CanBeState<Style>,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { string }>,
	optionConstructor: CanBeState<OptionConstructor?>,
	elevation: CanBeState<number?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed
	local styleState: State<Style> = _import(style, DEFAULTS.ON_PRIMARY_CONTAINER.STYLE)
	local elevationState = _import(elevation, DEFAULTS.ON_PRIMARY_CONTAINER.ELEVATION)

	local out = Base.newBar(
		false,
		_import(onInputEntered, DEFAULTS.ON_PRIMARY_CONTAINER.ON_INPUT_ENTERED),
		_import(label, DEFAULTS.ON_PRIMARY_CONTAINER.LABEL),
		_import(optionSolver, DEFAULTS.ON_PRIMARY_CONTAINER.OPTION_SOLVER),
		_import(optionConstructor, DEFAULTS.ON_PRIMARY_CONTAINER.OPTION_CONSTRUCTOR),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnPrimaryContainer)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.PrimaryContainer)
		end, styleState),
		elevationState,
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.onPrimary(
	style: CanBeState<Style>,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { string }>,
	optionConstructor: CanBeState<OptionConstructor?>,
	elevation: CanBeState<number?>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, DEFAULTS.ON_PRIMARY.STYLE)
	local elevationState = _import(elevation, DEFAULTS.ON_PRIMARY.ELEVATION)

	local out = Base.newBar(
		false,
		_import(onInputEntered, DEFAULTS.ON_PRIMARY.ON_INPUT_ENTERED),
		_import(label, DEFAULTS.ON_PRIMARY.LABEL),
		_import(optionSolver, DEFAULTS.ON_PRIMARY.OPTION_SOLVER),
		_import(optionConstructor, DEFAULTS.ON_PRIMARY.OPTION_CONSTRUCTOR),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnPrimary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Primary)
		end, styleState),
		elevationState,
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.new(
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { string }>,
	optionConstructor: CanBeState<OptionConstructor?>,
	textColor: CanBeState<Color3>,
	backgroundColor: CanBeState<Color3>,
	elevation: CanBeState<number>,
	schemeType: CanBeState<Enums.SchemeType>,
	fontData: CanBeState<FontData>,
	scale: CanBeState<number>
): GuiObject
	return Base.newBar(
		false,
		if onInputEntered ~= nil then onInputEntered else DEFAULTS.NEW.ON_INPUT_ENTERED,
		if label ~= nil then label else DEFAULTS.NEW.LABEL,
		if optionSolver ~= nil then optionSolver else DEFAULTS.NEW.OPTION_SOLVER,
		if optionConstructor ~= nil then optionConstructor else DEFAULTS.NEW.OPTION_CONSTRUCTOR,
		if textColor ~= nil then textColor else DEFAULTS.NEW.TEXT_COLOR,
		if backgroundColor ~= nil then backgroundColor else DEFAULTS.NEW.BACKGROUND_COLOR,
		if elevation ~= nil then elevation else DEFAULTS.NEW.ELEVATION or 0,
		if schemeType ~= nil then schemeType else DEFAULTS.NEW.SCHEME_TYPE,
		if fontData ~= nil then fontData else DEFAULTS.NEW.FONT_DATA,
		if scale ~= nil then scale else DEFAULTS.NEW.SCALE
	)
end

return Interface
