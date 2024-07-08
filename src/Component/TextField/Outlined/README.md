# Outlined


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
#### onSubmit
Type: **((text: string?) -> string?)**
Initial Value: **function(text: string?)
return text
end**

#### onInput
Type: **((text: string?) -> string?)**
Initial Value: **function(text: string?)
return text
end**

#### initialText
Type: **string?**
Initial Value: **nil**

#### isEnabled
Type: **boolean**
Initial Value: **true**

#### isError
Type: **boolean**
Initial Value: **false**

#### label
Type: **string**
Initial Value: **"Label"**

#### characterLimit
Type: **number?**
Initial Value: **nil**

#### supportingText
Type: **string?**
Initial Value: **nil**

#### icon
Type: **ImageData?**
Initial Value: **nil**

#### hightlightColor
Type: **Color3**
Initial Value: **Color3.new()**

#### errorColor
Type: **Color3**
Initial Value: **Color3.new()**

#### borderColor
Type: **Color3**
Initial Value: **Color3.new()**

#### textColor
Type: **Color3**
Initial Value: **Color3.new()**

#### labelColor
Type: **Color3**
Initial Value: **Color3.new()**

#### elevation
Type: **number**
Initial Value: **0**

#### schemeType
Type: **Enums.SchemeType**
Initial Value: **Enums.SchemeType.Light**

#### bodyFontData
Type: **FontData**
Initial Value: **Types.FontData.new(Font.fromEnum(Enum.Font.SourceSans), 14)**

#### supportFontData
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

#### onSubmit
Type: **((text: string?) -> string?)**
Initial Value: **function(text: string?)
return text
end**

#### label
Type: **string**
Initial Value: **"Label"**

#### initialText
Type: **string?**
Initial Value: **nil**

#### onInput
Type: **(((text: string?) -> string?)?)**
Initial Value: **nil**

#### supportingText
Type: **string?**
Initial Value: **nil**

#### icon
Type: **ImageData?**
Initial Value: **nil**

#### characterLimit
Type: **number?**
Initial Value: **nil**

#### isError
Type: **boolean?**
Initial Value: **nil**

#### elevation
Type: **number?**
Initial Value: **nil**

#### isEnabled
Type: **boolean?**
Initial Value: **nil**

