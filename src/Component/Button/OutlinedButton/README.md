# Outlined Button

![Preview](preview.gif)

An outlined button is like a filled button, but the background is transparent and replaced by lines. Read more [here](https://m3.material.io/components/buttons/overview).
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
local text: string = "Button"
local icon: ImageData? = nil
local textColor: Color3 = Color3.new()
local disabledTextColor: Color3 = Color3.new()
local isEnabled: boolean = true
local elevation: number = 0
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scale: number = 1

local outlinedButton = Synthetic.Component.Button.OutlinedButton.Fusion.new()
outlinedButton.OnClick = onClick
outlinedButton.Text = text
outlinedButton.Icon = icon
outlinedButton.TextColor = textColor
outlinedButton.DisabledTextColor = disabledTextColor
outlinedButton.IsEnabled = isEnabled
outlinedButton.Elevation = elevation
outlinedButton.SchemeType = schemeType
outlinedButton.FontData = fontData
outlinedButton.Scale = scale
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

**Roact**
```luau
local outlinedButton = Roact.createElement(Module.Roact.New, {
	onClick = function() end,
	text = "Button",
	icon = nil,
	textColor = Color3.new(),
	disabledTextColor = Color3.new(),
	isEnabled = true,
	elevation = 0,
	schemeType = Enums.SchemeType.Light,
	fontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14),
	scale = 1,
})

Roact.mount(outlinedButton, parent)
```
## onPrimary / onSecondary / onTertiary / onPrimaryContainer / onSecondaryContainer / onTertiaryContainer
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onClick**: () -> ()
- **text**: string
- **icon**: ImageData?
- **elevation**: number
- **isEnabled**: boolean


### Usage

**No Framework**
```luau
local style: Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
local onClick: () -> () = function() end
local text: string = "Button"
local icon: ImageData? = nil
local elevation: number = 0
local isEnabled: boolean = true

local outlinedButton = Synthetic.Component.Button.OutlinedButton.Fusion.onPrimary()
outlinedButton.Style = style
outlinedButton.OnClick = onClick
outlinedButton.Text = text
outlinedButton.Icon = icon
outlinedButton.Elevation = elevation
outlinedButton.IsEnabled = isEnabled
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onClick: () -> () = function() end
local textState: Fusion.Value<string> = Value("Button")
local icon: ImageData? = nil
local elevationState: Fusion.Value<number> = Value(0)
local isEnabled: boolean = true

local outlinedButton: GuiObject = Synthetic.Component.Button.OutlinedButton.Fusion.onPrimary(
	styleState,
	onClick,
	textState,
	icon,
	elevationState,
	isEnabled
)
```

**Roact**
```luau
local outlinedButton = Roact.createElement(Module.Roact.OnPrimary, {
	style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)),
	onClick = function() end,
	text = "Button",
	icon = nil,
	elevation = 0,
	isEnabled = true,
})

Roact.mount(outlinedButton, parent)
```