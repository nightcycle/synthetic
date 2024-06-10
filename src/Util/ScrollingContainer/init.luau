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

-- Types
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type Style = Style.Style
type ImageData = Types.ImageData
-- Constants
local MID_IMAGE = "http://www.roblox.com/asset/?id=16331943650"
local TOP_IMAGE = "http://www.roblox.com/asset/?id=16331984401"
local BOTTOM_IMAGE = "http://www.roblox.com/asset/?id=16331988989"

-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

Util.ColdFusion = {}

function Util.ColdFusion.new(barThickness: CanBeState<number?>, barColor: CanBeState<Color3?>): ScrollingFrame
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local barThicknessState = _import(barThickness, 10)
	local barColorState = _import(barColor, Color3.new(1, 1, 1))

	local out = _new("ScrollingFrame")({
		Name = "ScrollingContainer",
		AutomaticSize = Enum.AutomaticSize.None,
		AutomaticCanvasSize = Enum.AutomaticSize.None,
		Size = UDim2.fromScale(0, 0),
		CanvasSize = UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		BottomImage = BOTTOM_IMAGE,
		TopImage = TOP_IMAGE,
		MidImage = MID_IMAGE,
		ScrollBarThickness = barThicknessState,
		ScrollBarImageColor3 = barColorState,
		VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
		HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
		Children = {},
	}) :: ScrollingFrame

	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

return Util
