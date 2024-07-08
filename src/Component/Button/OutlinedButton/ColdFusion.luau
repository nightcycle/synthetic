--!strict
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Sounds = require(_Package:WaitForChild("Sounds"))
local Enums = require(_Package:WaitForChild("Enums"))
local Types = require(_Package:WaitForChild("Types"))
local Base = require(script.Parent.Parent:WaitForChild("Base"))
local Style = require(_Package:WaitForChild("Style"))
local Theme = require(_Package:WaitForChild("Theme"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type Style = Style.Style
type ImageData = Types.ImageData
type FontData = Types.FontData

-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

-- Private Functions
function newThemedComponent(
	themeDefaults: typeof(DEFAULTS.ON_PRIMARY),
	textColor: Enums.ColorRoleType,
	disabledTextColor: Enums.ColorRoleType,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	style: CanBeState<Style>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, themeDefaults.STYLE)

	local out = Interface.new(
		_import(onClick, themeDefaults.ON_CLICK),
		_import(text, themeDefaults.TEXT),
		_import(icon, themeDefaults.ICON),
		_Computed(function(s: Style): Color3
			return s:GetColor(textColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(disabledTextColor)
		end, styleState),
		_import(isEnabled, if themeDefaults.IS_ENABLED ~= nil then themeDefaults.IS_ENABLED else true),
		_import(elevation, themeDefaults.ELEVATION or 0),
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
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.ON_PRIMARY,
		Enums.ColorRoleType.OnPrimary,
		Enums.ColorRoleType.OnSurfaceVariant,
		onClick,
		text,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.onSecondary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.ON_SECONDARY,
		Enums.ColorRoleType.OnSecondary,
		Enums.ColorRoleType.OnSurfaceVariant,
		onClick,
		text,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.onTertiary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.ON_TERTIARY,
		Enums.ColorRoleType.OnTertiary,
		Enums.ColorRoleType.SurfaceVariant,
		onClick,
		text,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.onPrimaryContainer(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.ON_PRIMARY_CONTAINER,
		Enums.ColorRoleType.OnPrimaryContainer,
		Enums.ColorRoleType.Primary,
		onClick,
		text,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.onSecondaryContainer(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.ON_SECONDARY_CONTAINER,
		Enums.ColorRoleType.OnSecondaryContainer,
		Enums.ColorRoleType.Secondary,
		onClick,
		text,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.onTertiaryContainer(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.ON_TERTIARY_CONTAINER,
		Enums.ColorRoleType.OnTertiaryContainer,
		Enums.ColorRoleType.Tertiary,
		onClick,
		text,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.new(
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	textColor: CanBeState<Color3>,
	disabledTextColor: CanBeState<Color3>,
	isEnabled: CanBeState<boolean>,
	elevation: CanBeState<number>,
	schemeType: CanBeState<Enums.SchemeType>,
	fontData: CanBeState<FontData>,
	scale: CanBeState<number>
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local scaleState: State<number> = _import(scale, DEFAULTS.NEW.SCALE)
	local schemeTypeState: State<Enums.SchemeType> = _import(schemeType, DEFAULTS.NEW.SCHEME_TYPE)
	local fontDataState: State<FontData> = _import(fontData, DEFAULTS.NEW.FONT_DATA)
	local elevationState: State<number> = _import(elevation, DEFAULTS.NEW.ELEVATION)

	local textColorState: State<Color3> = _import(textColor, DEFAULTS.NEW.TEXT_COLOR)
	local hoverColorState: State<Color3> = _import(textColorState, DEFAULTS.NEW.TEXT_COLOR)

	local disabledTextColorState: State<Color3> = _import(disabledTextColor, DEFAULTS.NEW.DISABLED_TEXT_COLOR)
	local disabledHoverColorState: State<Color3> =
		_import(disabledTextColor, DEFAULTS.NEW.DISABLED_TEXT_COLOR)

	local iconState: State<ImageData?> = _import(icon, DEFAULTS.NEW.ICON)

	local button = Base.new(
		maid,
		_import(onClick, DEFAULTS.NEW.ON_CLICK),
		_import(text, DEFAULTS.NEW.TEXT),
		_import(isEnabled, DEFAULTS.NEW.IS_ENABLED),
		_Computed(
			function(
				st: Enums.SchemeType,
				sc: number,
				f: FontData,
				e: number,
				tC: Color3,
				sC: Color3,
				dTC: Color3,
				dSC: Color3,
				i: ImageData?
			): { [Enums.ButtonStateType]: RenderData }
				e += 1
				return {
					[Enums.ButtonStateType.Enabled] = Types._RenderData.new(
						sc,
						Types._AppearanceData.new(Theme.getElevatedColor(tC, e, st), 0),
						Types._AppearanceData.new(Theme.getElevatedColor(sC, e, st), 1),
						Types._AppearanceData.new(Theme.getElevatedColor(tC, e, st), 0),
						f,
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Disabled] = Types._RenderData.new(
						sc,
						Types._AppearanceData.new(Theme.getElevatedColor(dTC, e, st), 1 - 0.38),
						Types._AppearanceData.new(Theme.getElevatedColor(dSC, e, st), 1),
						Types._AppearanceData.new(Theme.getElevatedColor(dTC, e, st), 1 - 0.38),
						f,
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Hovered] = Types._RenderData.new(
						sc,
						Types._AppearanceData.new(Theme.getElevatedColor(tC, e + 1, st), 0),
						Types._AppearanceData.new(Theme.getElevatedColor(sC, e + 1, st), 1 - 0.08),
						Types._AppearanceData.new(Theme.getElevatedColor(tC, e + 1, st), 0),
						f,
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Focused] = Types._RenderData.new(
						sc,
						Types._AppearanceData.new(Theme.getElevatedColor(tC, e, st), 0),
						Types._AppearanceData.new(Theme.getElevatedColor(sC, e, st), 1 - 0.1),
						Types._AppearanceData.new(Theme.getElevatedColor(tC, e, st), 0),
						f,
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Pressed] = Types._RenderData.new(
						sc,
						Types._AppearanceData.new(Theme.getElevatedColor(tC, e, st), 1),
						Types._AppearanceData.new(Theme.getElevatedColor(sC, e - 1, st), 0.1),
						Types._AppearanceData.new(Theme.getElevatedColor(tC, e - 1, st), 0.1),
						f,
						i,
						Types._SoundData.new(Sounds.Library[Enums.SoundType.ui_tap_variant_01], 0),
						nil
					),
				}
			end,
			schemeTypeState,
			scaleState,
			fontDataState,
			elevationState,
			textColorState,
			hoverColorState,
			disabledTextColorState,
			disabledHoverColorState,
			iconState
		),
		nil,
		nil,
		nil,
		nil
	)
	maid:GiveTask(button.Destroying:Connect(function()
		maid:Destroy()
	end))

	return button
end

return Interface
