--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
local SoundService = game:GetService("SoundService")

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Signal = require(_Packages:WaitForChild("Signal"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))
local TableUtil = require(_Packages:WaitForChild("TableUtil"))

-- Modules
local Sounds = require(_Package:WaitForChild("Sounds"))
local Enums = require(_Package:WaitForChild("Enums"))
local Types = require(_Package:WaitForChild("Types"))
local Config = require(_Package:WaitForChild("Config"))
local Util = require(_Package:WaitForChild("Util"))

local IconButton = require(_Package:WaitForChild("Component"):WaitForChild("Button"):WaitForChild("IconButton"))
local FAB = require(_Package:WaitForChild("Component"):WaitForChild("Button"):WaitForChild("FAB"))

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
-- Constants
local MAX_BUTTONS = 4
local ICONS = MaterialIcons.default.dp_48.scale_1
local ERROR_ICON = ICONS.error
local BUTTON_SEPARATION_DP = 4
local BAR_TOP_BOTTOM_PADDING_DP = 6
local BAR_LEFT_RIGHT_PADDING_DP = 10
-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

function Interface.cfusion(
	buttons: CanBeState<{
		[number]: ButtonData
	}>,
	fab: CanBeState<ButtonData>,
	theme: CanBeState<ThemeData>
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
	end, elevatedThemeState)
	local scaleState: State<number> = _Computed(function(th: ThemeData): number
		return th.Scale
	end, themeState)
	local fabState: State<ButtonData> = _import(fab, nil :: ButtonData?)

	local inst = _new("Frame")({
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = _Computed(function(th: ThemeData): Color3
			return Util.getElevatedColor(th.BackgroundColor3 or th.Color3, th.Elevation, th.IsDarkMode)
		end, themeState),
		Children = {
			_new("UIListLayout")({
				Padding = _Computed(function(s: number): UDim
					return UDim.new(0, 0)
				end, scaleState),
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
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
		}
	}) :: Frame


	_new("Frame")({
		AutomaticSize = Enum.AutomaticSize.XY,
		Parent = inst,
		LayoutOrder = 2,
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
			_bind(FAB.cfusion(
				_Computed(function(fData: ButtonData?)
					return if fData then fData.OnClick else function() end
				end, fabState),
				_Computed(function(fData: ButtonData?): ImageData
					return if fData and fData.Icon then fData.Icon else ERROR_ICON
				end, fabState),
				elevatedThemeState,
				_Computed(function(fData: ButtonData?): boolean
					return if fData then fData.Enabled else true
				end, fabState)
			))({
				Visible = _Computed(function(fData: ButtonData?): boolean
					return fData ~= nil
				end, fabState),
				Parent = inst,
			})
		}
	})


	local buttonContainer = _new("Frame")({
		AutomaticSize = Enum.AutomaticSize.XY,
		Parent = inst,
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
			contrastThemeState,
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
