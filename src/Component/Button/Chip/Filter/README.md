# Filter


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onClick**: (isSelected: boolean) -> ()
- **isInitiallySelected**: boolean
- **text**: string
- **textColor**: Color3
- **disabledTextColor**: Color3
- **fillTextColor**: Color3
- **disabledFillTextColor**: Color3
- **disabledFillColor**: Color3
- **isEnabled**: boolean
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number


### Usage

#### Fusion
You can use states or regular values for every parameter.
```luau
local onClickState: Fusion.Value<(isSelected: boolean) -> (), unknown> = Value(function(isSelected: boolean) end)
local isInitiallySelected: boolean = false
local textState: Fusion.Value<string, unknown> = Value("Filter")
local textColor: Color3 = Color3.new()
local disabledTextColorState: Fusion.Value<Color3, unknown> = Value(Color3.new())
local fillTextColor: Color3 = Color3.new()
local disabledFillTextColorState: Fusion.Value<Color3, unknown> = Value(Color3.new())
local disabledFillColor: Color3 = Color3.new()
local isEnabledState: Fusion.Value<boolean, unknown> = Value(true)
local elevation: number = 0
local schemeTypeState: Fusion.Value<Enums.SchemeType, unknown> = Value(Enums.SchemeType.Light)
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scaleState: Fusion.Value<number, unknown> = Value(1)

local filter: GuiObject = Synthetic.Component.Button.Chip.Filter.Fusion.new(
	onClickState,
	isInitiallySelected,
	textState,
	textColor,
	disabledTextColorState,
	fillTextColor,
	disabledFillTextColorState,
	disabledFillColor,
	isEnabledState,
	elevation,
	schemeTypeState,
	fontData,
	scaleState
)
```
## primary / secondary / tertiary
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onClick**: (isSelected: boolean) -> ()
- **text**: string
- **isInitiallySelected**: boolean
- **isEnabled**: boolean?
- **elevation**: number?


### Usage

#### Fusion
You can use states or regular values for every parameter.
```luau
local styleState: Fusion.Value<Style, unknown> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onClick: (isSelected: boolean) -> () = function(isSelected: boolean) end
local textState: Fusion.Value<string, unknown> = Value("Filter")
local isInitiallySelected: boolean = false
local isEnabledState: Fusion.Value<boolean?, unknown> = Value(nil)
local elevation: number? = nil

local filter: GuiObject = Synthetic.Component.Button.Chip.Filter.Fusion.primary(
	styleState,
	onClick,
	textState,
	isInitiallySelected,
	isEnabledState,
	elevation
)
```