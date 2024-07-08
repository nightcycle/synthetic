# OutlinedButton


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onClick**: () -> ()
- **text**: string
- **icon**: ImageData?
- **textColor**: Color3
- **disabledTextColor**: Color3
- **isEnabled**: boolean
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number


### Usage

**Vanilla**
```luau
local outlinedButton = Synthetic.Component.Button.OutlinedButton.Fusion.new()
outlinedButton.OnClick = function() end :: () -> ()
outlinedButton.Text = "Button" :: string
outlinedButton.Icon = nil :: ImageData?
outlinedButton.TextColor = Color3.new() :: Color3
outlinedButton.DisabledTextColor = Color3.new() :: Color3
outlinedButton.IsEnabled = true :: boolean
outlinedButton.Elevation = 0 :: number
outlinedButton.SchemeType = Enums.SchemeType.Light :: Enums.SchemeType
outlinedButton.FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14) :: FontData
outlinedButton.Scale = 1 :: number
```

**Fusion**
```luau
local onClickState: Fusion.Value<() -> ()> = Value(function() end)
local text: string = "Button"
local iconState: Fusion.Value<ImageData?> = Value(nil)
local textColor: Color3 = Color3.new()
local disabledTextColorState: Fusion.Value<Color3> = Value(Color3.new())
local isEnabled: boolean = true
local elevationState: Fusion.Value<number> = Value(0)
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontDataState: Fusion.Value<FontData> = Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14))
local scale: number = 1

local outlinedButton: GuiObject = Synthetic.Component.Button.OutlinedButton.Fusion.new(
	onClickState,
	text,
	iconState,
	textColor,
	disabledTextColorState,
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
local outlinedButton = Synthetic.Component.Button.OutlinedButton.Fusion.primary()
outlinedButton.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)) :: Style
outlinedButton.OnClick = function() end :: () -> ()
outlinedButton.Text = "Button" :: string
outlinedButton.Icon = nil :: ImageData?
outlinedButton.Elevation = 0 :: number
outlinedButton.IsEnabled = true :: boolean
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onClick: () -> () = function() end
local textState: Fusion.Value<string> = Value("Button")
local icon: ImageData? = nil
local elevationState: Fusion.Value<number> = Value(0)
local isEnabled: boolean = true

local outlinedButton: GuiObject = Synthetic.Component.Button.OutlinedButton.Fusion.primary(
	styleState,
	onClick,
	textState,
	icon,
	elevationState,
	isEnabled
)
```