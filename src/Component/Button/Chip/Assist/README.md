# Assist

A assist chip is a small button that allows for contextual action input. Read more (here)[https://m3.material.io/components/chips/overview].
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

**No Framework**
```luau
local onClick: () -> () = function() end
local text: string = "Chip"
local icon: ImageData? = nil
local textColor: Color3 = Color3.new()
local disabledTextColor: Color3 = Color3.new()
local isEnabled: boolean = true
local elevation: number = 0
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scale: number = 1

local assist = Synthetic.Component.Button.Chip.Assist.Fusion.new()
assist.OnClick = onClick
assist.Text = text
assist.Icon = icon
assist.TextColor = textColor
assist.DisabledTextColor = disabledTextColor
assist.IsEnabled = isEnabled
assist.Elevation = elevation
assist.SchemeType = schemeType
assist.FontData = fontData
assist.Scale = scale
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

**No Framework**
```luau
local style: Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
local onClick: () -> () = function() end
local text: string = "Chip"
local icon: ImageData? = nil
local isEnabled: boolean? = nil
local elevation: number? = nil

local assist = Synthetic.Component.Button.Chip.Assist.Fusion.primary()
assist.Style = style
assist.OnClick = onClick
assist.Text = text
assist.Icon = icon
assist.IsEnabled = isEnabled
assist.Elevation = elevation
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