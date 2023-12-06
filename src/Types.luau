--!strict
-- Services
-- Packages
-- Modules
-- Types
export type ThemeData = {
	Elevation: number,
	IsDarkMode: boolean,
	Color3: Color3,
	SelectionColor3: Color3,
	Font: Font,
	BackgroundColor3: Color3?,
	Scale: number,
}
export type ImageData = {
	Image: string,
	ImageRectOffset: Vector2,
	ImageRectSize: Vector2,
}
export type Style = {
	BorderColor3: Color3,
	BorderTransparency: number,
	BackgroundColor3: Color3,
	BackgroundTransparency: number,
}
export type TextStyle = {
	TextColor3: Color3,
	TextTransparency: number,
} & Style
export type ToggleTextStyle = {
	Selected: TextStyle,
	Unselected: TextStyle,
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
	backgroundColor3: Color3,
	backgroundTransparency: number,
	borderColor3: Color3,
	borderTransparency: number
): Style
	return {
		BackgroundColor3 = backgroundColor3,
		BackgroundTransparency = backgroundTransparency,
		BorderColor3 = borderColor3,
		BorderTransparency = borderTransparency,
	}
end

function Types.newTextStyle(
	textColor3: Color3,
	textTransparency: number,
	backgroundColor: Color3,
	backgroundTransparency: number,
	borderColor3: Color3,
	borderTransparency: number
): TextStyle
	return {
		TextColor3 = textColor3,
		TextTransparency = textTransparency,
		BackgroundColor3 = backgroundColor,
		BackgroundTransparency = backgroundTransparency,
		BorderColor3 = borderColor3,
		BorderTransparency = borderTransparency,
	}
end

function Types.newToggleTextStyle(selected: TextStyle, unselected: TextStyle): ToggleTextStyle
	return {
		Selected = selected,
		Unselected = unselected,
	}
end

function Types.newThemeData(
	elevation: number,
	isDarkMode: boolean,
	scale: number,
	font: Font,
	color3: Color3,
	backgroundColor3: Color3?,
	selectionColor3: Color3?
): ThemeData
	return {
		Color3 = color3,
		SelectionColor3 = selectionColor3 or color3,
		BackgroundColor3 = backgroundColor3,
		Elevation = elevation,
		IsDarkMode = isDarkMode,
		Font = font,
		Scale = scale,
	}
end

return Types
