# FAB


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
- **shadowColor**: Color3
- **isEnabled**: boolean
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number


### Usage

**Vanilla**
```luau
local fAB = Synthetic.Component.Button.FAB.Fusion.new()
fAB.OnClick = function() end
fAB.Icon = Types.ImageData.new("")
fAB.TextColor = Color3.new()
fAB.SurfaceColor = Color3.new()
fAB.DisabledTextColor = Color3.new()
fAB.DisabledSurfaceColor = Color3.new()
fAB.ShadowColor = Color3.new()
fAB.IsEnabled = true
fAB.Elevation = 0
fAB.SchemeType = Enums.SchemeType.Light
fAB.FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
fAB.Scale = 1
```

**Fusion**
```luau
local onClickState: Fusion.Value<() -> ()> = Value(function() end)
local icon: ImageData = Types.ImageData.new("")
local textColorState: Fusion.Value<Color3> = Value(Color3.new())
local surfaceColor: Color3 = Color3.new()
local disabledTextColorState: Fusion.Value<Color3> = Value(Color3.new())
local disabledSurfaceColor: Color3 = Color3.new()
local shadowColorState: Fusion.Value<Color3> = Value(Color3.new())
local isEnabled: boolean = true
local elevationState: Fusion.Value<number> = Value(0)
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontDataState: Fusion.Value<FontData> = Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14))
local scale: number = 1

local fAB: GuiObject = Synthetic.Component.Button.FAB.Fusion.new(
	onClickState,
	icon,
	textColorState,
	surfaceColor,
	disabledTextColorState,
	disabledSurfaceColor,
	shadowColorState,
	isEnabled,
	elevationState,
	schemeType,
	fontDataState,
	scale
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
local fAB = Synthetic.Component.Button.FAB.Fusion.primary()
fAB.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
fAB.OnClick = function() end
fAB.Icon = Types.ImageData.new("")
fAB.Elevation = 0
fAB.IsEnabled = true
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onClick: () -> () = function() end
local iconState: Fusion.Value<ImageData> = Value(Types.ImageData.new(""))
local elevation: number = 0
local isEnabledState: Fusion.Value<boolean> = Value(true)

local fAB: GuiObject = Synthetic.Component.Button.FAB.Fusion.primary(
	styleState,
	onClick,
	iconState,
	elevation,
	isEnabledState
)
```