--!strict
local _Package = script.Parent.Parent.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local TopBase = require(script.Parent:WaitForChild("Base"))
local Enums = require(_Package:WaitForChild("Enums"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type ImageData = Types.ImageData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type Style = Style.Style
type FontData = Types.FontData
-- Constants
-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

function newThemedComponent(
	style: CanBeState<Style>,

	backgroundColor: Enums.ColorRoleType,
	textColor: Enums.ColorRoleType,

	title: CanBeState<string>,
	buttons: CanBeState<{
		[number]: ButtonData,
	}>,
	navigation: CanBeState<ButtonData?>,
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

	local out = Interface.ColdFusion.new(
		title,
		buttons,
		navigation,
		_Computed(function(s: Style): Color3
			return s:GetColor(backgroundColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(textColor)
		end, styleState),
		_import(elevation, 0),
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.TitleLarge)
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.HeadlineMedium)
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

Interface.ColdFusion = {}

function Interface.ColdFusion.primary(
	style: CanBeState<Style>,
	title: CanBeState<string>,
	buttons: CanBeState<{
		[number]: ButtonData,
	}>,
	navigation: CanBeState<ButtonData?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		style,
		Enums.ColorRoleType.Primary,
		Enums.ColorRoleType.OnPrimary,
		title,
		buttons,
		navigation,
		elevation
	)
end

function Interface.ColdFusion.secondary(
	style: CanBeState<Style>,
	title: CanBeState<string>,
	buttons: CanBeState<{
		[number]: ButtonData,
	}>,
	navigation: CanBeState<ButtonData?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		style,
		Enums.ColorRoleType.Secondary,
		Enums.ColorRoleType.OnSecondary,
		title,
		buttons,
		navigation,
		elevation
	)
end

function Interface.ColdFusion.tertiary(
	style: CanBeState<Style>,
	title: CanBeState<string>,
	buttons: CanBeState<{
		[number]: ButtonData,
	}>,
	navigation: CanBeState<ButtonData?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		style,
		Enums.ColorRoleType.Tertiary,
		Enums.ColorRoleType.OnTertiary,
		title,
		buttons,
		navigation,
		elevation
	)
end

function Interface.ColdFusion.new(
	title: CanBeState<string>,
	buttons: CanBeState<{
		[number]: ButtonData,
	}>,
	navigation: CanBeState<ButtonData?>,
	backgroundColor: CanBeState<Color3>,
	textColor: CanBeState<Color3>,
	elevation: CanBeState<number>,
	schemeType: CanBeState<Enums.SchemeType>,
	titleFontData: CanBeState<FontData>,
	subHeadingFontData: CanBeState<FontData>,
	buttonFontData: CanBeState<FontData>,
	scale: CanBeState<number>
): GuiObject
	return TopBase.component(
		title,
		buttons,
		navigation,
		"Small",
		backgroundColor,
		textColor,
		elevation,
		schemeType,
		titleFontData,
		subHeadingFontData,
		buttonFontData,
		scale
	)
end

return Interface
