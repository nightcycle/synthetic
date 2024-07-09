# Radio Button

![Preview](preview.gif)

The radio button is a component used for selection a single item from a list. Read more [here](https://m3.material.io/components/radio-button/overview)
# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onSelect**: (isSelected: boolean) -> ()
- **initialSelection**: boolean
- **isEnabled**: boolean
- **outlineColor**: Color3
- **fillColor**: Color3
- **iconColor**: Color3
- **disabledColor**: Color3
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number


### Usage

**No Framework**
```luau
local onSelect: (isSelected: boolean) -> () = function(isSelected: boolean) end
local initialSelection: boolean = false
local isEnabled: boolean = true
local outlineColor: Color3 = Color3.new()
local fillColor: Color3 = Color3.new()
local iconColor: Color3 = Color3.new()
local disabledColor: Color3 = Color3.new()
local elevation: number = 0
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scale: number = 1

local radioButton = Synthetic.Component.RadioButton.Fusion.new()
radioButton.OnSelect = onSelect
radioButton.InitialSelection = initialSelection
radioButton.IsEnabled = isEnabled
radioButton.OutlineColor = outlineColor
radioButton.FillColor = fillColor
radioButton.IconColor = iconColor
radioButton.DisabledColor = disabledColor
radioButton.Elevation = elevation
radioButton.SchemeType = schemeType
radioButton.FontData = fontData
radioButton.Scale = scale
```

**Fusion**
```luau
local onSelectState: Fusion.Value<(isSelected: boolean) -> ()> = Value(function(isSelected: boolean) end)
local initialSelection: boolean = false
local isEnabledState: Fusion.Value<boolean> = Value(true)
local outlineColor: Color3 = Color3.new()
local fillColorState: Fusion.Value<Color3> = Value(Color3.new())
local iconColor: Color3 = Color3.new()
local disabledColorState: Fusion.Value<Color3> = Value(Color3.new())
local elevation: number = 0
local schemeTypeState: Fusion.Value<Enums.SchemeType> = Value(Enums.SchemeType.Light)
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scaleState: Fusion.Value<number> = Value(1)

local radioButton: GuiObject = Synthetic.Component.RadioButton.Fusion.new(
	onSelectState,
	initialSelection,
	isEnabledState,
	outlineColor,
	fillColorState,
	iconColor,
	disabledColorState,
	elevation,
	schemeTypeState,
	fontData,
	scaleState
)
```

**Roact**
```luau
local radioButton = Roact.createElement(Module.Roact.New, {
	onSelect = function(isSelected: boolean) end,
	initialSelection = false,
	isEnabled = true,
	outlineColor = Color3.new(),
	fillColor = Color3.new(),
	iconColor = Color3.new(),
	disabledColor = Color3.new(),
	elevation = 0,
	schemeType = Enums.SchemeType.Light,
	fontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14),
	scale = 1,
})

Roact.mount(radioButton, parent)
```
## primary / secondary / tertiary / primaryContainer / secondaryContainer / tertiaryContainer
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onSelect**: (isSelected: boolean) -> ()
- **initialSelection**: boolean
- **elevation**: number?
- **isEnabled**: boolean?


### Usage

**No Framework**
```luau
local style: Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
local onSelect: (isSelected: boolean) -> () = function(isSelected: boolean) end
local initialSelection: boolean = false
local elevation: number? = 0
local isEnabled: boolean? = true

local radioButton = Synthetic.Component.RadioButton.Fusion.primary()
radioButton.Style = style
radioButton.OnSelect = onSelect
radioButton.InitialSelection = initialSelection
radioButton.Elevation = elevation
radioButton.IsEnabled = isEnabled
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onSelect: (isSelected: boolean) -> () = function(isSelected: boolean) end
local initialSelectionState: Fusion.Value<boolean> = Value(false)
local elevation: number? = 0
local isEnabledState: Fusion.Value<boolean?> = Value(true)

local radioButton: GuiObject = Synthetic.Component.RadioButton.Fusion.primary(
	styleState,
	onSelect,
	initialSelectionState,
	elevation,
	isEnabledState
)
```

**Roact**
```luau
local radioButton = Roact.createElement(Module.Roact.Primary, {
	style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)),
	onSelect = function(isSelected: boolean) end,
	initialSelection = false,
	elevation = 0,
	isEnabled = true,
})

Roact.mount(radioButton, parent)
```