# Small Snackbar

![Preview](preview.gif)

A snackbar is a single-line notification pop up that sometimes has buttons. Read more [here](https://m3.material.io/components/snackbar/overview).
# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **text**: string
- **buttonText**: string?
- **onButtonClick**: ((() -> ())?)
- **onCloseClick**: ((() -> ())?)
- **textColor**: Color3
- **buttonTextColor**: Color3
- **backgroundColor**: Color3
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number


### Usage

**No Framework**
```luau
local text: string = ""
local buttonText: string? = nil
local onButtonClick: ((() -> ())?) = nil
local onCloseClick: ((() -> ())?) = nil
local textColor: Color3 = Color3.new()
local buttonTextColor: Color3 = Color3.new()
local backgroundColor: Color3 = Color3.new()
local elevation: number = 0
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scale: number = 1

local small = Synthetic.Component.Snackbar.Small.Fusion.new()
small.Text = text
small.ButtonText = buttonText
small.OnButtonClick = onButtonClick
small.OnCloseClick = onCloseClick
small.TextColor = textColor
small.ButtonTextColor = buttonTextColor
small.BackgroundColor = backgroundColor
small.Elevation = elevation
small.SchemeType = schemeType
small.FontData = fontData
small.Scale = scale
```

**Fusion**
```luau
local textState: Fusion.Value<string> = Value("")
local buttonText: string? = nil
local onButtonClickState: Fusion.Value<((() -> ())?)> = Value(nil)
local onCloseClick: ((() -> ())?) = nil
local textColorState: Fusion.Value<Color3> = Value(Color3.new())
local buttonTextColor: Color3 = Color3.new()
local backgroundColorState: Fusion.Value<Color3> = Value(Color3.new())
local elevation: number = 0
local schemeTypeState: Fusion.Value<Enums.SchemeType> = Value(Enums.SchemeType.Light)
local fontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scaleState: Fusion.Value<number> = Value(1)

local small: GuiObject = Synthetic.Component.Snackbar.Small.Fusion.new(
	textState,
	buttonText,
	onButtonClickState,
	onCloseClick,
	textColorState,
	buttonTextColor,
	backgroundColorState,
	elevation,
	schemeTypeState,
	fontData,
	scaleState
)
```
## surfaceContainer / primaryContainer / secondaryContainer / tertiaryContainer
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **text**: string
- **buttonText**: string?
- **onButtonClick**: ((() -> ())?)
- **onCloseClick**: ((() -> ())?)
- **elevation**: number?


### Usage

**No Framework**
```luau
local style: Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
local text: string = ""
local buttonText: string? = nil
local onButtonClick: ((() -> ())?) = nil
local onCloseClick: ((() -> ())?) = nil
local elevation: number? = nil

local small = Synthetic.Component.Snackbar.Small.Fusion.surfaceContainer()
small.Style = style
small.Text = text
small.ButtonText = buttonText
small.OnButtonClick = onButtonClick
small.OnCloseClick = onCloseClick
small.Elevation = elevation
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local text: string = ""
local buttonTextState: Fusion.Value<string?> = Value(nil)
local onButtonClick: ((() -> ())?) = nil
local onCloseClickState: Fusion.Value<((() -> ())?)> = Value(nil)
local elevation: number? = nil

local small: GuiObject = Synthetic.Component.Snackbar.Small.Fusion.surfaceContainer(
	styleState,
	text,
	buttonTextState,
	onButtonClick,
	onCloseClickState,
	elevation
)
```