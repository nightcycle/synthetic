--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
local SoundService = game:GetService("SoundService")

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Util = require(_Package:WaitForChild("Util"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type AppearanceData = Types.AppearanceData
type ImageData = Types.ImageData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type Style = Style.Style
type SwitchRenderData = {
	Text: AppearanceData,
	Button: AppearanceData,
	Background: AppearanceData,
	Outline: AppearanceData,
}

-- Constants
local CONTAINER_HEIGHT_DP = 56
local LEFT_RIGHT_NO_ICONS_PADDING_DP = 16
local LEFT_RIGHT_YES_ICONS_PADDING_DP = 12
local TEXT_AND_ICON_PADDING_DP = 16
local SUPPORTING_TEXT_PADDING_DP = 4
local CHARACTER_COUNT_PADDING = 16
local LEFT_RIGHT_LABEL_PADDING_DP = 12
local MIN_WIDTH_DP = CONTAINER_HEIGHT_DP * 3
local DEFAULT_OUTLINE_THICKNESS_DP = 1
local FOCUSED_OUTLINE_THICKNESS_DP = 2
local RADIUS_DP = 4
local ICON_WIDTH_DP = 24

-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

function Interface.new(
	onSubmit: (text: string?) -> string?,
	onInput: (text: string?) -> string?,
	initialText: CanBeState<string?>,
	isEnabled: CanBeState<boolean>,
	label: CanBeState<string>,
	isMultiLine: CanBeState<boolean>,
	characterLimit: CanBeState<number?>,
	supportingText: CanBeState<string?>,
	leadingIcon: CanBeState<ImageData?>,
	dropdownOptions: CanBeState<{[number]: string}?>,
	textColor: CanBeState<Color3>,
	backgroundColor: CanBeState<Color3>,
	borderColor: CanBeState<Color3>,
	elevation: CanBeState<number>,
	style: CanBeState<Style>,
	isOutlined: CanBeState<boolean>
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed
				
	local onSubmitState = _import(onSubmit, function(input: string?): string? return nil end)
	local onInputState = _import(onInput, function(input: string?): string? return nil end)

	local elevationState = _import(elevation, 0)
	local isEnabledState = _import(isEnabled, true)
	local initialTextState = _import(initialText, nil :: string?)
	local labelTextState = _import(label, nil :: string?)
	
	local isMultiLineState = _import(isMultiLine, false)
	local characterLimitState = _import(characterLimit, nil :: number?)

	local supportingTextState = _import(supportingText, nil :: string?)
	local leadingIconState = _import(leadingIcon, nil :: ImageData?)
	local dropdownOptionsState = _import(dropdownOptions, nil :: {[number]: string}?)

	local textColorState = _import(textColor, Color3.new())
	local borderColorState = _import(borderColor, Color3.new())
	local backgroundColorState = _import(backgroundColor, Color3.new())

	local isOutlinedState = _import(isOutlined, true)

	local styleState: State<Style> = _import(style, nil :: any)

	local isFocusedState = _Value(false)
	local isPressedState = _Value(false)
	local isHoveredState = _Value(false)

	local buttonStateTypeState = _Computed(
		function(isEnab: boolean, isFocused: boolean, isPressed: boolean, isHovered: boolean): Enums.ButtonStateType
			if isEnab then
				if isPressed then
					return Enums.ButtonStateType.Pressed
				else
					if isHovered then
						return Enums.ButtonStateType.Hovered
					else
						if isFocused then
							return Enums.ButtonStateType.Focused
						else
							return Enums.ButtonStateType.Enabled
						end
					end
				end
			else
				return Enums.ButtonStateType.Disabled
			end
		end,
		isEnabledState,
		isFocusedState,
		isPressedState,
		isHoveredState
	) :: State<any>

	local iconAddedWidthState = _Computed(function(lead: ImageData?, s: Style): number
		return if lead then (ICON_WIDTH_DP + TEXT_AND_ICON_PADDING_DP) * s.Scale else 0
	end, leadingIconState, styleState)

	local inst = _new("Frame")({
		Size = _Computed(function(s: Style): UDim2
			return UDim2.fromOffset(0, s.Scale * CONTAINER_HEIGHT_DP)
		end, styleState),
		BackgroundColor3 = backgroundColorState,
		AutomaticSize = Enum.AutomaticSize.XY,
		Children = {
			_new("UICorner")({
				CornerRadius = _Computed(function(s: Style): UDim
					return UDim.new(0, s.Scale * RADIUS_DP)
				end, styleState)
			}),
			_new("UISizeConstraint")({
				MaxSize = Vector2.new(math.huge, math.huge),
				MinSize = _Computed(function(s: Style, add: number): Vector2
					return Vector2.new((s.Scale * MIN_WIDTH_DP) + add, 0)
				end, styleState, iconAddedWidthState),
			}),
			_new("TextBox")({
				LayoutOrder = 2,
				RichText = true,
				TextColor3 = textColorState,
				TextTransparency = 0,
				BackgroundTransparency = 1,
				Text = "",
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = _Computed(function(s: Style): number
					return s:GetTextSize(Enums.FontType.BodyLarge)
				end, styleState),
				LineHeight = _Computed(function(s: Style): number
					return s:GetLineHeight(Enums.FontType.BodyLarge)
				end, styleState),
				FontFace = _Computed(function(s: Style): Font
					return s:GetFont(Enums.FontType.BodyLarge)
				end, styleState),
				Size = UDim2.fromOffset(0,0),
			}),
			_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
				LayoutOrder = 1,
				Children = {
					_bind(maid:GiveTask(Util.ImageLabel.ColdFusion.new(
						leadingIcon,
						textColorState,
						0
					)))({
						Visible = _Computed(function(i: ImageData?): boolean
							return i ~= nil
						end, leadingIconState),
						Size = _Computed(function(s: Style): UDim2
							return UDim2.fromOffset(s.Scale * ICON_WIDTH_DP, s.Scale * ICON_WIDTH_DP)
						end, styleState),
					}),
					maid:GiveTask(_new("UIAspectRatioConstraint")({
						AspectRatio = 1,
						AspectType = Enum.AspectType.FitWithinMaxSize,
						DominantAxis = Enum.DominantAxis.Height,
					})),
					maid:GiveTask(Util.List.ColdFusion.center()) :: Instance,
				}
			}),
			_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
				LayoutOrder = 3,
				Children = {
					_bind(maid:GiveTask(Util.ImageLabel.ColdFusion.new(
						leadingIcon,
						textColorState,
						0
					)))({
						Visible = _Computed(function(i: ImageData?): boolean
							return i ~= nil
						end, leadingIconState),
						Size = _Computed(function(s: Style): UDim2
							return UDim2.fromOffset(s.Scale * ICON_WIDTH_DP, s.Scale * ICON_WIDTH_DP)
						end, styleState),
					}),
					maid:GiveTask(_new("UIAspectRatioConstraint")({
						AspectRatio = 1,
						AspectType = Enum.AspectType.FitWithinMaxSize,
						DominantAxis = Enum.DominantAxis.Height,
					})),
					maid:GiveTask(Util.List.ColdFusion.center()) :: Instance,
				}
			}),
			maid:GiveTask(Util.List.ColdFusion.new(
				Enum.VerticalAlignment.Center,
				Enum.HorizontalAlignment.Center,
				Enum.FillDirection.Horizontal,
				_Computed(function(s: Style): UDim
					return UDim.new(0, s.Scale * TEXT_AND_ICON_PADDING_DP)
				end, styleState),
				Enum.UIFlexAlignment.None,
				Enum.UIFlexAlignment.Fill,
				Enum.ItemLineAlignment.Center,
				false
			)) :: Instance,
			maid:GiveTask(Util.Padding.ColdFusion.new(
				_Computed(function(s: Style, l: ImageData?): UDim
					return if l then UDim.new(0, s.Scale * LEFT_RIGHT_YES_ICONS_PADDING_DP) else UDim.new(0, s.Scale * LEFT_RIGHT_NO_ICONS_PADDING_DP)
				end, styleState, leadingIconState),
				UDim.new(0,0)
			)) :: Instance,
		},
	}) :: GuiObject

	maid.bind(inst)

	return inst
end

return Interface
