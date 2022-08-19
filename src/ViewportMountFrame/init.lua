
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

export type ViewportMountFrameParameters = Types.ViewportFrameParameters & {
	WorldPosition: ParameterValue<Vector2>?,
	WorldSize: ParameterValue<Vector2>?,
}

export type ViewportMountFrame = ViewportFrame

return function(config: ViewportMountFrameParameters): Frame
	local _Maid = Maid.new()
	local _Fuse = ColdFusion.fuse(_Maid)
	local _Computed = _Fuse.Computed
	local _Value = _Fuse.Value
	local _import = _Fuse.import
	local _new = _Fuse.new

	local WorldPosition = _import(config.WorldPosition, Vector2.new(0,0))
	local WorldSize = _import(config.WorldSize, Vector2.new(0,0))

	local B: any = _Value(nil); local BillboardFrame: ValueState<ViewportFrame?> = B
	local C: any = _Fuse.Property(BillboardFrame, "CurrentCamera"); local Camera: ValueState<Camera?> = C

	-- using signals here causes a noticeable drag when moving board camera
	local CameraCFrame = _Value(CFrame.new(0,0,0))
	local FieldOfView = _Value(70)
	local BoardAbsoluteSize = _Value(Vector2.new(0,0))
	local BoardCameraWindowSize = _Value(Vector2.new(0,0))

	_Maid:GiveTask(RunService.Heartbeat:Connect(function(dt)
		local cam = Camera:Get()
		local boardFrame = BillboardFrame:Get()
		if not cam or not boardFrame then return end
		assert(cam ~= nil and boardFrame ~= nil)
		CameraCFrame:Set(cam.CFrame)
		FieldOfView:Set(cam.FieldOfView)
		BoardAbsoluteSize:Set(boardFrame.AbsoluteSize)
		BoardCameraWindowSize:Set(boardFrame:GetAttribute("CameraWindowSize"))
	end))

	local parameters: any = {
		Name = _import(config.Name, script.Name),
		Parent = _import(config.Parent, nil),
		Size = _Computed(function(size: Vector2, winSize, boardSize)
			boardSize = boardSize or Vector2.new(0,0)
			winSize = winSize or Vector2.new(0,0)
			local ratio = boardSize / winSize
			local finalSize = size * ratio * 0.5
			return UDim2.fromOffset(finalSize.X,finalSize.Y)
		end, WorldSize, BoardCameraWindowSize, BoardAbsoluteSize),
		Position = _Computed(function(pos: Vector2, camCF, fov, viewportSize)
			camCF = camCF or CFrame.new(0,0,0)
			fov = fov or 10
			pos = pos or Vector2.new(0,0)
			viewportSize = viewportSize or Vector2.new(0,0)
			local pos3 = Vector3.new(pos.X, pos.Y, 0)

			--This is written by EgoMoose :D
			local camSpacePoint = camCF:PointToObjectSpace(pos3); -- make point relative to camera so easier to work with

			local r = viewportSize.X/viewportSize.Y; -- aspect ratio
			local h = -camSpacePoint.Z*math.tan(math.rad(fov/2)); -- calc height/2
			local w = r*h; -- calc width/2
		
			local corner = Vector3.new(-w, h, camSpacePoint.Z); -- find the top left corner of the far plane
			local relative = camSpacePoint - corner; -- get the 3d point relative to the corner
		
			local scaleX = relative.X / (w*2); -- find the x percentage 
			local scaleY = -relative.Y / (h*2); -- find the y percentage 
		
			-- returns in pixels as opposed to scale
			local finalPos = Vector2.new(scaleX*viewportSize.X, scaleY*viewportSize.Y);

			return UDim2.fromOffset(finalPos.X, finalPos.Y)
		end, WorldPosition, CameraCFrame, FieldOfView, BoardAbsoluteSize),
		Attributes = {
			ClassName = script.Name,
		},
	}

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	local Output = _Fuse.new("Frame")(parameters)

	Util.cleanUpPrep(_Maid, Output)

	BillboardFrame:Set(Output:FindFirstAncestorOfClass("ViewportFrame"))
	_Maid:GiveTask(Output.AncestryChanged:Connect(function()
		BillboardFrame:Set(Output:FindFirstAncestorOfClass("ViewportFrame"))
	end))


	return Output
end
