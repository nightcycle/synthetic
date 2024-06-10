--!strict
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
local Base = require(_Package:WaitForChild("Component"):WaitForChild("Button"):WaitForChild("Base"))
local Sounds = require(_Package:WaitForChild("Sounds"))
local Theme = require(_Package:WaitForChild("Style"):WaitForChild("Theme"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type ImageData = Types.ImageData
type ButtonData = Types.ButtonData
type FontData = Types.FontData
type Style = Style.Style

-- Constants
local INVIS = 0.99
-- Variables
-- References
-- Private Functions
-- Class
local Interface = {}

function Interface.new(
	onClick: CanBeState<(isSelected: boolean) -> ()>,
	isInitiallySelected: CanBeState<boolean>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	scale: CanBeState<number>,
	fontData: CanBeState<FontData>,
	schemeType: CanBeState<Enums.SchemeType>,
	textColor: CanBeState<Color3>,
	disabledTextColor: CanBeState<Color3>,
	fillTextColor: CanBeState<Color3>,
	disabledFillTextColor: CanBeState<Color3>,
	fillColor: CanBeState<Color3>,
	disabledFillColor: CanBeState<Color3>,
	isEnabled: CanBeState<boolean>,
	elevation: CanBeState<number>,
	isButton: CanBeState<boolean>?
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local scaleState: State<number> = _import(scale, 1)
	local fontDataState: State<FontData> = _import(fontData, nil :: any)
	local schemeTypeState: State<Enums.SchemeType> = _import(schemeType, Enums.SchemeType.Light)
	local elevationState: State<number> = _import(elevation, 0)
	local textColorState: State<Color3> = _import(textColor, Color3.new(1, 1, 1))
	local fillTextColorState: State<Color3> = _import(fillTextColor, Color3.new(1, 1, 1))
	local disabledFillTextColorState: State<Color3> = _import(disabledFillTextColor, Color3.new(1, 1, 1))
	local isButtonState: State<boolean> = _import(isButton, false)

	local fillColorState: State<Color3> = _import(fillColor, Color3.new(1, 1, 1))
	local disabledFillColorState: State<Color3> = _import(disabledFillColor, Color3.new(1, 1, 1))

	local hoverColorState: State<Color3> = _import(textColor, Color3.new(1, 1, 1))
	local disabledTextColorState: State<Color3> = _import(disabledTextColor, Color3.new(1, 1, 1))

	local onClickState = _import(onClick, function(isSel: boolean) end)

	local isInitiallySelectedState = _import(isInitiallySelected, false)

	local iconState: State<ImageData?> = _import(icon, nil :: ImageData?)

	local clickCountState = _Value(0)
	isInitiallySelectedState:Connect(function()
		clickCountState:Set(0)
	end)

	local isSelectedState = _Computed(function(i: boolean, c: number): boolean
		if i then
			return c % 2 == 0
		else
			return c % 2 == 1
		end
	end, isInitiallySelectedState, clickCountState)

	local outlineRenderDatasState = _Computed(
		function(
			sc: number,
			f: FontData,
			st: Enums.SchemeType,
			e: number,
			hC: Color3,
			tC: Color3,
			dC: Color3,
			i: ImageData?
		): { [Enums.ButtonStateType]: RenderData }
			e += 1
			return {
				[Enums.ButtonStateType.Enabled] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(tC, e, st), 0),
					Types.newAppearanceData(Theme.getElevatedColor(hC, e, st), INVIS),
					Types.newAppearanceData(Theme.getElevatedColor(tC, e, st), 0),
					f,
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Disabled] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(dC, e, st), 1 - 0.38),
					Types.newAppearanceData(Theme.getElevatedColor(hC, e, st), INVIS),
					Types.newAppearanceData(Theme.getElevatedColor(dC, e, st), 1 - 0.38),
					f,
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Hovered] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(tC, e + 1, st), 0),
					Types.newAppearanceData(Theme.getElevatedColor(hC, e + 1, st), 1 - 0.08),
					Types.newAppearanceData(Theme.getElevatedColor(tC, e + 1, st), 0),
					f,
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Focused] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(tC, e, st), 0),
					Types.newAppearanceData(Theme.getElevatedColor(hC, e, st), 1 - 0.1),
					Types.newAppearanceData(Theme.getElevatedColor(tC, e, st), 0),
					f,
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Pressed] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(tC, e - 1, st), 0),
					Types.newAppearanceData(Theme.getElevatedColor(hC, e - 1, st), 1 - 0.1),
					Types.newAppearanceData(Theme.getElevatedColor(tC, e - 1, st), 0),
					f,
					i,
					Types.newSoundData(Sounds.Library[Enums.SoundType.ui_tap_variant_01], 1),
					nil
				),
			}
		end,
		scaleState,
		fontDataState,
		schemeTypeState,
		elevationState,
		hoverColorState,
		textColorState,
		disabledTextColorState,
		iconState
	)

	local filledRenderDatasState = _Computed(
		function(
			sc: number,
			f: FontData,
			st: Enums.SchemeType,
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
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(sC, e, st), INVIS),
					Types.newAppearanceData(Theme.getElevatedColor(sC, e, st), 0),
					Types.newAppearanceData(Theme.getElevatedColor(tC, e, st), 0),
					f,
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Disabled] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(dSC, e, st), INVIS),
					Types.newAppearanceData(Theme.getElevatedColor(dSC, e, st), 0.12),
					Types.newAppearanceData(Theme.getElevatedColor(dTC, e, st), 0.12),
					f,
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Hovered] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(sC, e, st), INVIS),
					Types.newAppearanceData(Theme.getElevatedColor(sC, e + 1, st), 0.08),
					Types.newAppearanceData(Theme.getElevatedColor(tC, e + 1, st), 0.08),
					f,
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Focused] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(sC, e, st), INVIS),
					Types.newAppearanceData(Theme.getElevatedColor(sC, e, st), 0.1),
					Types.newAppearanceData(Theme.getElevatedColor(tC, e, st), 0.1),
					f,
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Pressed] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(sC, e, st), INVIS),
					Types.newAppearanceData(Theme.getElevatedColor(sC, e - 1, st), 0.1),
					Types.newAppearanceData(Theme.getElevatedColor(tC, e - 1, st), 0.1),
					f,
					i,
					Types.newSoundData(Sounds.Library[Enums.SoundType.ui_tap_variant_01], 0),
					nil
				),
			}
		end,
		scaleState,
		fontDataState,
		schemeTypeState,
		elevationState,
		fillTextColorState,
		fillColorState,
		disabledFillTextColorState,
		disabledFillColorState,
		iconState
	)

	local button = Base.new(
		maid,
		function()
			clickCountState:Set(clickCountState:Get() + 1)
			onClickState:Get()(isSelectedState:Get())
		end,
		text,
		if isEnabled == nil then true else isEnabled,
		_Computed(
			function(
				isSel: boolean,
				isB: boolean,
				fDatas: { [Enums.ButtonStateType]: RenderData },
				oDatas: { [Enums.ButtonStateType]: RenderData }
			): { [Enums.ButtonStateType]: RenderData }
				return if isSel and not isB then fDatas else oDatas
			end,
			isSelectedState,
			isButtonState,
			filledRenderDatasState,
			outlineRenderDatasState
		),
		nil,
		_Computed(function(sc: number): number
			return sc * 8
		end, scaleState),
		0.75,
		true,
		0.8
	)
	maid:GiveTask(button.Destroying:Connect(function()
		maid:Destroy()
	end))

	return button
end

return Interface
