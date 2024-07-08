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
