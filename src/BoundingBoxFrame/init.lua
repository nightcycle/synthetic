--!strict

local RunService = game:GetService("RunService")

local package = script.Parent
local packages = package.Parent

local Isotope = require(packages:WaitForChild("isotope"))
type Isotope = Isotope.Isotope
type Fuse = Isotope.Fuse
type State = Isotope.State
type ValueState = Isotope.ValueState

local math = require(packages:WaitForChild("math"))

local MountFrame = require(package:WaitForChild("ViewportMountFrame"))

local BoundingBoxFrame = {}
BoundingBoxFrame.__index = BoundingBoxFrame
setmetatable(BoundingBoxFrame, Isotope)

export type BoundingBoxFrameParameters = {
	Target: Instance | State?,
	[any]: any?,
}



function BoundingBoxFrame.new(config: BoundingBoxFrameParameters): GuiObject
	local self = Isotope.new() :: any
	setmetatable(self, BoundingBoxFrame)

	self.Target = self:Import(config.Target, nil)

	self.TargetCFrame = self._Fuse.Value(nil)
	self.TargetSize = self._Fuse.Value(nil)
	self.BoardFrame = self._Fuse.Value(nil)
	self.Camera = self._Fuse.Property(self.BoardFrame, "CurrentCamera")

	local parameters = {
		Name = "BoundingBoxFrame",
		AnchorPoint = Vector2.new(0.5,0.5),
		WorldPosition = self._Fuse.Computed(self.TargetCFrame, function(cf)
			if not cf then return Vector2.new(0,0) end
			return Vector2.new(cf.p.X, cf.p.Y)
		end),
		WorldSize = self._Fuse.Computed(self.TargetSize, function(size)
			if not size then return Vector2.new(0,0) end
			return size
		end),
		Parent = self:Import(config.Parent, nil)
	}

	for k, v in pairs(config) do
		if parameters[k] == nil and self[k] == nil then
			parameters[k] = v
		end
	end
	self._Maid:GiveTask(RunService.Heartbeat:Connect(function(dt)
		local target = self.Target:Get()
		local cam = self.Camera:Get()
		if not target or not cam then return end
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

		self.TargetCFrame:Set(cf)
		-- print("BoundSize", size)
		self.TargetSize:Set(Vector2.new(size.X, size.Y)*2)
	end))


	self.Instance = MountFrame.new(parameters)
	self._Maid:GiveTask(self.Instance)
	self._Maid:GiveTask(self.Instance.Destroying:Connect(function() self:Destroy() end))

	self.BoardFrame:Set(self.Instance:FindFirstAncestorOfClass("ViewportFrame"))
	self._Maid:GiveTask(self.Instance.AncestryChanged:Connect(function()
		self.BoardFrame:Set(self.Instance:FindFirstAncestorOfClass("ViewportFrame"))
	end))

	self:Construct()
	return self.Instance
end

return BoundingBoxFrame