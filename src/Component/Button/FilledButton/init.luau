--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Sounds = require(_Package:WaitForChild("Sounds"))
local Enums = require(_Package:WaitForChild("Enums"))
local Types = require(_Package:WaitForChild("Types"))
local Base = require(script.Parent:WaitForChild("Base"))
local Style = require(_Package:WaitForChild("Style"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type Style = Style.Style
type ImageData = Types.ImageData

-- Constants
-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

-- Private Functions
function newThemedComponent(
	textColor: Enums.ColorRoleType,
	surfaceColor: Enums.ColorRoleType,
	disabledTextColor: Enums.ColorRoleType,
	disabledSurfaceColor: Enums.ColorRoleType,
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

	local styleState: State<Style> = _import(style, nil :: any)

	local out = Interface.ColdFusion.new(
		onClick,
		text,
		icon,
		style,
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
		_import(isEnabled, true),
		_import(elevation, 0)
	)

	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

Interface.ColdFusion = {}

function Interface.ColdFusion.primary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		Enums.ColorRoleType.OnPrimary,
		Enums.ColorRoleType.Primary,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SurfaceVariant,
		onClick,
		text,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.secondary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		Enums.ColorRoleType.OnSecondary,
		Enums.ColorRoleType.Secondary,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SurfaceVariant,
		onClick,
		text,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.tertiary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		Enums.ColorRoleType.OnTertiary,
		Enums.ColorRoleType.Tertiary,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SurfaceVariant,
		onClick,
		text,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.primaryContainer(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		Enums.ColorRoleType.OnPrimaryContainer,
		Enums.ColorRoleType.PrimaryContainer,
		Enums.ColorRoleType.OnSecondaryContainer,
		Enums.ColorRoleType.SurfaceContainer,
		onClick,
		text,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.secondaryContainer(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		Enums.ColorRoleType.OnSecondaryContainer,
		Enums.ColorRoleType.SecondaryContainer,
		Enums.ColorRoleType.OnSecondaryContainer,
		Enums.ColorRoleType.SurfaceContainer,
		onClick,
		text,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.tertiaryContainer(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		Enums.ColorRoleType.OnTertiaryContainer,
		Enums.ColorRoleType.TertiaryContainer,
		Enums.ColorRoleType.OnSecondaryContainer,
		Enums.ColorRoleType.SurfaceContainer,
		onClick,
		text,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.new(
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	textColor: CanBeState<Color3>,
	surfaceColor: CanBeState<Color3>,
	disabledTextColor: CanBeState<Color3>,
	disabledSurfaceColor: CanBeState<Color3>,
	isEnabled: CanBeState<boolean>,
	elevation: CanBeState<number>
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

	local elevationState: State<number> = _import(elevation, 0)

	local textColorState: State<Color3> = _import(textColor, Color3.new(1, 1, 1))
	local surfaceColorState: State<Color3> = _import(surfaceColor, Color3.new(1, 1, 1))

	local disabledTextColorState: State<Color3> = _import(disabledTextColor, Color3.new(1, 1, 1))
	local disabledSurfaceColorState: State<Color3> = _import(disabledSurfaceColor, Color3.new(1, 1, 1))

	local iconState: State<ImageData?> = _import(icon, nil :: ImageData?)

	local button = Base.component(
		maid,
		onClick,
		text,
		if isEnabled == nil then true else isEnabled,
		_Computed(
			function(
				s: Style,
				e: number,
				tC: Color3,
				sC: Color3,
				dTC: Color3,
				dSC: Color3,
				i: ImageData?
			): { [Enums.ButtonStateType]: RenderData }
				e += 1
				return {
					[Enums.ButtonStateType.Enabled] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(sC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(sC, e), 0),
						Types.newAppearanceData(s:GetElevatedColor(tC, e), 0),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Disabled] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(dSC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(dSC, e), 0.12),
						Types.newAppearanceData(s:GetElevatedColor(dTC, e), 0.12),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Hovered] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(sC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(sC, e + 1), 0.08),
						Types.newAppearanceData(s:GetElevatedColor(tC, e + 1), 0.08),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Focused] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(sC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(sC, e), 0.1),
						Types.newAppearanceData(s:GetElevatedColor(tC, e), 0.1),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Pressed] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(sC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(sC, e - 1), 0.1),
						Types.newAppearanceData(s:GetElevatedColor(tC, e - 1), 0.1),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						Types.newSoundData(Sounds.Library[Enums.SoundType.ui_tap_variant_01], 0),
						nil
					),
				}
			end,
			styleState,
			elevationState,
			textColorState,
			surfaceColorState,
			disabledTextColorState,
			disabledSurfaceColorState,
			iconState
		),
		nil,
		nil,
		nil,
		true
	)
	maid:GiveTask(button.Destroying:Connect(function()
		maid:Destroy()
	end))

	return button
end

return Interface
