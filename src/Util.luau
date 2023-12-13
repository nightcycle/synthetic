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

-- Types
type RenderData = Types.RenderData
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type Style = Style.Style
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

return Util