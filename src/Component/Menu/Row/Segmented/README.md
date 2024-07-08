# Segmented


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **options**: { OptionData }
- **density**: number?
- **isMultiSelect**: boolean?
- **textColor**: Color3
- **fillTextColor**: Color3
- **fillBackgroundColor**: Color3
- **outlineColor**: Color3
- **elevation**: number?
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number?

## primaryContainer / secondaryContainer / tertiaryContainer
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **options**: { OptionData }
- **density**: number?
- **isMultiSelect**: boolean?
- **elevation**: number?
