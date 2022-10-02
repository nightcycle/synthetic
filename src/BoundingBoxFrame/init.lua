--!strict

local RunService = game:GetService("RunService")

local package = script.Parent
local packages = package.Parent

local Util = require(package.Util)

local ColdFusion = require(packages.coldfusion)
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>
type CanBeState<T> = ColdFusion.CanBeState<T>

local Maid = require(packages.maid)
type Maid = Maid.Maid

local math = require(packages:WaitForChild("math"))

local MountFrame = require(package.ViewportMountFrame)

export type BoundingBoxFrameParameters = MountFrame.ViewportMountFrameParameters & {
	Target: CanBeState<Instance?>?,
}

export type BoundingBoxFrame = Frame

function Constructor(config: BoundingBoxFrameParameters): BoundingBoxFrame
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
	local Parent = _import(config.Parent, nil)

	-- init internal states
	local Target: State<Instance?> = _Value(nil :: Instance?)
	local TargetCFrame: ValueState<CFrame?> = _Value(nil :: CFrame?)
	local TargetSize: ValueState<Vector2?> = _Value(nil :: Vector2?)
	local BoardFrame: ValueState<ViewportFrame?>  = _Value(nil :: ViewportFrame?); 
	local Camera: ValueState<Camera?> = _Value(nil :: Camera?)
	_Maid:GiveTask(BoardFrame:Connect(function(cur: ViewportFrame?)
		Camera:Set(nil)
		if not cur then return end
		assert(cur ~= nil)
		_Maid._billboardCameraCheck = cur:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			Camera:Set(cur.CurrentCamera)
		end)
		Camera:Set(cur.CurrentCamera)
	end))

	-- update states each frame
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

	-- assemble final parameters
	local parameters: any = {
		AnchorPoint = Vector2.new(0.5,0.5),
		WorldPosition = _Computed(function(cf: CFrame?)
			if not cf then return Vector2.new(0,0) end
			assert(cf ~= nil)
			return Vector2.new(cf.Position.X, cf.Position.Y)
		end, TargetCFrame),
		WorldSize = _Computed(function(size: Vector2?): Vector2
			if not size then return Vector2.new(0,0) end
			assert(size ~= nil)
			return size
		end, TargetSize),
		Parent = Parent
	}

	config.Target = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- construct output instance
	local Output = MountFrame(_Maid)(parameters)
	Util.cleanUpPrep(_Maid, Output)
	
	BoardFrame:Set(Output:FindFirstAncestorOfClass("ViewportFrame"))
	_Maid:GiveTask(Output.AncestryChanged:Connect(function()
		BoardFrame:Set(Output:FindFirstAncestorOfClass("ViewportFrame"))
	end))

	return Output
end

return function(maid: Maid?)
	return function(params: BoundingBoxFrameParameters): BoundingBoxFrame
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end