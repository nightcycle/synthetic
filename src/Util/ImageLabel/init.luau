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
	icon: CanBeState<ImageData?>,
	color: CanBeState<Color3?>,
	transparency: CanBeState<number?>
): ImageLabel
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local iconState = _import(icon, nil :: ImageData?)
	local out = _new("ImageLabel")({
		Image = _Computed(function(i: ImageData?): string
			return if i then i.Image else ""
		end, iconState),
		ImageRectOffset = _Computed(function(i: ImageData?): Vector2
			return if i then i.ImageRectOffset else Vector2.zero
		end, iconState),
		ImageRectSize = _Computed(function(i: ImageData?): Vector2
			return if i then i.ImageRectSize else Vector2.zero
		end, iconState),
		BackgroundTransparency = 1,
		ImageColor3 = color,
		ImageTransparency = transparency,
	}) :: ImageLabel

	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

return Util
