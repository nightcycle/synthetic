--!strict

local RunService = game:GetService("RunService")

local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)

local Util = require(Package:WaitForChild("Util"))

local Types = require(Package:WaitForChild("Types"))

local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>
type CanBeState<T> = ColdFusion.CanBeState<T>

local Maid = require(Packages:WaitForChild("Maid"))
type Maid = Maid.Maid

export type ViewportMountFrameParameters = Types.ViewportFrameParameters & {
	WorldPosition: CanBeState<Vector2>?,
	WorldSize: CanBeState<Vector2>?,
}

export type ViewportMountFrame = Frame

function Constructor(config: ViewportMountFrameParameters): ViewportMountFrame
	-- init workspace
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	-- unload config states
	local WorldPosition = _import(config.WorldPosition, Vector2.new(0, 0))
	local WorldSize = _import(config.WorldSize, Vector2.new(0, 0))

	-- init internal states
	local Camera: ValueState<Camera?> = _Value(nil :: Camera?)
	local BillboardFrame: ValueState<ViewportFrame?> = _Value(nil :: ViewportFrame?)
	maid:GiveTask(BillboardFrame:Connect(function(cur: ViewportFrame?)
		Camera:Set(nil)
		if not cur then
			return
		end
		assert(cur ~= nil)
		maid._billboardCameraCheck = cur:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			Camera:Set(cur.CurrentCamera)
		end)
		Camera:Set(cur.CurrentCamera)
	end))

	-- using signals here causes a noticeable drag when moving board camera
	local CameraCFrame = _Value(CFrame.new(0, 0, 0))
	local FieldOfView = _Value(70)
	local BoardAbsoluteSize = _Value(Vector2.new(0, 0))
	local BoardCameraWindowSize = _Value(Vector2.new(0, 0))

	maid:GiveTask(RunService.Heartbeat:Connect(function(dt)
		local cam = Camera:Get()
		local boardFrame = BillboardFrame:Get()
		if not cam or not boardFrame then
			return
		end
		assert(cam ~= nil and boardFrame ~= nil)
		CameraCFrame:Set(cam.CFrame)
		FieldOfView:Set(cam.FieldOfView)
		BoardAbsoluteSize:Set(boardFrame.AbsoluteSize)
		BoardCameraWindowSize:Set(boardFrame:GetAttribute("CameraWindowSize"))
	end))

	-- assemble final parameters
	local parameters: any = {
		Name = _import(config.Name, script.Name),
		Parent = _import(config.Parent, nil),
		Size = _Computed(function(size: Vector2, winSize, boardSize)
			boardSize = boardSize or Vector2.new(0, 0)
			winSize = winSize or Vector2.new(0, 0)
			local ratio = boardSize / winSize
			local finalSize = size * ratio * 0.5
			return UDim2.fromOffset(finalSize.X, finalSize.Y)
		end, WorldSize, BoardCameraWindowSize, BoardAbsoluteSize),
		Position = _Computed(function(pos: Vector2, camCF, fov, viewportSize)
			camCF = camCF or CFrame.new(0, 0, 0)
			fov = fov or 10
			pos = pos or Vector2.new(0, 0)
			viewportSize = viewportSize or Vector2.new(0, 0)
			local pos3 = Vector3.new(pos.X, pos.Y, 0)

			--This is written by EgoMoose :D
			local camSpacePoint = camCF:PointToObjectSpace(pos3) -- make point relative to camera so easier to work with

			local r = viewportSize.X / viewportSize.Y -- aspect ratio
			local h = -camSpacePoint.Z * math.tan(math.rad(fov / 2)) -- calc height/2
			local w = r * h -- calc width/2

			local corner = Vector3.new(-w, h, camSpacePoint.Z) -- find the top left corner of the far plane
			local relative = camSpacePoint - corner -- get the 3d point relative to the corner

			local scaleX = relative.X / (w * 2) -- find the x percentage
			local scaleY = -relative.Y / (h * 2) -- find the y percentage

			-- returns in pixels as opposed to scale
			local finalPos = Vector2.new(scaleX * viewportSize.X, scaleY * viewportSize.Y)

			return UDim2.fromOffset(finalPos.X, finalPos.Y)
		end, WorldPosition, CameraCFrame, FieldOfView, BoardAbsoluteSize),
	}

	config.WorldPosition = nil
	config.WorldSize = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- construct output instance
	local Output = _fuse.new("Frame")(parameters)
	Util.cleanUpPrep(maid, Output)

	-- provide output inst to relevant states
	BillboardFrame:Set(Output:FindFirstAncestorOfClass("ViewportFrame"))
	maid:GiveTask(Output.AncestryChanged:Connect(function()
		BillboardFrame:Set(Output:FindFirstAncestorOfClass("ViewportFrame"))
	end))

	return Output :: Frame
end

return function(maid: Maid?)
	return function(params: ViewportMountFrameParameters): ViewportMountFrame
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
