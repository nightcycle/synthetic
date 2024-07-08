# Switch


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
#### onSelect
Type: **(isSelected: boolean) -> ()**
Initial Value: **function(isSelected: boolean) end**

#### initialSelection
Type: **boolean**
Initial Value: **false**

#### isEnabled
Type: **boolean**
Initial Value: **true**

#### includeIconOnSelected
Type: **boolean**
Initial Value: **true**

#### includeIconOnDeselected
Type: **boolean**
Initial Value: **true**

#### backgroundColor
Type: **Color3**
Initial Value: **Color3.new()**

#### onBackgroundColor
Type: **Color3**
Initial Value: **Color3.new()**

#### fillColor
Type: **Color3**
Initial Value: **Color3.new()**

#### buttonColor
Type: **Color3**
Initial Value: **Color3.new()**

#### onButtonColor
Type: **Color3**
Initial Value: **Color3.new()**

#### disabledColor
Type: **Color3**
Initial Value: **Color3.new()**

#### onDisabledColor
Type: **Color3**
Initial Value: **Color3.new()**

#### elevation
Type: **number**
Initial Value: **0**

#### schemeType
Type: **Enums.SchemeType**
Initial Value: **Enums.SchemeType.Light**

#### fontData
Type: **FontData**
Initial Value: **Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)**

#### scale
Type: **number**
Initial Value: **1**


## primary / secondary / tertiary
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
#### style
Type: **Style**
Initial Value: **Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))**

#### onSelect
Type: **(isSelected: boolean) -> ()**
Initial Value: **function(isSelected: boolean) end**

#### initialSelection
Type: **boolean**
Initial Value: **false**

#### includeIconOnSelected
Type: **boolean?**
Initial Value: **nil**

#### includeIconOnDeselected
Type: **boolean?**
Initial Value: **nil**

#### elevation
Type: **number?**
Initial Value: **nil**

#### isEnabled
Type: **boolean?**
Initial Value: **nil**

