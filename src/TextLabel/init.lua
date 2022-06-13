--!strict
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local package = script.Parent
local packages = package.Parent

local Isotope = require(packages:WaitForChild("isotope"))
local Format = require(packages:WaitForChild("format"))
local ColdFusion = require(packages:WaitForChild("coldfusion"))

local Icon = require(package:WaitForChild("IconLabel"))

local TextLabel = {}
TextLabel.__index = TextLabel
setmetatable(TextLabel, Isotope)

function TextLabel:Destroy()
	Isotope.Destroy(self)
end

function TextLabel.new(config)
	local self = setmetatable(Isotope.new(config), TextLabel)
	self.Name = self:Import(config.Name, script.Name)
	self.ClassName = self._Fuse.Computed(function() return script.Name end)

	self.Padding = self:Import(config.Padding, UDim.new(0, 2))
	self.TextSize = self:Import(config.TextSize, 14)
	self.TextColor3 = self:Import(config.TextColor3, Color3.new(1,1,1))
	self.TextTransparency = self:Import(config.TextTransparency, 0)
	self.TextXAlignment = self:Import(config.TextXAlignment, Enum.TextXAlignment.Center)
	self.TextYAlignment = self:Import(config.TextYAlignment, Enum.TextYAlignment.Center)
	self.Text = self:Import(config.Text, false)
	self.Font = self:Import(config.Font, Enum.Font.Gotham)
	self.LeftIcon = self:Import(config.LeftIcon)
	self.RightIcon = self:Import(config.RightIcon)
	self.IconSize = self._Fuse.Computed(self.TextSize, function(textSize)
		local size = math.round(textSize*1.25)
		return UDim2.fromOffset(size, size)
	end)
	local parameters = {
		Name = self.Name,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0,0),
		[ColdFusion.Children] = {
			self._Fuse.new "UIListLayout" {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = self._Fuse.Computed(self.TextXAlignment, function(xAlign)
					if xAlign == Enum.TextXAlignment.Center then
						return Enum.HorizontalAlignment.Center
					elseif xAlign == Enum.TextXAlignment.Left then
						return Enum.HorizontalAlignment.Left
					elseif xAlign == Enum.TextXAlignment.Right then
						return Enum.HorizontalAlignment.Right
					end
				end),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = self._Fuse.Computed(self.TextYAlignment, function(yAlign)
					if yAlign == Enum.TextYAlignment.Center then
						return Enum.VerticalAlignment.Center
					elseif yAlign == Enum.TextYAlignment.Top then
						return Enum.VerticalAlignment.Top
					elseif yAlign == Enum.TextYAlignment.Bottom then
						return Enum.VerticalAlignment.Bottom
					end
				end),
				Padding = self.Padding,
			},
			self._Fuse.new "TextLabel" {
				RichText = true,
				TextColor3 = self.TextColor3,
				TextSize = self.TextSize,
				Visible = self._Fuse.Computed(self.Text, function(txt)
					if not txt or string.len(txt) == 0 then
						return false
					else
						return true
					end
				end),
				Font = self.Font,
				LayoutOrder = 2,
				TextTransparency = self.TextTransparency,
				Text = self._Fuse.Computed(self.Text, function(txt)
					return Format(txt)
					-- return txt
				end),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
			},
			Icon.new {
				Parent = self.Instance,
				Size = self.IconSize,
				LayoutOrder = 1,
				Visible = self._Fuse.Computed(self.LeftIcon, function(icon)
					return icon ~= nil and icon ~= ""
				end),
				Name = "LeftIcon",
				Icon = self.LeftIcon,
				IconColor3 = self.TextColor3,
				IconTransparency = self.TextTransparency,
			},
			Icon.new {
				Size = self.IconSize,
				LayoutOrder = 3,
				Visible = self._Fuse.Computed(self.RightIcon, function(icon)
					return icon ~= nil and icon ~= ""
				end),
				Name = "RightIcon",
				Icon = self.RightIcon,
				IconColor3 = self.TextColor3,
				IconTransparency = self.TextTransparency,
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

return TextLabel