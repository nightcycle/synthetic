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
local Typography = require(_Package:WaitForChild("Typography"))
local Theme = require(_Package:WaitForChild("Theme"))
local Style = require(_Package:WaitForChild("Style"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type Typography = Typography.Typography
type Theme = Theme.Theme
type Style = Style.Style
type ImageData = Types.ImageData

-- Constants
-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

Interface.ColdFusion = {}

function Interface.ColdFusion.new(
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
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
	local textColorState: State<Color3> = _import(textColor, Color3.new(1,1,1))
	local hoverColorState: State<Color3> = _import(textColor, Color3.new(1,1,1))
	local disabledColorState: State<Color3> = _import(disabledTextColor, Color3.new(1,1,1))

	local iconState: State<ImageData?> = _import(icon, nil :: ImageData?)

	local button = Base.component(
		maid,
		onClick,
		text,
		if isEnabled == nil then true else isEnabled,
		_Computed(function(
			style: Style, 
			e: number,
			hC: Color3,
			tC: Color3,
			dC: Color3,
			i: ImageData?
		): {[Enums.ButtonStateType]: RenderData}
			e += 1
			return {
				[Enums.ButtonStateType.Enabled] = Types.newRenderData(
					style.Scale,
					Types.newAppearanceData(
						style:GetElevatedColor(tC, e), 
						0
					),
					Types.newAppearanceData(
						style:GetElevatedColor(hC, e), 
						1
					),
					Types.newAppearanceData(
						style:GetElevatedColor(tC, e), 
						0
					),
					style.Typography:Get(Enums.FontType.LabelLarge),
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Disabled] = Types.newRenderData(
					style.Scale,
					Types.newAppearanceData(
						style:GetElevatedColor(dC, e), 
						1-0.38
					),
					Types.newAppearanceData(
						style:GetElevatedColor(hC, e), 
						1
					),
					Types.newAppearanceData(
						style:GetElevatedColor(dC, e), 
						1-0.38
					),
					style.Typography:Get(Enums.FontType.LabelLarge),
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Hovered] = Types.newRenderData(
					style.Scale,
					Types.newAppearanceData(
						style:GetElevatedColor(tC, e+1), 
						0
					),
					Types.newAppearanceData(
						style:GetElevatedColor(hC, e+1), 
						1-0.08
					),
					Types.newAppearanceData(
						style:GetElevatedColor(tC, e+1), 
						0
					),
					style.Typography:Get(Enums.FontType.LabelLarge),
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Focused] = Types.newRenderData(
					style.Scale,
					Types.newAppearanceData(
						style:GetElevatedColor(tC, e), 
						0
					),
					Types.newAppearanceData(
						style:GetElevatedColor(hC, e), 
						1-0.1
					),
					Types.newAppearanceData(
						style:GetElevatedColor(tC, e), 
						0
					),
					style.Typography:Get(Enums.FontType.LabelLarge),
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Pressed] = Types.newRenderData(
					style.Scale,
					Types.newAppearanceData(
						style:GetElevatedColor(tC, e-1), 
						0
					),
					Types.newAppearanceData(
						style:GetElevatedColor(hC, e-1), 
						1-0.1
					),
					Types.newAppearanceData(
						style:GetElevatedColor(tC, e-1), 
						0
					),
					style.Typography:Get(Enums.FontType.LabelLarge),
					i,
					Types.newSoundData(
						Sounds.ui_tap_variant_01,
						1
					),
					nil
				),
			}
		end, styleState, elevationState, hoverColorState, textColorState, disabledColorState, iconState),
		nil,
		nil,
		nil,
		nil
	)
	maid.bind(button)

	return button
end


return Interface
