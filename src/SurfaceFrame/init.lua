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

export type SurfaceFrameParameters = Types.FrameParameters & {
	Face: ParameterValue<Enum.NormalId>?,
	Adornee: ParameterValue<Instance>?,
	Parent: ParameterValue<Instance>?,
	PixelsPerStud: ParameterValue<number>?,
	LightInfluence: ParameterValue<number>?,
	Brightness: ParameterValue<number>?,
	AlwaysOnTop: ParameterValue<boolean>?,
}

export type SurfaceFrame = Frame

return function(config: SurfaceFrameParameters): SurfaceFrame
	local _Maid = Maid.new()
	local _Fuse = ColdFusion.fuse(_Maid)
	local _Computed = _Fuse.Computed
	local _Value = _Fuse.Value
	local _import = _Fuse.import
	local _new = _Fuse.new

	local Name = _import(config.Name, script.Name)
	local Face = _import(config.Face, Enum.NormalId.Left)
	local Ad: any = _import(config.Adornee, nil); local Adornee: State<Instance> = Ad
	local PixelsPerStud = _import(config.PixelsPerStud, 10)
	local LightInfluence = _import(config.LightInfluence, 1)
	local Brightness = _import(config.Brightness, 0)
	local AlwaysOnTop = _import(config.AlwaysOnTop, false)

	local SurfaceGui = _new "SurfaceGui" {
		Name = Name,
		Adornee = Adornee,
		Face = Face,
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		PixelsPerStud = PixelsPerStud,
		AlwaysOnTop = AlwaysOnTop,
		Brightness = Brightness,
		ClipsDescendants = true,
		LightInfluence = LightInfluence,
	}
	_Maid:GiveTask(SurfaceGui)

	local parameters: any = {
		Name = Name,
		Parent = SurfaceGui,
		Attributes = {
			ClassName = script.Name,
		}
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
