# Text


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onInputEntered**: (input: string) -> string
- **label**: string?
- **optionSolver**: (input: string) -> { string }
- **optionConstructor**: (((key: string, onClick: (key: string) -> ()) -> GuiObject)?)
- **textColor**: Color3
- **backgroundColor**: Color3
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number


### Usage

**Vanilla**
```luau
local text = Synthetic.Component.Search.Text.Fusion.new()
text.OnInputEntered = function(input: string)
return input
end
text.Label = nil
text.OptionSolver = function(input: string)
return {}
end
text.OptionConstructor = nil
text.TextColor = Color3.new()
text.BackgroundColor = Color3.new()
text.Elevation = 0
text.SchemeType = Enums.SchemeType.Light
text.FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
text.Scale = 1
```

**Fusion**
```luau
local onInputEnteredState: Fusion.Value<(input: string) -> string> = Value(function(input: string)
return input
end)
local label: string? = nil
local optionSolverState: Fusion.Value<(input: string) -> { string }> = Value(function(input: string)
return {}
end)
local optionConstructor: (((key: string, onClick: (key: string) -> ()) -> GuiObject)?) = nil
local textColorState: Fusion.Value<Color3> = Value(Color3.new())
local backgroundColor: Color3 = Color3.new()
local elevationState: Fusion.Value<number> = Value(0)
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontDataState: Fusion.Value<FontData> = Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14))
local scale: number = 1

local text: GuiObject = Synthetic.Component.Search.Text.Fusion.new(
	onInputEnteredState,
	label,
	optionSolverState,
	optionConstructor,
	textColorState,
	backgroundColor,
	elevationState,
	schemeType,
	fontDataState,
	scale
)
```
## onPrimary / onSecondary / onTertiary / onPrimaryContainer / onSecondaryContainer / onTertiaryContainer
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onInputEntered**: (input: string) -> string
- **label**: string?
- **optionSolver**: (input: string) -> { string }
- **optionConstructor**: (((key: string, onClick: (key: string) -> ()) -> GuiObject)?)
- **elevation**: number?


### Usage

**Vanilla**
```luau
local text = Synthetic.Component.Search.Text.Fusion.onPrimary()
text.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
text.OnInputEntered = function(input: string)
return input
end
text.Label = nil
text.OptionSolver = function(input: string)
return {}
end
text.OptionConstructor = nil
text.Elevation = nil
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onInputEntered: (input: string) -> string = function(input: string)
return input
end
local labelState: Fusion.Value<string?> = Value(nil)
local optionSolver: (input: string) -> { string } = function(input: string)
return {}
end
local optionConstructorState: Fusion.Value<(((key: string, onClick: (key: string) -> ()) -> GuiObject)?)> = Value(nil)
local elevation: number? = nil

local text: GuiObject = Synthetic.Component.Search.Text.Fusion.onPrimary(
	styleState,
	onInputEntered,
	labelState,
	optionSolver,
	optionConstructorState,
	elevation
)
```