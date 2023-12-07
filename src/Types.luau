--!strict
-- Services
-- Packages
-- Modules
-- Types
export type Style = {
	Scale: number,
	Font: Font,
	TextColor3: Color3,
	TextTransparency: number,
	BorderColor3: Color3,
	BorderTransparency: number,
	BackgroundColor3: Color3,
	BackgroundTransparency: number,
	SoundId: string,
	SoundVolume: number,
}

export type ImageData = {
	Image: string,
	ImageRectOffset: Vector2,
	ImageRectSize: Vector2,
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
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Types = {}

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

function Types.newImageData(image: string, rectOffset: Vector2?, rectSize: Vector2?): ImageData
	return {
		Image = image,
		ImageRectOffset = rectOffset or Vector2.zero,
		ImageRectSize = rectSize or Vector2.zero,
	}
end

function Types.newStyle(
	scale: number?,
	font: Font?,
	textColor3: Color3?,
	textTransparency: number?,
	borderColor3: Color3?,
	borderTransparency: number?,
	backgroundColor3: Color3?,
	backgroundTransparency: number?,
	soundId: string?,
	soundVolume: number?
): Style
	return {
		Scale = scale or 1,
		Font = font or Font.fromEnum(Enum.Font.SourceSans),
		TextColor3 = textColor3 or Color3.new(0.15,0.15,0.15),
		TextTransparency = textTransparency or 0,
		BorderColor3 = borderColor3 or Color3.new(0.15,0.15,0.15),
		BorderTransparency = borderTransparency or 0,
		BackgroundColor3 = backgroundColor3 or Color3.new(0.85,0.85,0.85),
		BackgroundTransparency = backgroundTransparency or 0,
		SoundId = soundId or "",
		SoundVolume = soundVolume or 0,
	}
end

return Types
