# Slider


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
#### onChange
Type: **(onChange: number) -> ()**
Initial Value: **function(onChange: number) end**

#### initialValue
Type: **number**
Initial Value: **50**

#### minimum
Type: **number?**
Initial Value: **nil**

#### maximum
Type: **number?**
Initial Value: **nil**

#### increment
Type: **number?**
Initial Value: **nil**

#### leftTextOrIcon
Type: **string | ImageData | nil**
Initial Value: ****

#### rightTextOrIcon
Type: **string | ImageData | nil**
Initial Value: ****

#### onBackgroundColor
Type: **Color3**
Initial Value: **Color3.new()**

#### onBackgroundTextColor
Type: **Color3**
Initial Value: **Color3.new()**

#### fillColor
Type: **Color3**
Initial Value: **Color3.new()**

#### fillContainerColor
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


## primary / secondary / tertiary / onPrimary / onSecondary / onTertiary
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
#### style
Type: **Style**
Initial Value: **Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))**

#### onChange
Type: **(onChange: number) -> ()**
Initial Value: **function(onChange: number) end**

#### initialValue
Type: **number**
Initial Value: **50**

#### minimum
Type: **number?**
Initial Value: **nil**

#### maximum
Type: **number?**
Initial Value: **nil**

#### increment
Type: **number?**
Initial Value: **nil**

#### leftTextOrIcon
Type: **string | ImageData | nil**
Initial Value: **nil**

#### rightTextOrIcon
Type: **string | ImageData | nil**
Initial Value: **nil**

#### elevation
Type: **number**
Initial Value: **0**

