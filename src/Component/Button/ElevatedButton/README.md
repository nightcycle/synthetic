# ElevatedButton


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
#### onClick
Type: **() -> ()**
Initial Value: **function() end**

#### text
Type: **string**
Initial Value: **"Button"**

#### icon
Type: **ImageData**
Initial Value: **Types.ImageData.new("")**

#### textColor
Type: **Color3**
Initial Value: **Color3.new()**

#### surfaceColor
Type: **Color3**
Initial Value: **Color3.new()**

#### disabledTextColor
Type: **Color3**
Initial Value: **Color3.new()**

#### disabledSurfaceColor
Type: **Color3**
Initial Value: **Color3.new()**

#### shadowColor
Type: **Color3**
Initial Value: **Color3.new()**

#### isEnabled
Type: **boolean**
Initial Value: **true**

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


## primary / secondary / tertiary / primaryContainer / secondaryContainer / tertiaryContainer
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
#### style
Type: **Style**
Initial Value: **Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))**

#### onClick
Type: **() -> ()**
Initial Value: **function() end**

#### text
Type: **string**
Initial Value: **"Button"**

#### icon
Type: **ImageData**
Initial Value: **Types.ImageData.new("")**

#### elevation
Type: **number**
Initial Value: **0**

#### isEnabled
Type: **boolean**
Initial Value: **true**

