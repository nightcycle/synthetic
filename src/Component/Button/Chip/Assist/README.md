# Assist


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
local assist = Synthetic.Component.Button.Chip.Assist.Fusion.new()
assist.OnClick = function() end
assist.Text = "Chip"
assist.Icon = nil
assist.TextColor = Color3.new()
assist.DisabledTextColor = Color3.new()
assist.IsEnabled = true
assist.Elevation = 0
assist.SchemeType = Enums.SchemeType.Light
assist.FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
assist.Scale = 1
```

**Fusion**
```luau
local onClickState: Fusion.Value<() -> ()> = Value(function() end)
local text: string = "Chip"
local iconState: Fusion.Value<ImageData?> = Value(nil)
local textColor: Color3 = Color3.new()
local disabledTextColorState: Fusion.Value<Color3> = Value(Color3.new())
local isEnabled: boolean = true
local elevationState: Fusion.Value<number> = Value(0)
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontDataState: Fusion.Value<FontData> = Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14))
local scale: number = 1

local assist: GuiObject = Synthetic.Component.Button.Chip.Assist.Fusion.new(
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
## primary / secondary / tertiary
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onClick**: () -> ()
- **text**: string
- **icon**: ImageData?
- **isEnabled**: boolean?
- **elevation**: number?


### Usage

**Vanilla**
```luau
local assist = Synthetic.Component.Button.Chip.Assist.Fusion.primary()
assist.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
assist.OnClick = function() end
assist.Text = "Chip"
assist.Icon = nil
assist.IsEnabled = nil
assist.Elevation = nil
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onClick: () -> () = function() end
local textState: Fusion.Value<string> = Value("Chip")
local icon: ImageData? = nil
local isEnabledState: Fusion.Value<boolean?> = Value(nil)
local elevation: number? = nil

local assist: GuiObject = Synthetic.Component.Button.Chip.Assist.Fusion.primary(
	styleState,
	onClick,
	textState,
	icon,
	isEnabledState,
	elevation
)
```