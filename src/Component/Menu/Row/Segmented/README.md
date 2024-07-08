# Segmented


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **options**: { OptionData }
- **density**: number?
- **isMultiSelect**: boolean?
- **textColor**: Color3
- **fillTextColor**: Color3
- **fillBackgroundColor**: Color3
- **outlineColor**: Color3
- **elevation**: number?
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number?


### Usage

#### Fusion
You can use states or regular values for every parameter.
```luau
local optionsState: Fusion.Value<{ OptionData }, unknown> = Value({})
local density: number? = nil
local isMultiSelectState: Fusion.Value<boolean?, unknown> = Value(nil)
local textColor: Color3 = Color3.new()
local fillTextColorState: Fusion.Value<Color3, unknown> = Value(Color3.new())
local fillBackgroundColor: Color3 = Color3.new()
local outlineColorState: Fusion.Value<Color3, unknown> = Value(Color3.new())
local elevation: number? = nil
local schemeTypeState: Fusion.Value<Enums.SchemeType, unknown> = Value(Enums.SchemeType.Light)
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scaleState: Fusion.Value<number?, unknown> = Value(nil)

local segmented: GuiObject = Synthetic.Component.Menu.Row.Segmented.Fusion.new(
	optionsState,
	density,
	isMultiSelectState,
	textColor,
	fillTextColorState,
	fillBackgroundColor,
	outlineColorState,
	elevation,
	schemeTypeState,
	fontData,
	scaleState
)
```
## primaryContainer / secondaryContainer / tertiaryContainer
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **options**: { OptionData }
- **density**: number?
- **isMultiSelect**: boolean?
- **elevation**: number?


### Usage

#### Fusion
You can use states or regular values for every parameter.
```luau
local styleState: Fusion.Value<Style, unknown> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local options: { OptionData } = {}
local densityState: Fusion.Value<number?, unknown> = Value(nil)
local isMultiSelect: boolean? = nil
local elevationState: Fusion.Value<number?, unknown> = Value(nil)

local segmented: GuiObject = Synthetic.Component.Menu.Row.Segmented.Fusion.primaryContainer(
	styleState,
	options,
	densityState,
	isMultiSelect,
	elevationState
)
```