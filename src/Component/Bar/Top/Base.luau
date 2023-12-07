--!strict
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Signal = require(_Packages:WaitForChild("Signal"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))
local TableUtil = require(_Packages:WaitForChild("TableUtil"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Util = require(_Package:WaitForChild("Util"))

local IconButton = require(_Package:WaitForChild("Component"):WaitForChild("Button"):WaitForChild("IconButton"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type TextStyle = Types.TextStyle
type ToggleTextStyle = Types.ToggleTextStyle
type ImageData = Types.ImageData
type ThemeData = Types.ThemeData
type OptionData = Types.OptionData
type Signal = Signal.Signal
type ButtonData = Types.ButtonData
export type BarVariant = "Center" | "Small" | "Medium" | "Large"
-- Constants
local MAX_BUTTONS = 3
local ICONS = MaterialIcons.default.dp_48.scale_1
local ERROR_ICON = ICONS.error
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

function Interface.cfusion(
	title: CanBeState<string>,
	buttons: CanBeState<{
		[number]: ButtonData
	}>,
	navigationButton: CanBeState<ButtonData>,
	theme: CanBeState<ThemeData>,
	variant: CanBeState<BarVariant>
): Frame
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local buttonsState: State<{
		[number]: ButtonData
	}> = _import(buttons, {})

	local themeState: State<ThemeData> = _import(theme, nil :: ThemeData?)
	local elevatedThemeState = _Computed(function(th: ThemeData): ThemeData
		local cth: ThemeData = TableUtil.deepCopy(th)
		cth.Elevation += 1
		return cth
	end, themeState)
	local contrastThemeState = _Computed(function(th: ThemeData): ThemeData
		local cth: ThemeData = TableUtil.deepCopy(th)
		cth.Color3 = Util.getReadableColor(cth.Color3, Util.getElevatedColor(cth.BackgroundColor3 or cth.Color3, cth.Elevation, cth.IsDarkMode))
		return cth
	end, themeState)
	local elevatedContrastThemeState = _Computed(function(th: ThemeData): ThemeData
		local cth: ThemeData = TableUtil.deepCopy(th)
		cth.Color3 = Util.getReadableColor(cth.Color3, Util.getElevatedColor(cth.BackgroundColor3 or cth.Color3, cth.Elevation, cth.IsDarkMode))
		return cth
	end, elevatedThemeState)
	local scaleState: State<number> = _Computed(function(th: ThemeData): number
		return th.Scale
	end, themeState)
	local navState: State<ButtonData> = _import(navigationButton, nil :: ButtonData?)
	local variantState: State<BarVariant> = _import(variant, "Center" :: BarVariant)

	local inst = _new("Frame")({
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = _Computed(function(th: ThemeData): Color3
			return Util.getElevatedColor(th.BackgroundColor3 or th.Color3, th.Elevation, th.IsDarkMode)
		end, themeState),
		Children = {
			_new("UIListLayout")({
				Padding = _Computed(function(s: number, var: BarVariant): UDim
					if var == "Medium" then
						return UDim.new(0, LOWER_TEXT_MEDIUM_PADDING_DP * s)
					elseif var == "Large" then
						return UDim.new(0, LOWER_TEXT_LARGE_PADDING_DP * s)
					else
						return UDim.new(0,0)
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
				TextColor3 = _Computed(function(th: ThemeData): Color3
					return th.Color3
				end, contrastThemeState),
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
				FontFace = _Computed(function(th: ThemeData): Font
					return th.Font
				end, themeState),
			}),
		}
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
				TextColor3 = _Computed(function(th: ThemeData): Color3
					return th.Color3
				end, contrastThemeState),
				Size = _Computed(function(s: number): UDim2
					return UDim2.fromOffset(0, UPPER_TEXT_HEIGHT_DP * s)
				end, scaleState),
				TextScaled = true,
				FontFace = _Computed(function(th: ThemeData): Font
					return th.Font
				end, themeState),
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
						TextColor3 = _Computed(function(th: ThemeData): Color3
							return th.Color3
						end, contrastThemeState),
						Size = _Computed(function(s: number): UDim2
							return UDim2.fromOffset(0, UPPER_TEXT_HEIGHT_DP * s)
						end, scaleState),
						TextScaled = true,
						FontFace = _Computed(function(th: ThemeData): Font
							return th.Font
						end, themeState),
					}),
					_bind(IconButton.cfusion(
						_Computed(function(nData: ButtonData?)
							return if nData then nData.OnClick else function() end
						end, navState),
						_Computed(function(nData: ButtonData?): ImageData
							return if nData and nData.Icon then nData.Icon else ERROR_ICON
						end, navState),
						elevatedThemeState,
						_Computed(function(nData: ButtonData?): boolean
							return if nData then nData.Enabled else true
						end, navState)
					))({
						Visible = _Computed(function(nData: ButtonData?): boolean
							return nData ~= nil
						end, navState),
						Parent = inst,
						LayoutOrder = 1,
					})
				}
			})
		}
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
		}
	}) :: Frame

	for i=1, MAX_BUTTONS do
		local buttonData = _Computed(function(bs: {[number]: ButtonData}): ButtonData?
			return bs[i]
		end, buttonsState)

		_bind(IconButton.cfusion(
			_Computed(function(bData: ButtonData?)
				return if bData then bData.OnClick else function() end
			end, buttonData),
			_Computed(function(bData: ButtonData?): ImageData
				return if bData and bData.Icon then bData.Icon else ERROR_ICON
			end, buttonData),
			elevatedContrastThemeState,
			_Computed(function(bData: ButtonData?): boolean
				return if bData then bData.Enabled else true
			end, buttonData)
		))({
			LayoutOrder = i,
			Visible = _Computed(function(bData: ButtonData?): boolean
				return bData ~= nil
			end, buttonData),
			Parent = buttonContainer,
		})

	end

	return inst

end

return Interface
