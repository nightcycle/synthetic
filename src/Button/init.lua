--!strict
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local package = script.Parent
local packages = package.Parent

local Isotope = require(packages:WaitForChild("isotope"))
local Format = require(packages:WaitForChild("format"))
local Signal = require(packages:WaitForChild("signal"))

local TextLabel = require(script.Parent:WaitForChild("TextLabel"))

local Button = {}
Button.__index = Button
setmetatable(Button, Isotope)

function Button:Destroy()
	Isotope.Destroy(self)
end

function Button.new(config)
	local self = setmetatable(Isotope.new(), Button)
	self.Name = self:Import(config.Name, script.Name)
	self.ClassName = self._Fuse.Computed(function() return script.Name end)

	self.Padding = self:Import(config.Padding, UDim.new(0, 2))
	self.CornerRadius = self:Import(config.CornerRadius, UDim.new(0,4))
	self.TextSize = self:Import(config.TextSize, 14)

	self.BorderSizePixel = self:Import(config.BorderSizePixel, 3)
	self.TextColor3 = self:Import(config.TextColor3, Color3.new(0.2,0.2,0.2))
	self.Font = self:Import(config.Font, Enum.Font.GothamBold)
	self.SelectedTextColor3 = self:Import(config.SelectedTextColor3, Color3.new(1,1,1))
	self.HoverTextColor3 = self:Import(config.HoverTextColor3, Color3.new(0.2,0.2,0.2))
	self.BackgroundColor3 = self:Import(config.BackgroundColor3,Color3.fromHSV(0.7,0,1))
	self.BorderColor3 = self:Import(config.BorderColor3,Color3.fromHSV(0.7,0,0.3))
	self.SelectedBackgroundColor3 = self:Import(config.SelectedBackgroundColor3,Color3.fromHSV(0.7,0.7,1))
	self.HoverBackgroundColor3 = self:Import(config.HoverBackgroundColor3, self._Fuse.Computed(self.SelectedBackgroundColor3, self.BackgroundColor3, function(sCol, bCol)
		local h1,s1,v1 = sCol:ToHSV()
		local h2,s2,v2 = bCol:ToHSV()
		return Color3.fromHSV(h1, s1 + (s2-s1)*0.5, v1 + (v2-v1)*0.5)
	end)):IsDeep()
	self.BackgroundTransparency = self:Import(config.BackgroundTransparency,0)
	self.BorderTransparency = self:Import(config.BackgroundTransparency,0)
	self.TextTransparency = self:Import(config.TextTransparency, 0)

	self.TextXAlignment = self:Import(config.TextXAlignment, Enum.TextXAlignment.Center)
	self.TextYAlignment = self:Import(config.TextYAlignment, Enum.TextYAlignment.Center)

	self.Text = self:Import(config.Text, "Button *Time*")
	self.LeftIcon = self:Import(config.LeftIcon)
	self.RightIcon = self:Import(config.RightIcon)
	self.TextOnly = self:Import(config.TextOnly, false)

	self.IconSize = self._Fuse.Computed(self.TextSize, function(textSize)
		local size = math.round(textSize*1.25)
		return UDim2.fromOffset(size, size)
	end)

	self.IsHovering = self._Fuse.Value(false)
	self.IsPressing = self._Fuse.Value(false)
	self.IsRippling = self._Fuse.Value(false)


	self.Activated = Signal.new()
	self.MouseButton1Down = Signal.new()
	self.MouseButton1Up = Signal.new()

	self.InputBegan = Signal.new()
	self.InputEnded = Signal.new()

	self.ClickCenter = self._Fuse.Value(0.5)
	self.ClickTick = self._Fuse.Value(0)
	self.MaxRippleDuration = self._Fuse.Value(0.4)
	self.TimeSinceLastClick = self._Fuse.Value(tick())
	self.RippleAlpha = self._Fuse.Computed(self.TimeSinceLastClick, self.MaxRippleDuration, function(timeSince, dur)
		return math.clamp(timeSince / dur, 0, 1)
	end)
	local bump = 0.01
	self.LeftRippleAlpha = self._Fuse.Computed(self.RippleAlpha, self.ClickCenter, function(alpha, center)
		return math.clamp(center - alpha, bump*2, 1-bump*2)
	end)
	self.RightRippleAlpha = self._Fuse.Computed(self.RippleAlpha, self.ClickCenter, function(alpha, center)
		return math.clamp(center + alpha, bump*2, 1-bump*2)
	end)
	local eDir = Enum.EasingDirection.InOut
	local eSty = Enum.EasingStyle.Quad
	self.TimeKeys = self._Fuse.Computed(
		self.ClickCenter,
		self.LeftRippleAlpha,
		self.RightRippleAlpha,	
		function(centerAlpha, leftAlpha, rightAlpha)
			leftAlpha = math.clamp(TweenService:GetValue(leftAlpha, eSty, eDir), bump, math.max(centerAlpha-bump, bump*2))
			rightAlpha = math.clamp(TweenService:GetValue(rightAlpha, eSty, eDir), math.min(centerAlpha+bump, 1-bump*2), 1-bump)
			return {
				0,
				math.clamp(leftAlpha-bump, bump, math.clamp(centerAlpha-bump*2, bump*2, 1-bump*5)),
				math.clamp(leftAlpha, bump*2.5, math.clamp(centerAlpha-bump, bump*3, 1-bump*4)),
				math.clamp(rightAlpha, math.clamp(centerAlpha+bump, bump*4, 1-bump*3), 1-bump*2),
				math.clamp(rightAlpha+bump, math.clamp(centerAlpha+bump*2, bump*5, 1-bump*2), 1-bump),
				1
			}
		end
	)


	self.TextLabel = TextLabel.new {
		BackgroundTransparency = 1,
		TextTransparency = self.TextTransparency,

		ZIndex = 2,
		Font = self.Font,
		Padding = UDim.new(0,0),
		TextSize = self.TextSize,
		TextColor3 = self._Fuse.Computed(
			self.IsHovering,
			self.IsPressing,
			self.IsRippling,
			self.TextColor3,
			self.HoverTextColor3,
			self.SelectedTextColor3,
			function(hover, press, ripple, textColor3, hoverColor, selColor)	
				if press or ripple then
					return selColor
				elseif hover then
					return hoverColor
				end
				return textColor3
			end
		):Tween(0.3),
		TextXAlignment = self.TextXAlignment,
		TextYAlignment = self.TextYAlignment,

		Text = self.Text,

		LeftIcon = self.LeftIcon,
		RightIcon = self.RightIcon,
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(0.5,0.5),
	}


	self.LabelAbsoluteSize = self._Fuse.Property(self.TextLabel, "AbsoluteSize", 60)
	self.ButtonSize = self._Fuse.Computed(self.Padding, self.LabelAbsoluteSize,  function(padding: UDim, absSize: Vector2 | nil)
		absSize = absSize or Vector2.new(0,0)
		local fullSize = absSize + Vector2.new(1,1) * padding.Offset * 2
		return UDim2.fromOffset(fullSize.X, fullSize.Y)
	end)

	self.ActiveBackgroundColor = self._Fuse.Computed(self.IsPressing, self.IsRippling, self.IsHovering, self.BackgroundColor3, self.HoverBackgroundColor3, self.SelectedBackgroundColor3, function(isPressing, isRippling, isHovering, backgroundColor, hoverColor, selColor)
		if isHovering or isRippling then
			return hoverColor
		elseif isPressing then
			return selColor
		else
			return backgroundColor
		end
	end):Tween(0.2)

	self.ActiveFillColor = self._Fuse.Computed(self.IsPressing, self.IsRippling, self.ActiveBackgroundColor, self.SelectedBackgroundColor3,  function(isPressing, isRipple, hoverColor, selectedColor)
		if isPressing or isRipple then
			return selectedColor
		else
			return hoverColor
		end
	end):Tween(0.15)

	local parameters = {
		Name = self.Name,
		Size = self.ButtonSize,
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = self._Fuse.Computed(self.TextOnly, function(textOnly)
			if textOnly then
				return 1
			else
				return 0
			end
		end),
		[self._Fuse.Children] = {
			self._Fuse.new "UICorner" {
				CornerRadius = self.CornerRadius,
			},
			self._Fuse.new "UIPadding" {
				PaddingBottom = self.Padding,
				PaddingTop = self.Padding,
				PaddingLeft = self.Padding,
				PaddingRight = self.Padding,
			},
			self._Fuse.new 'UIStroke' {
				Transparency = 0,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = self._Fuse.Computed(self.TextOnly, self.BorderSizePixel, function(textOnly, bSizePix)
					if textOnly then
						return 0
					else
						return bSizePix
					end
				end),
				Color = self._Fuse.Computed(self.BorderColor3, self.ActiveFillColor, self.ActiveBackgroundColor, self.IsHovering, self.IsPressing, function(border, fill, back, hover, press)
					if press then
						return fill
					elseif hover then
						return back
					else
						return border
					end
				end),
			},
			self._Fuse.new 'UIGradient' {
				Transparency = self._Fuse.Computed(
					self.IsHovering,
					self.IsPressing,
					self.IsRippling,
					self.BackgroundTransparency,
					self.TimeKeys,
					function(hover, press, ripple, defTrans, timeKeys)
						local fill = math.min(0.7, defTrans)
						if ripple then
							local startTrans = defTrans
							local finishTrans = defTrans

							if timeKeys[5] < 0.99 then
								finishTrans = defTrans
							else
								finishTrans = fill
							end

							if timeKeys[2] > 0.01 then
								startTrans = defTrans
							else
								startTrans = fill
							end
							-- print(timeKeys)
							local k1 = NumberSequenceKeypoint.new(timeKeys[1], startTrans)
							local k2 = NumberSequenceKeypoint.new(timeKeys[2], startTrans)
							local k3 = NumberSequenceKeypoint.new(timeKeys[3], fill)
							local k4 = NumberSequenceKeypoint.new(timeKeys[4], fill)
							local k5 = NumberSequenceKeypoint.new(timeKeys[5], finishTrans)
							local k6 = NumberSequenceKeypoint.new(timeKeys[6], finishTrans)
							return NumberSequence.new({k1, k2, k3, k4, k5, k6})
						elseif press then
							return NumberSequence.new({
								NumberSequenceKeypoint.new(0, fill),
								NumberSequenceKeypoint.new(1, fill),
							})
						elseif hover then
							return NumberSequence.new({
								NumberSequenceKeypoint.new(0, defTrans),
								NumberSequenceKeypoint.new(1, defTrans),
							})
						end
						return NumberSequence.new({
							NumberSequenceKeypoint.new(0, defTrans),
							NumberSequenceKeypoint.new(1, defTrans),
						})
					end
				),
				Color = self._Fuse.Computed(
					self.IsHovering,
					self.IsPressing,
					self.IsRippling,
					self.ActiveBackgroundColor,
					self.ActiveFillColor,
					self.TimeKeys,
					function(hover, press, ripple, backColor, selColor, timeKeys)
						if ripple then
							local beginColor = backColor
							local finishColor = backColor
			
							if timeKeys[5] < 0.99 then
								finishColor = backColor
							else
								finishColor = selColor
							end

							if timeKeys[2] > 0.01 then
								beginColor = backColor
							else
								beginColor = selColor
							end
							-- print(timeKeys)
							local k1 = ColorSequenceKeypoint.new(timeKeys[1], beginColor)
							local k2 = ColorSequenceKeypoint.new(timeKeys[2], beginColor)
							local k3 = ColorSequenceKeypoint.new(timeKeys[3], selColor)
							local k4 = ColorSequenceKeypoint.new(timeKeys[4], selColor)
							local k5 = ColorSequenceKeypoint.new(timeKeys[5], finishColor)
							local k6 = ColorSequenceKeypoint.new(timeKeys[6], finishColor)
							return ColorSequence.new({k1, k2, k3, k4, k5, k6})
						elseif press then
							return ColorSequence.new({
								ColorSequenceKeypoint.new(0, selColor),
								ColorSequenceKeypoint.new(1, selColor),
							})
						elseif hover then
							return ColorSequence.new({
								ColorSequenceKeypoint.new(0, backColor),
								ColorSequenceKeypoint.new(1, backColor),
							})
						end
						return ColorSequence.new({
							ColorSequenceKeypoint.new(0, backColor),
							ColorSequenceKeypoint.new(1, backColor),
						})
					end
				),
			},
			self._Fuse.new "TextButton" {
				RichText = true,
				TextColor3 = self.TextColor3,
				LayoutOrder = 2,
				ZIndex = 3,
				Size = UDim2.fromScale(1,1),
				Position = UDim2.fromScale(0.5,0.5),
				AnchorPoint = Vector2.new(0.5,0.5),
				TextTransparency = self.TextTransparency,
				Text = "",
				[self._Fuse.Event "Activated"] = function()
					self.Activated:Fire()
				end,
				[self._Fuse.Event "MouseButton1Down"] = function(x)
					self.MouseButton1Down:Fire()
					
					if not self.IsPressing:Get() and self.TimeSinceLastClick:Get() > 0.8 then
						self.ClickTick:Set(tick())
						self.ClickCenter:Set(x/self.ButtonSize:Get().X.Offset - 0.5)
						self.IsRippling:Set(true)
						task.delay(self.MaxRippleDuration:Get() + 0.2, function()
							self.IsRippling:Set(false)
						end)
						self.IsPressing:Set(true)
					end
		
				end,
				[self._Fuse.Event "MouseButton1Up"] = function()
					self.MouseButton1Up:Fire()
					self.IsPressing:Set(false)
				end,
				[self._Fuse.Event "InputChanged"] = function()
					self.IsHovering:Set(true)
				end,
				[self._Fuse.Event "MouseLeave"] = function()
					self.IsHovering:Set(false)
				end,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
			},
			self.TextLabel,
		}
	}

	for k, v in pairs(config) do
		if parameters[k] == nil and self[k] == nil then
			parameters[k] = v
		end
	end
	self._Maid:GiveTask(RunService.RenderStepped:Connect(function(dt)
		self.TimeSinceLastClick:Set(tick() - self.ClickTick:Get())
	end))

	-- print("Parameters", parameters, self)
	self.Instance = self._Fuse.new("Frame")(parameters)

	self:Construct()
	
	return self.Instance
end

return Button