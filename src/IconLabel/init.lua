--!strict
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local package = script.Parent
local packages = package.Parent

local Isotope = require(packages:WaitForChild("isotope"))
type Isotope = Isotope.Isotope
type Fuse = Isotope.Fuse
type State = Isotope.State
type ValueState = Isotope.ValueState

local Signal = require(packages:WaitForChild("signal"))
local Format = require(packages:WaitForChild("format"))
local Spritesheet = require(script:WaitForChild("Spritesheet"))

local IconLabel = {}
IconLabel.__index = IconLabel
setmetatable(IconLabel, Isotope)

function IconLabel:Destroy()
	Isotope.Destroy(self)
end

function IconLabel.new(config)
	local self = setmetatable(Isotope.new(config), IconLabel)
	self.Name = self:Import(config.Name, script.Name)
	self.ClassName = self._Fuse.Computed(function() return script.Name end)

	self.IconTransparency = self:Import(config.IconTransparency, 0)
	self.IconColor3 = self:Import(config.IconColor3, Color3.new(1,1,1))
	self.Icon = self:Import(config.Icon, nil)
	
	self.DotsPerInch = self._Fuse.Value(36)

	self.IconData = self._Fuse.Computed(self.Icon, self.DotsPerInch, function(key, dpi)
		if not key or key == "" then return {} end
		local iconResolutions = Spritesheet[string.lower(key)] or {}
		return iconResolutions[dpi]
	end)

	local parameters = {
		BackgroundTransparency = 1,
		Image = self._Fuse.Computed(self.IconData, self.Icon, function(iconData, key)
			if not key or key == "" then return "" end
			if not iconData then return "" end
			return "rbxassetid://"..iconData.Sheet
		end),
		ImageRectOffset = self._Fuse.Computed(self.IconData, function(iconData)
			if not iconData then return Vector2.new(0,0) end
			return Vector2.new(iconData.X, iconData.Y)
		end),
		ImageRectSize = self._Fuse.Computed(self.DotsPerInch, function(dpi)
			return Vector2.new(dpi, dpi)
		end),
		ImageColor3 = self.IconColor3,
	}

	for k, v in pairs(config) do
		if parameters[k] == nil and self[k] == nil then
			parameters[k] = v
		end
	end

	self.Instance = self._Fuse.new("ImageLabel")(parameters)
	self.AbsoluteSize = self._Fuse.Property(self.Instance, "AbsoluteSize"):Else(Vector2.new(0,0))
	self._Maid:GiveTask(self.AbsoluteSize:Connect(function()
		if not self.Instance or not self.Instance:IsDescendantOf(game) then return end
		local dpi = math.min(self.Instance.AbsoluteSize.X, self.Instance.AbsoluteSize.Y)
		local options = {36,48,72,96}
		local closest = 36
		local closestDelta = nil
	
		for i, res in ipairs(options) do
			if dpi % res == 0 or res % dpi == 0 then
				closest = res
				break
			elseif not closestDelta or math.abs(res - dpi) < closestDelta then
				closest = res
				closestDelta = math.abs(res - dpi)
			end
		end
	
		self.DotsPerInch:Set(closest)
	end))

	self:Construct()
	return self.Instance
end

return IconLabel