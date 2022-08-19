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

local BillboardFrame = {}
BillboardFrame.__index = BillboardFrame
setmetatable(BillboardFrame, Isotope)

export type BillboardFrameParameters = Types.FrameParameters & {
	Name: ParameterValue<string>?,
	Parent: ParameterValue<Instance>?,
	Position: ParameterValue<Vector3>?,
	Size: ParameterValue<Vector2>?,
	LightInfluence: ParameterValue<number>?,
	AlwaysOnTop: ParameterValue<boolean>?,
	MaxDistance: ParameterValue<number>?,
	AnchorPoint: ParameterValue<Vector2>?,
}

export type BillboardFrame = Frame

function BillboardFrame.new(config: BillboardFrameParameters): BillboardFrame
	local self = Isotope.new() :: any
	setmetatable(self, BillboardFrame)

	self.Name = self:Import(config.Name, script.Name)
	self.Parent = self:Import(config.Parent, nil)
	
	self.Position = self:Import(config.Position, nil)
	self.Size = self:Import(config.Size, Vector2.new(2,2))
	self.LightInfluence = self:Import(config.LightInfluence, 0)
	self.AlwaysOnTop = self:Import(config.AlwaysOnTop, false)
	self.MaxDistance = self:Import(config.MaxDistance, 100)
	self.AnchorPoint = self:Import(config.AnchorPoint, Vector2.new(0.5,0.5))

	self.Part = _Fuse.new "Part" {
		Name = self.Name,
		Parent = workspace,
		Position = self.Position,
		Transparency = 1,
		Size = Vector3.new(1,1,1)*0.05,
		Anchored = true,
		CanCollide = false,
		CanTouch = false,
		CanQuery = false,
	}

	self.SurfaceGui = _Fuse.new "BillboardGui" {
		Name = self.Name,
		Parent = self.Parent,
		Adornee = self.Part,
		AlwaysOnTop = self.AlwaysOnTop,
		Size = _Computed(self.Size, function(size: Vector2)
			return UDim2.fromScale(size.X, size.Y)
		end),
		-- SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		ClipsDescendants = false,
		LightInfluence = self.LightInfluence,
		MaxDistance = self.MaxDistance,
	}

	local parameters = {
		Name = self.Name,
		Parent = self.SurfaceGui,
		Position = UDim2.fromScale(0.5,0.5),
		Size = UDim2.fromScale(1,1),
		AnchorPoint = self.AnchorPoint,
	}

	for k, v in pairs(config) do
		if parameters[k] == nil and self[k] == nil then
			parameters[k] = v
		end
	end

	self.Instance = _Fuse.new "Frame" (parameters)

	-- self._Maid:GiveTask(self.Instance)
	self._Maid:GiveTask(self.Instance.Destroying:Connect(function() self:Destroy() end))

	self:Construct()

	return self.Instance
end

return BillboardFrame