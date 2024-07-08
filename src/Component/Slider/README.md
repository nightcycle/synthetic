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

**Vanilla**
```luau
local slider = Synthetic.Component.Slider.Fusion.new()
slider.OnChange = function(onChange: number) end :: (onChange: number) -> ()
slider.InitialValue = 50 :: number
slider.Minimum = nil :: number?
slider.Maximum = nil :: number?
slider.Increment = nil :: number?
slider.LeftTextOrIcon =  :: string | ImageData | nil
slider.RightTextOrIcon =  :: string | ImageData | nil
slider.OnBackgroundColor = Color3.new() :: Color3
slider.OnBackgroundTextColor = Color3.new() :: Color3
slider.FillColor = Color3.new() :: Color3
slider.FillContainerColor = Color3.new() :: Color3
slider.Elevation = 0 :: number
slider.SchemeType = Enums.SchemeType.Light :: Enums.SchemeType
slider.FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14) :: FontData
slider.Scale = 1 :: number
```

**Fusion**
```luau
local onChangeState: Fusion.Value<(onChange: number) -> ()> = Value(function(onChange: number) end)
local initialValue: number = 50
local minimumState: Fusion.Value<number?> = Value(nil)
local maximum: number? = nil
local incrementState: Fusion.Value<number?> = Value(nil)
local leftTextOrIcon: string | ImageData | nil = 
local rightTextOrIconState: Fusion.Value<string | ImageData | nil> = Value()
local onBackgroundColor: Color3 = Color3.new()
local onBackgroundTextColorState: Fusion.Value<Color3> = Value(Color3.new())
local fillColor: Color3 = Color3.new()
local fillContainerColorState: Fusion.Value<Color3> = Value(Color3.new())
local elevation: number = 0
local schemeTypeState: Fusion.Value<Enums.SchemeType> = Value(Enums.SchemeType.Light)
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scaleState: Fusion.Value<number> = Value(1)

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

**Vanilla**
```luau
local slider = Synthetic.Component.Slider.Fusion.primary()
slider.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)) :: Style
slider.OnChange = function(onChange: number) end :: (onChange: number) -> ()
slider.InitialValue = 50 :: number
slider.Minimum = nil :: number?
slider.Maximum = nil :: number?
slider.Increment = nil :: number?
slider.LeftTextOrIcon = nil :: string | ImageData | nil
slider.RightTextOrIcon = nil :: string | ImageData | nil
slider.Elevation = 0 :: number
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onChange: (onChange: number) -> () = function(onChange: number) end
local initialValueState: Fusion.Value<number> = Value(50)
local minimum: number? = nil
local maximumState: Fusion.Value<number?> = Value(nil)
local increment: number? = nil
local leftTextOrIconState: Fusion.Value<string | ImageData | nil> = Value(nil)
local rightTextOrIcon: string | ImageData | nil = nil
local elevationState: Fusion.Value<number> = Value(0)

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