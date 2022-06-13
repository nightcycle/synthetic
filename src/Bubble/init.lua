--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local package = script.Parent
local packages = package.Parent

local Isotope = require(packages:WaitForChild("isotope"))
local Signal = require(packages:WaitForChild("signal"))
local EffectGui = require(package:WaitForChild("EffectGui"))

local Bubble = {}
Bubble.__index = Bubble
setmetatable(Bubble, Isotope)

function Bubble:Destroy()
	Isotope.Destroy(self)
end

function Bubble:Fire()
	self.Value:Set(1)
	task.delay(0.4, function()
		self:Destroy()
	end)
end

function Bubble.new(config)
	local self = setmetatable(Isotope.new(config), Bubble)

	self.Name = self:Import(config.Name, script.Name)
	self.ClassName = self._Fuse.Computed(function() return script.Name end)
	self.Parent = self:Import(config.Parent, nil)
	self.Scale = self:Import(config.Scale, 1.25)
	self.BackgroundTransparency = self:Import(config.BackgroundTransparency, 0.6)
	self.BackgroundColor3 = self:Import(config.BackgroundColor3, Color3.fromHSV(0,0,0.7))
	self.Value = self._Fuse.Value(0)
	self.ValueTween = self.Value:Tween(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local parameters = {
		Name = self.Name,
		Parent = self.Parent,
	}

	for k, v in pairs(config) do
		if parameters[k] == nil and self[k] == nil then
			parameters[k] = v
		end
	end

	self.Instance = EffectGui.new(parameters)
	self._Maid:GiveTask(self.Instance)

	self.AbsoluteSize = self._Fuse.Attribute(self.Instance, "AbsoluteSize"):Else(Vector2.new(0,0))
	self.AnchorPosition = self._Fuse.Attribute(self.Instance, "AnchorPosition"):Else(UDim2.fromOffset(0,0))

	local bubbleFrame = self._Fuse.new "Frame" {
		Name = "Bubble",
		Parent = self.Instance,
		Position = self.AnchorPosition,
		AnchorPoint = Vector2.new(0.5,0.5),
		BorderSizePixel = 0,
		ZIndex = 1,
		BackgroundColor3 = self.BackgroundColor3,
		Size = self._Fuse.Computed(self.ValueTween, self.AbsoluteSize, self.Scale, function(val, size, scale)
			local diameter = math.max(size.X, size.Y) * val * scale
			return UDim2.fromOffset(diameter,diameter)
		end),
		BackgroundTransparency = self._Fuse.Computed(self.Value, self.BackgroundTransparency, function(val, background)
			if val == 0 then
				return background
			else
				return 1
			end
		end):Tween(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		[self._Fuse.Children] = {
			self._Fuse.new "UICorner" {
				CornerRadius = UDim.new(0.5,0),
			},
		}
	}
	self._Maid:GiveTask(bubbleFrame)

	self:Construct()
	return self.Instance
end

return Bubble