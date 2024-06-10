--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Base = require(script.Parent:WaitForChild("Base"))
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
-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

Interface.ColdFusion = {}

function Interface.ColdFusion.onTertiaryContainer(
	style: CanBeState<Style>,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { [number]: string }>,
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

	local styleState: State<Style> = _import(style, nil :: any)
	local elevationState = _import(elevation, 0)

	local out = Base.newBar(
		false,
		onInputEntered,
		label,
		optionSolver,
		optionConstructor,
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

function Interface.ColdFusion.onTertiary(
	style: CanBeState<Style>,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { [number]: string }>,
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

	local styleState: State<Style> = _import(style, nil :: any)
	local elevationState = _import(elevation, 0)

	local out = Base.newBar(
		false,
		onInputEntered,
		label,
		optionSolver,
		optionConstructor,
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

function Interface.ColdFusion.onSecondaryContainer(
	style: CanBeState<Style>,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { [number]: string }>,
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

	local styleState: State<Style> = _import(style, nil :: any)
	local elevationState = _import(elevation, 0)

	local out = Base.newBar(
		false,
		onInputEntered,
		label,
		optionSolver,
		optionConstructor,
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

function Interface.ColdFusion.onSecondary(
	style: CanBeState<Style>,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { [number]: string }>,
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

	local styleState: State<Style> = _import(style, nil :: any)
	local elevationState = _import(elevation, 0)

	local out = Base.newBar(
		false,
		onInputEntered,
		label,
		optionSolver,
		optionConstructor,
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

function Interface.ColdFusion.onPrimaryContainer(
	style: CanBeState<Style>,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { [number]: string }>,
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

	local styleState: State<Style> = _import(style, nil :: any)
	local elevationState = _import(elevation, 0)

	local out = Base.newBar(
		false,
		onInputEntered,
		label,
		optionSolver,
		optionConstructor,
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

function Interface.ColdFusion.onPrimary(
	style: CanBeState<Style>,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { [number]: string }>,
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

	local styleState: State<Style> = _import(style, nil :: any)
	local elevationState = _import(elevation, 0)

	local out = Base.newBar(
		false,
		onInputEntered,
		label,
		optionSolver,
		optionConstructor,
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

function Interface.ColdFusion.new(
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> { [number]: string }>,
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
		onInputEntered,
		label,
		optionSolver,
		optionConstructor,
		textColor,
		backgroundColor,
		elevation,
		schemeType,
		fontData,
		scale
	)
end

return Interface
