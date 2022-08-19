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

local EffectGui = {}
EffectGui.__index = EffectGui
setmetatable(EffectGui, Isotope)

function EffectGui:Destroy()
	Isotope.Destroy(self)
end

export type EffectGuiParameters = Types.ScreenGuiParameters & {}

export type EffectGui = ScreenGui

function EffectGui.new(config: EffectGuiParameters): EffectGui
	local self = setmetatable(Isotope.new() :: any, EffectGui)

	self.Name = self:Import(config.Name, script.Name)
	self.ClassName = _Computed(function() return script.Name end)
	self.Parent = self:Import(config.Parent, nil)
	self.Enabled = self:Import(config.Enabled, true)
	self.ZIndexBehavior = self:Import(config.ZIndexBehavior, Enum.ZIndexBehavior.Sibling)

	self.ParentAnchorPoint = _Fuse.Property(self.Parent, "AnchorPoint"):Else(Vector2.new(0,0))
	self.AbsolutePosition = _Fuse.Property(self.Parent, "AbsolutePosition", 60):Else(Vector2.new(0,0))
	self.AbsoluteSize = _Fuse.Property(self.Parent, "AbsoluteSize", 60):Else(Vector2.new(0,0))
	self.Position = _Computed(self.AbsolutePosition, function(absPos)
		absPos = absPos or Vector2.new(0,0)
		return UDim2.fromOffset(absPos.X, absPos.Y)
	end):Else(UDim2.fromOffset(0,0))
	self.AnchorPosition = _Computed(self.AbsolutePosition, self.AbsoluteSize, self.ParentAnchorPoint, function(absPos, absSize, anchorPoint)
		absPos = absPos or Vector2.new(0,0)
		absSize = absSize or Vector2.new(0,0)
		anchorPoint = anchorPoint or Vector2.new(0,0)
		return UDim2.fromOffset(absPos.X+anchorPoint.X*absSize.X, absPos.Y+anchorPoint.Y*absSize.Y)
	end):Else(UDim2.fromOffset(0,0))
	self.CenterPosition = _Computed(self.AbsolutePosition, self.AbsoluteSize, function(absPos, absSize, anchorPoint)
		absPos = absPos or Vector2.new(0,0)
		absSize = absSize or Vector2.new(0,0)
		return UDim2.fromOffset(absPos.X+0.5*absSize.X, absPos.Y+0.5*absSize.Y)
	end):Else(Vector2.new(0,0))
	self.Size = _Computed(self.AbsoluteSize, function(absSize)
		absSize = absSize or Vector2.new(0,0)
		return UDim2.fromOffset(absSize.X, absSize.Y)
	end):Else(UDim2.fromOffset(0,0))
	
	self._KnownAncestorGui = _Value(nil)
	self._AncestorGui = _Computed(self._KnownAncestorGui, function(known: ScreenGui | nil)
		if not self.Instance then return end
		local expected = self.Instance:FindFirstAncestorWhichIsA("ScreenGui")
		if known == expected then
			return expected
		elseif known ~= nil then
			return known
		else
			return expected
		end
	end)
	self.AncestorDisplayOrder = _Fuse.Property(self._AncestorGui, "DisplayOrder")

	self.DisplayOrder = _Computed(self._AncestorGui, self.AncestorDisplayOrder, function(gui: ScreenGui?, displayOrder: number)
		if not gui then return 1000 end
		assert(gui ~= nil and gui:IsA("ScreenGui"))
		return (displayOrder or gui.DisplayOrder) + 1
	end)

	local parameters = {
		Name = self.Name,
		DisplayOrder = self.DisplayOrder,
		Enabled = self.Enabled,
		ZIndexBehavior = self.ZIndexBehavior,
		Parent = self.Parent,
		Children = {
			_Fuse.new "Frame" {
				BackgroundTransparency = 1,
				Size = _Computed(self.AbsoluteSize, function(absSize)
					if not absSize then return UDim2.fromOffset(0,0) end
					return UDim2.fromOffset(absSize.X, absSize.Y)
				end),
				Position = _Computed(self.AbsolutePosition, function(absPos)
					if not absPos then return UDim2.fromOffset(0,0) end
					return UDim2.fromOffset(absPos.X, absPos.Y)
				end),
			}
		}

	}

	for k, v in pairs(config) do
		if parameters[k] == nil and self[k] == nil then
			parameters[k] = v
		end
	end

	self.Instance = _Fuse.new("ScreenGui")(parameters)
	self._Maid:GiveTask(self.Instance.Destroying:Connect(function()
		self:Destroy()
	end))
	if self.Instance:FindFirstAncestorWhichIsA("ScreenGui") then
		self._KnownAncestorGui:Set(self.Instance:FindFirstAncestorWhichIsA("ScreenGui"))
	end
	self._Maid:GiveTask(self.Instance.AncestryChanged:Connect(function(ancestor)
		self._KnownAncestorGui:Set(self.Instance:FindFirstAncestorWhichIsA("ScreenGui"))
	end))

	self:Construct()
	return self.Instance
end

return EffectGui