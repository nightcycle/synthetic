--!strict


local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local package = script.Parent
local packages = package.Parent
local Isotope = require(packages:WaitForChild("isotope"))
type Isotope = Isotope.Isotope
type Fuse = Isotope.Fuse
type State = Isotope.State
type ValueState = Isotope.ValueState

local math = require(packages:WaitForChild("math"))

local BoardFrame = {}
BoardFrame.__index = BoardFrame
setmetatable(BoardFrame, Isotope)

export type BoardFrameParameters = {
	Parent: Instance | State?,
	Name: string | State?,
	Color: Color3 | State?,
	Size: UDim2 | State?,
	Position: UDim2 | State?,
	AnchorPoint: Vector2 | State?,
	PixelsPerStud: number | State?,
	CanvasPosition: Vector2 | State?,
	CanvasTransparency: number | State?,
	CanvasColor: Color3 | State?,
	CanvasMaterial: string | State?,
	CanvasMaterialVariant: string | State?,
	LockPosition: boolean | State?,
	LockZoom: boolean | State?,
	Zoom: number | State?,
	MinZoom: number | State?,
	MaxZoom: number | State?,
	ZoomSpeed: number | State?,
	CameraHeight: number | State?,
	[any]: any?,
}


function BoardFrame.new(config: BoardFrameParameters): GuiObject
	local self = Isotope.new() :: any
	setmetatable(self, BoardFrame)

	self.Color = self:Import(config.Color, Color3.new(0.3,0,0))
	self.Size = self:Import(config.Size, UDim2.fromScale(1,1))
	self.Position = self:Import(config.Position, UDim2.fromScale(0.5,0.5))
	self.AnchorPoint = self:Import(config.AnchorPoint, Vector2.new(0.5,0.5))

	self.PixelsPerStud = self:Import(config.PixelsPerStud, 20)
	self.CanvasPosition = self:Import(config.CanvasPosition, Vector2.new(0,0))
	self.CanvasTransparency = self:Import(config.CanvasTransparency, 0)
	self.CanvasColor = self:Import(config.CanvasColor, Color3.new(1,1,1))
	self.CanvasMaterial = self:Import(config.CanvasMaterial, "SmoothPlastic")
	self.CanvasMaterialVariant = self:Import(config.CanvasMaterialVariant, "")

	self.LockPosition = self:Import(config.LockPosition, false)
	self.LockZoom = self:Import(config.LockZoom, false)

	self.Zoom = self:Import(config.Zoom, 1)
	self.MinZoom = self:Import(config.MinZoom, 1)
	self.MaxZoom = self:Import(config.MaxZoom, 10)
	self.ZoomSpeed = self:Import(config.ZoomSpeed, 4)

	self.Delta = self._Fuse.Value(1/60)
	self.AbsoluteSize = self._Fuse.Value(Vector2.new(0,0))
	self.CanvasSize = self._Fuse.Computed(self.AbsoluteSize, self.PixelsPerStud, function(absSize: Vector2, pxRatio: number)
		return absSize / pxRatio
	end) --self:Import(config.CanvasSize, Vector2.new(60,40))

	self.SizeRatio = self._Fuse.Computed(self.AbsoluteSize, function(absSize: Vector2)
		return absSize.X / absSize.Y
	end)

	self.CameraHeight = self:Import(config.CameraHeight, 100)
	self.CameraFieldOfView = self._Fuse.Computed(self.Zoom, self.CanvasSize, self.CameraHeight, function(zoom: number, canvasSize: Vector2, z: number)
		local y = canvasSize.Y
		local goalY = y / zoom
		local angle = math.atan2(goalY*0.5, z)*2
		return math.deg(angle)
	end)
	self.CameraWindowSize = self._Fuse.Computed(self.CameraHeight, self.CameraFieldOfView, self.SizeRatio, function(height: number, fov: number, ratio: number)
		local y = 2*math.tan(math.rad(fov*0.5))*height
		local x = y * ratio
		return Vector2.new(math.abs(x),math.abs(y))
	end)
	self.AbsoluteCanvasPosition = self._Fuse.Computed(self.CanvasPosition, self.CameraWindowSize, self.CanvasSize, function(pos: Vector2, winSize: Vector2, canSize: Vector2)
		local min = pos - winSize/2
		local max = pos + winSize/2

		local x = pos.X
		local y = pos.Y

		local canMin = -canSize/2
		local canMax = canSize/2

		if min.X < canMin.X and max.X > canMax.X then
			x = 0
		else
			if min.X < canMin.X then x += canMin.X - min.X end
			if max.X > canMax.X then x -= max.X - canMax.X end
		end

		if min.Y < canMin.Y and max.Y > canMax.Y then
			y = 0
		else
			if min.Y < canMin.Y then y += canMin.Y - min.Y end
			if max.Y > canMax.Y then y -= max.Y - canMax.Y end
		end
		return Vector2.new(x,y)
	end)
	self.CameraCFrame = self._Fuse.Computed(self.AbsoluteCanvasPosition, self.CameraHeight, self.CameraFieldOfView, function(canvasPos: Vector2, height: number, fov: number)
		local pos = Vector3.new(canvasPos.X, canvasPos.Y, height)
		return CFrame.new(pos, Vector3.new(canvasPos.X, canvasPos.Y, 0))
	end)
	self.Camera = self._Fuse.new "Camera" {
		CFrame = self.CameraCFrame,
		FieldOfView = self.CameraFieldOfView,--:Tween(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
	}
	self.WorldModel = self._Fuse.new "WorldModel" {
		Name = "Canvas",
	}
	local parameters = {
		Parent = self:Import(config.Parent, nil),
		Name = self:Import(config.Name, "BoardFrame"),
		ClipsDescendants = true,
		Size = self.Size,
		Position = self.Position,
		AnchorPoint = self.AnchorPoint,
		Transparency = 1,
		CurrentCamera = self.Camera,
		[self._Fuse.Children] = {
			self.WorldModel,
			self.Camera,
		}
	}

	for k, v in pairs(config) do
		if parameters[k] == nil and self[k] == nil then
			parameters[k] = v
		end
	end

	-- print("Parameters", parameters, self)
	self.Instance = self._Fuse.new("ViewportFrame")(parameters)
	self._Maid:GiveTask(self.Instance.Destroying:Connect(function() self:Destroy() end))

	self.Canvas = self._Fuse.new "Part" {
		Name = "CanvasPart",
		Shape = Enum.PartType.Block,
		Parent = self.WorldModel,
		Material = self._Fuse.Computed(self.CanvasMaterial, function(matName: string)
			local enum: any = Enum.Material
			return enum[matName]
		end),
		MaterialVariant = self.CanvasMaterialVariant,
		Transparency = self.CanvasTransparency,
		Color = self.CanvasColor,
		CFrame = CFrame.new(Vector3.new(0,0,-1), Vector3.new(0,0,1)),
		Size = self._Fuse.Computed(self.CanvasSize, function(size)
			return Vector3.new(size.X, size.Y, 0.01)
		end),
	}
	self.PreviousMousePosition = self._Fuse.Value(Vector2.new(0,0))
	self.MousePosition = self._Fuse.Value(Vector2.new(0,0))
	self.MouseDelta = self._Fuse.Computed(self.MousePosition, self.PreviousMousePosition, function(mPos:Vector2, pMPos:Vector2)
		return pMPos - mPos
	end)
	self.IsHovering = self._Fuse.Computed(self.MousePosition, function(mPos)
		local sGui = self.Instance:FindFirstAncestorWhichIsA("BasePlayerGui")
		if not sGui then return false end
		local guis = sGui:GetGuiObjectsAtPosition(mPos.X, mPos.Y)
		for i, gui in ipairs(guis) do
			if gui == self.Instance then
				return true
			end
		end
		return false
	end)
	self._Maid:GiveTask(UserInputService.PointerAction:Connect(function(wheel: number, pan: number, pinch: number)
		if not self.LockZoom:Get() and self.IsHovering:Get() then
			local currentZoom = self.Zoom:Get()
			local zoomSpeed = self.ZoomSpeed:Get()
			local delta = self.Delta:Get()
			local alpha = (wheel + pinch)
		
			zoomSpeed *= alpha
		
			local goal = currentZoom * (1 + zoomSpeed)
			-- print("Goal", goal, "Alpha", alpha, "Speed", zoomSpeed)
			local newZoom = currentZoom + delta * (goal - currentZoom)
			self.Zoom:Set(
				math.clamp(
					newZoom,
					self.MinZoom:Get(),
					self.MaxZoom:Get()
				)
			)
		end
	end))
	self._Maid:GiveTask(RunService.RenderStepped:Connect(function(delta)
		self.Delta:Set(delta)
		self.AbsoluteSize:Set(self.Instance.AbsoluteSize)
		self.PreviousMousePosition:Set(self.MousePosition:Get())
		self.MousePosition:Set(UserInputService:GetMouseLocation())
		if self.IsHovering:Get() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not self.LockPosition:Get() then

			local mouseDelta = self.MouseDelta:Get()--UserInputService:GetMouseDelta()
			-- print("Dragging", mouseDelta)
			local cameraWindowSize = self.CameraWindowSize:Get()
			local vportSize = self.AbsoluteSize:Get()
			local mouseOffset = mouseDelta * Vector2.new(1,-1)
			local worldOffset = cameraWindowSize * mouseOffset / vportSize
			-- local delta = self.Delta:Get()
			-- print("World", worldOffset, "Mouse", mouseScaleOffset, "Pos", mousePos)
			self.CanvasPosition:Set(self.AbsoluteCanvasPosition:Get() + worldOffset)
		end
	end))
	self:Construct()
	-- print("Returning canvas")

	return self.Instance
end

return BoardFrame