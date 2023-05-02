--!strict
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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

local Bubble = require(Package:WaitForChild("Bubble"))
local Hint = require(Package:WaitForChild("Hint"))

export type SliderParameters = Types.FrameParameters & {
	EnabledColor3: CanBeState<Color3>?,
	HintBackgroundColor3: CanBeState<Color3>?,
	TextColor3: CanBeState<Color3>?,
	TickSound: CanBeState<Sound>?,
	EnableSound: CanBeState<Sound>?,
	DisableSound: CanBeState<Sound>?,
	Input: CanBeState<number>?,
	Minimum: CanBeState<number>?,
	Maximum: CanBeState<number>?,
	Increment: CanBeState<number>?,
	Padding: CanBeState<UDim>?,
	BubbleEnabled: CanBeState<boolean>?,
	HintEnabled: CanBeState<boolean>?,
}

export type Slider = Frame

function Constructor(config: SliderParameters): Slider
	-- init workspace
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	-- unload config states
	local Name = _import(config.Name, script.Name)
	local BackgroundColor3 = _import(config.BackgroundColor3, Color3.fromHSV(0, 0, 0.9))
	local EnabledColor3 = _import(config.EnabledColor3, Color3.fromHSV(0.6, 1, 1))
	local HintBackgroundColor3 = _import(config.HintBackgroundColor3, Color3.fromHSV(0, 0, 0.5))
	local TextColor3 = _import(config.TextColor3, Color3.fromHSV(0, 0, 0.2))
	local TickSound = _import(config.TickSound, nil)
	local EnableSound = _import(config.EnableSound, nil)
	local DisableSound = _import(config.DisableSound, nil)
	local Input = _Value(
		if typeof(config.Input) == "number"
			then config.Input
			elseif typeof(config.Input) == "table" then config.Input:Get()
			else 5
	)
	local Minimum = _import(config.Minimum, 0)
	local Maximum = _import(config.Maximum, 10)
	local Increment = _import(config.Increment, 1)
	local BorderSizePixel = _import(config.BorderSizePixel, 4)
	local Padding = _import(config.Padding, UDim.new(0, 4))
	local Size = _import(config.Size, UDim2.fromOffset(150, 50))
	local BubbleEnabled = _import(config.BubbleEnabled, true)
	local HintEnabled = _import(config.HintEnabled, true)

	-- construct signals
	local OnRelease = Signal.new()
	maid:GiveTask(OnRelease)

	-- init internal states
	local Dragging = _Value(false)
	local ButtonAbsolutePosition = _Value(Vector2.new(0, 0))
	local ButtonAbsoluteSize = _Value(Vector2.new(0, 0))
	local Value = _Computed(function(input: number, min: number, max: number, inc: number): number
		local val = input - (input % inc) --math.round(input * inc)/inc
		if val ~= val then
			val = min
		end
		return math.clamp(val, min, max)
	end, Input, Minimum, Maximum, Increment)
	local Alpha = _Computed(function(val: number, min: number, max: number)
		return (val - min) / (max - min)
	end, Value, Minimum, Maximum)

	-- bind internal states
	maid:GiveTask(Value:Connect(function()
		local tickSound = TickSound:Get()
		if tickSound then
			SoundService:PlayLocalSound(tickSound)
		end
	end))
	local Diameter = _Computed(function(size: UDim2, padding: UDim)
		return size.Y.Offset - padding.Offset * 2
	end, Size, Padding)

	-- construct sub-instances
	local Knob: any = _fuse.new("Frame")({
		Name = "Knob",
		ZIndex = 2,
		Position = _Computed(function(val: number): UDim2
			return UDim2.fromScale(val, 0.5)
		end, Alpha),
		AnchorPoint = _Computed(function(val: number): Vector2
			return Vector2.new(val, 0.5)
		end, Alpha),
		Size = UDim2.fromScale(1, 1),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundTransparency = 1,
		Children = {
			_fuse.new("Frame")({
				Name = "Frame",
				ZIndex = 2,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = EnabledColor3:Tween(),
				Size = _Computed(function(diameter: number)
					return UDim2.fromOffset(diameter, diameter)
				end, Diameter),
				BorderSizePixel = 0,
				Children = {
					_fuse.new("UICorner")({
						CornerRadius = _Computed(function(padding: UDim)
							return UDim.new(1, 0)
						end, Padding),
					}),
					_fuse.new("UIStroke")({
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Thickness = _Computed(function(padding: UDim)
							return 1 --math.round(padding*0.25)
						end, Padding),
						Transparency = 0.8,
					}),
				} :: { Instance },
			}),
		} :: { Instance },
	})

	local _Hint = Hint(maid)({
		Parent = Knob,
		Override = true,
		AnchorPoint = Vector2.new(0, -1),
		BackgroundColor3 = HintBackgroundColor3,
		TextColor3 = TextColor3,
		Padding = UDim.new(0, 4),
		Enabled = _Computed(function(drag: boolean, enab: boolean): boolean
			return drag and enab
		end, Dragging, HintEnabled),
		Text = _Computed(function(val): string
			return tostring(val)
		end, Value),
	})

	local Button = _fuse.new("ImageButton")({
		Name = "Button",
		ZIndex = 3,
		BackgroundTransparency = 1,
		ImageTransparency = 1,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Events = {
			MouseButton1Down = function()
				Dragging:Set(true)
				if BubbleEnabled:Get() then
					local bubble = Bubble(maid)({
						Parent = Knob,
						FinalTransparency = 0.7,
						BackgroundTransparency = 1,
						BackgroundColor3 = EnabledColor3,
						Scale = 1.75,
					})
					maid._currentBubble = function()
						if bubble and bubble:IsDescendantOf(game) then
							local destFunction: Instance? = bubble:FindFirstChild("Disable")
							assert(destFunction ~= nil and destFunction:IsA("BindableFunction"))
							if destFunction then
								destFunction:Invoke()
							else
								bubble:Destroy()
							end
						end
					end
					local enabFunction: Instance? = bubble:WaitForChild("Enable")
					assert(enabFunction ~= nil and enabFunction:IsA("BindableFunction"))
					enabFunction:Invoke()
					local enabSound = EnableSound:Get()
					if enabSound then
						SoundService:PlayLocalSound(enabSound)
					end
				end
			end :: any,
		},
		
	}) :: ImageButton

	maid:GiveTask(RunService.RenderStepped:Connect(function()
		ButtonAbsolutePosition:Set(Button.AbsolutePosition)
		ButtonAbsoluteSize:Set(Button.AbsoluteSize)
	end))

	-- assemble output parameters
	local parameters = {
		Name = Name,
		Size = Size,
		BackgroundTransparency = 1,
		Children = {
			Button,
			_fuse.new("Frame")({
				Name = "Frame",
				ZIndex = 1,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Children = {
					_fuse.new("Frame")({
						Name = "Track",
						ZIndex = 1,
						BackgroundTransparency = 0.5,
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Size = _Computed(function(diameter, bsp)
							return UDim2.new(1, -diameter, 0, bsp)
						end, Diameter, BorderSizePixel),
						BackgroundColor3 = Color3.new(1, 1, 1),
						Children = {
							_fuse.new("UICorner")({
								CornerRadius = UDim.new(0.5, 0),
							}),
							_fuse.new("UIGradient")({
								Color = _Computed(function(back, enab, alpha: number)
									local bump = 0.001
									return ColorSequence.new({
										ColorSequenceKeypoint.new(0, enab),
										ColorSequenceKeypoint.new(math.clamp(alpha - bump, bump, 1 - bump * 2), enab),
										ColorSequenceKeypoint.new(math.clamp(alpha, bump * 2, 1 - bump), back),
										ColorSequenceKeypoint.new(1, back),
									})
								end, BackgroundColor3, EnabledColor3, Alpha),
							}),
						} :: { Instance },
					}),
					Knob,
				} :: { Instance },
			}),
		} :: { Instance },
	}

	config.EnabledColor3 = nil
	config.HintBackgroundColor3 = nil
	config.TextColor3 = nil
	config.TickSound = nil
	config.EnableSound = nil
	config.DisableSound = nil
	config.Input = nil
	config.Minimum = nil
	config.Maximum = nil
	config.Increment = nil
	config.Padding = nil
	config.BubbleEnabled = nil
	config.HintEnabled = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- construct output instance
	local Output: Frame = _fuse.new("Frame")(parameters :: any) :: Frame

	_Computed(function(dragging): nil
		maid._dragStep = nil
		maid._dragRelease = nil
		if dragging then
			maid._dragStep = UserInputService.InputChanged:Connect(function(inputObj: InputObject)
				if inputObj.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = Vector2.new(inputObj.Position.X, inputObj.Position.Y)
					local absPos = ButtonAbsolutePosition:Get()
					local absSize = ButtonAbsoluteSize:Get()
					local min = Minimum:Get()
					local max = Maximum:Get()
					Input:Set(min + (max - min) * math.clamp((pos.X - absPos.X) / absSize.X, 0, 1))
				end
			end)
			maid._dragRelease = UserInputService.InputEnded:Connect(function(inputObj: InputObject)
				if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
					Dragging:Set(false)
					OnRelease:Fire(Value:Get())
				end
			end)
		else
			local disabSound = DisableSound:Get()
			if disabSound then
				SoundService:PlayLocalSound(disabSound)
			end
			maid._currentBubble = nil
		end
		return nil
	end, Dragging)

	maid:GiveTask(Value:Connect(function(cur)
		Output:SetAttribute("Value", cur)
	end))

	Util.cleanUpPrep(maid, Output)

	return Output
end

return function(maid: Maid?)
	return function(params: SliderParameters): Slider
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
