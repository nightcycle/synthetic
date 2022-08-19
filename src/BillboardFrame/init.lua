--!strict
local package = script.Parent
local packages = package.Parent

local Util = require(package.Util)

local Types = require(package.Types)
type ParameterValue<T> = Types.ParameterValue<T>

local ColdFusion = require(packages.coldfusion)
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>

local Maid = require(packages.maid)
type Maid = Maid.Maid

export type BillboardFrameParameters = Types.FrameParameters & {
	Name: ParameterValue<string>?,
	Parent: ParameterValue<Instance>?,
	Position: ParameterValue<Vector3>?,
	Size: ParameterValue<Vector2>?,
	LightInfluence: ParameterValue<number>?,
	AlwaysOnTop: ParameterValue<boolean>?,
	MaxDistance: ParameterValue<number>?,
	AnchorPoint: ParameterValue<Vector2>?,
}

export type BillboardFrame = Frame

return function(config: BillboardFrameParameters): BillboardFrame
	local _Maid = Maid.new()
	local _Fuse = ColdFusion.fuse(_Maid)
	local _Computed = _Fuse.Computed
	local _Value = _Fuse.Value
	local _import = _Fuse.import
	local _new = _Fuse.new

	local P: any = _import(config.Parent, nil); local Parent: State<Instance> = P
	
	local v3Def: any = Vector3.new(0,0,0)
	local v2Def: any = Vector2.new(0,0)
	local PO: any = _import(config.Position, v3Def); local Position: State<Vector3> = PO
	local S: any = _import(config.Size, v2Def); local Size: State<Vector2> = S
	local LightInfluence = _import(config.LightInfluence, 0)
	local AlwaysOnTop = _import(config.AlwaysOnTop, false)
	local MaxDistance = _import(config.MaxDistance, 100)
	local AnchorPoint = _import(config.AnchorPoint, Vector2.new(0.5,0.5))

	local partParent: any = workspace

	local Part: any = _new "Part"{
		Parent = partParent,
		Position = Position,
		Transparency = 1,
		Size = Vector3.new(1,1,1)*0.05,
		Anchored = true,
		CanCollide = false,
		CanTouch = false,
		CanQuery = false,
	}

	local SurfaceGui = _new "BillboardGui" {
		-- Name = Name,
		Parent = Parent,
		Adornee = Part,
		AlwaysOnTop = AlwaysOnTop,
		Size = _Computed(function(size: Vector2)
			return UDim2.fromScale(size.X, size.Y)
		end, Size),
		ClipsDescendants = false,
		LightInfluence = LightInfluence,
		MaxDistance = MaxDistance,
	}

	local parameters: any = {
		-- Name = Name,
		Parent = SurfaceGui,
		Position = UDim2.fromScale(0.5,0.5),
		Size = UDim2.fromScale(1,1),
		AnchorPoint = AnchorPoint,
	}

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	local Output = _new "Frame" (parameters)

	Util.cleanUpPrep(_Maid, Output)

	return Output
end
