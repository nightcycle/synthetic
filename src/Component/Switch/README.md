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

#### Fusion
You can use states or regular values for every parameter.
```luau
local onSelectState: Fusion.Value<(isSelected: boolean) -> (), unknown> = Value(function(isSelected: boolean) end)
local initialSelection: boolean = false
local isEnabledState: Fusion.Value<boolean, unknown> = Value(true)
local includeIconOnSelected: boolean = true
local includeIconOnDeselectedState: Fusion.Value<boolean, unknown> = Value(true)
local backgroundColor: Color3 = Color3.new()
local onBackgroundColorState: Fusion.Value<Color3, unknown> = Value(Color3.new())
local fillColor: Color3 = Color3.new()
local buttonColorState: Fusion.Value<Color3, unknown> = Value(Color3.new())
local onButtonColor: Color3 = Color3.new()
local disabledColorState: Fusion.Value<Color3, unknown> = Value(Color3.new())
local onDisabledColor: Color3 = Color3.new()
local elevationState: Fusion.Value<number, unknown> = Value(0)
local schemeType: Enums.SchemeType = Enums.SchemeType.Light
local fontDataState: Fusion.Value<FontData, unknown> = Value(Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14))
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

#### Fusion
You can use states or regular values for every parameter.
```luau
local styleState: Fusion.Value<Style, unknown> = Value(Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7)))
local onSelect: (isSelected: boolean) -> () = function(isSelected: boolean) end
local initialSelectionState: Fusion.Value<boolean, unknown> = Value(false)
local includeIconOnSelected: boolean? = nil
local includeIconOnDeselectedState: Fusion.Value<boolean?, unknown> = Value(nil)
local elevation: number? = nil
local isEnabledState: Fusion.Value<boolean?, unknown> = Value(nil)

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