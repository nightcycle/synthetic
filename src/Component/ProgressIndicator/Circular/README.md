# Circular


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **progress**: number?
- **isEnabled**: boolean?
- **fillColor**: Color3
- **emptyColor**: Color3
- **scale**: number


### Usage

**Vanilla**
```luau
local circular = Synthetic.Component.ProgressIndicator.Circular.Fusion.new()
circular.Progress = nil :: number?
circular.IsEnabled = nil :: boolean?
circular.FillColor = Color3.new() :: Color3
circular.EmptyColor = Color3.new() :: Color3
circular.Scale = 1 :: number
```

**Fusion**
```luau
local progressState: Fusion.Value<number?> = Value(nil)
local isEnabled: boolean? = nil
local fillColorState: Fusion.Value<Color3> = Value(Color3.new())
local emptyColor: Color3 = Color3.new()
local scaleState: Fusion.Value<number> = Value(1)

local circular: GuiObject = Synthetic.Component.ProgressIndicator.Circular.Fusion.new(
	progressState,
	isEnabled,
	fillColorState,
	emptyColor,
	scaleState
)
```
## primary / secondary / tertiary
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **progress**: number?
- **isEnabled**: boolean?


### Usage

**Vanilla**
```luau
local circular = Synthetic.Component.ProgressIndicator.Circular.Fusion.primary()
circular.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)) :: Style
circular.Progress = nil :: number?
circular.IsEnabled = nil :: boolean?
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local progress: number? = nil
local isEnabledState: Fusion.Value<boolean?> = Value(nil)

local circular: GuiObject = Synthetic.Component.ProgressIndicator.Circular.Fusion.primary(
	styleState,
	progress,
	isEnabledState
)
```