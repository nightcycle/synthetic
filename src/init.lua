--!strict
local module = script
local packages = script.Parent
local Isotope = require(packages.isotope)
type Isotope = Isotope.Isotope
type Fuse = Isotope.Fuse
type State = Isotope.State
type ValueState = Isotope.ValueState

local TextLabel = require(module.TextLabel)
export type TextLabelConstructor = typeof(TextLabel.new)
export type TextLabelParameters = TextLabel.TextLabelParameters

local ViewportMountFrame = require(module.ViewportMountFrame)
export type ViewportMountFrameConstructor = typeof(ViewportMountFrame.new)
export type ViewportMountFrameParameters = ViewportMountFrame.ViewportMountFrameParameters

local TextField = require(module.TextField)
export type TextFieldConstructor = typeof(TextField.new)
export type TextFieldParameters = TextField.TextFieldParameters

local Switch = require(module.Switch)
export type SwitchConstructor = typeof(Switch.new)
export type SwitchParameters = Switch.SwitchParameters

local SurfaceFrame = require(module.SurfaceFrame)
export type SurfaceFrameConstructor = typeof(SurfaceFrame.new)
export type SurfaceFrameParameters = SurfaceFrame.SurfaceFrameParameters

local Slider = require(module.Slider)
export type SliderConstructor = typeof(Slider.new)
export type SliderParameters = Slider.SliderParameters

local RadioButton = require(module.RadioButton)
export type RadioButtonConstructor = typeof(RadioButton.new)
export type RadioButtonParameters = RadioButton.RadioButtonParameters

local IconLabel = require(module.IconLabel)
export type IconLabelConstructor = typeof(IconLabel.new)
export type IconLabelParameters = IconLabel.IconLabelParameters

local Hint = require(module.Hint)
export type HintConstructor = typeof(Hint.new)
export type HintParameters = Hint.HintParameters

local EffectGui = require(module.EffectGui)
export type EffectGuiConstructor = typeof(EffectGui.new)
export type EffectGuiParameters = EffectGui.EffectGuiParameters

local Checkbox = require(module.Checkbox)
export type CheckboxConstructor = typeof(Checkbox.new)
export type CheckboxParameters = Checkbox.CheckboxParameters

local ButtonList = require(module.ButtonList)
export type ButtonListConstructor = typeof(ButtonList.new)
export type ButtonListParameters = ButtonList.ButtonListParameters

local Button = require(module.Button)
export type ButtonConstructor = typeof(Button.new)
export type ButtonParameters = Button.ButtonParameters

local Bubble = require(module.Bubble)
export type BubbleConstructor = typeof(Bubble.new)
export type BubbleParameters = Bubble.BubbleParameters

local BoundingBoxFrame = require(module.BoundingBoxFrame)
export type BoundingBoxFrameConstructor = typeof(BoundingBoxFrame.new)
export type BoundingBoxFrameParameters = BoundingBoxFrame.BoundingBoxFrameParameters

local BoardFrame = require(module.BoardFrame)
export type BoardFrameConstructor = typeof(BoardFrame.new)
export type BoardFrameParameters = BoardFrame.BoardFrameParameters

local BillboardFrame = require(module.BillboardFrame)
export type BillboardFrameConstructor = typeof(BillboardFrame.new)
export type BillboardFrameParameters = BillboardFrame.BillboardFrameParameters

export type Synthetic = ((className: "TextLabel") -> TextLabelConstructor)	
& ((className: "ViewportMountFrame") -> ViewportMountFrameConstructor)
& ((className: "TextField") -> TextFieldConstructor)
& ((className: "Switch") -> SwitchConstructor)
& ((className: "SurfaceFrame") -> SurfaceFrameConstructor)
& ((className: "Slider") -> SliderConstructor)
& ((className: "RadioButton") -> RadioButtonConstructor)
& ((className: "IconLabel") -> IconLabelConstructor)
& ((className: "Hint") -> HintConstructor)
& ((className: "EffectGui") -> EffectGuiConstructor)
& ((className: "Checkbox") -> CheckboxConstructor)
& ((className: "ButtonList") -> ButtonListConstructor)
& ((className: "Button") -> ButtonConstructor)
& ((className: "Bubble") -> BubbleConstructor)
& ((className: "BoundingBoxFrame") -> BoundingBoxFrameConstructor)
& ((className: "BoardFrame") -> BoardFrameConstructor)
& ((className: "BillboardFrame") -> BillboardFrameConstructor)

local synth: Synthetic = function(className: string)
	assert(
		className == "TextLabel" 
		or className == "ViewportMountFrame"
		or className == "TextField"
		or className == "Switch"
		or className == "SurfaceFrame"
		or className == "Slider"
		or className == "RadioButton"
		or className == "IconLabel"
		or className == "Hint"
		or className == "EffectGui"
		or className == "Checkbox"
		or className == "ButtonList"
		or className == "Button"
		or className == "Bubble"
		or className == "BoundingBoxFrame"
		or className == "BoardFrame"
		or className == "BillboardFrame"
	)
	if className == "TextLabel" then
		return TextLabel.new
	elseif className == "ViewportMountFrame" then
		return ViewportMountFrame.new
	elseif className == "TextField" then
		return TextField.new
	elseif className == "Switch" then
		return Switch.new
	elseif className == "SurfaceFrame" then
		return SurfaceFrame.new
	elseif className == "Slider" then
		return Slider.new
	elseif className == "RadioButton" then
		return RadioButton.new
	elseif className == "IconLabel" then
		return IconLabel.new
	elseif className == "Hint" then
		return Hint.new
	elseif className == "EffectGui" then
		return EffectGui.new
	elseif className == "Checkbox" then
		return Checkbox.new
	elseif className == "ButtonList" then
		return ButtonList.new
	elseif className == "Button" then
		return Button.new
	elseif className == "Bubble" then
		return Bubble.new
	elseif className == "BoundingBoxFrame" then
		return BoundingBoxFrame.new
	elseif className == "BoardFrame" then
		return BoardFrame.new
	elseif className == "BillboardFrame" then
		return BillboardFrame.new
	end
	return nil
end

return synth