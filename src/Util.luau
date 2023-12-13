--!strict
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Maid = require(_Packages:WaitForChild("Maid"))
-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))

-- Types
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type Style = Style.Style
type ImageData = Types.ImageData
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}
Util.Container = {}
Util.Container.ColdFusion = {}

function Util.Container.ColdFusion.new(): Frame

	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local out = _new("Frame")({
		Name = "Container",
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(0,0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}) :: Frame

	maid.bind(out)

	return out
end

Util.List = {}
Util.List.ColdFusion = {}

function Util.List.ColdFusion.new(
	verticalAlignment: CanBeState<Enum.VerticalAlignment>,
	horizontalAlignment: CanBeState<Enum.HorizontalAlignment>,
	fillDirection: CanBeState<Enum.FillDirection>,
	listPadding: CanBeState<UDim>,
	verticalFlex: CanBeState<Enum.UIFlexAlignment>,
	horizontalFlex: CanBeState<Enum.UIFlexAlignment>,
	itemLineAlignment: CanBeState<Enum.ItemLineAlignment>,
	wraps: CanBeState<boolean>
): UIListLayout

	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local out = _new("UIListLayout")({
		Padding = listPadding,
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = fillDirection,
		VerticalAlignment = verticalAlignment,
		HorizontalAlignment = horizontalAlignment,
		ItemLineAlignment = itemLineAlignment,
		HorizontalFlex = horizontalFlex,
		VerticalFlex = verticalFlex,
		Wraps = wraps,
	}) :: UIListLayout

	maid.bind(out)

	return out

end

function Util.List.ColdFusion.classic(
	verticalAlignment: CanBeState<Enum.VerticalAlignment>,
	horizontalAlignment: CanBeState<Enum.HorizontalAlignment>,
	fillDirection: CanBeState<Enum.FillDirection>,
	listPadding: CanBeState<UDim>
): UIListLayout

	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local out = _new("UIListLayout")({
		Padding = listPadding,
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = fillDirection,
		VerticalAlignment = verticalAlignment,
		HorizontalAlignment = horizontalAlignment,
		ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
		HorizontalFlex = Enum.UIFlexAlignment.None,
		VerticalFlex = Enum.UIFlexAlignment.None,
		Wraps = false,
	}) :: UIListLayout

	maid.bind(out)

	return out

end


function Util.List.ColdFusion.center(): UIListLayout

	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local out = _new("UIListLayout")({
		Padding = UDim.new(0,0),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
		HorizontalFlex = Enum.UIFlexAlignment.None,
		VerticalFlex = Enum.UIFlexAlignment.None,
		Wraps = false,
	}) :: UIListLayout

	maid.bind(out)

	return out

end

Util.Padding = {}
Util.Padding.ColdFusion = {}

function Util.Padding.ColdFusion.new(
	leftRight: CanBeState<UDim>,
	topBottom: CanBeState<UDim>
): UIPadding

	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local out = _new("UIPadding")({
		PaddingTop = topBottom,
		PaddingBottom = topBottom,
		PaddingLeft = leftRight,
		PaddingRight = leftRight,
	}) :: UIPadding

	maid.bind(out)

	return out
end

function Util.Padding.ColdFusion.fromStyle(
	leftRightDp: CanBeState<number>,
	topBottomDp: CanBeState<number>,
	style: CanBeState<Style>
): UIPadding

	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local leftRightDpState = _import(leftRightDp, 0)
	local topBottomDpState = _import(topBottomDp, 0)
	local styleState: State<Style> = _import(style, nil :: any)

	local leftRight = _Computed(function(s: Style, dp: number): UDim
		return UDim.new(0, s.Scale * dp)
	end, styleState, leftRightDpState)

	local topBottom = _Computed(function(s: Style, dp: number): UDim
		return UDim.new(0, s.Scale * dp)
	end, styleState, topBottomDpState)

	local out = _new("UIPadding")({
		PaddingTop = topBottom,
		PaddingBottom = topBottom,
		PaddingLeft = leftRight,
		PaddingRight = leftRight,
	}) :: UIPadding

	maid.bind(out)

	return out
end

function Util.Padding.ColdFusion.fromStyleSimple(
	dp: CanBeState<number>,
	style: CanBeState<Style>
): UIPadding
	return Util.Padding.ColdFusion.fromStyle(
		dp,
		dp,
		style
	)
end

Util.TextLabel = {}
Util.TextLabel.ColdFusion = {}
function Util.TextLabel.ColdFusion.new(
	text: CanBeState<string>,
	textColor3: CanBeState<Color3>,
	textTransparency: CanBeState<number>,
	fontType: CanBeState<Enums.FontType>,
	leftIcon: CanBeState<ImageData?>,
	rightIcon: CanBeState<ImageData?>,
	paddingDp: CanBeState<number>,
	style: CanBeState<Style>
): Frame
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed
	local leftIconState = _import(leftIcon, nil :: ImageData?)
	local rightIconState = _import(rightIcon, nil :: ImageData?)

	local textState = _import(text, "")
	local textColor3State = _import(textColor3, Color3.new(1,1,1))
	local textTransparencyState = _import(textTransparency, 0)

	local styleState: State<Style> = _import(style, nil :: any)
	
	local fontTypeState: State<Enums.FontType> = _import(fontType, Enums.FontType.LabelMedium)
	local paddingState: State<number> = _import(paddingDp, 0)

	local iconSizeState = _Computed(function(s: Style, ft: Enums.FontType): UDim2
		local dp = s:GetLineHeight(ft) * s:GetTextSize(ft)
		return UDim2.fromOffset(dp, dp)
	end, styleState, fontTypeState)

	local out = _bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
		Name = "TextLabel",
		Children = {
			_new("UIListLayout")({
				Padding = _Computed(function(s: Style, dp: number): UDim
					return UDim.new(0, s.Scale * dp)
				end, styleState, paddingState),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			_new("TextLabel")({
				Text = textState,
				RichText = true,
				LayoutOrder = 1,
				Visible = _Computed(function(h: string): boolean
					return h:len() > 0
				end, textState),
				TextColor3 = textColor3State,
				TextTransparency = textTransparencyState,
				BackgroundTransparency = 1,
				TextXAlignment = _Computed(function(i: ImageData?): Enum.TextXAlignment
					return if i then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left
				end, leftIconState),
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
			_new("ImageLabel")({
				Name = "LeftIcon",
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Visible = _Computed(function(icon: ImageData?): boolean
					return icon ~= nil
				end, leftIconState),
				Image = _Computed(function(icon: ImageData?): string
					return if icon then icon.Image else ""
				end, leftIconState),
				ImageColor3 = _Computed(
					function(icon: ImageData?, c: Color3): Color3
						return if icon then c else Color3.new(1, 1, 1)
					end,
					leftIconState,
					textColor3State
				),
				ImageRectOffset = _Computed(function(icon: ImageData?): Vector2
					return if icon then icon.ImageRectOffset else Vector2.zero
				end, leftIconState),
				ImageRectSize = _Computed(function(icon: ImageData?): Vector2
					return if icon then icon.ImageRectSize else Vector2.zero
				end, leftIconState),
				ImageTransparency = textTransparencyState,
				Size = iconSizeState,
			}),
			_new("ImageLabel")({
				Name = "RightIcon",
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Visible = _Computed(function(icon: ImageData?): boolean
					return icon ~= nil
				end, rightIconState),
				Image = _Computed(function(icon: ImageData?): string
					return if icon then icon.Image else ""
				end, rightIconState),
				ImageColor3 = _Computed(
					function(icon: ImageData?, c: Color3): Color3
						return if icon then c else Color3.new(1, 1, 1)
					end,
					rightIconState,
					textColor3State
				),
				ImageRectOffset = _Computed(function(icon: ImageData?): Vector2
					return if icon then icon.ImageRectOffset else Vector2.zero
				end, rightIconState),
				ImageRectSize = _Computed(function(icon: ImageData?): Vector2
					return if icon then icon.ImageRectSize else Vector2.zero
				end, rightIconState),
				ImageTransparency = textTransparencyState,
				Size = iconSizeState,
			})
		}
	}) :: Frame

	return out
end

return Util