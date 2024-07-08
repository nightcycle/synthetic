# FilledButton


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onClick**: () -> ()
- **text**: string
- **icon**: ImageData?
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
local filledButton = Synthetic.Component.Button.FilledButton.Fusion.new()
filledButton.OnClick = function() end
filledButton.Text = "Button"
filledButton.Icon = nil
filledButton.TextColor = Color3.new()
filledButton.SurfaceColor = Color3.new()
filledButton.DisabledTextColor = Color3.new()
filledButton.DisabledSurfaceColor = Color3.new()
filledButton.IsEnabled = true
filledButton.Elevation = 0
filledButton.SchemeType = Enums.SchemeType.Light
filledButton.FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
filledButton.Scale = 1
```

**Fusion**
```luau
local onClickState: Fusion.Value<() -> ()> = Value(function() end)
local text: string = "Button"
local iconState: Fusion.Value<ImageData?> = Value(nil)
local textColor: Color3 = Color3.new()
local surfaceColorState: Fusion.Value<Color3> = Value(Color3.new())
local disabledTextColor: Color3 = Color3.new()
local disabledSurfaceColorState: Fusion.Value<Color3> = Value(Color3.new())
local isEnabled: boolean = true
local elevationState: Fusion.Value<number> = Value(0)
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontDataState: Fusion.Value<FontData> = Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14))
local scale: number = 1

local filledButton: GuiObject = Synthetic.Component.Button.FilledButton.Fusion.new(
	onClickState,
	text,
	iconState,
	textColor,
	surfaceColorState,
	disabledTextColor,
	disabledSurfaceColorState,
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
- **text**: string
- **icon**: ImageData?
- **elevation**: number
- **isEnabled**: boolean


### Usage

**Vanilla**
```luau
local filledButton = Synthetic.Component.Button.FilledButton.Fusion.primary()
filledButton.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
filledButton.OnClick = function() end
filledButton.Text = "Button"
filledButton.Icon = nil
filledButton.Elevation = 0
filledButton.IsEnabled = true
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onClick: () -> () = function() end
local textState: Fusion.Value<string> = Value("Button")
local icon: ImageData? = nil
local elevationState: Fusion.Value<number> = Value(0)
local isEnabled: boolean = true

local filledButton: GuiObject = Synthetic.Component.Button.FilledButton.Fusion.primary(
	styleState,
	onClick,
	textState,
	icon,
	elevationState,
	isEnabled
)
```