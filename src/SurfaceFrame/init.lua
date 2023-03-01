--!strict
local package = script.Parent
local packages = package.Parent

local Util = require(package.Util)

local Types = require(package.Types)

local ColdFusion = require(packages.ColdFusion)
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>
type CanBeState<T> = ColdFusion.CanBeState<T>

local Maid = require(packages.Maid)
type Maid = Maid.Maid

export type SurfaceFrameParameters = Types.FrameParameters & {
	Face: CanBeState<Enum.NormalId>?,
	Adornee: CanBeState<Instance?>?,
	Parent: CanBeState<Instance?>?,
	PixelsPerStud: CanBeState<number>?,
	LightInfluence: CanBeState<number>?,
	Brightness: CanBeState<number>?,
	AlwaysOnTop: CanBeState<boolean>?,
}

export type SurfaceFrame = Frame

function Constructor(config: SurfaceFrameParameters): SurfaceFrame
	-- init workspace
	local Maid = Maid.new()
	local _fuse = ColdFusion.fuse(Maid)
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
	local Name = _import(config.Name, script.Name)
	local Face = _import(config.Face, Enum.NormalId.Left)
	local Ad: any = _import(config.Adornee, nil)
	local Adornee: State<Instance> = Ad
	local PixelsPerStud = _import(config.PixelsPerStud, 10)
	local LightInfluence = _import(config.LightInfluence, 1)
	local Brightness = _import(config.Brightness, 0)
	local Par: any = _import(config.Parent, nil)
	local Parent: State<Instance?> = Par
	local AlwaysOnTop = _import(config.AlwaysOnTop, false)

	-- construct sub-instances
	local SurfaceGui = _new("SurfaceGui")({
		Name = Name,
		Adornee = Adornee,
		Face = Face,
		Parent = Parent,
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		PixelsPerStud = PixelsPerStud,
		AlwaysOnTop = AlwaysOnTop,
		Brightness = Brightness,
		ClipsDescendants = true,
		LightInfluence = LightInfluence,
	})
	Maid:GiveTask(SurfaceGui)

	-- assemble final parameters
	local parameters: any = {
		Name = Name,
		Parent = SurfaceGui,
	}

	config.Face = nil
	config.Adornee = nil
	config.PixelsPerStud = nil
	config.LightInfluence = nil
	config.Brightness = nil
	config.AlwaysOnTop = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- construct output instance
	local Output: Frame = _new("Frame")(parameters) :: any
	Util.cleanUpPrep(Maid, Output)

	return Output
end

return function(Maid: Maid?)
	return function(params: SurfaceFrameParameters): SurfaceFrame
		local inst = Constructor(params)
		if Maid then
			Maid:GiveTask(inst)
		end
		return inst
	end
end
