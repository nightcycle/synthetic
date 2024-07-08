# Large


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
#### text
Type: **string**
Initial Value: **""**

#### buttonText
Type: **string?**
Initial Value: **nil**

#### onButtonClick
Type: **((() -> ())?)**
Initial Value: **nil**

#### onCloseClick
Type: **((() -> ())?)**
Initial Value: **nil**

#### textColor
Type: **Color3**
Initial Value: **Color3.new()**

#### buttonTextColor
Type: **Color3**
Initial Value: **Color3.new()**

#### backgroundColor
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


## surfaceContainer / primaryContainer / secondaryContainer / tertiaryContainer
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
#### style
Type: **Style**
Initial Value: **Style.new(1, Enum.Font.SourceSans, "Light", Color3.new(0, 0.4, 0.7))**

#### text
Type: **string**
Initial Value: **""**

#### buttonText
Type: **string?**
Initial Value: **nil**

#### onButtonClick
Type: **((() -> ())?)**
Initial Value: **nil**

#### onCloseClick
Type: **((() -> ())?)**
Initial Value: **nil**

#### elevation
Type: **number?**
Initial Value: **nil**

