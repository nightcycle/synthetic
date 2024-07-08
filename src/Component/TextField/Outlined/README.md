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
end :: ((text: string?) -> string?)
outlined.OnInput = function(text: string?)
return text
end :: ((text: string?) -> string?)
outlined.InitialText = nil :: string?
outlined.IsEnabled = true :: boolean
outlined.IsError = false :: boolean
outlined.Label = "Label" :: string
outlined.CharacterLimit = nil :: number?
outlined.SupportingText = nil :: string?
outlined.Icon = nil :: ImageData?
outlined.HightlightColor = Color3.new() :: Color3
outlined.ErrorColor = Color3.new() :: Color3
outlined.BorderColor = Color3.new() :: Color3
outlined.TextColor = Color3.new() :: Color3
outlined.LabelColor = Color3.new() :: Color3
outlined.Elevation = 0 :: number
outlined.SchemeType = Enums.SchemeType.Light :: Enums.SchemeType
outlined.BodyFontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14) :: FontData
outlined.SupportFontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14) :: FontData
outlined.Scale = 1 :: number
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
outlined.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)) :: Style
outlined.OnSubmit = function(text: string?)
return text
end :: ((text: string?) -> string?)
outlined.Label = "Label" :: string
outlined.InitialText = nil :: string?
outlined.OnInput = nil :: (((text: string?) -> string?)?)
outlined.SupportingText = nil :: string?
outlined.Icon = nil :: ImageData?
outlined.CharacterLimit = nil :: number?
outlined.IsError = nil :: boolean?
outlined.Elevation = nil :: number?
outlined.IsEnabled = nil :: boolean?
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