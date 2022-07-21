--!strict
local package = script.Parent
local packages = package.Parent

local Isotope = require(packages:WaitForChild("isotope"))
type Isotope = Isotope.Isotope
type Fuse = Isotope.Fuse
type State = Isotope.State
type ValueState = Isotope.ValueState

local EffectGui = require(package:WaitForChild("EffectGui"))
local TextLabel = require(package:WaitForChild("TextLabel"))

local Hint = {}
Hint.__index = Hint
setmetatable(Hint, Isotope)

function Hint:Destroy()
	Isotope.Destroy(self)
end

export type HintParameters = {
	Name: string | State?,
	Parent: Instance | State?,
	Font: Enum.Font | State?,
	Text: string | State?,
	TextSize: number | State?,
	AnchorPoint: Vector2 | State?,
	Padding: UDim | State?,
	GapPadding: UDim | State?,
	CornerRadius: UDim | State?,
	BackgroundTransparency: number | State?,
	TextTransparency: number | State?,
	BackgroundColor3: Color3 | State?,
	Enabled: boolean | State?,
	Override: boolean | State?,
	[any]: any?,
}


function Hint.new(config: HintParameters): GuiObject
	local self = setmetatable(Isotope.new() :: any, Hint)
	self.ClassName = self._Fuse.Computed(function() return script.Name end)

	self.Name = self:Import(config.Name, script.Name)
	self.Parent = self:Import(config.Parent, nil)
	self.Font = self:Import(config.Font, Enum.Font.Gotham)
	self.Text = self:Import(config.Text, nil)
	self.TextSize = self:Import(config.TextSize, 10)
	self.AnchorPoint = self:Import(config.AnchorPoint, Vector2.new(0,0))
	self.Padding = self:Import(config.Padding, UDim.new(0,2))
	self.GapPadding = self:Import(config.GapPadding, UDim.new(0,6))
	self.CornerRadius = self:Import(config.CornerRadius , UDim.new(0,3))
	self.BackgroundTransparency = self:Import(config.BackgroundTransparency, 0)
	self.TextTransparency = self:Import(config.TextTransparency, 0)
	self.BackgroundColor3 = self:Import(config.BackgroundColor3, Color3.fromHSV(0,0,0.7))
	self.Enabled = self:Import(config.Enabled, false)
	self.Override = self:Import(config.Override, false)
	self.Visible = self._Fuse.Value(false)

	self.ActiveTextTransparency = self._Fuse.Computed(self.Enabled, self.TextTransparency, function(enab, trans)
		if enab then
			return trans
		else
			return 1
		end
	end):Tween()

	self._Fuse.Computed(self.Parent, function(par)
		if par then
			self._Maid._parentInputBeginSignal = par.InputChanged:Connect(function()
				if not self.Override:Get() then
					self.Visible:Set(false)
				end
				if self.Enabled:IsA("Value") then
					self.Enabled:Set(true)
				end
			end)
			self._Maid._parentInputEndSignal =  par.MouseLeave:Connect(function()
				if self.Enabled:IsA("Value") then
					self.Enabled:Set(false)
				end
				task.wait(0.3)
				pcall(function()
					if self.Enabled:Get() == false then
						if not self.Override:Get() then
							self.Visible:Set(false)
						end
					end
				end)
			end)
		end
	end)
	local parameters = {
		Name = self.Name,
		Parent = self.Parent,
		Enabled = self.Visible,
	}
	self.Instance = EffectGui.new(parameters)
	self._Maid:GiveTask(self.Instance.Destroying:Connect(function()
		self:Destroy()
	end))
	self._Maid:GiveTask(self.Instance)

	self.AbsoluteSize = self._Fuse.Attribute(self.Instance, "AbsoluteSize"):Else(Vector2.new(0,0))
	self.CenterPosition = self._Fuse.Attribute(self.Instance, "CenterPosition"):Else(UDim2.fromOffset(0,0))

	config.Override = nil
	config.CornerRadius = nil
	config.GapPadding = nil
	config.Padding = nil
	config.AnchorPoint = nil
	config.Enabled = nil
	config.BackgroundColor3 = nil
	config.BackgroundTransparency = nil
	config.LeftIcon = nil
	config.RightIcon = nil
	config.TextTransparency = self.ActiveTextTransparency
	self.TextLabel = TextLabel.new(config)

	local bubbleFrame = self._Fuse.new "Frame" {
		Name = "Hint",
		Parent = self.Instance,
		Position = self._Fuse.Computed(self.CenterPosition, self.AnchorPoint, self.AbsoluteSize, self.GapPadding, function(center: UDim2, anchor: Vector2, size: Vector2, pad: UDim)
			local pos: Vector2 = Vector2.new(center.X.Offset, center.Y.Offset)
			local finalPoint = pos + (size*0.5 + Vector2.new(1,1)*pad.Offset)*anchor
			return UDim2.fromOffset(finalPoint.X, finalPoint.Y)
		end),
		AnchorPoint = self._Fuse.Computed(self.AnchorPoint, function(anchor)
			return Vector2.new(1,1)*0.5-anchor
		end),
		BorderSizePixel = 0,
		ZIndex = 1,
		BackgroundColor3 = self.BackgroundColor3,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromOffset(0,0),
		BackgroundTransparency = self._Fuse.Computed(self.BackgroundTransparency, self.Enabled, function(background, enab)
			if enab then
				return background
			else
				return 1
			end
		end):Tween(),
		[self._Fuse.Children] = {
			self._Fuse.new "UIPadding" {
				PaddingBottom = self.Padding,
				PaddingTop = self.Padding,
				PaddingLeft = self.Padding,
				PaddingRight = self.Padding,
			},
			self._Fuse.new "UICorner" {
				CornerRadius = self.CornerRadius,
			},
			self.TextLabel,
		}
	}
	self._Maid:GiveTask(bubbleFrame)

	self:Construct()
	return self.Instance
end

return Hint