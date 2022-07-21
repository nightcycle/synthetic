--!strict
local SoundService = game:GetService("SoundService")

local package = script.Parent
local packages = package.Parent

local Isotope = require(packages:WaitForChild("isotope"))
type Isotope = Isotope.Isotope
type Fuse = Isotope.Fuse
type State = Isotope.State
type ValueState = Isotope.ValueState

local Signal = require(packages:WaitForChild("signal"))

local Bubble = require(package:WaitForChild("Bubble"))

local Switch = {}
Switch.__index = Switch
setmetatable(Switch, Isotope)

function Switch:Destroy()
	self.ActiveColor3:Unlock()
	Isotope.Destroy(self)
end

export type SwitchParameters = {
	Name: string | State?,
	Scale: number | State?,
	BackgroundColor3: Color3 | State?,
	EnabledColor3: Color3 | State?,
	Value: boolean | State?,
	EnableSound: Sound | State?,
	DisableSound: Sound | State?,
	BubbleEnabled: boolean | State?,
	[any]: any?,
}


function Switch.new(config: SwitchParameters): GuiObject
	local self = setmetatable(Isotope.new() :: any, Switch)
	self.ClassName = self._Fuse.Computed(function() return script.Name end)

	self.Name = self:Import(config.Name, script.Name)
	self.Scale = self:Import(config.Scale, 1)
	self.BackgroundColor3 = self:Import(config.BackgroundColor3, Color3.fromHSV(0,0,0.9))
	self.EnabledColor3 = self:Import(config.EnabledColor3, Color3.fromHSV(0.6,1,1))
	self.Value = self:Import(config.Value, false)
	self.EnableSound = self:Import(config.EnableSound)
	self.DisableSound = self:Import(config.DisableSound)
	self.BubbleEnabled = self:Import(config.BubbleEnabled, true)

	self.Padding = self._Fuse.Computed(self.Scale, function(scale)
		return math.round(6 * scale)
	end)
	self.Width = self._Fuse.Computed(self.Scale, function(scale: number)
		return math.round(scale * 20)
	end)
	self.Activated = Signal.new()
	self._Maid:GiveTask(self.Activated)


	self._Maid:GiveTask(self.Activated:Connect(function()	
		if self.Value:Get() == true then
			local clickSound = self.EnableSound:Get()
			if clickSound then
				SoundService:PlayLocalSound(clickSound)
			end
		else
			local clickSound = self.DisableSound:Get()
			if clickSound then
				SoundService:PlayLocalSound(clickSound)
			end
		end
		if self.Value:IsA("Value") then
			self.Value:Set(not self.Value:Get())
		end
		if self.BubbleEnabled:Get() == false then
			self.BubbleEnabled:Set(true)
			task.wait(0.2)
			self.BubbleEnabled:Set(false)
		end
	end))
	self.ActiveColor3 = self._Fuse.Computed(
		self.Value,
		self.BackgroundColor3,
		self.EnabledColor3,
		function(val, back, col)
			if val then
				return col
			else
				return back
			end
		end
	):Lock()
	self.Knob = self._Fuse.new "Frame" {
		Name = "Knob",
		ZIndex = 2,
		Position = self._Fuse.Computed(
			self.Value,
			function(val)
				if val then
					return UDim2.fromScale(1,0.5)
				else
					return UDim2.fromScale(0,0.5)
				end
			end
		):Tween(),
		AnchorPoint = Vector2.new(0.5,0.5),
		Size = UDim2.fromScale(1,1),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundTransparency = 1,
		[self._Fuse.Children] = {
			self._Fuse.new "Frame" {
				Name = "Frame",
				ZIndex = 2,
				Position = UDim2.fromScale(0.5,0.5),
				AnchorPoint = Vector2.new(0.5,0.5),
				BackgroundColor3 = self.ActiveColor3:Tween(),
				Size = self._Fuse.Computed(self.Width, self.Padding, function(width: number, padding: number)
					return UDim2.fromOffset(width-padding, width-padding)
				end),
				BorderSizePixel = 0,
				[self._Fuse.Children] = {
					self._Fuse.new "UICorner" {
						CornerRadius = self._Fuse.Computed(self.Padding, function(padding)
							return UDim.new(1,0)
						end)
					},
					self._Fuse.new "UIStroke" {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Thickness = self._Fuse.Computed(self.Padding, function(padding)
							return 1--math.round(padding*0.25)
						end),
						Transparency = 0.8,
					}
				}
			},
		},
	}

	local parameters = {
		Name = self.Name,
		Size = self._Fuse.Computed(self.Width, function(width: number)
			return UDim2.fromOffset(width * 2, width * 2)
		end),
		BackgroundTransparency = 1,
		[self._Fuse.Children] = {
			self._Fuse.new "ImageButton" {
				Name = "Button",
				ZIndex = 3,
				BackgroundTransparency = 1,
				ImageTransparency = 1,
				Position = UDim2.fromScale(0.5,0.5),
				Size = UDim2.fromScale(1,1),
				AnchorPoint = Vector2.new(0.5,0.5),
				[self._Fuse.Event "Activated"] = function()
					self.Activated:Fire()
					if self.BubbleEnabled:Get() then
						local bubble: Instance = Bubble.new {
							Parent = self.Knob,
							-- BackgroundColor3 = self.ActiveColor3,
							-- BackgroundTransparency = 0.6,
						}

						local fireFunction:Instance? = bubble:WaitForChild("Fire")
						assert(fireFunction ~= nil and fireFunction:IsA("BindableFunction"))
						fireFunction:Invoke()
					end
				end
			},
			self._Fuse.new "Frame" {
				Name = "Frame",
				ZIndex = 1,
				Size = self._Fuse.Computed(self.Width, self.Padding, function(width: number, padding: number)
					local w = width - padding*2
					return UDim2.new(0, 2*w, 1, 0)
				end),
				Position = UDim2.fromScale(0.5,0.5),
				AnchorPoint = Vector2.new(0.5,0.5),
				BackgroundTransparency = 1,
				[self._Fuse.Children] = {
					self._Fuse.new "Frame" {
						Name = "Track",
						ZIndex = 1,
						BackgroundTransparency = 0.5,
						Position = UDim2.fromScale(0.5,0.5),
						AnchorPoint = Vector2.new(0.5,0.5),
						Size = self._Fuse.Computed(self.Width, self.Padding, function(width: number, padding: number)
							local w = math.round(width - padding*1.75)
							return UDim2.new(1, 0, 0, w)
						end),
						BackgroundColor3 = self._Fuse.Computed(
							self.Value,
							self.EnabledColor3, function(val, col)
							local h,_s,_v = col:ToHSV()
							if val then
								return Color3.fromHSV(h, 0.5, 1)
							else
								return Color3.fromHSV(h, 0, 1)
							end
						end):Tween(),
						[self._Fuse.Children] = {
							self._Fuse.new "UICorner" {
								CornerRadius = UDim.new(0.5,0),
							}
						},
					},
					self.Knob,
				}
			},
		}
	}
	for k, v in pairs(config) do
		if parameters[k] == nil and self[k] == nil then
			parameters[k] = v
		end
	end
	-- print("Parameters", parameters, self)
	self.Instance = self._Fuse.new("Frame")(parameters)
	self:Construct()
	return self.Instance
end

return Switch