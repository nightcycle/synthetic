--!strict
local _Package = script.Parent.Parent.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Signal = require(_Packages:WaitForChild("Signal"))
local Icons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local IconButton = require(
	_Package
		:WaitForChild("Component")
		:WaitForChild("Button")
		:WaitForChild("IconButton")
		:WaitForChild("ColdFusion")
)
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Theme = require(_Package:WaitForChild("Theme"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type ImageData = Types.ImageData
type OptionData = Types.OptionData
type Signal = Signal.Signal
type ButtonData = Types.ButtonData
type Style = Style.Style
type FontData = Types.FontData

export type BarVariant = "Center" | "Small" | "Medium" | "Large"
-- Constants
local MAX_BUTTONS = 3
local ERROR_ICON = Icons.error
local BUTTON_SEPARATION_DP = 10
local BAR_TOP_BOTTOM_PADDING_DP = 12
local BAR_LEFT_RIGHT_PADDING_DP = 10
local LOWER_TEXT_MEDIUM_HEIGHT_DP = 36
local LOWER_TEXT_LARGE_HEIGHT_DP = 48
local LOWER_TEXT_MEDIUM_PADDING_DP = 18
local LOWER_TEXT_LARGE_PADDING_DP = 24
local UPPER_TEXT_HEIGHT_DP = 36
-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

function Interface.new(
	title: CanBeState<string>,
	buttons: CanBeState<{ ButtonData }>,
	navigationButton: CanBeState<ButtonData?>,
	variant: CanBeState<BarVariant>,
	backgroundColor: CanBeState<Color3>,
	textColor: CanBeState<Color3>,
	elevation: CanBeState<number>,
	schemeType: CanBeState<Enums.SchemeType>,
	titleFontData: CanBeState<FontData>,
	subHeadingFontData: CanBeState<FontData>,
	buttonFontData: CanBeState<FontData>,
	scale: CanBeState<number>
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local buttonsState: State<{ ButtonData }> = _import(buttons, {})

	local scaleState: State<number> = _import(scale, 1)
	local schemeTypeState: State<Enums.SchemeType> = _import(schemeType, Enums.SchemeType.Light)
	local titleFontDataState: State<FontData> = _import(titleFontData, nil :: any)
	local subHeadingFontDataState: State<FontData> = _import(subHeadingFontData, nil :: any)
	local buttonFontDataState: State<FontData> = _import(buttonFontData, nil :: any)

	local navState: State<ButtonData?> = _import(navigationButton, nil :: ButtonData?)
	local variantState: State<BarVariant> = _import(variant, "Center" :: BarVariant)
	local backgroundColorState: State<Color3> = _import(backgroundColor, Color3.new(1, 1, 1))
	local elevationState: State<number> = _import(elevation, 1)
	local textColorState: State<Color3> = _import(textColor, Color3.new(1, 1, 1))

	local inst = _new("Frame")({
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = _Computed(function(color: Color3, e: number, st: Enums.SchemeType): Color3
			return Theme.getElevatedColor(color, e, st)
		end, backgroundColorState, elevationState, schemeTypeState),
		Children = {
			_new("UIListLayout")({
				Padding = _Computed(function(s: number, var: BarVariant): UDim
					if var == "Medium" then
						return UDim.new(0, LOWER_TEXT_MEDIUM_PADDING_DP * s)
					elseif var == "Large" then
						return UDim.new(0, LOWER_TEXT_LARGE_PADDING_DP * s)
					else
						return UDim.new(0, 0)
					end
				end, scaleState, variantState),
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			_new("UIPadding")({
				PaddingLeft = _Computed(function(s: number): UDim
					return UDim.new(0, BAR_LEFT_RIGHT_PADDING_DP * s)
				end, scaleState),
				PaddingRight = _Computed(function(s: number): UDim
					return UDim.new(0, BAR_LEFT_RIGHT_PADDING_DP * s)
				end, scaleState),
				PaddingTop = _Computed(function(s: number): UDim
					return UDim.new(0, BAR_TOP_BOTTOM_PADDING_DP * s)
				end, scaleState),
				PaddingBottom = _Computed(function(s: number): UDim
					return UDim.new(0, BAR_TOP_BOTTOM_PADDING_DP * s)
				end, scaleState),
			}),
			_new("TextLabel")({
				Name = "LowerText",
				Text = title,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.X,
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				TextColor3 = _Computed(function(color: Color3, e: number, st: Enums.SchemeType): Color3
					return Theme.getElevatedColor(color, e, st)
				end, textColorState, elevationState, schemeTypeState),
				Visible = _Computed(function(var: BarVariant): boolean
					return var == "Medium" or var == "Large"
				end, variantState),
				Size = _Computed(function(s: number, var: BarVariant): UDim2
					if var == "Medium" then
						return UDim2.fromOffset(0, LOWER_TEXT_MEDIUM_HEIGHT_DP * s)
					else
						return UDim2.fromOffset(0, LOWER_TEXT_LARGE_HEIGHT_DP * s)
					end
				end, scaleState, variantState),
				TextScaled = true,
				FontFace = _Computed(function(f: FontData): Font
					return f.Font
				end, subHeadingFontDataState),
			}),
		},
	}) :: Frame

	local main = _new("Frame")({
		AutomaticSize = Enum.AutomaticSize.XY,
		Parent = inst,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Children = {
			_new("UIListLayout")({
				Padding = _Computed(function(s: number): UDim
					return UDim.new(0, 0)
				end, scaleState),
				HorizontalFlex = _Computed(function(var: BarVariant): Enum.UIFlexAlignment
					if var == "Center" then
						return Enum.UIFlexAlignment.SpaceBetween
					else
						return Enum.UIFlexAlignment.Fill
					end
				end, variantState),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			_new("TextLabel")({
				Name = "MiddleText",
				Text = title,
				TextXAlignment = Enum.TextXAlignment.Center,
				AutomaticSize = Enum.AutomaticSize.X,
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Visible = _Computed(function(var: BarVariant): boolean
					return var == "Center"
				end, variantState),
				TextColor3 = _Computed(function(color: Color3, e: number, st: Enums.SchemeType): Color3
					return Theme.getElevatedColor(color, e, st)
				end, textColorState, elevationState, schemeTypeState),
				Size = _Computed(function(s: number): UDim2
					return UDim2.fromOffset(0, UPPER_TEXT_HEIGHT_DP * s)
				end, scaleState),
				TextScaled = true,
				FontFace = _Computed(function(f: FontData): Font
					return f.Font
				end, titleFontDataState),
			}),
			_new("Frame")({
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Children = {
					_new("UIListLayout")({
						Padding = _Computed(function(s: number): UDim
							return UDim.new(0, s * BUTTON_SEPARATION_DP)
						end, scaleState),
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						ItemLineAlignment = Enum.ItemLineAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
					}),
					_new("TextLabel")({
						Name = "LeftText",
						Text = title,
						TextXAlignment = Enum.TextXAlignment.Center,
						AutomaticSize = Enum.AutomaticSize.X,
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						Visible = _Computed(function(var: BarVariant): boolean
							return var == "Small"
						end, variantState),
						TextColor3 = _Computed(
							function(color: Color3, e: number, st: Enums.SchemeType): Color3
								return Theme.getElevatedColor(color, e, st)
							end,
							textColorState,
							elevationState,
							schemeTypeState
						),
						Size = _Computed(function(s: number): UDim2
							return UDim2.fromOffset(0, UPPER_TEXT_HEIGHT_DP * s)
						end, scaleState),
						TextScaled = true,
						FontFace = _Computed(function(f: FontData): Font
							return f.Font
						end, titleFontDataState),
					}),
					_bind(IconButton.new(
						_Computed(function(nData: ButtonData?)
							return if nData then nData.OnClick else function() end
						end, navState),
						_Computed(function(nData: ButtonData?): ImageData
							return if nData and nData.Icon then nData.Icon else ERROR_ICON
						end, navState),
						textColor,
						textColor,
						_Computed(function(nData: ButtonData?): boolean
							return if nData then nData.Enabled else false
						end, navState),
						elevation,
						schemeTypeState,
						buttonFontDataState,
						scaleState
					))({
						LayoutOrder = 1,
						Visible = _Computed(function(nData: ButtonData?): boolean
							return if nData then nData.Enabled else false
						end, navState),
					}),
				},
			}),
		},
	})

	local buttonContainer = _new("Frame")({
		AutomaticSize = Enum.AutomaticSize.XY,
		Parent = main,
		LayoutOrder = 3,
		BackgroundTransparency = 1,
		Children = {
			_new("UIListLayout")({
				Padding = _Computed(function(s: number): UDim
					return UDim.new(0, s * BUTTON_SEPARATION_DP)
				end, scaleState),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
			}),
		},
	}) :: Frame

	for i = 1, MAX_BUTTONS do
		local buttonData = _Computed(function(bs: { ButtonData }): ButtonData?
			return bs[i]
		end, buttonsState)

		_bind(IconButton.new(
			_Computed(function(nData: ButtonData?)
				return if nData then nData.OnClick else function() end
			end, buttonData),
			_Computed(function(nData: ButtonData?): ImageData
				return if nData and nData.Icon then nData.Icon else ERROR_ICON
			end, buttonData),
			textColor,
			textColor,
			_Computed(function(nData: ButtonData?): boolean
				return if nData then nData.Enabled else false
			end, buttonData),
			elevation,
			schemeTypeState,
			buttonFontDataState,
			scaleState
		))({
			LayoutOrder = i,
			Visible = _Computed(function(nData: ButtonData?): boolean
				return if nData then nData.Enabled else false
			end, buttonData),
			Parent = buttonContainer,
		})
	end

	return inst
end

return Interface
