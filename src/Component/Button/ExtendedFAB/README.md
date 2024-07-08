# ExtendedFAB


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onClick**: () -> ()
- **text**: string
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
local extendedFAB = Synthetic.Component.Button.ExtendedFAB.Fusion.new()
extendedFAB.OnClick = function() end :: () -> ()
extendedFAB.Text = "Button" :: string
extendedFAB.Icon = Types.ImageData.new("") :: ImageData
extendedFAB.TextColor = Color3.new() :: Color3
extendedFAB.SurfaceColor = Color3.new() :: Color3
extendedFAB.DisabledTextColor = Color3.new() :: Color3
extendedFAB.DisabledSurfaceColor = Color3.new() :: Color3
extendedFAB.ShadowColor = Color3.new() :: Color3
extendedFAB.IsEnabled = true :: boolean
extendedFAB.Elevation = 0 :: number
extendedFAB.SchemeType = Enums.SchemeType.Light :: Enums.SchemeType
extendedFAB.FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14) :: FontData
extendedFAB.Scale = 1 :: number
```

**Fusion**
```luau
local onClickState: Fusion.Value<() -> ()> = Value(function() end)
local text: string = "Button"
local iconState: Fusion.Value<ImageData> = Value(Types.ImageData.new(""))
local textColor: Color3 = Color3.new()
local surfaceColorState: Fusion.Value<Color3> = Value(Color3.new())
local disabledTextColor: Color3 = Color3.new()
local disabledSurfaceColorState: Fusion.Value<Color3> = Value(Color3.new())
local shadowColor: Color3 = Color3.new()
local isEnabledState: Fusion.Value<boolean> = Value(true)
local elevation: number = 0
local schemeTypeState: Fusion.Value<Enums.SchemeType> = Value(Enums.SchemeType.Light)
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scaleState: Fusion.Value<number> = Value(1)

local extendedFAB: GuiObject = Synthetic.Component.Button.ExtendedFAB.Fusion.new(
	onClickState,
	text,
	iconState,
	textColor,
	surfaceColorState,
	disabledTextColor,
	disabledSurfaceColorState,
	shadowColor,
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
- **text**: string
- **icon**: ImageData
- **elevation**: number
- **isEnabled**: boolean


### Usage

**Vanilla**
```luau
local extendedFAB = Synthetic.Component.Button.ExtendedFAB.Fusion.primary()
extendedFAB.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)) :: Style
extendedFAB.OnClick = function() end :: () -> ()
extendedFAB.Text = "Button" :: string
extendedFAB.Icon = Types.ImageData.new("") :: ImageData
extendedFAB.Elevation = 0 :: number
extendedFAB.IsEnabled = true :: boolean
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onClick: () -> () = function() end
local textState: Fusion.Value<string> = Value("Button")
local icon: ImageData = Types.ImageData.new("")
local elevationState: Fusion.Value<number> = Value(0)
local isEnabled: boolean = true

local extendedFAB: GuiObject = Synthetic.Component.Button.ExtendedFAB.Fusion.primary(
	styleState,
	onClick,
	textState,
	icon,
	elevationState,
	isEnabled
)
```