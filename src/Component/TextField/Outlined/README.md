# Outlined


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onSubmit**: ((text: string?) -> string?)
- **onInput**: ((text: string?) -> string?)
- **initialText**: string?
- **isEnabled**: boolean
- **isError**: boolean
- **label**: string
- **characterLimit**: number?
- **supportingText**: string?
- **icon**: ImageData?
- **hightlightColor**: Color3
- **errorColor**: Color3
- **borderColor**: Color3
- **textColor**: Color3
- **labelColor**: Color3
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **bodyFontData**: FontData
- **supportFontData**: FontData
- **scale**: number


### Usage

**Vanilla**
```luau
local outlined = Synthetic.Component.TextField.Outlined.Fusion.new()
outlined.OnSubmit = function(text: string?)
return text
end
outlined.OnInput = function(text: string?)
return text
end
outlined.InitialText = nil
outlined.IsEnabled = true
outlined.IsError = false
outlined.Label = "Label"
outlined.CharacterLimit = nil
outlined.SupportingText = nil
outlined.Icon = nil
outlined.HightlightColor = Color3.new()
outlined.ErrorColor = Color3.new()
outlined.BorderColor = Color3.new()
outlined.TextColor = Color3.new()
outlined.LabelColor = Color3.new()
outlined.Elevation = 0
outlined.SchemeType = Enums.SchemeType.Light
outlined.BodyFontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
outlined.SupportFontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
outlined.Scale = 1
```

**Fusion**
```luau
local onSubmitState: Fusion.Value<((text: string?) -> string?)> = Value(function(text: string?)
return text
end)
local onInput: ((text: string?) -> string?) = function(text: string?)
return text
end
local initialTextState: Fusion.Value<string?> = Value(nil)
local isEnabled: boolean = true
local isErrorState: Fusion.Value<boolean> = Value(false)
local label: string = "Label"
local characterLimitState: Fusion.Value<number?> = Value(nil)
local supportingText: string? = nil
local iconState: Fusion.Value<ImageData?> = Value(nil)
local hightlightColor: Color3 = Color3.new()
local errorColorState: Fusion.Value<Color3> = Value(Color3.new())
local borderColor: Color3 = Color3.new()
local textColorState: Fusion.Value<Color3> = Value(Color3.new())
local labelColor: Color3 = Color3.new()
local elevationState: Fusion.Value<number> = Value(0)
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local bodyFontDataState: Fusion.Value<FontData> = Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14))
local supportFontData: FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)
local scaleState: Fusion.Value<number> = Value(1)

local outlined: GuiObject = Synthetic.Component.TextField.Outlined.Fusion.new(
	onSubmitState,
	onInput,
	initialTextState,
	isEnabled,
	isErrorState,
	label,
	characterLimitState,
	supportingText,
	iconState,
	hightlightColor,
	errorColorState,
	borderColor,
	textColorState,
	labelColor,
	elevationState,
	schemeType,
	bodyFontDataState,
	supportFontData,
	scaleState
)
```
## primary / secondary / tertiary
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onSubmit**: ((text: string?) -> string?)
- **label**: string
- **initialText**: string?
- **onInput**: (((text: string?) -> string?)?)
- **supportingText**: string?
- **icon**: ImageData?
- **characterLimit**: number?
- **isError**: boolean?
- **elevation**: number?
- **isEnabled**: boolean?


### Usage

**Vanilla**
```luau
local outlined = Synthetic.Component.TextField.Outlined.Fusion.primary()
outlined.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))
outlined.OnSubmit = function(text: string?)
return text
end
outlined.Label = "Label"
outlined.InitialText = nil
outlined.OnInput = nil
outlined.SupportingText = nil
outlined.Icon = nil
outlined.CharacterLimit = nil
outlined.IsError = nil
outlined.Elevation = nil
outlined.IsEnabled = nil
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onSubmit: ((text: string?) -> string?) = function(text: string?)
return text
end
local labelState: Fusion.Value<string> = Value("Label")
local initialText: string? = nil
local onInputState: Fusion.Value<(((text: string?) -> string?)?)> = Value(nil)
local supportingText: string? = nil
local iconState: Fusion.Value<ImageData?> = Value(nil)
local characterLimit: number? = nil
local isErrorState: Fusion.Value<boolean?> = Value(nil)
local elevation: number? = nil
local isEnabledState: Fusion.Value<boolean?> = Value(nil)

local outlined: GuiObject = Synthetic.Component.TextField.Outlined.Fusion.primary(
	styleState,
	onSubmit,
	labelState,
	initialText,
	onInputState,
	supportingText,
	iconState,
	characterLimit,
	isErrorState,
	elevation,
	isEnabledState
)
```