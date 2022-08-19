--!strict

local RunService = game:GetService("RunService")

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

local math = require(packages:WaitForChild("math"))

local MountFrame = require(package.ViewportMountFrame)

export type BoundingBoxFrameParameters = MountFrame.ViewportMountFrameParameters & {
	Target: ParameterValue<Instance?>?,
}

export type BoundingBoxFrame = Frame

return function(config: BoundingBoxFrameParameters): BoundingBoxFrame
	local _Maid = Maid.new()
	local _Fuse = ColdFusion.fuse(_Maid)
	local _Computed = _Fuse.Computed
	local _Value = _Fuse.Value
	local _import = _Fuse.import
	local _new = _Fuse.new

	local T: any = _import(config.Target, nil); local Target: State<Instance?> = T
	local TCF: any = _Value(nil); local TargetCFrame: ValueState<CFrame?> = TCF
	local TS: any  = _Value(nil); local TargetSize: ValueState<Vector2?> = TS
	local BFR: any  = _Value(nil); local BoardFrame: ValueState<ViewportFrame?>  = BFR
	local C: any  = _Fuse.Property(BoardFrame, "CurrentCamera"); local Camera: ValueState<Camera?> = C

	local parameters: any = {
		AnchorPoint = Vector2.new(0.5,0.5),
		Attributes = {
			ClassName = script.Name,
		},
		WorldPosition = _Computed(function(cf)
			if not cf then return Vector2.new(0,0) end
			return Vector2.new(cf.p.X, cf.p.Y)
		end, TargetCFrame),
		WorldSize = _Computed(function(size)
			if not size then return Vector2.new(0,0) end
			return size
		end, TargetSize),
		Parent = _import(config.Parent, nil)
	}

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end
	_Maid:GiveTask(RunService.Heartbeat:Connect(function(dt)
		local target = Target:Get()
		local cam = Camera:Get()
		if not target or not cam then return end
		assert(target ~= nil and cam ~= nil)
		local camCF = cam.CFrame

		local parts = {}
		if target:IsA("Model") or target:IsA("Folder") then
			for i, part in ipairs(target:GetDescendants()) do
				if part:IsA("BasePart") then
					table.insert(parts, part)
				end
			end
		elseif target:IsA("BasePart") then
			table.insert(parts, target)
		end

		local size, cf = math.Mesh.getBoundingBoxAtCFrame(camCF, parts)

		TargetCFrame:Set(cf)
		TargetSize:Set(Vector2.new(size.X, size.Y)*2)
	end))


	local Output = MountFrame(parameters)

	Util.cleanUpPrep(_Maid, Output)

	BoardFrame:Set(Output:FindFirstAncestorOfClass("ViewportFrame"))
	_Maid:GiveTask(Output.AncestryChanged:Connect(function()
		BoardFrame:Set(Output:FindFirstAncestorOfClass("ViewportFrame"))
	end))

	return Output
end
