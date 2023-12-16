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

function newThemedComponent(
	textColor: Enums.ColorRoleType,
	disabledTextColor: Enums.ColorRoleType,
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

	local styleState: State<Style> = _import(style, nil :: any)

	local out = Interface.ColdFusion.new(
		onClick,
		icon,
		style,
		_Computed(function(s: Style): Color3
			return s:GetColor(textColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(disabledTextColor)
		end, styleState),
		_import(isEnabled, true),
		_import(elevation, 0)
	)

	maid.bind(out)

	return out
end

Interface.ColdFusion = {}

function Interface.ColdFusion.primary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		Enums.ColorRoleType.Primary,
		Enums.ColorRoleType.OnSurfaceVariant,
		onClick,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.secondary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		Enums.ColorRoleType.Secondary,
		Enums.ColorRoleType.OnSurfaceVariant,
		onClick,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.tertiary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		Enums.ColorRoleType.Tertiary,
		Enums.ColorRoleType.OnSurfaceVariant,
		onClick,
		icon,
		style,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.new(
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData?>,
	style: CanBeState<Style>,
	textColor: CanBeState<Color3>,
	disabledTextColor: CanBeState<Color3>,
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
	local hoverColorState: State<Color3> = _import(textColor, Color3.new(1, 1, 1))
	local disabledColorState: State<Color3> = _import(disabledTextColor, Color3.new(1, 1, 1))

	local iconState: State<ImageData?> = _import(icon, nil :: ImageData?)

	local button = Base.component(
		maid,
		onClick,
		"",
		if isEnabled == nil then true else isEnabled,
		_Computed(
			function(
				s: Style,
				e: number,
				hC: Color3,
				tC: Color3,
				dC: Color3,
				i: ImageData?
			): { [Enums.ButtonStateType]: RenderData }
				e += 1
				return {
					[Enums.ButtonStateType.Enabled] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(tC, e), 0),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Disabled] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(dC, e), 1 - 0.38),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Hovered] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(hC, e + 1), 1 - 0.08),
						Types.newAppearanceData(s:GetElevatedColor(tC, e + 1), 0),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Focused] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1 - 0.1),
						Types.newAppearanceData(s:GetElevatedColor(tC, e), 0),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Pressed] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(hC, e - 1), 1 - 0.1),
						Types.newAppearanceData(s:GetElevatedColor(tC, e - 1), 0),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						Types.newSoundData(Sounds.Library[Enums.SoundType.ui_tap_variant_01], 1),
						nil
					),
				}
			end,
			styleState,
			elevationState,
			hoverColorState,
			textColorState,
			disabledColorState,
			iconState
		),
		false,
		nil,
		0.8,
		nil
	)
	maid.bind(button)

	return button
end

return Interface
