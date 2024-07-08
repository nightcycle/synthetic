# Slider


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onChange**: (onChange: number) -> ()
- **initialValue**: number
- **minimum**: number?
- **maximum**: number?
- **increment**: number?
- **leftTextOrIcon**: string | ImageData | nil
- **rightTextOrIcon**: string | ImageData | nil
- **onBackgroundColor**: Color3
- **onBackgroundTextColor**: Color3
- **fillColor**: Color3
- **fillContainerColor**: Color3
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number


### Usage

#### Fusion
You can use states or regular values for every parameter.
```luau
local onChangeState: Fusion.Value<(onChange: number) -> (), unknown> = Value(function(onChange: number) end)
local initialValue: number = 50
local minimumState: Fusion.Value<number?, unknown> = Value(nil)
local maximum: number? = nil
local incrementState: Fusion.Value<number?, unknown> = Value(nil)
local leftTextOrIcon: string | ImageData | nil = 
local rightTextOrIconState: Fusion.Value<string | ImageData | nil, unknown> = Value()
local onBackgroundColor: Color3 = Color3.new()
local onBackgroundTextColorState: Fusion.Value<Color3, unknown> = Value(Color3.new())
local fillColor: Color3 = Color3.new()
local fillContainerColorState: Fusion.Value<Color3, unknown> = Value(Color3.new())
local elevation: number = 0
local schemeTypeState: Fusion.Value<Enums.SchemeType, unknown> = Value(Enums.SchemeType.Light)
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scaleState: Fusion.Value<number, unknown> = Value(1)

local slider: GuiObject = Synthetic.Component.Slider.Fusion.new(
	onChangeState,
	initialValue,
	minimumState,
	maximum,
	incrementState,
	leftTextOrIcon,
	rightTextOrIconState,
	onBackgroundColor,
	onBackgroundTextColorState,
	fillColor,
	fillContainerColorState,
	elevation,
	schemeTypeState,
	fontData,
	scaleState
)
```
## primary / secondary / tertiary / onPrimary / onSecondary / onTertiary
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onChange**: (onChange: number) -> ()
- **initialValue**: number
- **minimum**: number?
- **maximum**: number?
- **increment**: number?
- **leftTextOrIcon**: string | ImageData | nil
- **rightTextOrIcon**: string | ImageData | nil
- **elevation**: number


### Usage

#### Fusion
You can use states or regular values for every parameter.
```luau
local styleState: Fusion.Value<Style, unknown> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onChange: (onChange: number) -> () = function(onChange: number) end
local initialValueState: Fusion.Value<number, unknown> = Value(50)
local minimum: number? = nil
local maximumState: Fusion.Value<number?, unknown> = Value(nil)
local increment: number? = nil
local leftTextOrIconState: Fusion.Value<string | ImageData | nil, unknown> = Value(nil)
local rightTextOrIcon: string | ImageData | nil = nil
local elevationState: Fusion.Value<number, unknown> = Value(0)

local slider: GuiObject = Synthetic.Component.Slider.Fusion.primary(
	styleState,
	onChange,
	initialValueState,
	minimum,
	maximumState,
	increment,
	leftTextOrIconState,
	rightTextOrIcon,
	elevationState
)
```