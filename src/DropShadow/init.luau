--!strict
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
-- Types
-- Constants
local IMAGE_SIZE = 500
local HALF_IMAGE_SIZE = IMAGE_SIZE/2
-- Variables
-- References
-- Private Functions
-- Class
-- Types
type CanBeState<V> = ColdFusion.CanBeState<V>
type ValueState<V> = ColdFusion.ValueState<V>
type State<V> = ColdFusion.State<V>
type Maid = Maid.Maid


return function(cornerRadius: CanBeState<number>, transparency: CanBeState<number>): ImageLabel
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local cornerRadiusState = _import(cornerRadius, 1)

	local inst = _new("ImageLabel")({
		Image = "rbxassetid://15549395120",
		ImageColor3 = Color3.new(0,0,0),
		BackgroundTransparency = 1,
		ImageTransparency = transparency,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(HALF_IMAGE_SIZE, HALF_IMAGE_SIZE, HALF_IMAGE_SIZE, HALF_IMAGE_SIZE),
		SliceScale = _Computed(function(radius: number): number
			return math.clamp(radius/HALF_IMAGE_SIZE, 0, 1)
		end, cornerRadiusState),
	}) :: ImageLabel
	
	maid.bind(inst)

	return inst
end