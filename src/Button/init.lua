--!strict
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)

local Util = require(Package:WaitForChild("Util"))
local Types = require(Package:WaitForChild("Types"))

local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>
type CanBeState<T> = ColdFusion.CanBeState<T>

local Maid = require(Packages:WaitForChild("Maid"))
type Maid = Maid.Maid

local Signal = require(Packages:WaitForChild("Signal"))

local TextLabel = require(Package:WaitForChild("TextLabel"))

export type ButtonParameters = Types.FrameParameters & {
	Padding: CanBeState<UDim>?,
	CornerRadius: CanBeState<UDim>?,
	TextSize: CanBeState<number>?,
	IconScale: CanBeState<number>?,
	TextColor3: CanBeState<Color3>?,
	Font: CanBeState<Font>?,
	SelectedTextColor3: CanBeState<Color3>?,
	HoverTextColor3: CanBeState<Color3>?,
	BorderTransparency: CanBeState<number>?,
	BackgroundTransparency: CanBeState<number>?,
	SelectedBackgroundColor3: CanBeState<Color3>?,
	HoverBackgroundColor3: CanBeState<Color3>?,
	TextTransparency: CanBeState<number>?,
	TextXAlignment: CanBeState<Enum.TextXAlignment>?,
	TextYAlignment: CanBeState<Enum.TextYAlignment>?,
	Text: CanBeState<string>?,
	LeftIcon: CanBeState<string>?,
	RightIcon: CanBeState<string>?,
	ClickSound: CanBeState<Sound>?,
	TextOnly: CanBeState<boolean>?,
	IsSelected: CanBeState<boolean>?,
}

export type Button = Frame

function Constructor(config: ButtonParameters): Button
	-- init workspace
	local maid: Maid = Maid.new()
	local _fuse: Fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	-- unload config states
	local Name = _import(config.Name, script.Name)
	local Padding = _import(config.Padding, UDim.new(0, 2))
	local CornerRadius = _import(config.CornerRadius, UDim.new(0, 4))
	local TextSize = _import(config.TextSize, 14)
	local Size: State<Vector2?> = _import(config.Size, nil :: Vector2?)
	local IconScale = _import(config.IconScale, 1.25)
	local BorderSizePixel = _import(config.BorderSizePixel, 3)
	local TextColor3 = _import(config.TextColor3, Color3.new(0.2, 0.2, 0.2))
	local FontFace = _import(config.Font, Font.fromEnum(Enum.Font.GothamBold))
	local SelectedTextColor3 = _import(config.SelectedTextColor3, Color3.new(1, 1, 1))
	local HoverTextColor3 = _import(config.HoverTextColor3, Color3.new(0.2, 0.2, 0.2))
	local BackgroundColor3 = _import(config.BackgroundColor3, Color3.fromHSV(0.7, 0, 1))
	local BorderColor3 = _import(config.BorderColor3, Color3.fromHSV(0.7, 0, 0.3))
	local SelectedBackgroundColor3 = _import(config.SelectedBackgroundColor3, Color3.fromHSV(0.7, 0.7, 1))
	local HoverBackgroundColor3: State<Color3> = _import(
		config.HoverBackgroundColor3,
		_Computed(function(sCol: Color3, bCol: Color3): Color3
			local h1, s1, v1 = sCol:ToHSV()
			local _, s2, v2 = bCol:ToHSV()
			return Color3.fromHSV(h1, s1 + (s2 - s1) * 0.5, v1 + (v2 - v1) * 0.5)
		end, SelectedBackgroundColor3, BackgroundColor3)
	) :: any
	local BackgroundTransparency: State<number> = _import(config.BackgroundTransparency, 0) :: any
	local TextTransparency = _import(config.TextTransparency, 0)
	local TextXAlignment = _import(config.TextXAlignment, Enum.TextXAlignment.Center)
	local TextYAlignment = _import(config.TextYAlignment, Enum.TextYAlignment.Center)
	local Text = _import(config.Text, "")
	local LeftIcon = _import(config.LeftIcon, "")
	local RightIcon = _import(config.RightIcon, "")
	local TextOnly = _import(config.TextOnly, false)
	local IsSelected: ValueState<boolean> = if config.IsSelected
		then if typeof(config.IsSelected) == "table" then config.IsSelected else _Value(config.IsSelected)
		else _Value(false) :: any
	local ClickSound = _import(config.ClickSound, nil)

	-- init signals
	local Activated = Signal.new()
	maid:GiveTask(Activated)
	local MouseButton1Down = Signal.new()
	maid:GiveTask(MouseButton1Down)
	local MouseButton1Up = Signal.new()
	maid:GiveTask(MouseButton1Up)
	local InputBegan = Signal.new()
	maid:GiveTask(InputBegan)
	local InputEnded = Signal.new()
	maid:GiveTask(InputEnded)

	-- init internal states
	local IsHovering = _Value(false)
	local IsRippling = _Value(false)
	local ClickCenter = _Value(0.5)
	local ClickTick = _Value(0)
	local MaxRippleDuration = _Value(0.4)
	local TimeSinceLastClick = _Value(tick())
	local ActiveBorderColor3 = _Computed(function(trans, border, background)
		if trans == 0 then
			return background
		else
			return border
		end
	end, BackgroundTransparency, BorderColor3, BackgroundColor3)
	local ActiveBorderTransparency = _Computed(function(backTrans)
		if backTrans == 0 then
			return 1
		else
			return 0
		end
	end, BackgroundTransparency)
	local RippleAlpha = _Computed(function(timeSince: number, dur: number)
		return math.clamp(timeSince / dur, 0, 1)
	end, TimeSinceLastClick, MaxRippleDuration)
	local bump = 0.01
	local LeftRippleAlpha = _Computed(function(alpha: number, center: number)
		return math.clamp(center - alpha, bump * 2, 1 - bump * 2)
	end, RippleAlpha, ClickCenter)
	local RightRippleAlpha = _Computed(function(alpha: number, center: number)
		return math.clamp(center + alpha, bump * 2, 1 - bump * 2)
	end, RippleAlpha, ClickCenter)
	local eDir = Enum.EasingDirection.InOut
	local eSty = Enum.EasingStyle.Quad
	local TimeKeys = _Computed(function(centerAlpha: number, leftAlpha: number, rightAlpha: number)
		leftAlpha =
			math.clamp(TweenService:GetValue(leftAlpha, eSty, eDir), bump, math.max(centerAlpha - bump, bump * 2))
		rightAlpha = math.clamp(
			TweenService:GetValue(rightAlpha, eSty, eDir),
			math.min(centerAlpha + bump, 1 - bump * 2),
			1 - bump
		)
		return {
			0,
			math.clamp(leftAlpha - bump, bump, math.clamp(centerAlpha - bump * 2, bump * 2, 1 - bump * 5)),
			math.clamp(leftAlpha, bump * 2.5, math.clamp(centerAlpha - bump, bump * 3, 1 - bump * 4)),
			math.clamp(rightAlpha, math.clamp(centerAlpha + bump, bump * 4, 1 - bump * 3), 1 - bump * 2),
			math.clamp(rightAlpha + bump, math.clamp(centerAlpha + bump * 2, bump * 5, 1 - bump * 2), 1 - bump),
			1,
		}
	end, ClickCenter, LeftRippleAlpha, RightRippleAlpha)
	local LabelAbsoluteSize = _Value(Vector2.new(0, 0))
	local ButtonSize = _Computed(function(padding: UDim, absSize: Vector2, size: Vector2?): UDim2
		if size then
			return UDim2.fromOffset(size.X, size.Y)
		end
		absSize = absSize or Vector2.new(0, 0)
		local fullSize = absSize + Vector2.new(1, 1) * padding.Offset * 2
		return UDim2.fromOffset(fullSize.X, fullSize.Y)
	end, Padding, LabelAbsoluteSize, Size)
	local ActiveBackgroundColor = _Computed(
		function(
			isPressing: boolean,
			isRippling: boolean,
			isHovering: boolean,
			backgroundColor: Color3,
			hoverColor: Color3,
			selColor: Color3
		)
			if isHovering or isRippling then
				return hoverColor
			elseif isPressing then
				return selColor
			else
				return backgroundColor
			end
		end,
		IsSelected,
		IsRippling,
		IsHovering,
		BackgroundColor3,
		HoverBackgroundColor3,
		SelectedBackgroundColor3
	):Tween(0.15)
	local ActiveFillColor = _Computed(function(isPressing, isRipple, hoverColor, selectedColor)
		if isPressing or isRipple then
			return selectedColor
		else
			return hoverColor
		end
	end, IsSelected, IsRippling, ActiveBackgroundColor, SelectedBackgroundColor3):Tween(0.1)

	-- bind signals
	maid:GiveTask(Activated:Connect(function()
		local clickSound = ClickSound:Get()
		if clickSound then
			SoundService:PlayLocalSound(clickSound)
		end
	end))

	-- construct sub-instances
	local TextLabel = TextLabel(maid)({
		BackgroundTransparency = 1,
		TextTransparency = TextTransparency,
		ZIndex = 2,
		FontFace = FontFace,
		Padding = Padding,
		TextSize = TextSize,
		TextColor3 = _Computed(function(hover, press, ripple, textColor3, hoverColor, selColor)
			if press or ripple then
				return selColor
			elseif hover then
				return hoverColor
			end
			return textColor3
		end, IsHovering, IsSelected, IsRippling, TextColor3, HoverTextColor3, SelectedTextColor3):Tween(0.2),
		TextXAlignment = TextXAlignment,
		TextYAlignment = TextYAlignment,

		Text = Text,
		IconScale = IconScale,
		LeftIcon = LeftIcon,
		RightIcon = RightIcon,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	})
	maid:GiveTask(RunService.RenderStepped:Connect(function(deltaTime: number)
		LabelAbsoluteSize:Set(TextLabel.AbsoluteSize)
	end))

	local TextButton: TextButton = _fuse.new("TextButton")({
		RichText = true,
		TextColor3 = TextColor3,
		LayoutOrder = 2,
		ZIndex = 3,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextTransparency = TextTransparency,
		Text = "",
		Events = {
			Activated = function()
				Activated:Fire()
			end,
			MouseButton1Down = function(x: any)
				MouseButton1Down:Fire()
	
				if not IsSelected:Get() and TimeSinceLastClick:Get() > 0.8 then
					ClickTick:Set(tick())
					IsRippling:Set(true)
					task.delay(MaxRippleDuration:Get() + 0.2, function()
						pcall(function()
							IsRippling:Set(false)
						end)
					end)
					if IsSelected.Set then
						local ValSelect: any = IsSelected
						ValSelect:Set(true)
					end
					-- IsSelected:Set(true)
				end
			end,
			MouseButton1Up = function()
				MouseButton1Up:Fire()
				if IsSelected.Set then
					local ValSelect: any = IsSelected
					ValSelect:Set(false)
				end
			end,
			InputChanged = function()
				IsHovering:Set(true)
			end,
			MouseLeave = function()
				IsHovering:Set(false)
			end,
		},

		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
	}) :: any

	-- assemble final parameters
	local parameters: any = {
		Name = Name,
		Size = ButtonSize,
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = _Computed(function(textOnly)
			if textOnly then
				return 1
			else
				return 0
			end
		end, TextOnly),
		Children = {
			_fuse.new("UICorner")({
				CornerRadius = CornerRadius,
			}),
			_fuse.new("UIPadding")({
				PaddingBottom = Padding,
				PaddingTop = Padding,
				PaddingLeft = Padding,
				PaddingRight = Padding,
			}),
			_fuse.new("UIStroke")({
				Transparency = ActiveBorderTransparency,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Thickness = _Computed(function(textOnly, bSizePix)
					if textOnly then
						return 0
					else
						return bSizePix
					end
				end, TextOnly, BorderSizePixel),
				Color = _Computed(function(border, fill, back, hover, press)
					if press then
						return fill
					elseif hover then
						return back
					else
						return border
					end
				end, ActiveBorderColor3, ActiveFillColor, ActiveBackgroundColor, IsHovering, IsSelected),
			}),
			_fuse.new("UIGradient")({
				Transparency = _Computed(
					function(hover: boolean, press: boolean, ripple: boolean, defTrans: number, timeKeys: { number })
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
							return NumberSequence.new({ k1, k2, k3, k4, k5, k6 })
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
					end,
					IsHovering,
					IsSelected,
					IsRippling,
					BackgroundTransparency,
					TimeKeys
				),
				Color = _Computed(function(hover, press, ripple, backColor, selColor, timeKeys)
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
						return ColorSequence.new({ k1, k2, k3, k4, k5, k6 })
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
				end, IsHovering, IsSelected, IsRippling, ActiveBackgroundColor, ActiveFillColor, TimeKeys),
			}),
			TextButton,
			TextLabel,
		} :: { Instance },
	}
	config.BorderTransparency = nil
	config.Padding = nil
	config.CornerRadius = nil
	config.TextSize = nil
	config.IconScale = nil
	config.TextColor3 = nil
	config.FontFace = nil
	config.SelectedTextColor3 = nil
	config.HoverTextColor3 = nil
	config.SelectedBackgroundColor3 = nil
	config.HoverBackgroundColor3 = nil
	config.TextTransparency = nil
	config.TextXAlignment = nil
	config.TextYAlignment = nil
	config.Text = nil
	config.IsSelected = nil
	config.LeftIcon = nil
	config.RightIcon = nil
	config.ClickSound = nil
	config.TextOnly = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	maid:GiveTask(RunService.RenderStepped:Connect(function(dt)
		TimeSinceLastClick:Set(tick() - ClickTick:Get())
	end))

	-- construct output instance
	local Output: Frame = _fuse.new("Frame")(parameters) :: any
	Util.bindSignal(Output, maid, "MouseButton1Down", MouseButton1Down)
	Util.bindSignal(Output, maid, "MouseButton1Up", MouseButton1Up)
	Util.bindSignal(Output, maid, "Activated", Activated)

	maid:GiveTask(TextButton.MouseButton1Down:Connect(function(x: number)
		local xWidth = Output.AbsoluteSize.X
		local xPos = Output.AbsolutePosition.X
		local clickCenter = (x - xPos) / xWidth
		ClickCenter:Set(clickCenter)
	end))

	Util.cleanUpPrep(maid, Output)

	return Output
end

return function(maid: Maid?)
	return function(params: ButtonParameters): Button
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
