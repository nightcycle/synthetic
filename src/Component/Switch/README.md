# Switch


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onSelect**: (isSelected: boolean) -> ()
- **initialSelection**: boolean
- **isEnabled**: boolean
- **includeIconOnSelected**: boolean
- **includeIconOnDeselected**: boolean
- **backgroundColor**: Color3
- **onBackgroundColor**: Color3
- **fillColor**: Color3
- **buttonColor**: Color3
- **onButtonColor**: Color3
- **disabledColor**: Color3
- **onDisabledColor**: Color3
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number


### Usage

**Vanilla**
```luau
local switch = Synthetic.Component.Switch.Fusion.new()
switch.OnSelect = function(isSelected: boolean) end :: (isSelected: boolean) -> ()
switch.InitialSelection = false :: boolean
switch.IsEnabled = true :: boolean
switch.IncludeIconOnSelected = true :: boolean
switch.IncludeIconOnDeselected = true :: boolean
switch.BackgroundColor = Color3.new() :: Color3
switch.OnBackgroundColor = Color3.new() :: Color3
switch.FillColor = Color3.new() :: Color3
switch.ButtonColor = Color3.new() :: Color3
switch.OnButtonColor = Color3.new() :: Color3
switch.DisabledColor = Color3.new() :: Color3
switch.OnDisabledColor = Color3.new() :: Color3
switch.Elevation = 0 :: number
switch.SchemeType = Enums.SchemeType.Light :: Enums.SchemeType
switch.FontData = Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14) :: FontData
switch.Scale = 1 :: number
```

**Fusion**
```luau
local onSelectState: Fusion.Value<(isSelected: boolean) -> ()> = Value(function(isSelected: boolean) end)
local initialSelection: boolean = false
local isEnabledState: Fusion.Value<boolean> = Value(true)
local includeIconOnSelected: boolean = true
local includeIconOnDeselectedState: Fusion.Value<boolean> = Value(true)
local backgroundColor: Color3 = Color3.new()
local onBackgroundColorState: Fusion.Value<Color3> = Value(Color3.new())
local fillColor: Color3 = Color3.new()
local buttonColorState: Fusion.Value<Color3> = Value(Color3.new())
local onButtonColor: Color3 = Color3.new()
local disabledColorState: Fusion.Value<Color3> = Value(Color3.new())
local onDisabledColor: Color3 = Color3.new()
local elevationState: Fusion.Value<number> = Value(0)
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontDataState: Fusion.Value<FontData> = Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14))
local scale: number = 1

local switch: GuiObject = Synthetic.Component.Switch.Fusion.new(
	onSelectState,
	initialSelection,
	isEnabledState,
	includeIconOnSelected,
	includeIconOnDeselectedState,
	backgroundColor,
	onBackgroundColorState,
	fillColor,
	buttonColorState,
	onButtonColor,
	disabledColorState,
	onDisabledColor,
	elevationState,
	schemeType,
	fontDataState,
	scale
)
```
## primary / secondary / tertiary
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onSelect**: (isSelected: boolean) -> ()
- **initialSelection**: boolean
- **includeIconOnSelected**: boolean?
- **includeIconOnDeselected**: boolean?
- **elevation**: number?
- **isEnabled**: boolean?


### Usage

**Vanilla**
```luau
local switch = Synthetic.Component.Switch.Fusion.primary()
switch.Style = Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)) :: Style
switch.OnSelect = function(isSelected: boolean) end :: (isSelected: boolean) -> ()
switch.InitialSelection = false :: boolean
switch.IncludeIconOnSelected = nil :: boolean?
switch.IncludeIconOnDeselected = nil :: boolean?
switch.Elevation = nil :: number?
switch.IsEnabled = nil :: boolean?
```

**Fusion**
```luau
local styleState: Fusion.Value<Style> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onSelect: (isSelected: boolean) -> () = function(isSelected: boolean) end
local initialSelectionState: Fusion.Value<boolean> = Value(false)
local includeIconOnSelected: boolean? = nil
local includeIconOnDeselectedState: Fusion.Value<boolean?> = Value(nil)
local elevation: number? = nil
local isEnabledState: Fusion.Value<boolean?> = Value(nil)

local switch: GuiObject = Synthetic.Component.Switch.Fusion.primary(
	styleState,
	onSelect,
	initialSelectionState,
	includeIconOnSelected,
	includeIconOnDeselectedState,
	elevation,
	isEnabledState
)
```