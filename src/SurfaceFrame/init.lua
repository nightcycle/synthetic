--!strict
local package = script.Parent
local packages = package.Parent
local Isotope = require(packages.isotope)
type Isotope = Isotope.Isotope
type Fuse = Isotope.Fuse
type State = Isotope.State
type ValueState = Isotope.ValueState

local SurfaceFrame = {}
SurfaceFrame.__index = SurfaceFrame
setmetatable(SurfaceFrame, Isotope)

export type SurfaceFrameParameters = {
	Name: string | State?,
	Face: string | State?,
	Adornee: Instance | State?,
	Parent: Instance | State?,
	PixelsPerStud: number | State?,
	[any]: any?,
}

function SurfaceFrame.new(config: SurfaceFrameParameters): GuiObject
	local self = Isotope.new() :: any
	setmetatable(self, SurfaceFrame)

	self.Name = self:Import(config.Name, script.Name)
	self.Face = self:Import(config.Face, "Left")
	self.Adornee = self:Import(config.Adornee, nil)
	self.Parent = self:Import(config.Parent, nil)
	self.PixelsPerStud = self:Import(config.PixelsPerStud, 10)
	self.SurfaceGui = self._Fuse.new "SurfaceGui" {
		Name = self.Name,
		Parent = self.Parent,
		Adornee = self.Adornee,
		Face = self.Face,
		SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud,
		PixelsPerStud = self.PixelsPerStud,
		ClipsDescendants = true,
		LightInfluence = 1,
	}

	local parameters = {
		Name = self.Name,
		Parent = self.SurfaceGui,
	}

	for k, v in pairs(config) do
		if parameters[k] == nil and self[k] == nil then
			parameters[k] = v
		end
	end

	self.Instance = self._Fuse.new "Frame" (parameters)

	self._Maid:GiveTask(self.SurfaceGui)
	self._Maid:GiveTask(self.SurfaceGui.Destroying:Connect(function() self:Destroy() end))
	self._Maid:GiveTask(self.Instance)
	self._Maid:GiveTask(self.Instance.Destroying:Connect(function() self:Destroy() end))

	self:Construct()

	return self.Instance
end

return SurfaceFrame