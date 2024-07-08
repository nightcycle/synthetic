# Filter


# Constructors


## new
This function is a native constructor, with verbosity allowing for control over every configurable property at the cost of a less convenient calling.

### Parameters
- **onClick**: (isSelected: boolean) -> ()
- **isInitiallySelected**: boolean
- **text**: string
- **textColor**: Color3
- **disabledTextColor**: Color3
- **fillTextColor**: Color3
- **disabledFillTextColor**: Color3
- **disabledFillColor**: Color3
- **isEnabled**: boolean
- **elevation**: number
- **schemeType**: Enums.SchemeType
- **fontData**: FontData
- **scale**: number

## primary / secondary / tertiary
This function is a style constructor, utilizing the "Style" type to reduce the number of parameters required for implementation.

### Parameters
- **style**: Style
- **onClick**: (isSelected: boolean) -> ()
- **text**: string
- **isInitiallySelected**: boolean
- **isEnabled**: boolean?
- **elevation**: number?
