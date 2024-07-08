# Large


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

**Vanilla**
```luau
local large = Synthetic.Component.Snackbar.Large.Fusion.new()
large.Text = ""
large.ButtonText = nil
large.OnButtonClick = nil
large.OnCloseClick = nil
large.TextColor = Color3.new()
large.ButtonTextColor = Color3.new()
large.BackgroundColor = Color3.new()
large.Elevation = 0
large.SchemeType = Enums.SchemeType.Light
large.FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
large.Scale = 1
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

local large: GuiObject = Synthetic.Component.Snackbar.Large.Fusion.new(
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

**Vanilla**
```luau
local large = Synthetic.Component.Snackbar.Large.Fusion.surfaceContainer()
large.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
large.Text = ""
large.ButtonText = nil
large.OnButtonClick = nil
large.OnCloseClick = nil
large.Elevation = nil
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local text: string = ""
local buttonTextState: Fusion.Value<string?> = Value(nil)
local onButtonClick: ((() -> ())?) = nil
local onCloseClickState: Fusion.Value<((() -> ())?)> = Value(nil)
local elevation: number? = nil

local large: GuiObject = Synthetic.Component.Snackbar.Large.Fusion.surfaceContainer(
	styleState,
	text,
	buttonTextState,
	onButtonClick,
	onCloseClickState,
	elevation
)
```