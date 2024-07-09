# Switch

![Preview](preview.gif)

A true / false input component often used in menus. Read more [here](https://m3.material.io/components/switch/overview).
# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onSelect**: (isSelected: boolean) -> ()
- **initialSelection**: boolean
- **isEnabled**: boolean
- **includeIconOnSelected**: boolean
- **includeIconOnDeselected**: boolean
- **backgroundColor**: Color3
- **onBackgroundColor**: Color3
- **fillColor**: Color3
- **buttonColor**: Color3
- **onButtonColor**: Color3
- **disabledColor**: Color3
- **onDisabledColor**: Color3
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
local includeIconOnSelected: boolean = true
local includeIconOnDeselected: boolean = true
local backgroundColor: Color3 = Color3.new()
local onBackgroundColor: Color3 = Color3.new()
local fillColor: Color3 = Color3.new()
local buttonColor: Color3 = Color3.new()
local onButtonColor: Color3 = Color3.new()
local disabledColor: Color3 = Color3.new()
local onDisabledColor: Color3 = Color3.new()
local elevation: number = 0
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scale: number = 1

local switch = Synthetic.Component.Switch.Fusion.new()
switch.OnSelect = onSelect
switch.InitialSelection = initialSelection
switch.IsEnabled = isEnabled
switch.IncludeIconOnSelected = includeIconOnSelected
switch.IncludeIconOnDeselected = includeIconOnDeselected
switch.BackgroundColor = backgroundColor
switch.OnBackgroundColor = onBackgroundColor
switch.FillColor = fillColor
switch.ButtonColor = buttonColor
switch.OnButtonColor = onButtonColor
switch.DisabledColor = disabledColor
switch.OnDisabledColor = onDisabledColor
switch.Elevation = elevation
switch.SchemeType = schemeType
switch.FontData = fontData
switch.Scale = scale
```

**Fusion**
```luau
local onSelectState: Fusion.Value<(isSelected: boolean) -> ()> = Value(function(isSelected: boolean) end)
local initialSelection: boolean = false
local isEnabledState: Fusion.Value<boolean> = Value(true)
local includeIconOnSelected: boolean = true
local includeIconOnDeselectedState: Fusion.Value<boolean> = Value(true)
local backgroundColor: Color3 = Color3.new()
local onBackgroundColorState: Fusion.Value<Color3> = Value(Color3.new())
local fillColor: Color3 = Color3.new()
local buttonColorState: Fusion.Value<Color3> = Value(Color3.new())
local onButtonColor: Color3 = Color3.new()
local disabledColorState: Fusion.Value<Color3> = Value(Color3.new())
local onDisabledColor: Color3 = Color3.new()
local elevationState: Fusion.Value<number> = Value(0)
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontDataState: Fusion.Value<FontData> = Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14))
local scale: number = 1

local switch: GuiObject = Synthetic.Component.Switch.Fusion.new(
	onSelectState,
	initialSelection,
	isEnabledState,
	includeIconOnSelected,
	includeIconOnDeselectedState,
	backgroundColor,
	onBackgroundColorState,
	fillColor,
	buttonColorState,
	onButtonColor,
	disabledColorState,
	onDisabledColor,
	elevationState,
	schemeType,
	fontDataState,
	scale
)
```

**Roact**
```luau
local switch = Roact.createElement(Module.Roact.New, {
	onSelect = function(isSelected: boolean) end,
	initialSelection = false,
	isEnabled = true,
	includeIconOnSelected = true,
	includeIconOnDeselected = true,
	backgroundColor = Color3.new(),
	onBackgroundColor = Color3.new(),
	fillColor = Color3.new(),
	buttonColor = Color3.new(),
	onButtonColor = Color3.new(),
	disabledColor = Color3.new(),
	onDisabledColor = Color3.new(),
	elevation = 0,
	schemeType = Enums.SchemeType.Light,
	fontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14),
	scale = 1,
})

Roact.mount(switch, parent)
```
## primary / secondary / tertiary
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onSelect**: (isSelected: boolean) -> ()
- **initialSelection**: boolean
- **includeIconOnSelected**: boolean?
- **includeIconOnDeselected**: boolean?
- **elevation**: number?
- **isEnabled**: boolean?


### Usage

**No Framework**
```luau
local style: Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
local onSelect: (isSelected: boolean) -> () = function(isSelected: boolean) end
local initialSelection: boolean = false
local includeIconOnSelected: boolean? = true
local includeIconOnDeselected: boolean? = true
local elevation: number? = 0
local isEnabled: boolean? = true

local switch = Synthetic.Component.Switch.Fusion.primary()
switch.Style = style
switch.OnSelect = onSelect
switch.InitialSelection = initialSelection
switch.IncludeIconOnSelected = includeIconOnSelected
switch.IncludeIconOnDeselected = includeIconOnDeselected
switch.Elevation = elevation
switch.IsEnabled = isEnabled
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onSelect: (isSelected: boolean) -> () = function(isSelected: boolean) end
local initialSelectionState: Fusion.Value<boolean> = Value(false)
local includeIconOnSelected: boolean? = true
local includeIconOnDeselectedState: Fusion.Value<boolean?> = Value(true)
local elevation: number? = 0
local isEnabledState: Fusion.Value<boolean?> = Value(true)

local switch: GuiObject = Synthetic.Component.Switch.Fusion.primary(
	styleState,
	onSelect,
	initialSelectionState,
	includeIconOnSelected,
	includeIconOnDeselectedState,
	elevation,
	isEnabledState
)
```

**Roact**
```luau
local switch = Roact.createElement(Module.Roact.Primary, {
	style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)),
	onSelect = function(isSelected: boolean) end,
	initialSelection = false,
	includeIconOnSelected = true,
	includeIconOnDeselected = true,
	elevation = 0,
	isEnabled = true,
})

Roact.mount(switch, parent)
```