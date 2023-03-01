--!strict

local module = script

local Maid = require(module.Parent.Maid)
export type Maid = Maid.Maid

local Types = require(module.Types)
export type CanBeState<T> = Types.CanBeState<T>

local TextLabel = require(module.TextLabel)
export type TextLabelParameters = TextLabel.TextLabelParameters

local ViewportMountFrame = require(module.ViewportMountFrame)
export type ViewportMountFrameParameters = ViewportMountFrame.ViewportMountFrameParameters

local TextField = require(module.TextField)
export type TextFieldParameters = TextField.TextFieldParameters

local Switch = require(module.Switch)
export type SwitchParameters = Switch.SwitchParameters

local SurfaceFrame = require(module.SurfaceFrame)
export type SurfaceFrameParameters = SurfaceFrame.SurfaceFrameParameters

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

export type Synthetic =
	(((className: "TextLabel") -> ((TextLabelParameters) -> TextLabel.TextLabel)) & ((className: "ViewportMountFrame") -> ((ViewportMountFrameParameters) -> ViewportMountFrame.ViewportMountFrame)) & ((className: "TextField") -> ((TextFieldParameters) -> TextField.TextField)) & ((className: "Switch") -> ((SwitchParameters) -> Switch.Switch)) & ((className: "SurfaceFrame") -> ((SurfaceFrameParameters) -> SurfaceFrame.SurfaceFrameParameters)) & ((className: "Slider") -> ((SliderParameters) -> Slider.Slider)) & ((className: "RadioButton") -> ((RadioButtonParameters) -> RadioButton.RadioButton)) & ((className: "IconLabel") -> ((IconLabelParameters) -> IconLabel.IconLabel)) & ((className: "Hint") -> ((HintParameters) -> Hint.Hint)) & ((className: "EffectGui") -> ((EffectGuiParameters) -> EffectGui.EffectGui)) & ((className: "Checkbox") -> ((CheckboxParameters) -> Checkbox.Checkbox)) & ((className: "Button") -> ((ButtonParameters) -> Button.Button)) & ((className: "Bubble") -> ((BubbleParameters) -> Bubble.Bubble)) & ((
		className: "BoundingBoxFrame"
	) -> ((BoundingBoxFrameParameters) -> BoundingBoxFrame.BoundingBoxFrame)) & ((
		className: "BoardFrame"
	) -> ((BoardFrameParameters) -> BoardFrame.BoardFrame)) & ((
		className: "BillboardFrame"
	) -> ((BillboardFrameParameters) -> BillboardFrame.BillboardFrame)))

return function(Maid: Maid?): Synthetic
	return function(className: any): any
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
			return TextLabel(Maid)
		elseif className == "ViewportMountFrame" then
			return ViewportMountFrame(Maid)
		elseif className == "TextField" then
			return TextField(Maid)
		elseif className == "Switch" then
			return Switch(Maid)
		elseif className == "SurfaceFrame" then
			return SurfaceFrame(Maid)
		elseif className == "Slider" then
			return Slider(Maid)
		elseif className == "RadioButton" then
			return RadioButton(Maid)
		elseif className == "IconLabel" then
			return IconLabel(Maid)
		elseif className == "Hint" then
			return Hint(Maid)
		elseif className == "EffectGui" then
			return EffectGui(Maid)
		elseif className == "Checkbox" then
			return Checkbox(Maid)
		elseif className == "Button" then
			return Button(Maid)
		elseif className == "Bubble" then
			return Bubble(Maid)
		elseif className == "BoundingBoxFrame" then
			return BoundingBoxFrame(Maid)
		elseif className == "BoardFrame" then
			return BoardFrame(Maid)
		elseif className == "BillboardFrame" then
			return BillboardFrame(Maid)
		end
		return nil
	end
end
