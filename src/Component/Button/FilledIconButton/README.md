# FilledIconButton


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onClick**: () -> ()
- **icon**: ImageData
- **textColor**: Color3
- **surfaceColor**: Color3
- **disabledTextColor**: Color3
- **disabledSurfaceColor**: Color3
- **isEnabled**: boolean
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number


### Usage

**Vanilla**
```luau
local filledIconButton = Synthetic.Component.Button.FilledIconButton.Fusion.new()
filledIconButton.OnClick = function() end
filledIconButton.Icon = Types.ImageData.new("")
filledIconButton.TextColor = Color3.new()
filledIconButton.SurfaceColor = Color3.new()
filledIconButton.DisabledTextColor = Color3.new()
filledIconButton.DisabledSurfaceColor = Color3.new()
filledIconButton.IsEnabled = true
filledIconButton.Elevation = 0
filledIconButton.SchemeType = Enums.SchemeType.Light
filledIconButton.FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
filledIconButton.Scale = 1
```

**Fusion**
```luau
local onClickState: Fusion.Value<() -> ()> = Value(function() end)
local icon: ImageData = Types.ImageData.new("")
local textColorState: Fusion.Value<Color3> = Value(Color3.new())
local surfaceColor: Color3 = Color3.new()
local disabledTextColorState: Fusion.Value<Color3> = Value(Color3.new())
local disabledSurfaceColor: Color3 = Color3.new()
local isEnabledState: Fusion.Value<boolean> = Value(true)
local elevation: number = 0
local schemeTypeState: Fusion.Value<Enums.SchemeType> = Value(Enums.SchemeType.Light)
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scaleState: Fusion.Value<number> = Value(1)

local filledIconButton: GuiObject = Synthetic.Component.Button.FilledIconButton.Fusion.new(
	onClickState,
	icon,
	textColorState,
	surfaceColor,
	disabledTextColorState,
	disabledSurfaceColor,
	isEnabledState,
	elevation,
	schemeTypeState,
	fontData,
	scaleState
)
```
## primary / secondary / tertiary / primaryContainer / secondaryContainer / tertiaryContainer
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onClick**: () -> ()
- **icon**: ImageData
- **elevation**: number
- **isEnabled**: boolean


### Usage

**Vanilla**
```luau
local filledIconButton = Synthetic.Component.Button.FilledIconButton.Fusion.primary()
filledIconButton.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
filledIconButton.OnClick = function() end
filledIconButton.Icon = Types.ImageData.new("")
filledIconButton.Elevation = 0
filledIconButton.IsEnabled = true
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onClick: () -> () = function() end
local iconState: Fusion.Value<ImageData> = Value(Types.ImageData.new(""))
local elevation: number = 0
local isEnabledState: Fusion.Value<boolean> = Value(true)

local filledIconButton: GuiObject = Synthetic.Component.Button.FilledIconButton.Fusion.primary(
	styleState,
	onClick,
	iconState,
	elevation,
	isEnabledState
)
```