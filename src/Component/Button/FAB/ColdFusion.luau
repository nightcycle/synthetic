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
local UP_SCALE = 56 / 40

-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

-- Private Functions
function newThemedComponent(
	themeDefaults: typeof(DEFAULTS.PRIMARY),
	textColor: Enums.ColorRoleType,
	surfaceColor: Enums.ColorRoleType,
	disabledTextColor: Enums.ColorRoleType,
	disabledSurfaceColor: Enums.ColorRoleType,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
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
		_import(icon, themeDefaults.ICON),
		_Computed(function(s: Style): Color3
			return s:GetColor(textColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(surfaceColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(disabledTextColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(disabledSurfaceColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Shadow)
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

function Interface.primary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.PRIMARY,
		Enums.ColorRoleType.OnPrimary,
		Enums.ColorRoleType.Primary,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SurfaceVariant,
		onClick,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.secondary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.SECONDARY,
		Enums.ColorRoleType.OnSecondary,
		Enums.ColorRoleType.Secondary,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SurfaceVariant,
		onClick,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.tertiary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.TERTIARY,
		Enums.ColorRoleType.OnTertiary,
		Enums.ColorRoleType.Tertiary,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SurfaceVariant,
		onClick,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.primaryContainer(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.PRIMARY_CONTAINER,
		Enums.ColorRoleType.OnPrimaryContainer,
		Enums.ColorRoleType.PrimaryContainer,
		Enums.ColorRoleType.OnSecondaryContainer,
		Enums.ColorRoleType.SurfaceContainer,
		onClick,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.secondaryContainer(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.SECONDARY_CONTAINER,
		Enums.ColorRoleType.OnSecondaryContainer,
		Enums.ColorRoleType.SecondaryContainer,
		Enums.ColorRoleType.OnSecondaryContainer,
		Enums.ColorRoleType.SurfaceContainer,
		onClick,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.tertiaryContainer(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.TERTIARY_CONTAINER,
		Enums.ColorRoleType.OnTertiaryContainer,
		Enums.ColorRoleType.TertiaryContainer,
		Enums.ColorRoleType.OnSecondaryContainer,
		Enums.ColorRoleType.SurfaceContainer,
		onClick,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.new(
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	textColor: CanBeState<Color3>,
	surfaceColor: CanBeState<Color3>,
	disabledTextColor: CanBeState<Color3>,
	disabledSurfaceColor: CanBeState<Color3>,
	shadowColor: CanBeState<Color3>,
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
	local surfaceColorState: State<Color3> = _import(surfaceColor, DEFAULTS.NEW.SURFACE_COLOR)

	local disabledTextColorState: State<Color3> = _import(disabledTextColor, DEFAULTS.NEW.DISABLED_TEXT_COLOR)
	local disabledSurfaceColorState: State<Color3> =
		_import(disabledSurfaceColor, DEFAULTS.NEW.DISABLED_SURFACE_COLOR)

	local shadowColorState: State<Color3> = _import(shadowColor, DEFAULTS.NEW.SHADOW_COLOR)

	local iconState: State<ImageData?> = _import(icon, DEFAULTS.NEW.ICON)

	local button = Base.new(
		maid,
		_import(onClick, DEFAULTS.NEW.ON_CLICK),
		"",
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
				sHC: Color3,
				i: ImageData?
			): { [Enums.ButtonStateType]: RenderData }
				e += 1
				return {
					[Enums.ButtonStateType.Enabled] = Types._RenderData.new(
						sc * UP_SCALE,
						Types._AppearanceData.new(Theme.getElevatedColor(sC, e, st), 1),
						Types._AppearanceData.new(Theme.getElevatedColor(sC, e, st), 0),
						Types._AppearanceData.new(Theme.getElevatedColor(tC, e, st), 0),
						f,
						i,
						nil,
						Types._ShadowData.new(
							Types._AppearanceData.new(Theme.getElevatedColor(sHC, e, st), 0),
							Vector2.new(0, 1)
						)
					),
					[Enums.ButtonStateType.Disabled] = Types._RenderData.new(
						sc * UP_SCALE,
						Types._AppearanceData.new(Theme.getElevatedColor(dSC, e, st), 1),
						Types._AppearanceData.new(Theme.getElevatedColor(dSC, e, st), 0.12),
						Types._AppearanceData.new(Theme.getElevatedColor(dTC, e, st), 0.12),
						f,
						i,
						nil,
						Types._ShadowData.new(
							Types._AppearanceData.new(Theme.getElevatedColor(sHC, e, st), 0),
							Vector2.new(0, 1)
						)
					),
					[Enums.ButtonStateType.Hovered] = Types._RenderData.new(
						sc * UP_SCALE,
						Types._AppearanceData.new(Theme.getElevatedColor(sC, e, st), 1),
						Types._AppearanceData.new(Theme.getElevatedColor(sC, e + 1, st), 0.08),
						Types._AppearanceData.new(Theme.getElevatedColor(tC, e + 1, st), 0.08),
						f,
						i,
						nil,
						Types._ShadowData.new(
							Types._AppearanceData.new(Theme.getElevatedColor(sHC, e, st), 0),
							Vector2.new(0, 1)
						)
					),
					[Enums.ButtonStateType.Focused] = Types._RenderData.new(
						sc * UP_SCALE,
						Types._AppearanceData.new(Theme.getElevatedColor(sC, e, st), 1),
						Types._AppearanceData.new(Theme.getElevatedColor(sC, e, st), 0.1),
						Types._AppearanceData.new(Theme.getElevatedColor(tC, e, st), 0.1),
						f,
						i,
						nil,
						Types._ShadowData.new(
							Types._AppearanceData.new(Theme.getElevatedColor(sHC, e, st), 0),
							Vector2.new(0, 1)
						)
					),
					[Enums.ButtonStateType.Pressed] = Types._RenderData.new(
						sc * UP_SCALE,
						Types._AppearanceData.new(Theme.getElevatedColor(sC, e, st), 1),
						Types._AppearanceData.new(Theme.getElevatedColor(sC, e - 1, st), 0.1),
						Types._AppearanceData.new(Theme.getElevatedColor(tC, e - 1, st), 0.1),
						f,
						i,
						Types._SoundData.new(Sounds.Library[Enums.SoundType.ui_tap_variant_01], 0),
						Types._ShadowData.new(
							Types._AppearanceData.new(Theme.getElevatedColor(sHC, e, st), 0),
							Vector2.new(0, 1)
						)
					),
				}
			end,
			schemeTypeState,
			scaleState,
			fontDataState,
			elevationState,
			textColorState,
			surfaceColorState,
			disabledTextColorState,
			disabledSurfaceColorState,
			shadowColorState,
			iconState
		),
		false,
		16,
		1,
		true
	)
	maid:GiveTask(button.Destroying:Connect(function()
		maid:Destroy()
	end))

	return button
end

return Interface
