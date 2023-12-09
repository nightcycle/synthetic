--!strict
-- Services
-- Packages
-- Modules
-- Types
export type AppearanceData = {
	Color3: Color3,
	Transparency: number,
}

export type ShadowData = {
	Offset: Vector2,
	Appearance: AppearanceData,
}

export type RenderData = {
	Scale: number,
	Border: AppearanceData,
	Background: AppearanceData,
	Sound: SoundData?,
	Image: ImageData?,
	Font: FontData?,
	Text: AppearanceData?,
	Shadow: ShadowData?
}

export type ImageData = {
	Image: string,
	ImageRectOffset: Vector2,
	ImageRectSize: Vector2,
}

export type SoundData = {
	SoundId: string,
	Volume: number,
}

export type ButtonData = {
	Icon: ImageData?,
	Text: string?,
	Enabled: boolean,
	OnClick: () -> ()
}

export type OptionData = {
	Text: string,
	Icon: ImageData?,
	Disabled: boolean,
	IsInitiallySelected: boolean,
	SelectedText: string,
	SelectedIcon: ImageData?,
	OnSelect: (isSelected: boolean) -> (),
}

export type FontData = {
	Font: Font,
	Size: number,
	Tracking: number,
	LineHeight: number,
}

-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Types = {}

function Types.newFontData(
	font: Font,
	size: number,
	lineHeight: number?,
	tracking: number?
): FontData
	return {
		Font = font,
		Size = size,
		Tracking = tracking or 0,
		LineHeight = lineHeight or size,
	}
end

function Types.newButtonData(
	onClick: () -> (),
	icon: ImageData?,
	text: string?,
	enabled: boolean?
): ButtonData
	return {
		Icon = icon,
		Text = text,
		OnClick = onClick,
		Enabled = if enabled == nil then true else enabled
	}
end

function Types.newOptionData(
	onSelect: (isSelected: boolean) -> (),
	disabled: boolean,
	isInitiallySelected: boolean,
	text: string,
	icon: ImageData?,
	selectedText: string?,
	selectedIcon: ImageData?
): OptionData
	return {
		Text = text,
		Icon = icon,
		Disabled = disabled,
		SelectedText = selectedText or text,
		SelectedIcon = selectedIcon or icon,
		IsInitiallySelected = isInitiallySelected,
		OnSelect = onSelect,
	}
end
function Types.newSoundData(soundId: string, volume: number?): SoundData
	return {
		SoundId = soundId,
		Volume = volume or 1
	}
end

function Types.newShadow(
	appearance: AppearanceData,
	offset: Vector2
): ShadowData
	return {
		Appearance = appearance,
		Offset = offset
	}
end

function Types.newAppearanceData(color3: Color3, transparency: number?): AppearanceData
	return {
		Color3 = color3,
		Transparency = transparency or 0,
	}
end

function Types.newImageData(image: string, rectOffset: Vector2?, rectSize: Vector2?): ImageData
	return {
		Image = image,
		ImageRectOffset = rectOffset or Vector2.zero,
		ImageRectSize = rectSize or Vector2.zero,
	}
end

function Types.newRenderData(
	scale: number,
	border: AppearanceData,
	background: AppearanceData,
	text: AppearanceData?,
	font: FontData?,
	image: ImageData?,
	sound: SoundData?,
	shadow: ShadowData?
): RenderData
	return {
		Scale = scale,
		Border = border,
		Background = background,
		Sound = sound,
		Image = image,
		Font = font,
		Text = text,
		Shadow = shadow,
	}
end

return Types
