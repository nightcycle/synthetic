--!strict
local package = script.Parent
local packages = package.Parent

local Util = require(package.Util)

local Types = require(package.Types)

local ColdFusion = require(packages.coldfusion)
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>
type CanBeState<T> = ColdFusion.CanBeState<T>

local Maid = require(packages.maid)
type Maid = Maid.Maid

export type BillboardFrameParameters = Types.FrameParameters & {
	Parent: CanBeState<Instance>?,
	Position: CanBeState<Vector3>?,
	Size: CanBeState<Vector2>?,
	LightInfluence: CanBeState<number>?,
	Active: CanBeState<boolean>?,
	AlwaysOnTop: CanBeState<boolean>?,
	MaxDistance: CanBeState<number>?,
	AnchorPoint: CanBeState<Vector2>?,
}

export type BillboardFrame = Frame

function Constructor(config: BillboardFrameParameters): BillboardFrame
	-- init workspace
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _new = _fuse.new
	local _mount = _fuse.mount
	local _import = _fuse.import
	local _OUT = _fuse.OUT
	local _REF = _fuse.REF
	local _CHILDREN = _fuse.CHILDREN
	local _ON_EVENT = _fuse.ON_EVENT
	local _ON_PROPERTY = _fuse.ON_PROPERTY
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	-- unload config states
	local Parent: State<Instance?> = _import(config.Parent, nil :: Instance?) :: any
	local Position = _import(config.Position :: any, Vector3.new(0, 0, 0)) :: State<Vector3>
	local Size: State<Vector2> = _import(config.Size :: any, Vector2.new(0, 0)) :: any
	local LightInfluence = _import(config.LightInfluence, 0)
	local AlwaysOnTop = _import(config.AlwaysOnTop, false)
	local MaxDistance = _import(config.MaxDistance, 100)
	local Active = _import(config.Active, true)
	local AnchorPoint = _import(config.AnchorPoint, Vector2.new(0.5, 0.5))

	-- constructing instances
	local Part: any = _new("Part")({
		Parent = workspace,
		Position = Position,
		Transparency = 1,
		Size = Vector3.new(1, 1, 1) * 0.05,
		Anchored = true,
		CanCollide = false,
		CanTouch = false,
		CanQuery = false,
	})

	local SurfaceGui = _new("BillboardGui")({
		Parent = Parent,
		Adornee = Part,
		Active = Active,
		AlwaysOnTop = AlwaysOnTop,
		Size = _Computed(function(size: Vector2)
			return UDim2.fromScale(size.X, size.Y)
		end, Size),
		ClipsDescendants = false,
		LightInfluence = LightInfluence,
		MaxDistance = MaxDistance,
	})

	-- assemble final parameters
	local parameters: any = {
		Parent = SurfaceGui,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = AnchorPoint,
	}

	config.Size = nil
	config.LightInfluence = nil
	config.AlwaysOnTop = nil
	config.MaxDistance = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- construct output instance
	local Output: Frame = _new("Frame")(parameters) :: any
	Util.cleanUpPrep(maid, Output)

	return Output
end

return function(maid: Maid?)
	return function(params: BillboardFrameParameters): BillboardFrame
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
