--!strict
local package = script.Parent
local packages = package.Parent

local Isotope = require(packages:WaitForChild("isotope"))
type Isotope = Isotope.Isotope
type Fuse = Isotope.Fuse
type State = Isotope.State
type ValueState = Isotope.ValueState

local ColdFusion = require(packages:WaitForChild("coldfusion"))
local Signal = require(packages:WaitForChild("signal"))

local IconLabel = require(script.Parent:WaitForChild("IconLabel"))

local TextField = {}
TextField.__index = TextField
setmetatable(TextField, Isotope)

function TextField:Destroy()
	Isotope.Destroy(self)
end

function TextField:SetInput(txt, cursorOffset: number?)
	self.TextBox.Text = txt
	assert(typeof(self.TextBox.CursorPosition) == "number")
	self.TextBox.CursorPosition += cursorOffset or 0
end

function TextField:GetInput()
	return self.TextBox.Text
end

function TextField:Clear()
	self.TextBox.Text = ""
	self.TextBox.CursorPosition = 1
end

export type TextFieldParameters = {
	Name: string | State?,
	TextSize: number | State?,
	LowerText: string | State?,
	LowerTextColor3: Color3 | State?,
	Width: UDim | State?,
	CornerRadius: number | State?,
	CharacterLimit: number | State?,
	BackgroundTransparency: number | State?,
	ClearTextOnFocus: boolean | State?,
	TextColor3: Color3 | State?,
	TextTransparency: number | State?,
	Text: string | State?,
	Font: Enum.Font | State?,
	MaintainLowerSpacing: boolean | State?,
	BackgroundColor3: Color3 | State?,
	FocusedBackgroundColor3: Color3 | State?,
	HoverBackgroundColor3: Color3 | State?,
	BorderSizePixel: number | State?,
	BorderColor3: Color3 | State?,
	IconScale: number | State?,
	LeftIcon: string | State?,
	RightIcon: string | State?,
	[any]: any?,
}

function TextField.new(config: TextFieldParameters): GuiObject
	local self = setmetatable(Isotope.new() :: any, TextField)

	self.ClassName = self._Fuse.Computed(function() return script.Name end)

	self.OnInputChanged = Signal.new()
	self._Maid:GiveTask(self.OnInputChanged)

	self.OnInputComplete = Signal.new()
	self._Maid:GiveTask(self.OnInputComplete)

	self.Name = self:Import(config.Name, script.Name)
	self.TextSize = self:Import(config.TextSize, 14)
	self.LowerText = self:Import(config.LowerText, nil)
	self.LowerTextColor3 = self:Import(config.LowerTextColor3, Color3.new(1,0,0))
	self.Width = self:Import(config.Width, UDim.new(0,250))
	self.CornerRadius = self:Import(config.CornerRadius, UDim.new(0,3))
	self.CharacterLimit = self:Import(config.CharacterLimit, nil)
	self.BackgroundTransparency = self:Import(config.BackgroundTransparency, 0)
	self.ClearTextOnFocus = self:Import(config.ClearTextOnFocus, false)
	self.TextColor3 = self:Import(config.TextColor3, Color3.new(1,1,1))
	self.TextTransparency = self:Import(config.TextTransparency, 0)
	self.Text = self:Import(config.Text, false)
	self.Font = self:Import(config.Font, Enum.Font.Gotham)
	self.MaintainLowerSpacing = self:Import(config.MaintainLowerSpacing, false)
	self.BackgroundColor3 = self:Import(config.BackgroundColor3, Color3.fromHSV(0,0,0.2))
	self.FocusedBackgroundColor3 = self:Import(config.FocusedBackgroundColor3,Color3.fromHSV(0,0,0.4))
	self.HoverBackgroundColor3 = self:Import(config.HoverBackgroundColor3, self._Fuse.Computed(self.FocusedBackgroundColor3, self.BackgroundColor3, function(sCol: Color3, bCol: Color3)
		local h1,s1,v1 = sCol:ToHSV()
		local _,s2,v2 = bCol:ToHSV()
		return Color3.fromHSV(h1, s1 + (s2-s1)*0.5, v1 + (v2-v1)*0.5)
	end)):IsDeep()
	self.BorderSizePixel = self:Import(config.BorderSizePixel, 2)
	self.BorderColor3 = self:Import(config.BorderColor3, Color3.fromHSV(0.6,1,1))
	self.IconScale = self:Import(config.IconScale, 1.25)
	self.LeftIcon = self:Import(config.LeftIcon)
	self.RightIcon = self:Import(config.RightIcon)

	self.IsHovering = self._Fuse.Value(false)

	self.IconSize = self._Fuse.Computed(self.TextSize, self.IconScale, function(textSize: number, scale: number)
		return math.round(textSize*scale)
	end)
	self.IconCount = self._Fuse.Computed(self.LeftIcon, self.RightIcon, function(left, right)
		if left and right then
			return 2
		elseif left or right then
			return 1
		else
			return 0
		end
	end)
	self.LeftOffset = self._Fuse.Computed(self.LeftIcon, self.IconSize, self.TextSize, function(leftIcon: string?, iconSize: number, textSize: number)
		if leftIcon then
			return iconSize + textSize
		else
			return 0
		end
	end)
	self.RightOffset = self._Fuse.Computed(self.RightIcon, self.IconSize, self.TextSize, function(rightIcon: string?, iconSize: number, textSize: number)
		if rightIcon then
			return iconSize + textSize
		else
			return 0
		end
	end)
	self.CenterOffset = self._Fuse.Computed(self.LeftOffset, self.RightOffset, function(leftOff: number, rightOff: number)
		return leftOff - rightOff
	end)
	
	self.TextBox = self._Fuse.new "TextBox" {
		BackgroundTransparency = 1,
		Text = "",
		ClearTextOnFocus = self.ClearTextOnFocus,
		AnchorPoint = Vector2.new(0.5,1),
		Position = self._Fuse.Computed(self.TextSize, self.CenterOffset, function(txtSize, cOff)
			return UDim2.new(UDim.new(0.5,0.5*cOff),UDim.new(1,-txtSize*0.5))
		end),
		TextColor3 = self.TextColor3,
		TextSize = self.TextSize,
		Font = self.Font,
		MultiLine = false,
		PlaceholderText = "",
		RichText = false,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTransparency = self.TextTransparency,
		Size = self._Fuse.Computed(self.TextSize, self.LeftOffset, self.RightOffset,  function(textSize, lOff, rOff)
			return UDim2.new(UDim.new(1,-textSize*1.25-lOff-rOff), UDim.new(0, textSize))
		end),
		[self._Fuse.Event "Focused"] = function()
			self.IsFocused:Set(true)
		end,
		[self._Fuse.Event "FocusLost"] = function()
			self.IsFocused:Set(false)
		end,
	} :: TextBox

	self.Input = self._Fuse.Property(self.TextBox, "Text")
	self.Input:Connect(function(cur)
		self.OnInputChanged:Fire(cur)
	end)
	self.IsFocused = self._Fuse.Value(self.TextBox:IsFocused())
	self.IsFocused:Connect(function(v)
		if v == false then
			self.OnInputComplete:Fire()
		end
	end)
	self.IsEmpty = self._Fuse.Computed(self.Input, self.IsFocused, function(input, focused)
		return input == "" and not focused
	end)
	self.LowerTextSize = self._Fuse.Computed(self.TextSize, self.IsEmpty, function(textSize: number, isEmpty)
		return textSize*0.75
	end)
	self.LowerTextFrameHeight = self._Fuse.Computed(self.LowerTextSize, function(txtSize)
		return UDim.new(0,txtSize)
	end)
	self.CharacterCount = self._Fuse.Computed(self.Input, function(input)
		return string.len(input)
	end)
	self._Fuse.Computed(self.Input, self.CharacterCount, self.CharacterLimit, function(input, count: number, lim: number)
		if lim then
			if lim < count then
				self:SetInput(string.sub(input, 1, lim))
			end
		end
	end)
	
	self.Label = self._Fuse.new "TextLabel" {
		Name = "Label",
		BackgroundTransparency = 1,
		Text = self.Text,
		Font = self.Font,
		TextTransparency = self.TextTransparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextSize = self._Fuse.Computed(self.TextSize, self.IsEmpty, function(textSize: number, isEmpty)
			if isEmpty then
				return textSize*1
			else
				return textSize*0.75
			end
		end):Tween(),
		TextColor3 = self._Fuse.Computed(self.BorderColor3, self.TextColor3, self.IsEmpty, function(col, textCol, isEmpty)
			if not isEmpty then
				return col
			else
				return textCol
			end
		end):Tween(),
		Size = self._Fuse.Computed(self.TextSize, self.LeftOffset, self.RightOffset, function(textSize, leftOffset, rightOffset)
			return UDim2.new(UDim.new(1,-textSize*2-leftOffset-rightOffset), UDim.new(0, textSize * 0.75))
		end):Tween(),
		Position = self._Fuse.Computed(self.IsEmpty, self.TextSize, self.LeftOffset, self.RightOffset, self.CenterOffset, function(isEmpty, textSize: number, lOff: number, rOff: number, cOff: number)
			if not isEmpty then
				return UDim2.new(UDim.new(0,textSize*0.75+lOff), UDim.new(0,textSize*0.5))
			else
				return UDim2.new(UDim.new(0.5, (lOff - rOff)*0.5),UDim.new(0.5,0))
			end
		end):Tween(),
		AnchorPoint = self._Fuse.Computed(self.IsEmpty, function(isEmpty)
			if not isEmpty then
				return Vector2.new(0,0)
			else
				return Vector2.new(0.5,0.5)
			end
		end):Tween(),
	}
	
	self.Frame = self._Fuse.new "Frame" {
		Name = "Container",
		BackgroundTransparency = self.BackgroundTransparency,
		BackgroundColor3 = self._Fuse.Computed(self.IsFocused, self.IsHovering, self.BackgroundColor3, self.FocusedBackgroundColor3, self.HoverBackgroundColor3, function(isFocused, isHovering, backColor, focusColor, hoverColor)
			if isFocused then
				return focusColor
			elseif isHovering then
				return hoverColor
			else
				return backColor
			end
		end),
		Size = self._Fuse.Computed(self.TextSize, self.Width, function(textSize: number, width)
			return UDim2.new(width, UDim.new(0,textSize*3))
		end),
		[ColdFusion.Children] = {
			self._Fuse.new "Frame" {
				AnchorPoint = Vector2.new(0.5,1),
				Size = self._Fuse.Computed(self.BorderSizePixel, self.IsFocused, function(pix: number, focused)
					if focused then
						return UDim2.new(UDim.new(1,0), UDim.new(0,pix))
					else
						return UDim2.new(UDim.new(1,0), UDim.new(0,pix*0.5))
					end
				end):Tween(),
				Position = UDim2.fromScale(0.5,1),
				BackgroundTransparency = self._Fuse.Computed(self.BackgroundTransparency, function(trans)
					if trans == 0 then
						return 0
					else
						return 1
					end
				end):Tween(),
				BackgroundColor3 = self._Fuse.Computed(self.IsFocused, self.BorderColor3, self.TextColor3, function(isFocused, borderCol, textCol)
					if isFocused then
						return borderCol
					else
						return textCol
					end
				end):Tween(),
			},
			self._Fuse.new "UIStroke" {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = self.BorderSizePixel,
				Color = self._Fuse.Computed(self.BorderColor3, self.TextColor3, self.IsFocused, function(bCol, tCol, isFoc)
					if isFoc then
						return bCol
					else
						return tCol
					end
				end):Tween(),
				Transparency = self._Fuse.Computed(self.BackgroundTransparency, function(trans)
					if trans == 0 then
						return 1
					else
						return 0
					end
				end):Tween(),
			},
			self._Fuse.new "UICorner" {
				CornerRadius = self.CornerRadius,
			},
			self._Fuse.new "TextButton" {
				Text = "",
				TextTransparency = 1,
				AnchorPoint = Vector2.new(0.5,0.5),
				Position = UDim2.fromScale(0.5,0.5),
				Size = UDim2.fromScale(1,1),
				ZIndex = 10,
				BackgroundTransparency = 1,
				[self._Fuse.Event "Activated"] = function()
					if self.TextBox:IsFocused() then
						self.TextBox:ReleaseFocus()
					else
						self.TextBox:CaptureFocus()
					end
				end,
				[self._Fuse.Event "InputChanged"] = function()
					self.IsHovering:Set(true)
				end,
				[self._Fuse.Event "MouseLeave"] = function()
					self.IsHovering:Set(false)
				end,
			},
			IconLabel.new {
				Name = "Right",
				IconTransparency = 0,
				IconColor3 = self.TextColor3,
				Icon = self.RightIcon,
				Position = self._Fuse.Computed(self.TextSize, function(txtSize)
					return UDim2.new(UDim.new(1,-txtSize), UDim.new(0.5,0))
				end),
				Size = self._Fuse.Computed(self.IconSize, function(iconSize)
					return UDim2.fromOffset(iconSize, iconSize)
				end),
				AnchorPoint = Vector2.new(1, 0.5),
			},
			IconLabel.new {
				Name = "Left",
				Position = self._Fuse.Computed(self.TextSize, function(txtSize)
					return UDim2.new(UDim.new(0,txtSize), UDim.new(0.5,0))
				end),
				Size = self._Fuse.Computed(self.IconSize, function(iconSize)
					return UDim2.fromOffset(iconSize, iconSize)
				end),
				AnchorPoint = Vector2.new(0, 0.5),
				IconTransparency = 0,
				IconColor3 = self.TextColor3,
				Icon = self.LeftIcon,
			},
			self.TextBox,
			self.Label,
		}
	}
	self.CharLimitLabel = self._Fuse.new "TextLabel" {
		Name = "CharLimit",
		AnchorPoint = Vector2.new(1,0),
		Position = UDim2.fromScale(1,0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Text = self._Fuse.Computed(self.CharacterLimit, self.CharacterCount, function(lim: number, count: number)
			if lim and count then
				return count.." / "..lim
			else
				return ""
			end
		end),
		Font = self.Font,
		TextTransparency = self.TextTransparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextSize = self.LowerTextSize,
		TextColor3 = self._Fuse.Computed(self.BorderColor3, self.TextColor3, self.IsEmpty, function(col, textCol, isEmpty)
			if not isEmpty then
				return col
			else
				return textCol
			end
		end),
	}
	self.LowerTextLabel = self._Fuse.new "TextLabel" {
		Name = "TextLabel",
		AnchorPoint = Vector2.new(0,0),
		Position = UDim2.fromScale(0,0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Text = self.LowerText:Else(""),
		Font = self.Font,
		TextTransparency = self.TextTransparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextSize = self.LowerTextSize,
		TextColor3 = self.LowerTextColor3,
	}
	self.LowerTextFrame = self._Fuse.new "Frame" {
		Name = "LowerTextFrame",
		BackgroundTransparency = 1,
		AutomaticSize = 0,
		LayoutOrder = 2,
		Size = self._Fuse.Computed(self.Width, self.LowerTextFrameHeight, function(width, height)
			return UDim2.new(width, height)
		end),
		Visible = self._Fuse.Computed(self.CharacterLimit, self.LowerText, self.MaintainLowerSpacing, function(charLim, lowerText, lowerSpacing)
			local isFilled = not (charLim == nil and (lowerText == nil or lowerText == ""))
			-- print("LT", lowerText)
			-- print("IsFilled,", isFilled, charLim, "-", lowerText)
			return lowerSpacing == true or isFilled
		end),
		[ColdFusion.Children] = {
			self.CharLimitLabel,
			self.LowerTextLabel,
		},
	}

	local parameters = {
		Name = self.Name,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = self._Fuse.Computed(self.Width, function(width)
			return UDim2.new(width, UDim.new(0,0))
		end),
		[ColdFusion.Children] = {
			self._Fuse.new "UIListLayout" {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = self._Fuse.Computed(self.TextSize, function(txtSize: number)
					return UDim.new(0,txtSize*0.25)
				end),
			},
			self.Frame,
			self.LowerTextFrame,
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

return TextField