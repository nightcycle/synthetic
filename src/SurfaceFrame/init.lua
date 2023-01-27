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
	local _Maid = Maid.new()
	local _Fuse = ColdFusion.fuse(_Maid)
	local _new = _Fuse.new
	local _mount = _Fuse.mount
	local _import = _Fuse.import
	local _OUT = _Fuse.OUT
	local _REF = _Fuse.REF
	local _CHILDREN = _Fuse.CHILDREN
	local _ON_EVENT = _Fuse.ON_EVENT
	local _ON_PROPERTY = _Fuse.ON_PROPERTY
	local _Value = _Fuse.Value
	local _Computed = _Fuse.Computed

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
	_Maid:GiveTask(SurfaceGui)

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
	Util.cleanUpPrep(_Maid, Output)

	return Output
end

return function(maid: Maid?)
	return function(params: SurfaceFrameParameters): SurfaceFrame
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
