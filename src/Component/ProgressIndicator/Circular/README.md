# Circular


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
#### progress
Type: **number?**
Initial Value: **nil**

#### isEnabled
Type: **boolean?**
Initial Value: **nil**

#### fillColor
Type: **Color3**
Initial Value: **Color3.new()**

#### emptyColor
Type: **Color3**
Initial Value: **Color3.new()**

#### scale
Type: **number**
Initial Value: **1**


## primary / secondary / tertiary
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
#### style
Type: **Style**
Initial Value: **Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))**

#### progress
Type: **number?**
Initial Value: **nil**

#### isEnabled
Type: **boolean?**
Initial Value: **nil**

