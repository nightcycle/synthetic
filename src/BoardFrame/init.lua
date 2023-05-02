--!strict
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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

export type BoardFrameParameters = Types.ViewportFrameParameters & {
	-- Color: CanBeState<Color3>?,
	PixelsPerStud: CanBeState<number>?,
	CanvasPosition: CanBeState<Vector2>?,
	CanvasTransparency: CanBeState<number>?,
	CanvasColor: CanBeState<Color3>?,
	CanvasMaterial: CanBeState<string>?,
	CanvasMaterialVariant: CanBeState<string>?,
	LockPosition: CanBeState<boolean>?,
	LockZoom: CanBeState<boolean>?,
	Zoom: CanBeState<number>?,
	MinZoom: CanBeState<number>?,
	MaxZoom: CanBeState<number>?,
	ZoomSpeed: CanBeState<number>?,
	CameraHeight: CanBeState<number>?,
}

export type BoardFrame = ViewportFrame

function Constructor(config: BoardFrameParameters): BoardFrame
	-- init workspace
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	-- unload config states
	local Size = _import(config.Size, UDim2.fromScale(1, 1))
	local Position = _import(config.Position, UDim2.fromScale(0.5, 0.5))
	local AnchorPoint = _import(config.AnchorPoint, Vector2.new(0.5, 0.5))
	local PixelsPerStud = _import(config.PixelsPerStud, 20)
	local CanvasPosition = _Value(
		if typeof(config.CanvasPosition) == "Vector2"
			then config.CanvasPosition
			elseif typeof(config.CanvasPosition) == "table" then config.CanvasPosition:Get()
			else Vector2.new(0, 0)
	)
	local CanvasTransparency = _import(config.CanvasTransparency, 0)
	local CanvasColor = _import(config.CanvasColor, Color3.new(1, 1, 1))
	local CanvasMaterial = _import(config.CanvasMaterial, "SmoothPlastic")
	local CanvasMaterialVariant = _import(config.CanvasMaterialVariant, "")
	local LockPosition = _import(config.LockPosition, false)
	local LockZoom = _import(config.LockZoom, false)
	local MinZoom = _import(config.MinZoom, 1)
	local MaxZoom = _import(config.MaxZoom, 10)
	local ZoomSpeed = _import(config.ZoomSpeed, 4)
	local CameraHeight = _import(config.CameraHeight, 100)

	-- init internal states
	local Zoom = _Value(
		if typeof(config.Zoom) == "number"
			then config.Zoom
			elseif typeof(config.Zoom) == "table" then config.Zoom:Get()
			else 1
	)
	local Delta = _Value(1 / 60)
	local AbsoluteSize = _Value(Vector2.new(0, 0))
	local CanvasSize = _Computed(function(absSize: Vector2, pxRatio: number)
		return absSize / pxRatio
	end, AbsoluteSize, PixelsPerStud) --_import(config.CanvasSize, Vector2.new(60,40))
	local SizeRatio = _Computed(function(absSize: Vector2)
		return absSize.X / absSize.Y
	end, AbsoluteSize)
	local CameraFieldOfView = _Computed(function(zoom: number, canvasSize: Vector2, z: number)
		local y = canvasSize.Y
		local goalY = y / zoom
		local angle = math.atan2(goalY * 0.5, z) * 2
		return math.deg(angle)
	end, Zoom, CanvasSize, CameraHeight)
	local CameraWindowSize = _Computed(function(height: number, fov: number, ratio: number)
		local y = 2 * math.tan(math.rad(fov * 0.5)) * height
		local x = y * ratio
		return Vector2.new(math.abs(x), math.abs(y))
	end, CameraHeight, CameraFieldOfView, SizeRatio)
	local AbsoluteCanvasPosition = _Computed(function(pos: Vector2, winSize: Vector2, canSize: Vector2)
		local min = pos - winSize / 2
		local max = pos + winSize / 2

		local x = pos.X
		local y = pos.Y

		local canMin = -canSize / 2
		local canMax = canSize / 2

		if min.X < canMin.X and max.X > canMax.X then
			x = 0
		else
			if min.X < canMin.X then
				x += canMin.X - min.X
			end
			if max.X > canMax.X then
				x -= max.X - canMax.X
			end
		end

		if min.Y < canMin.Y and max.Y > canMax.Y then
			y = 0
		else
			if min.Y < canMin.Y then
				y += canMin.Y - min.Y
			end
			if max.Y > canMax.Y then
				y -= max.Y - canMax.Y
			end
		end
		return Vector2.new(x, y)
	end, CanvasPosition, CameraWindowSize, CanvasSize)
	local CameraCFrame = _Computed(function(canvasPos: Vector2, height: number, fov: number)
		local pos = Vector3.new(canvasPos.X, canvasPos.Y, height)
		return CFrame.new(pos, Vector3.new(canvasPos.X, canvasPos.Y, 0))
	end, AbsoluteCanvasPosition, CameraHeight, CameraFieldOfView)

	-- constructing instances
	local Camera = _fuse.new("Camera")({
		CFrame = CameraCFrame,
		FieldOfView = CameraFieldOfView,
	})
	local WorldModel: any = _fuse.new("WorldModel")({
		Name = "Canvas",
	})

	-- assemble final parameters
	local parameters: any = {
		Parent = _import(config.Parent, nil),
		Name = _import(config.Name, script.Name),
		ClipsDescendants = true,
		Size = Size,
		Position = Position,
		AnchorPoint = AnchorPoint,
		Transparency = 1,
		CurrentCamera = Camera,
		Children = {
			WorldModel,
			Camera,
		},
	}

	config.PixelsPerStud = nil
	config.CanvasPosition = nil
	config.CanvasTransparency = nil
	config.CanvasColor = nil
	config.CanvasMaterial = nil
	config.CanvasMaterialVariant = nil
	config.LockPosition = nil
	config.LockZoom = nil
	config.Zoom = nil
	config.MinZoom = nil
	config.MaxZoom = nil
	config.ZoomSpeed = nil
	config.CameraHeight = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- construct output instance
	local Output: ViewportFrame = _fuse.new("ViewportFrame")(parameters) :: any
	Util.cleanUpPrep(maid, Output)

	local _Canvas = _fuse.new("Part")({
		Name = "CanvasPart",
		Shape = Enum.PartType.Block,
		Parent = WorldModel,
		Material = _Computed(function(matName: string): Enum.Material
			local enum: any = Enum.Material
			return enum[matName]
		end, CanvasMaterial),
		MaterialVariant = CanvasMaterialVariant,
		Transparency = CanvasTransparency,
		Color = CanvasColor,
		["CFrame"] = CFrame.new(Vector3.new(0, 0, -1), Vector3.new(0, 0, 1)),
		Size = _Computed(function(size: Vector2)
			return Vector3.new(size.X, size.Y, 0.01)
		end, CanvasSize),
	})
	local PreviousMousePosition = _Value(Vector2.new(0, 0))
	local MousePosition = _Value(Vector2.new(0, 0))
	local MouseDelta = _Computed(function(mPos: Vector2, pMPos: Vector2)
		return pMPos - mPos
	end, MousePosition, PreviousMousePosition)

	local IsHovering = _Computed(function(mPos: Vector2)
		local sGui = Output:FindFirstAncestorWhichIsA("BasePlayerGui")
		if not sGui then
			return false
		end
		assert(sGui ~= nil)
		local guis = sGui:GetGuiObjectsAtPosition(mPos.X, mPos.Y)
		for i, gui in ipairs(guis) do
			if gui == Output then
				return true
			end
		end
		return false
	end, MousePosition)

	maid:GiveTask(UserInputService.PointerAction:Connect(function(wheel: number, pan: Vector2, pinch: number)
		if not LockZoom:Get() and IsHovering:Get() then
			local currentZoom = Zoom:Get()
			local zoomSpeed = ZoomSpeed:Get()
			local delta = Delta:Get()
			local alpha = (wheel + pinch)

			zoomSpeed *= alpha

			local goal = currentZoom * (1 + zoomSpeed)
			-- print("Goal", goal, "Alpha", alpha, "Speed", zoomSpeed)
			local newZoom = currentZoom + delta * (goal - currentZoom)
			Zoom:Set(math.clamp(newZoom, MinZoom:Get(), MaxZoom:Get()))
		end
	end))

	maid:GiveTask(RunService.RenderStepped:Connect(function(delta)
		Delta:Set(delta)
		AbsoluteSize:Set(Output.AbsoluteSize)
		PreviousMousePosition:Set(MousePosition:Get())
		MousePosition:Set(UserInputService:GetMouseLocation())
		if
			IsHovering:Get()
			and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
			and not LockPosition:Get()
		then
			local mouseDelta = MouseDelta:Get() --UserInputService:GetMouseDelta()
			-- print("Dragging", mouseDelta)
			local cameraWindowSize = CameraWindowSize:Get()
			local vportSize = AbsoluteSize:Get()
			local mouseOffset = mouseDelta * Vector2.new(1, -1)
			local worldOffset = cameraWindowSize * mouseOffset / vportSize
			-- local delta = Delta:Get()
			-- print("World", worldOffset, "Mouse", mouseScaleOffset, "Pos", mousePos)
			CanvasPosition:Set(AbsoluteCanvasPosition:Get() + worldOffset)
		end
	end))

	return Output
end

return function(maid: Maid?)
	return function(params: BoardFrameParameters): BoardFrame
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
