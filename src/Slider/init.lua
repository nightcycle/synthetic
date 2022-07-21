--!strict
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local package = script.Parent
local packages = package.Parent

local Isotope = require(packages:WaitForChild("isotope"))
type Isotope = Isotope.Isotope
type Fuse = Isotope.Fuse
type State = Isotope.State
type ValueState = Isotope.ValueState

local Signal = require(packages:WaitForChild("signal"))

local Bubble = require(package:WaitForChild("Bubble"))
local Hint = require(package:WaitForChild("Hint"))

local Slider = {}
Slider.__index = Slider
setmetatable(Slider, Isotope)

function Slider:Destroy()
	self.TextColor3:Unlock()
	self.HintBackgroundColor3:Unlock()
	self.Value:Unlock()
	self.EnabledColor3:Unlock()
	Isotope.Destroy(self)
end

function Slider.new(config)
	local self = setmetatable(Isotope.new(config), Slider)
	self.Name = self:Import(config.Name, script.Name)
	self.ClassName = self._Fuse.Computed(function() return script.Name end)
	self.Scale = self:Import(config.Scale, 1)
	self.BackgroundColor3 = self:Import(config.BackgroundColor3, Color3.fromHSV(0,0,0.9))
	self.EnabledColor3 = self:Import(config.EnabledColor3, Color3.fromHSV(0.6,1,1)):Lock()
	self.HintBackgroundColor3 = self:Import(config.HintBackgroundColor3, Color3.fromHSV(0,0,0.5)):Lock()
	self.TextColor3 = self:Import(config.TextColor3, Color3.fromHSV(0,0,0.2)):Lock()
	self.TickSound = self:Import(config.TickSound, nil)
	self.EnableSound = self:Import(config.EnableSound, nil)
	self.DisableSound = self:Import(config.DisableSound, nil)

	self.Input = self:Import(config.Input, 5)
	self.Minimum = self:Import(config.Minimum, 0)
	self.Maximum = self:Import(config.Maximum, 10)
	self.Increment = self:Import(config.Increment, 1)
	self.BorderSizePixel = self:Import(config.BorderSizePixel, 4)
	self.Padding = self:Import(config.Padding, UDim.new(0,4))
	self.Size = self:Import(config.Size, UDim2.fromOffset(150,50))
	self.BubbleEnabled = self:Import(config.BubbleEnabled, true)
	self.HintEnabled = self:Import(config.HintEnabled, true)


	self.Value = self._Fuse.Computed(self.Input, self.Minimum, self.Maximum, self.Increment,  function(input, min, max, inc)
		local val = input-(input%inc)--math.round(input * inc)/inc
		if val ~= val then val = min end
		-- print("Val", val, "Inc", inc, "In", input)
		return math.clamp(val, min, max)
	end):Lock()
	self.Value:Connect(function()
		local tickSound = self.TickSound:Get()
		if tickSound then
			SoundService:PlayLocalSound(tickSound)
		end
	end)
	self.Alpha = self._Fuse.Computed(self.Value, self.Minimum, self.Maximum, function(val, min, max)
		return (val - min)/(max-min)
	end)

	self.OnRelease = Signal.new()
	self._Maid:GiveTask(self.OnRelease)

	self.Dragging = self._Fuse.Value(false)

	self.Diameter = self._Fuse.Computed(self.Size, self.Padding, function(size, padding)
		return size.Y.Offset - padding.Offset*2
	end)
	self.Knob = self._Fuse.new "Frame" {
		Name = "Knob",
		ZIndex = 2,
		Position = self._Fuse.Computed(
			self.Alpha,
			function(val)
				return UDim2.fromScale(val,0.5)
			end
		),
		AnchorPoint = self._Fuse.Computed(
			self.Alpha,
			function(val)
				return Vector2.new(val,0.5)
			end
		),
		Size = UDim2.fromScale(1,1),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundTransparency = 1,
		[self._Fuse.Children] = {
			self._Fuse.new "Frame" {
				Name = "Frame",
				ZIndex = 2,
				Position = UDim2.fromScale(0.5,0.5),
				AnchorPoint = Vector2.new(0.5,0.5),
				BackgroundColor3 = self.EnabledColor3:Tween(),
				Size = self._Fuse.Computed(self.Diameter, function(diameter)
					return UDim2.fromOffset(diameter,diameter)
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
	self.Hint = Hint.new {
		Parent = self.Knob,
		Override = true,
		AnchorPoint = Vector2.new(0,-1),
		BackgroundColor3 = self.HintBackgroundColor3,
		TextColor3 = self.TextColor3,
		Padding = UDim.new(0,4),
		Enabled = self._Fuse.Computed(self.Dragging, self.HintEnabled, function(drag, enab)
			return drag and enab
		end),
		Text = self._Fuse.Computed(self.Value, function(val)
			return tostring(val)
		end)
	}
	self.Button = self._Fuse.new "ImageButton" {
		Name = "Button",
		ZIndex = 3,
		BackgroundTransparency = 1,
		ImageTransparency = 1,
		Position = UDim2.fromScale(0.5,0.5),
		Size = UDim2.fromScale(1,1),
		AnchorPoint = Vector2.new(0.5,0.5),
		[self._Fuse.Event "MouseButton1Down"] = function()
			self.Dragging:Set(true)
			if self.BubbleEnabled:Get() then
				
				local bubble = Bubble.new {
					Parent = self.Knob,
					FinalTransparency = 0.7,
					BackgroundTransparency = 1,
					BackgroundColor3 = self.EnabledColor3,
					Scale = 1.75,
					-- BackgroundColor3 = self.ActiveColor3,
					-- BackgroundTransparency = 0.6,
				}
				self._Maid._currentBubble = function()
					if bubble and bubble:IsDescendantOf(game) then
						local destFunction = bubble:FindFirstChild("Disable")
						if destFunction then
							destFunction:Invoke()
						else
							bubble:Destroy()
						end
					end
				end
				local enabFunction = bubble:WaitForChild("Enable")
				enabFunction:Invoke()
				local enabSound = self.EnableSound:Get()
				if enabSound then
					SoundService:PlayLocalSound(enabSound)
				end
			end
		end,
	}

	self.ButtonAbsolutePosition = self._Fuse.Property(self.Button, "AbsolutePosition"):Else(Vector2.new(0,0))
	self.ButtonAbsoluteSize = self._Fuse.Property(self.Button, "AbsoluteSize"):Else(Vector2.new(0,0))

	local parameters = {
		Name = self.Name,
		Size = self.Size,
		BackgroundTransparency = 1,
		[self._Fuse.Children] = {
			self.Button,
			self._Fuse.new "Frame" {
				Name = "Frame",
				ZIndex = 1,
				Size = UDim2.fromScale(1,1),
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
						Size = self._Fuse.Computed(self.Diameter, self.BorderSizePixel, function(diameter, bsp)
							return UDim2.new(1, -diameter, 0, bsp)
						end),
						BackgroundColor3 = Color3.new(1,1,1),
						[self._Fuse.Children] = {
							self._Fuse.new "UICorner" {
								CornerRadius = UDim.new(0.5,0),
							},
							self._Fuse.new "UIGradient" {
								Color = self._Fuse.Computed(self.BackgroundColor3, self.EnabledColor3, self.Alpha, function(back, enab, alpha)
									local bump = 0.001
									return ColorSequence.new({
										ColorSequenceKeypoint.new(0, enab),
										ColorSequenceKeypoint.new(math.clamp(alpha-bump, bump, 1-bump*2), enab),
										ColorSequenceKeypoint.new(math.clamp(alpha, bump*2, 1-bump), back),
										ColorSequenceKeypoint.new(1, back),
									})
								end)
							},
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
	self._Fuse.Computed(self.Dragging, function(dragging)
		self._Maid._dragStep = nil
		self._Maid._dragRelease = nil
		if dragging then
			self._Maid._dragStep = UserInputService.InputChanged:Connect(function(inputObj: InputObject)
				if inputObj.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = Vector2.new(inputObj.Position.X, inputObj.Position.Y)
					local absPos = self.ButtonAbsolutePosition:Get()
					local absSize = self.ButtonAbsoluteSize:Get()
					local min = self.Minimum:Get()
					local max = self.Maximum:Get()
					self.Input:Set(min + (max-min)*math.clamp((pos.X - absPos.X)/absSize.X, 0, 1))
				end
			end)
			self._Maid._dragRelease = UserInputService.InputEnded:Connect(function(inputObj: InputObject)
				if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
					self.Dragging:Set(false)
					self.OnRelease:Fire(self.Value:Get())
				end
			end)
		else
			local disabSound = self.DisableSound:Get()
			if disabSound then
				SoundService:PlayLocalSound(disabSound)
			end
			self._Maid._currentBubble = nil
		end
	end)
	self:Construct()
	return self.Instance
end

return Slider