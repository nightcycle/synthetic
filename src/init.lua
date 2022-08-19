--!strict
local module = script

local Types = require(module.Types)
export type ParameterValue<T> = Types.ParameterValue<T>

local TextLabel = require(module.TextLabel)
export type TextLabelParameters = TextLabel.TextLabelParameters

local ViewportMountFrame = require(module.ViewportMountFrame)
export type ViewportMountFrameParameters = ViewportMountFrame.ViewportMountFrameParameters

local TextField = require(module.TextField)
export type TextFieldParameters = TextField.TextFieldParameters

local Switch = require(module.Switch)
export type SwitchParameters = Switch.SwitchParameters

local SurfaceFrame = require(module.SurfaceFrame)
export type SurfaceFrameConstructor = SurfaceFrame.SurfaceFrame

local Slider = require(module.Slider)
export type SliderParameters = Slider.SliderParameters

local RadioButton = require(module.RadioButton)
export type RadioButtonParameters = RadioButton.RadioButtonParameters

local IconLabel = require(module.IconLabel)
export type IconLabelParameters = IconLabel.IconLabelParameters

local Hint = require(module.Hint)
export type HintParameters = Hint.HintParameters

local EffectGui = require(module.EffectGui)
export type EffectGuiParameters = EffectGui.EffectGuiParameters

local Checkbox = require(module.Checkbox)
export type CheckboxParameters = Checkbox.CheckboxParameters

local ButtonList = require(module.ButtonList)
export type ButtonListParameters = ButtonList.ButtonListParameters

local Button = require(module.Button)
export type ButtonParameters = Button.ButtonParameters

local Bubble = require(module.Bubble)
export type BubbleParameters = Bubble.BubbleParameters

local BoundingBoxFrame = require(module.BoundingBoxFrame)
export type BoundingBoxFrameParameters = BoundingBoxFrame.BoundingBoxFrameParameters

local BoardFrame = require(module.BoardFrame)
export type BoardFrameParameters = BoardFrame.BoardFrameParameters

local BillboardFrame = require(module.BillboardFrame)
export type BillboardFrameParameters = BillboardFrame.BillboardFrameParameters

export type Synthetic = ((className: "TextLabel") -> ((TextLabelParameters) -> TextLabel.TextLabel))	
& ((className: "ViewportMountFrame") -> ((ViewportMountFrameParameters) -> ViewportMountFrame.ViewportMountFrame))
& ((className: "TextField") -> ((TextFieldParameters) -> TextField.TextField))
& ((className: "Switch") -> ((SwitchParameters) -> Switch.Switch))
& ((className: "SurfaceFrame") -> ((SurfaceFrameConstructor) -> SurfaceFrame.SurfaceFrameParameters))
& ((className: "Slider") -> ((SliderParameters) -> Slider.Slider))
& ((className: "RadioButton") -> ((RadioButtonParameters) -> RadioButton.RadioButton))
& ((className: "IconLabel") -> ((IconLabelParameters) -> IconLabel.IconLabel))
& ((className: "Hint") -> ((HintParameters) -> Hint.Hint))
& ((className: "EffectGui") -> ((EffectGuiParameters) -> EffectGui.EffectGui))
& ((className: "Checkbox") -> ((CheckboxParameters) -> Checkbox.Checkbox))
& ((className: "ButtonList") -> ((ButtonListParameters) -> ButtonList.ButtonList))
& ((className: "Button") -> ((ButtonParameters) -> Button.Button))
& ((className: "Bubble") -> ((BubbleParameters) -> Bubble.Bubble))
& ((className: "BoundingBoxFrame") -> ((BoundingBoxFrameParameters) -> BoundingBoxFrame.BoundingBoxFrame))
& ((className: "BoardFrame") -> ((BoardFrameParameters) -> BoardFrame.BoardFrame))
& ((className: "BillboardFrame") -> ((BillboardFrameParameters) -> BillboardFrame.BillboardFrame))

local synth: Synthetic = function(className: string): any
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
		return TextLabel
	elseif className == "ViewportMountFrame" then
		return ViewportMountFrame
	elseif className == "TextField" then
		return TextField
	elseif className == "Switch" then
		return Switch
	elseif className == "SurfaceFrame" then
		return SurfaceFrame
	elseif className == "Slider" then
		return Slider
	elseif className == "RadioButton" then
		return RadioButton
	elseif className == "IconLabel" then
		return IconLabel
	elseif className == "Hint" then
		return Hint
	elseif className == "EffectGui" then
		return EffectGui
	elseif className == "Checkbox" then
		return Checkbox
	elseif className == "ButtonList" then
		return ButtonList
	elseif className == "Button" then
		return Button
	elseif className == "Bubble" then
		return Bubble
	elseif className == "BoundingBoxFrame" then
		return BoundingBoxFrame
	elseif className == "BoardFrame" then
		return BoardFrame
	elseif className == "BillboardFrame" then
		return BillboardFrame
	end
	return nil
end

return synth