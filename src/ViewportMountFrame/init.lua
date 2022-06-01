
local RunService = game:GetService("RunService")

local packages = script.Parent.Parent
local Isotope = require(packages:WaitForChild("isotope"))
local math = require(packages:WaitForChild("math"))

local ViewportMountFrame = {}
ViewportMountFrame.__index = ViewportMountFrame
setmetatable(ViewportMountFrame, Isotope)

function ViewportMountFrame.new(config)
	local self = Isotope.new()
	setmetatable(self, ViewportMountFrame)

	self.WorldPosition = self:Import(config.WorldPosition, Vector2.new(0,0))
	self.WorldSize = self:Import(config.WorldSize, Vector2.new(0,0))

	self.BillboardFrame = self._Fuse.Value(nil)
	self.Camera = self._Fuse.Property(self.BillboardFrame, "CurrentCamera")

	-- using signals here causes a noticeable drag when moving board camera
	self.CameraCFrame = self._Fuse.Value(nil)
	self.FieldOfView = self._Fuse.Value(nil)
	self.BoardAbsoluteSize = self._Fuse.Value(nil)
	self.BoardCameraWindowSize = self._Fuse.Value(nil)
	self._Maid:GiveTask(RunService.Heartbeat:Connect(function(dt)
		local cam = self.Camera:Get()
		local boardFrame = self.BillboardFrame:Get()
		if not cam or not boardFrame then return end
		self.CameraCFrame:Set(cam.CFrame)
		self.FieldOfView:Set(cam.FieldOfView)
		self.BoardAbsoluteSize:Set(boardFrame.AbsoluteSize)
		self.BoardCameraWindowSize:Set(boardFrame:GetAttribute("CameraWindowSize"))
	end))

	local parameters = {
		Name = self:Import(config.Name, script.Name),
		Parent = self:Import(config.Parent, nil),
		Size = self._Fuse.Computed(self.WorldSize, self.BoardCameraWindowSize, self.BoardAbsoluteSize, function(size, winSize, boardSize)
			boardSize = boardSize or Vector2.new(0,0)
			winSize = winSize or Vector2.new(0,0)
			local ratio = boardSize / winSize
			local finalSize = size * ratio * 0.5
			return UDim2.fromOffset(finalSize.X,finalSize.Y)
		end),
		Position = self._Fuse.Computed(self.WorldPosition, self.CameraCFrame, self.FieldOfView, self.BoardAbsoluteSize, function(pos, camCF, fov, viewportSize)
			camCF = camCF or CFrame.new(0,0,0)
			fov = fov or 10
			pos = pos or Vector2.new(0,0)
			viewportSize = viewportSize or Vector2.new(0,0)
			pos = Vector3.new(pos.X, pos.Y, 0)
			--This is written by EgoMoose :D
			local camSpacePoint = camCF:PointToObjectSpace(pos); -- make point relative to camera so easier to work with

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
		end),
	}

	for k, v in pairs(config) do
		if parameters[k] == nil and self[k] == nil then
			parameters[k] = v
		end
	end

	self.Instance = self._Fuse.new("Frame")(parameters)
	self._Maid:GiveTask(self.Instance.Destroying:Connect(function() self:Destroy() end))

	self.BillboardFrame:Set(self.Instance:FindFirstAncestorOfClass("ViewportFrame"))
	self._Maid:GiveTask(self.Instance.AncestryChanged:Connect(function()
		self.BillboardFrame:Set(self.Instance:FindFirstAncestorOfClass("ViewportFrame"))
	end))

	self:Construct()
	return self.Instance
end

return ViewportMountFrame
