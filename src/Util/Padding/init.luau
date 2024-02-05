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

function Util.ColdFusion.new(leftRight: CanBeState<UDim>, topBottom: CanBeState<UDim>): UIPadding
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

	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Util.ColdFusion.fromStyle(
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

	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Util.ColdFusion.fromStyleSimple(dp: CanBeState<number>, style: CanBeState<Style>): UIPadding
	return Util.ColdFusion.fromStyle(dp, dp, style)
end

return Util
