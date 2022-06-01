--!strict
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = script.Parent.Parent

local Isotope = require(packages:WaitForChild("isotope"))
local Signal = require(packages:WaitForChild("signal"))

local Checkbox = {}
Checkbox.__index = Checkbox
setmetatable(Checkbox, Isotope)

function Checkbox:Destroy()
	Isotope.Destroy(self)
end

function Checkbox.new(config)
	local self = setmetatable(Isotope.new(config), Checkbox)
	self.Name = self:Import(config.Name, script.Name)
	self.ClassName = self._Fuse.Computed(function() return script.Name end)
	self.Scale = self:Import(config.Scale, 1)
	self.TextColor3 = self:Import(config.TextColor3, Color3.new(1,1,1))
	self.BorderColor3 = self:Import(config.BorderColor3, Color3.fromHSV(0,0,0.4))
	self.Color3 = self:Import(config.BackgroundColor3, Color3.fromHSV(0.6,1,1))
	self.BubbleColor3 = self:Import(config.BubbleColor3, Color3.fromHSV(0,0,0.7))
	self.Value = self:Import(config.Value, false)
	self.EnableSound = self:Import(config.EnableSound):CleanUp()
	self.DisableSound = self:Import(config.DisableSound):CleanUp()
	self.Padding = self._Fuse.Computed(self.Scale, function(scale)
		return math.round(6 * scale)
	end)
	self.Width = self._Fuse.Computed(self.Scale, function(scale)
		return math.round(scale * 20)
	end)

	self.Activated = Signal.new()
	self.BubbleEnabled = self._Fuse.Value(false)
	self._Maid:GiveTask(self.Activated:Connect(function()
		self.Value:Set(not self.Value:Get())
		if self.Value:Get() == true then
			local clickSound = self.EnableSound:Get()
			if clickSound then
				clickSound.Parent = self.Instance
				clickSound:Play()
			end
		else
			local clickSound = self.DisableSound:Get()
			if clickSound then
				clickSound.Parent = self.Instance
				clickSound:Play()
			end
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
				end
			},
			self._Fuse.new "ImageLabel" {
				Name = "ImageLabel",
				ZIndex = 2,
				Image = "rbxassetid://3926305904",
				ImageRectOffset = Vector2.new(312,4),
				ImageRectSize = Vector2.new(24,24),
				ImageColor3 = self.TextColor3,
				ImageTransparency = self._Fuse.Computed(self.Value, function(val)
					if val then return 0 else return 1 end
				end):Tween(),
				Position = UDim2.fromScale(0.5,0.5),
				AnchorPoint = Vector2.new(0.5,0.5),
				BackgroundColor3 = self.Color3,
				BackgroundTransparency = self._Fuse.Computed(self.Value, function(val)
					if val then
						return 0
					else
						return 0.999
					end
				end):Tween(),
				Size = self._Fuse.Computed(self.Width, self.Padding, function(width, padding)
					return UDim2.fromOffset(width-padding, width-padding)
				end),
				BorderSizePixel = 0,
				[self._Fuse.Children] = {
					self._Fuse.new "UICorner" {
						CornerRadius = self._Fuse.Computed(self.Padding, function(padding)
							return UDim.new(0,math.round(padding*0.5))
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
							self.Color3, function(val, border, background)
							if val then return background else return border end
						end):Tween()
					}
				}
			},
			self._Fuse.new "Frame" {
				Name = "Bubble",
				Position = UDim2.fromScale(0.5,0.5),
				AnchorPoint = Vector2.new(0.5,0.5),
				BorderSizePixel = 0,
				ZIndex = 1,
				BackgroundColor3 = self.BubbleColor3,
				Size = self._Fuse.Computed(self.BubbleEnabled, self.Value, function(bVal, val)
					if val then
						return UDim2.fromScale(1, 1)
					else
						return UDim2.fromScale(0, 0)
					end
				end):Tween(),
				BackgroundTransparency = self._Fuse.Computed(self.BubbleEnabled, self.Value, function(bVal, val)
					if bVal == false then
						return 1
					else
						return 0
					end
				end):Tween(0.5),
				[self._Fuse.Children] = {
					self._Fuse.new "UICorner" {
						CornerRadius = UDim.new(0.5,0),
					},
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

return Checkbox