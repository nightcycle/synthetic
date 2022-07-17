--!strict
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local package = script.Parent
local packages = package.Parent

local Isotope = require(packages:WaitForChild("isotope"))
local Signal = require(packages:WaitForChild("signal"))

local Bubble = require(package:WaitForChild("Bubble"))

local RadioButton = {}
RadioButton.__index = RadioButton
setmetatable(RadioButton, Isotope)

function RadioButton:Destroy()
	Isotope.Destroy(self)
end

function RadioButton.new(config)
	local self = setmetatable(Isotope.new(config), RadioButton)
	self.Name = self:Import(config.Name, script.Name)
	self.ClassName = self._Fuse.Computed(function() return script.Name end)
	self.Scale = self:Import(config.Scale, 1)
	self.BorderColor3 = self:Import(config.BorderColor3, Color3.fromHSV(0,0,0.4))
	self.BackgroundColor3 = self:Import(config.BackgroundColor3, Color3.fromHSV(0.6,1,1))
	self.Value = self:Import(config.Value, false)
	self.EnableSound = self:Import(config.EnableSound)
	self.DisableSound = self:Import(config.DisableSound)
	self.Padding = self._Fuse.Computed(self.Scale, function(scale)
		return math.round(6 * scale)
	end)
	self.Width = self._Fuse.Computed(self.Scale, function(scale)
		return math.round(scale * 20)
	end)
	self.Activated = Signal.new()
	self._Maid:GiveTask(self.Activated)
	
	self.BubbleEnabled = self._Fuse.Value(false)
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

	local parameters = {
		Name = self.Name,
		Size = self._Fuse.Computed(self.Width, function(width)
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
						local bubble = Bubble.new {
							Parent = self.Instance,
						}
						local fireFunction = bubble:WaitForChild("Fire")
						fireFunction:Invoke()
					end
				end
			},
			self._Fuse.new "Frame" {
				Name = "Frame",
				ZIndex = 2,
				Position = UDim2.fromScale(0.5,0.5),
				AnchorPoint = Vector2.new(0.5,0.5),
				BackgroundColor3 = self.BackgroundColor3,
				BackgroundTransparency = 0.999,
				Size = self._Fuse.Computed(self.Width, self.Padding, function(width, padding)
					return UDim2.fromOffset(width-padding, width-padding)
				end),
				BorderSizePixel = 0,
				[self._Fuse.Children] = {
					self._Fuse.new "Frame" {
						Name = "Fill",
						Size = self._Fuse.Computed(self.Width, self.Padding, function(width, padding)
							local w = math.round(width - padding*2)
							return UDim2.fromOffset(w,w)
						end),
						BackgroundColor3 = self.BackgroundColor3,
						BackgroundTransparency = self._Fuse.Computed(self.Value, function(val)
							if val then
								return 0
							else
								return 1
							end
						end):Tween(),
						[self._Fuse.Children] = {
							self._Fuse.new "UICorner" {
								CornerRadius = self._Fuse.Computed(self.Padding, function(padding)
									return UDim.new(1,0)
								end)
							},
						},
						Position = UDim2.fromScale(0.5,0.5),
						AnchorPoint = Vector2.new(0.5,0.5),
					},
					self._Fuse.new "UICorner" {
						CornerRadius = self._Fuse.Computed(self.Padding, function(padding)
							return UDim.new(1,0)
						end)
					},
					self._Fuse.new "UIStroke" {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Thickness = self._Fuse.Computed(self.Padding, function(padding)
							return math.round(padding*0.25)
						end),
						Transparency = 0,
						Color = self._Fuse.Computed(
							self.Value,
							self.BorderColor3,
							self.BackgroundColor3, function(val, border, background)
							if val then return background else return border end
						end):Tween()
					}
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

return RadioButton