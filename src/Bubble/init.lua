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

function Bubble:Enable()
	self.Value:Set(1)
end

function Bubble:Disable()
	self.Value:Set(0)
	task.delay(0.4, function()
		self:Destroy()
	end)
end

export type BubbleParameters = {
	Name: ParameterValue<string>?,
	Parent: ParameterValue<Instance>?,
	Scale: ParameterValue<number>?,
	BackgroundTransparency: ParameterValue<number>?,
	FinalTransparency: ParameterValue<number>?,
	BackgroundColor3: ParameterValue<Color3>?,
}

export type Bubble = EffectGui.EffectGui

function Bubble.new(config: BubbleParameters): Bubble
	local self = setmetatable(Isotope.new() :: any, Bubble)

	self.Name = self:Import(config.Name, script.Name)
	self.ClassName = _Computed(function() return script.Name end)
	self.Parent = self:Import(config.Parent, nil)
	self.Scale = self:Import(config.Scale, 1.25)
	self.BackgroundTransparency = self:Import(config.BackgroundTransparency, 0.6)
	self.FinalTransparency = self:Import(config.FinalTransparency, 1)
	self.BackgroundColor3 = self:Import(config.BackgroundColor3, Color3.fromHSV(0,0,0.7))
	self.Value = _Value(0)
	self.ValueTween = self.Value:Tween(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local parameters: any = {
		Name = self.Name,
		Parent = self.Parent,
	}

	self.Instance = EffectGui.new(parameters)
	self._Maid:GiveTask(self.Instance)

	self.AbsoluteSize = _Fuse.Attribute(self.Instance, "AbsoluteSize"):Else(Vector2.new(0,0))
	self.AnchorPosition = _Fuse.Attribute(self.Instance, "AnchorPosition"):Else(UDim2.fromOffset(0,0))
	self.CenterPosition = _Fuse.Attribute(self.Instance, "CenterPosition"):Else(UDim2.fromOffset(0,0))

	local bubbleFrame = _Fuse.new "Frame" {
		Name = "Bubble",
		Parent = self.Instance,
		Position = self.CenterPosition,
		AnchorPoint = Vector2.new(0.5,0.5),
		BorderSizePixel = 0,
		ZIndex = 1,
		BackgroundColor3 = self.BackgroundColor3,
		Size = _Computed(self.ValueTween, self.AbsoluteSize, self.Scale, function(val, size, scale)
			local diameter = math.max(size.X, size.Y) * val * scale
			return UDim2.fromOffset(diameter,diameter)
		end),
		BackgroundTransparency = _Computed(self.Value, self.BackgroundTransparency, self.FinalTransparency, function(val, background, max)
			if val == 0 then
				return background
			else
				return max
			end
		end):Tween(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		Children = {
			_Fuse.new "UICorner" {
				CornerRadius = UDim.new(0.5,0),
			},
		}
	}
	self._Maid:GiveTask(bubbleFrame)

	self:Construct()
	return self.Instance
end

return Bubble