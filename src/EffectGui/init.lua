--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local package = script.Parent
local packages = package.Parent

local Isotope = require(packages:WaitForChild("isotope"))
local Signal = require(packages:WaitForChild("signal"))

local EffectGui = {}
EffectGui.__index = EffectGui
setmetatable(EffectGui, Isotope)

function EffectGui:Destroy()
	Isotope.Destroy(self)
end

function EffectGui.new(config)
	local self = setmetatable(Isotope.new(config), EffectGui)

	self.Name = self:Import(config.Name, script.Name)
	self.ClassName = self._Fuse.Computed(function() return script.Name end)
	self.Parent = self:Import(config.Parent, nil)
	self.Enabled = self:Import(config.Enabled, true)
	self.AnchorPoint = self._Fuse.Property(self.Parent, "AnchorPoint"):Else(Vector2.new(0,0))
	self.AbsolutePosition = self._Fuse.Property(self.Parent, "AbsolutePosition", 60):Else(Vector2.new(0,0))
	self.AbsoluteSize = self._Fuse.Property(self.Parent, "AbsoluteSize", 60):Else(Vector2.new(0,0))
	self.Position = self._Fuse.Computed(self.AbsolutePosition, function(absPos)
		absPos = absPos or Vector2.new(0,0)
		return UDim2.fromOffset(absPos.X, absPos.Y)
	end):Else(UDim2.fromOffset(0,0))
	self.AnchorPosition = self._Fuse.Computed(self.AbsolutePosition, self.AbsoluteSize, self.AnchorPoint, function(absPos, absSize, anchorPoint)
		absPos = absPos or Vector2.new(0,0)
		absSize = absSize or Vector2.new(0,0)
		anchorPoint = anchorPoint or Vector2.new(0,0)
		return UDim2.fromOffset(absPos.X+anchorPoint.X*absSize.X, absPos.Y+anchorPoint.Y*absSize.Y)
	end):Else(UDim2.fromOffset(0,0))
	self.CenterPosition = self._Fuse.Computed(self.AbsolutePosition, self.AbsoluteSize, function(absPos, absSize, anchorPoint)
		absPos = absPos or Vector2.new(0,0)
		absSize = absSize or Vector2.new(0,0)
		return UDim2.fromOffset(absPos.X+0.5*absSize.X, absPos.Y+0.5*absSize.Y)
	end):Else(Vector2.new(0,0))
	self.Size = self._Fuse.Computed(self.AbsoluteSize, function(absSize)
		absSize = absSize or Vector2.new(0,0)
		return UDim2.fromOffset(absSize.X, absSize.Y)
	end):Else(UDim2.fromOffset(0,0))
	
	self._KnownAncestorGui = self._Fuse.Value(nil)
	self._AncestorGui = self._Fuse.Computed(self._KnownAncestorGui, function(known: ScreenGui | nil)
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
	self.AncestorDisplayOrder = self._Fuse.Property(self._AncestorGui, "DisplayOrder")

	self.DisplayOrder = self._Fuse.Computed(self._AncestorGui, self.AncestorDisplayOrder, function(gui, displayOrder)
		if not gui then return 1000 end
		return (displayOrder or gui.DisplayOrder) + 1
	end)

	local parameters = {
		DisplayOrder = self.DisplayOrder,
		Enabled = self.Enabled,
		Parent = self.Parent,
		[self._Fuse.Children] = {
			self._Fuse.new "Frame" {
				BackgroundTransparency = 1,
				Size = self._Fuse.Computed(self.AbsoluteSize, function(absSize)
					if not absSize then return UDim2.fromOffset(0,0) end
					return UDim2.fromOffset(absSize.X, absSize.Y)
				end),
				Position = self._Fuse.Computed(self.AbsolutePosition, function(absPos)
					if not absPos then return UDim2.fromOffset(0,0) end
					return UDim2.fromOffset(absPos.X, absPos.Y)
				end),
			}
		},
	}

	for k, v in pairs(config) do
		if parameters[k] == nil and self[k] == nil then
			parameters[k] = v
		end
	end

	self.Instance = self._Fuse.new("ScreenGui")(parameters)
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