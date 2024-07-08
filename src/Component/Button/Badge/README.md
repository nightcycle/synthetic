# Badge

A [badge](https://m3.material.io/components/badges/overview) is a small status indicator for UI elements
# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onClick**: () -> ()
- **icon**: ImageData
- **label**: string?
- **count**: number?
- **textColor**: Color3
- **hoverColor**: Color3
- **errorTextColor**: Color3
- **errorBackgroundColor**: Color3
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number


### Usage

**Vanilla**
```luau
local badge = Synthetic.Component.Button.Badge.Fusion.new()
badge.OnClick = function() end :: () -> ()
badge.Icon = Types.ImageData.new("") :: ImageData
badge.Label = nil :: string?
badge.Count = nil :: number?
badge.TextColor = Color3.new() :: Color3
badge.HoverColor = Color3.new() :: Color3
badge.ErrorTextColor = Color3.new() :: Color3
badge.ErrorBackgroundColor = Color3.new() :: Color3
badge.Elevation = 0 :: number
badge.SchemeType = Enums.SchemeType.Light :: Enums.SchemeType
badge.FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14) :: FontData
badge.Scale = 1 :: number
```

**Fusion**
```luau
local onClickState: Fusion.Value<() -> ()> = Value(function() end)
local icon: ImageData = Types.ImageData.new("")
local labelState: Fusion.Value<string?> = Value(nil)
local count: number? = nil
local textColorState: Fusion.Value<Color3> = Value(Color3.new())
local hoverColor: Color3 = Color3.new()
local errorTextColorState: Fusion.Value<Color3> = Value(Color3.new())
local errorBackgroundColor: Color3 = Color3.new()
local elevationState: Fusion.Value<number> = Value(0)
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontDataState: Fusion.Value<FontData> = Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14))
local scale: number = 1

local badge: GuiObject = Synthetic.Component.Button.Badge.Fusion.new(
	onClickState,
	icon,
	labelState,
	count,
	textColorState,
	hoverColor,
	errorTextColorState,
	errorBackgroundColor,
	elevationState,
	schemeType,
	fontDataState,
	scale
)
```
## onPrimary / onSurface
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onClick**: () -> ()
- **icon**: ImageData
- **label**: string?
- **count**: number?
- **elevation**: number?


### Usage

**Vanilla**
```luau
local badge = Synthetic.Component.Button.Badge.Fusion.onPrimary()
badge.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)) :: Style
badge.OnClick = function() end :: () -> ()
badge.Icon = Types.ImageData.new("") :: ImageData
badge.Label = nil :: string?
badge.Count = nil :: number?
badge.Elevation = nil :: number?
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onClick: () -> () = function() end
local iconState: Fusion.Value<ImageData> = Value(Types.ImageData.new(""))
local label: string? = nil
local countState: Fusion.Value<number?> = Value(nil)
local elevation: number? = nil

local badge: GuiObject = Synthetic.Component.Button.Badge.Fusion.onPrimary(
	styleState,
	onClick,
	iconState,
	label,
	countState,
	elevation
)
```