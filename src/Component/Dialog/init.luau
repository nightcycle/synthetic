--!strict
local _Package = script.Parent.Parent
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
local Sounds = require(_Package:WaitForChild("Sounds"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type ImageData = Types.ImageData
type ButtonData = Types.ButtonData
type Style = Style.Style

-- Constants
local ICONS = MaterialIcons.default.dp_48.scale_1
local ELEVATION = 6
local LIST_PAD_DP = 16
local ICON_SIZE_DP = 24
local SHAPE_DP = 28
local PADDING_DP = 24
-- Variables
-- References
-- Private Functions
-- Class
local Interface = {}

Interface.ColdFusion = {}

function Interface.ColdFusion.new(
	
	buttons: CanBeState<{[number]: ButtonData}>,

	isFullScreen: CanBeState<boolean>,
	icon: CanBeState<ImageData?>,
	headline: CanBeState<string?>,
	description: CanBeState<string?>,

	surfaceColor: CanBeState<Color3>,
	buttonTextColor: CanBeState<Color3>,
	headlineColor: CanBeState<Color3>,
	descriptionColor: CanBeState<Color3>,
	dividerColor: CanBeState<Color3>,
	scrimColor: CanBeState<Color3>,

	style: CanBeState<Style>
)

	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local isFullScreenState = _import(isFullScreen, true)
	local iconState = _import(icon, nil :: ImageData?)
	local styleState: State<Style> = _import(style, nil :: any)

	local headlineState: State<string?> = _import(headline, nil :: string?)
	local descriptionState: State<string?> = _import(description, nil :: string?)

	local buttonsState: State<{[number]: ButtonData}> = _import(buttons, {})

	local surfaceColorState: State<Color3> = _import(surfaceColor, Color3.new())
	local buttonTextColorState: State<Color3> = _import(buttonTextColor, Color3.new())
	local headlineColorState: State<Color3> = _import(headlineColor, Color3.new())
	local descriptionColorState: State<Color3> = _import(descriptionColor, Color3.new())
	local dividerColorState: State<Color3> = _import(dividerColor, Color3.new())
	local scrimColorState: State<Color3> = _import(scrimColor, Color3.new())

	local inst = _new("Frame")({
		Size = UDim2.fromScale(0,0),
		BackgroundTransparency = _Computed(
			function(isFull: boolean)
				return if isFull then 0.5 else 1
			end, 
			isFullScreenState
		),
		BackgroundColor3 = scrimColorState,
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(1,1),
		AutomaticSize = Enum.AutomaticSize.XY,
		Children = {
			_new("UIListLayout")({
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			_new("Frame")({
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromScale(0,0),
				BackgroundColor3 = surfaceColorState,
				Children = {

					_new("UIListLayout")({
						Padding = _Computed(function(s: Style): UDim
							return UDim.new(0, s.Scale * LIST_PAD_DP)
						end, styleState),
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						ItemLineAlignment = Enum.ItemLineAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					}),
					_new("UICorner")({
						CornerRadius = _Computed(function(s: Style): UDim
							return UDim.new(0, s.Scale * SHAPE_DP)
						end, styleState),
					}),
					_new("ImageLabel")({
						Size = _Computed(function(s: Style): UDim2
							return UDim2.fromOffset(s.Scale * ICON_SIZE_DP, s.Scale * ICON_SIZE_DP)
						end, styleState),
						Visible = _Computed(function(i: ImageData?): boolean
							return i ~= nil
						end, iconState),
						BackgroundTransparency = 1,
						ImageColor3 = headlineColorState,
						Image = _Computed(function(i: ImageData?): string
							return if i then i.Image else ""
						end, iconState),
						ImageRectOffset = _Computed(function(i: ImageData?): Vector2
							return if i then i.ImageRectOffset else Vector2.zero
						end, iconState),
						ImageRectSize = _Computed(function(i: ImageData?): Vector2
							return if i then i.ImageRectSize else Vector2.zero
						end, iconState),
					}),
					_new("UIPadding")({
						PaddingTop = _Computed(function(s: Style): UDim
							return UDim.new(0, s.Scale * PADDING_DP)
						end, styleState),
						PaddingBottom = _Computed(function(s: Style): UDim
							return UDim.new(0, s.Scale * PADDING_DP)
						end, styleState),
						PaddingLeft = _Computed(function(s: Style): UDim
							return UDim.new(0, s.Scale * PADDING_DP)
						end, styleState),
						PaddingRight = _Computed(function(s: Style): UDim
							return UDim.new(0, s.Scale * PADDING_DP)
						end, styleState),
					}),
					_new("TextLabel")({
						Text = headlineState,
						LayoutOrder = 1,
						Visible = _Computed(function(h: string?): boolean
							return not (h == nil or h:len() == 0)
						end, headlineState),
						TextColor3 = headlineColorState,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextSize = _Computed(function(s: Style): number
							return s:GetTextSize(Enums.FontType.HeadlineSmall)
						end, styleState),
						LineHeight = _Computed(function(s: Style): number
							return s:GetLineHeight(Enums.FontType.HeadlineSmall)
						end, styleState),
						FontFace = _Computed(function(s: Style): Font
							return s:GetFont(Enums.FontType.HeadlineSmall)
						end, styleState),
						Size = UDim2.fromOffset(0,0),

					}),
					_new("TextLabel")({
						Text = descriptionState,
						LayoutOrder = 2,
						Visible = _Computed(function(d: string?): boolean
							return not (d == nil or d:len() == 0)
						end, descriptionState),
						TextColor3 = descriptionColorState,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextSize = _Computed(function(s: Style): number
							return s:GetTextSize(Enums.FontType.BodyMedium)
						end, styleState),
						LineHeight = _Computed(function(s: Style): number
							return s:GetLineHeight(Enums.FontType.BodyMedium)
						end, styleState),
						FontFace = _Computed(function(s: Style): Font
							return s:GetFont(Enums.FontType.BodyMedium)
						end, styleState),
						Size = UDim2.fromOffset(0,0),

					}),
				},
			}),
		},
	}) :: GuiObject

	maid.bind(inst)

	return inst
end

return Interface