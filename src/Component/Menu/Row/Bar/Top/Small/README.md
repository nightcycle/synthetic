# Top Small Menu Bar

![Preview](preview.gif)

The top small menu bar has a left aligned title between the buttons. Read more [here](https://m3.material.io/components/top-app-bar/overview).
# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **title**: string
- **buttons**: {ButtonData}
- **navigation**: ButtonData?
- **backgroundColor**: Color3
- **textColor**: Color3
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **titleFontData**: FontData
- **subHeadingFontData**: FontData
- **buttonFontData**: FontData
- **scale**: number


### Usage

**No Framework**
```luau
local title: string = "Title"
local buttons: {ButtonData} = {}
local navigation: ButtonData? = nil
local backgroundColor: Color3 = Color3.new()
local textColor: Color3 = Color3.new()
local elevation: number = 0
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local titleFontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local subHeadingFontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local buttonFontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scale: number = 1

local small = Synthetic.Component.Menu.Row.Bar.Top.Small.Wrapper.new()
small.Title = title
small.Buttons = buttons
small.Navigation = navigation
small.BackgroundColor = backgroundColor
small.TextColor = textColor
small.Elevation = elevation
small.SchemeType = schemeType
small.TitleFontData = titleFontData
small.SubHeadingFontData = subHeadingFontData
small.ButtonFontData = buttonFontData
small.Scale = scale
```

**Fusion**
```luau
local titleState: Fusion.Value<string> = Value("Title")
local buttons: {ButtonData} = {}
local navigationState: Fusion.Value<ButtonData?> = Value(nil)
local backgroundColor: Color3 = Color3.new()
local textColorState: Fusion.Value<Color3> = Value(Color3.new())
local elevation: number = 0
local schemeTypeState: Fusion.Value<Enums.SchemeType> = Value(Enums.SchemeType.Light)
local titleFontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local subHeadingFontDataState: Fusion.Value<FontData> = Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14))
local buttonFontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scaleState: Fusion.Value<number> = Value(1)

local small: GuiObject = Synthetic.Component.Menu.Row.Bar.Top.Small.Fusion.new(
	titleState,
	buttons,
	navigationState,
	backgroundColor,
	textColorState,
	elevation,
	schemeTypeState,
	titleFontData,
	subHeadingFontDataState,
	buttonFontData,
	scaleState
)
```

**Roact**
```luau
local small = Roact.createElement(Module.Roact.New, {
	title = "Title",
	buttons = {},
	navigation = nil,
	backgroundColor = Color3.new(),
	textColor = Color3.new(),
	elevation = 0,
	schemeType = Enums.SchemeType.Light,
	titleFontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14),
	subHeadingFontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14),
	buttonFontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14),
	scale = 1,
})

Roact.mount(small, parent)
```
## primary / secondary / tertiary
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **title**: string
- **buttons**: {ButtonData}
- **navigation**: ButtonData?
- **elevation**: number?


### Usage

**No Framework**
```luau
local style: Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
local title: string = "Title"
local buttons: {ButtonData} = {}
local navigation: ButtonData? = nil
local elevation: number? = 0

local small = Synthetic.Component.Menu.Row.Bar.Top.Small.Wrapper.primary()
small.Style = style
small.Title = title
small.Buttons = buttons
small.Navigation = navigation
small.Elevation = elevation
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local title: string = "Title"
local buttonsState: Fusion.Value<{ButtonData}> = Value({})
local navigation: ButtonData? = nil
local elevationState: Fusion.Value<number?> = Value(0)

local small: GuiObject = Synthetic.Component.Menu.Row.Bar.Top.Small.Fusion.primary(
	styleState,
	title,
	buttonsState,
	navigation,
	elevationState
)
```

**Roact**
```luau
local small = Roact.createElement(Module.Roact.Primary, {
	style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)),
	title = "Title",
	buttons = {},
	navigation = nil,
	elevation = 0,
})

Roact.mount(small, parent)
```