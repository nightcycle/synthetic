--!strict
local _Package = script.Parent.Parent
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

Util.ColdFusion = {}

function Util.ColdFusion.new(
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

	maid:GiveTask(out.Destroying:Connect(function() maid:Destroy() end))

	return out
end

function Util.ColdFusion.classic(
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

	maid:GiveTask(out.Destroying:Connect(function() maid:Destroy() end))

	return out
end

function Util.ColdFusion.center(): UIListLayout
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local out = _new("UIListLayout")({
		Padding = UDim.new(0, 0),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
		HorizontalFlex = Enum.UIFlexAlignment.None,
		VerticalFlex = Enum.UIFlexAlignment.None,
		Wraps = false,
	}) :: UIListLayout

	maid:GiveTask(out.Destroying:Connect(function() maid:Destroy() end))

	return out
end

return Util
