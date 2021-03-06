--!strict
local package = script.Parent
local packages = package.Parent

local Isotope = require(packages:WaitForChild("isotope"))
type Isotope = Isotope.Isotope
type Fuse = Isotope.Fuse
type State = Isotope.State
type ValueState = Isotope.ValueState

local Maid = require(packages:WaitForChild("maid"))
local ColdFusion = require(packages:WaitForChild("coldfusion"))

local Button = require(package:WaitForChild("Button"))

local ButtonList = {}
ButtonList.__index = ButtonList
setmetatable(ButtonList, Isotope)

function ButtonList:Destroy()
	Isotope.Destroy(self)
end

function ButtonList:InsertButton(txt: string, layoutOrder:number | nil,  bindableEvent: BindableEvent | nil, leftIcon: string | nil, rightIcon: string | nil)
	self.Data:Update(function(cur)
		cur[txt] = {
			Text = txt,
			LayoutOrder = layoutOrder,
			LeftIcon = leftIcon,
			RightIcon = rightIcon,
			BindableEvent = bindableEvent
		}
		return cur
	end)
end

export type ButtonListParameters = {
	Data: {[any]: any} | State?,
	Size: UDim2 | State?,
	AutomaticSize: Enum.AutomaticSize | State?,
	ListPadding: UDim | State?,
	Padding: UDim | State?,
	CornerRadius: UDim | State?,
	TextSize: number | State?,
	IconScale: number | State?,
	BorderSizePixel: number | State?,
	TextColor3: Color3 | State?,
	Font: Enum.Font | State?,
	SelectedTextColor3: Color3 | State?,
	HoverTextColor3: Color3 | State?,
	BackgroundColor3: Color3 | State?,
	BorderColor3: Color3 | State?,
	SelectedBackgroundColor3: Color3 | State?,
	HoverBackgroundColor3: Color3 | State?,
	BackgroundTransparency: number | State?,
	BorderTransparency: number | State?,
	TextTransparency: number | State?,
	TextXAlignment: Enum.TextXAlignment | State?,
	TextYAlignment: Enum.TextYAlignment | State?,
	TextOnly: boolean | State?,
	VerticalAlignment: Enum.VerticalAlignment | State?,
	HorizontalAlignment: Enum.HorizontalAlignment | State?,
	FillDirection: Enum.FillDirection | State?,
	
	[any]: any?,
}


function ButtonList.new(config: ButtonListParameters): GuiObject
	local self = setmetatable(Isotope.new() :: any, ButtonList)
	self.Name = self:Import(config.Name, script.Name)
	self.ClassName = self._Fuse.Computed(function() return script.Name end)

	self._BuildMaid = Maid.new()
	self._Maid:GiveTask(self._BuildMaid)

	self.Data = self:Import(config.Data, {})

	self.Size = self:Import(config.Size, UDim2.fromScale(0,0))
	self.AutomaticSize = self:Import(config.AutomaticSize, Enum.AutomaticSize.XY)

	self.ListPadding = self:Import(config.ListPadding, UDim.new(0,2))
	self.Padding = self:Import(config.Padding, UDim.new(0, 2))
	self.CornerRadius = self:Import(config.CornerRadius, UDim.new(0,4))
	self.TextSize = self:Import(config.TextSize, 14)

	self.IconScale = self:Import(config.IconScale, 1.25)
	self.BorderSizePixel = self:Import(config.BorderSizePixel, 3)
	self.TextColor3 = self:Import(config.TextColor3, Color3.new(0.2,0.2,0.2))
	self.Font = self:Import(config.Font, Enum.Font.GothamBold)
	self.SelectedTextColor3 = self:Import(config.SelectedTextColor3, Color3.new(1,1,1))
	self.HoverTextColor3 = self:Import(config.HoverTextColor3, Color3.new(0.2,0.2,0.2))
	self.BackgroundColor3 = self:Import(config.BackgroundColor3,Color3.fromHSV(0.7,0,1))
	self.BorderColor3 = self:Import(config.BorderColor3,Color3.fromHSV(0.7,0,0.3))
	self.SelectedBackgroundColor3 = self:Import(config.SelectedBackgroundColor3,Color3.fromHSV(0.7,0.7,1))
	self.HoverBackgroundColor3 = self:Import(config.HoverBackgroundColor3, self._Fuse.Computed(self.SelectedBackgroundColor3, self.BackgroundColor3, function(sCol: Color3, bCol: Color3)
		local h1,s1,v1 = sCol:ToHSV()
		local _,s2,v2 = bCol:ToHSV()
		return Color3.fromHSV(h1, s1 + (s2-s1)*0.5, v1 + (v2-v1)*0.5)
	end)):IsDeep()
	self.BackgroundTransparency = self:Import(config.BackgroundTransparency,0)
	self.BorderTransparency = self:Import(config.BackgroundTransparency,0)
	self.TextTransparency = self:Import(config.TextTransparency, 0)

	self.TextXAlignment = self:Import(config.TextXAlignment, Enum.TextXAlignment.Center)
	self.TextYAlignment = self:Import(config.TextYAlignment, Enum.TextYAlignment.Center)

	self.TextOnly = self:Import(config.TextOnly, false)

	self.VerticalAlignment = self:Import(config.VerticalAlignment, Enum.VerticalAlignment.Center)
	self.HorizontalAlignment = self:Import(config.HorizontalAlignment, Enum.HorizontalAlignment.Center)
	self.FillDirection = self:Import(config.FillDirection, Enum.FillDirection.Vertical)
	
	local parameters = {
		Name = self.Name,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0,0),
		[ColdFusion.Children] = {
			self._Fuse.new "UIListLayout" {
				FillDirection = self.FillDirection,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = self.HorizontalAlignment,
				VerticalAlignment = self.VerticalAlignment,
				Padding = self.ListPadding,
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

	self._Fuse.Computed(self.Data, function(data)
		self._BuildMaid:DoCleaning()
		for k, buttonData in pairs(data) do
			local button = Button.new {
				Parent = self.Instance,
				Size = self.Size,
				AutomaticSize = self.AutomaticSize,
				
				IconScale = self.IconScale,
				BorderSizePixel = self.BorderSizePixel,
				TextColor3 = self.TextColor3,
				Font = self.Font,
				SelectedTextColor3 = self.SelectedTextColor3,
				HoverTextColor3 = self.HoverTextColor3,
				BackgroundColor3 = self.BackgroundColor3,
				BorderColor3 = self.BorderColor3,
				SelectedBackgroundColor3 = self.SelectedBackgroundColor3,
				HoverBackgroundColor3 = self.HoverBackgroundColor3,
				BackgroundTransparency = self.BackgroundTransparency,
				BorderTransparency = self.BorderTransparency,
				TextTransparency = self.TextTransparency,
			
				TextXAlignment = self.TextXAlignment,
				TextYAlignment = self.TextYAlignment,
			
				Text = buttonData.Text,
				LeftIcon = buttonData.LeftIcon,
				RightIcon = buttonData.RightIcon,
				LayoutOrder = buttonData.LayoutOrder,
				TextOnly = self.TextOnly,
			}

			if buttonData.BindableEvent then
				local buttonActivated: Instance? = button:WaitForChild("Activated")
				assert(buttonActivated ~= nil and buttonActivated:IsA("BindableEvent"))
				self._BuildMaid:GiveTask(buttonActivated.Event:Connect(function()
					buttonData.BindableEvent:Fire()
				end))
			end
			self._BuildMaid:GiveTask(button)
		end
	end)

	self:Construct()
	
	return self.Instance
end

return ButtonList