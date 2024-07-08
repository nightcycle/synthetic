# RadioButton


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

**Vanilla**
```luau
local radioButton = Synthetic.Component.RadioButton.Fusion.new()
radioButton.OnSelect = function(isSelected: boolean) end :: (isSelected: boolean) -> ()
radioButton.InitialSelection = false :: boolean
radioButton.IsEnabled = true :: boolean
radioButton.OutlineColor = Color3.new() :: Color3
radioButton.FillColor = Color3.new() :: Color3
radioButton.IconColor = Color3.new() :: Color3
radioButton.DisabledColor = Color3.new() :: Color3
radioButton.Elevation = 0 :: number
radioButton.SchemeType = Enums.SchemeType.Light :: Enums.SchemeType
radioButton.FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14) :: FontData
radioButton.Scale = 1 :: number
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
## primary / secondary / tertiary / primaryContainer / secondaryContainer / tertiaryContainer
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onSelect**: (isSelected: boolean) -> ()
- **initialSelection**: boolean
- **elevation**: number?
- **isEnabled**: boolean?


### Usage

**Vanilla**
```luau
local radioButton = Synthetic.Component.RadioButton.Fusion.primary()
radioButton.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)) :: Style
radioButton.OnSelect = function(isSelected: boolean) end :: (isSelected: boolean) -> ()
radioButton.InitialSelection = false :: boolean
radioButton.Elevation = nil :: number?
radioButton.IsEnabled = nil :: boolean?
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onSelect: (isSelected: boolean) -> () = function(isSelected: boolean) end
local initialSelectionState: Fusion.Value<boolean> = Value(false)
local elevation: number? = nil
local isEnabledState: Fusion.Value<boolean?> = Value(nil)

local radioButton: GuiObject = Synthetic.Component.RadioButton.Fusion.primary(
	styleState,
	onSelect,
	initialSelectionState,
	elevation,
	isEnabledState
)
```