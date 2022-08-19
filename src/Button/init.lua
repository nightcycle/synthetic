--!strict
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Util = require(package.Util)

local package = script.Parent
local packages = package.Parent

local Types = require(package.Types)
type ParameterValue<T> = Types.ParameterValue<T>

local ColdFusion = require(packages.coldfusion)
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>

local Maid = require(packages.maid)
type Maid = Maid.Maid

local Signal = require(packages:WaitForChild("signal"))

local TextLabel = require(script.Parent:WaitForChild("TextLabel"))

local Button = {}
Button.__index = Button
setmetatable(Button, Isotope)

function Button:Destroy()
	Isotope.Destroy(self)
end

export type ButtonParameters = Types.FrameParameters & {
	Padding: ParameterValue<UDim>?,
	CornerRadius: ParameterValue<UDim>?,
	TextSize: ParameterValue<number>?,
	IconScale: ParameterValue<number>?,
	TextColor3: ParameterValue<Color3>?,
	Font: ParameterValue<Enum.Font>?,
	SelectedTextColor3: ParameterValue<Color3>?,
	HoverTextColor3: ParameterValue<Color3>?,
	SelectedBackgroundColor3: ParameterValue<Color3>?,
	HoverBackgroundColor3: ParameterValue<Color3>?,
	TextTransparency: ParameterValue<number>?,
	TextXAlignment: ParameterValue<Enum.TextXAlignment>?,
	TextYAlignment: ParameterValue<Enum.TextYAlignment>?,
	Text: ParameterValue<string>?,
	LeftIcon: ParameterValue<string>?,
	RightIcon: ParameterValue<string>?,
	ClickSound: ParameterValue<Sound>?,
	TextOnly: ParameterValue<boolean>?,
}

export type Button = Frame

function Button.new(config: ButtonParameters): Button
	local self = setmetatable(Isotope.new() :: any, Button)
	self.ClassName = _Computed(function() return script.Name end)
	self.Name = self:Import(config.Name, script.Name)
	self.Padding = self:Import(config.Padding, UDim.new(0, 2))
	self.CornerRadius = self:Import(config.CornerRadius, UDim.new(0,4))
	self.TextSize = self:Import(config.TextSize, 14)
	self.Size = self:Import(config.Size, nil)
	self.IconScale = self:Import(config.IconScale, 1.25)
	self.BorderSizePixel = self:Import(config.BorderSizePixel, 3)
	self.TextColor3 = self:Import(config.TextColor3, Color3.new(0.2,0.2,0.2))
	self.Font = self:Import(config.Font, Enum.Font.GothamBold)
	self.SelectedTextColor3 = self:Import(config.SelectedTextColor3, Color3.new(1,1,1))
	self.HoverTextColor3 = self:Import(config.HoverTextColor3, Color3.new(0.2,0.2,0.2))
	self.BackgroundColor3 = self:Import(config.BackgroundColor3,Color3.fromHSV(0.7,0,1))
	self.BorderColor3 = self:Import(config.BorderColor3,Color3.fromHSV(0.7,0,0.3))
	self.SelectedBackgroundColor3 = self:Import(config.SelectedBackgroundColor3,Color3.fromHSV(0.7,0.7,1))
	self.HoverBackgroundColor3 = self:Import(config.HoverBackgroundColor3, _Computed(self.SelectedBackgroundColor3, self.BackgroundColor3, function(sCol: Color3, bCol: Color3)
		local h1,s1,v1 = sCol:ToHSV()
		local _,s2,v2 = bCol:ToHSV()
		return Color3.fromHSV(h1, s1 + (s2-s1)*0.5, v1 + (v2-v1)*0.5)
	end))
	self.BackgroundTransparency = self:Import(config.BackgroundTransparency,0)
	self.BorderTransparency = self:Import(config.BackgroundTransparency,0)
	self.TextTransparency = self:Import(config.TextTransparency, 0)

	self.TextXAlignment = self:Import(config.TextXAlignment, Enum.TextXAlignment.Center)
	self.TextYAlignment = self:Import(config.TextYAlignment, Enum.TextYAlignment.Center)

	self.Text = self:Import(config.Text, "")
	self.LeftIcon = self:Import(config.LeftIcon)
	self.RightIcon = self:Import(config.RightIcon)
	self.TextOnly = self:Import(config.TextOnly, false)

	self.IconSize = _Computed(self.TextSize, function(textSize: number)
		local size = math.round(textSize*1.25)
		return UDim2.fromOffset(size, size)
	end)
	self.ActiveBorderColor3 = _Computed(self.BackgroundTransparency, self.BorderColor3, self.BackgroundColor3, function(trans, border, background)
		if trans == 0 then
			return background
		else
			return border
		end
	end)
	self.ActiveBorderTransparency = _Computed(self.BackgroundTransparency, function(backTrans)
		if backTrans == 0 then
			return 1
		else
			return 0
		end
	end)
	self.IsHovering = _Value(false)
	self.IsPressing = _Value(false)
	self.IsRippling = _Value(false)

	self.Activated = Signal.new()
	self._Maid:GiveTask(self.Activated)

	self.MouseButton1Down = Signal.new()
	self._Maid:GiveTask(self.MouseButton1Down)

	self.MouseButton1Up = Signal.new()
	self._Maid:GiveTask(self.MouseButton1Up)

	self.InputBegan = Signal.new()
	self._Maid:GiveTask(self.InputBegan)

	self.InputEnded = Signal.new()
	self._Maid:GiveTask(self.InputEnded)
	
	self.ClickSound = self:Import(config.ClickSound, nil)
	self._Maid:GiveTask(self.Activated:Connect(function()
		local clickSound = self.ClickSound:Get()
		if clickSound then
			SoundService:PlayLocalSound(clickSound)
		end
	end))

	self.ClickCenter = _Value(0.5)
	self.ClickTick = _Value(0)
	self.MaxRippleDuration = _Value(0.4)
	self.TimeSinceLastClick = _Value(tick())
	self.RippleAlpha = _Computed(self.TimeSinceLastClick, self.MaxRippleDuration, function(timeSince: number, dur: number)
		return math.clamp(timeSince / dur, 0, 1)
	end)
	local bump = 0.01
	self.LeftRippleAlpha = _Computed(self.RippleAlpha, self.ClickCenter, function(alpha: number, center: number)
		return math.clamp(center - alpha, bump*2, 1-bump*2)
	end)
	self.RightRippleAlpha = _Computed(self.RippleAlpha, self.ClickCenter, function(alpha: number, center: number)
		return math.clamp(center + alpha, bump*2, 1-bump*2)
	end)
	local eDir = Enum.EasingDirection.InOut
	local eSty = Enum.EasingStyle.Quad
	self.TimeKeys = _Computed(
		self.ClickCenter,
		self.LeftRippleAlpha,
		self.RightRippleAlpha,	
		function(centerAlpha: number, leftAlpha: number, rightAlpha: number)
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
		Padding = self.Padding,
		TextSize = self.TextSize,
		TextColor3 = _Computed(
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
		):Tween(0.2),
		TextXAlignment = self.TextXAlignment,
		TextYAlignment = self.TextYAlignment,

		Text = self.Text,
		IconScale = self.IconScale,
		LeftIcon = self.LeftIcon,
		RightIcon = self.RightIcon,
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(0.5,0.5),
	}


	self.LabelAbsoluteSize = _Fuse.Property(self.TextLabel, "AbsoluteSize", 60)
	self.ButtonSize = _Computed(self.Padding, self.LabelAbsoluteSize, self.Size, function(padding: UDim, absSize: Vector2?, size: Vector2?): UDim2
		if size then return UDim2.fromOffset(size.X, size.Y) end
		absSize = absSize or Vector2.new(0,0)
		assert(absSize ~= nil)
		local fullSize = absSize + Vector2.new(1,1) * padding.Offset * 2
		return UDim2.fromOffset(fullSize.X, fullSize.Y)
	end)

	self.ActiveBackgroundColor = _Computed(self.IsPressing, self.IsRippling, self.IsHovering, self.BackgroundColor3, self.HoverBackgroundColor3, self.SelectedBackgroundColor3, function(isPressing, isRippling, isHovering, backgroundColor, hoverColor, selColor)
		if isHovering or isRippling then
			return hoverColor
		elseif isPressing then
			return selColor
		else
			return backgroundColor
		end
	end):Tween(0.15)

	self.ActiveFillColor = _Computed(self.IsPressing, self.IsRippling, self.ActiveBackgroundColor, self.SelectedBackgroundColor3,  function(isPressing, isRipple, hoverColor, selectedColor)
		if isPressing or isRipple then
			return selectedColor
		else
			return hoverColor
		end
	end):Tween(0.1)

	local parameters = {
		Name = self.Name,
		Size = self.ButtonSize,
		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = _Computed(self.TextOnly, function(textOnly)
			if textOnly then
				return 1
			else
				return 0
			end
		end),
		Children = {
			_Fuse.new "UICorner" {
				CornerRadius = self.CornerRadius,
			},
			_Fuse.new "UIPadding" {
				PaddingBottom = self.Padding,
				PaddingTop = self.Padding,
				PaddingLeft = self.Padding,
				PaddingRight = self.Padding,
			},
			_Fuse.new 'UIStroke' {
				Transparency = self.ActiveBorderTransparency,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = _Computed(self.TextOnly, self.BorderSizePixel, function(textOnly, bSizePix)
					if textOnly then
						return 0
					else
						return bSizePix
					end
				end),
				Color = _Computed(self.ActiveBorderColor3, self.ActiveFillColor, self.ActiveBackgroundColor, self.IsHovering, self.IsPressing, function(border, fill, back, hover, press)
					if press then
						return fill
					elseif hover then
						return back
					else
						return border
					end
				end),
			},
			_Fuse.new 'UIGradient' {
				Transparency = _Computed(
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
				Color = _Computed(
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
			_Fuse.new "TextButton" {
				RichText = true,
				TextColor3 = self.TextColor3,
				LayoutOrder = 2,
				ZIndex = 3,
				Size = UDim2.fromScale(1,1),
				Position = UDim2.fromScale(0.5,0.5),
				AnchorPoint = Vector2.new(0.5,0.5),
				TextTransparency = self.TextTransparency,
				Text = "",
				[_Fuse.Event "Activated"] = function()
					self.Activated:Fire()
				end,
				[_Fuse.Event "MouseButton1Down"] = function(x: any)
					self.MouseButton1Down:Fire()
					
					if not self.IsPressing:Get() and self.TimeSinceLastClick:Get() > 0.8 then
						self.ClickTick:Set(tick())
						self.IsRippling:Set(true)
						task.delay(self.MaxRippleDuration:Get() + 0.2, function()
							pcall(function()
								self.IsRippling:Set(false)
							end)
						end)
						self.IsPressing:Set(true)
					end
		
				end,
				[_Fuse.Event "MouseButton1Up"] = function()
					self.MouseButton1Up:Fire()
					self.IsPressing:Set(false)
				end,
				[_Fuse.Event "InputChanged"] = function()
					self.IsHovering:Set(true)
				end,
				[_Fuse.Event "MouseLeave"] = function()
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
	self.Instance = _Fuse.new("Frame")(parameters)

	self._Maid:GiveTask(self.Instance:WaitForChild("TextButton").MouseButton1Down:Connect(function(x: number)
		local xWidth = self.Instance.AbsoluteSize.X
		local xPos = self.Instance.AbsolutePosition.X
		local clickCenter = (x-xPos)/xWidth
		self.ClickCenter:Set(clickCenter)
	end))

	self:Construct()
	
	return self.Instance
end

return Button