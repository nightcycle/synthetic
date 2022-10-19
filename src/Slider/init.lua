--!strict
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local package = script.Parent
local packages = package.Parent

local Util = require(package.Util)

local Types = require(package.Types)

local ColdFusion = require(packages.coldfusion)
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>
type CanBeState<T> = ColdFusion.CanBeState<T>

local Maid = require(packages.maid)
type Maid = Maid.Maid

local Signal = require(packages:WaitForChild("signal"))

local Bubble = require(package:WaitForChild("Bubble"))
local Hint = require(package:WaitForChild("Hint"))

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
	local _Maid = Maid.new()
	local _Fuse = ColdFusion.fuse(_Maid)
	local _new = _Fuse.new
	local _mount = _Fuse.mount
	local _import = _Fuse.import
	local _OUT = _Fuse.OUT
	local _REF = _Fuse.REF
	local _CHILDREN = _Fuse.CHILDREN
	local _ON_EVENT = _Fuse.ON_EVENT
	local _ON_PROPERTY = _Fuse.ON_PROPERTY
	local _Value = _Fuse.Value
	local _Computed = _Fuse.Computed

	-- unload config states
	local Name = _import(config.Name, script.Name)
	local BackgroundColor3 = _import(config.BackgroundColor3, Color3.fromHSV(0,0,0.9))
	local EnabledColor3 = _import(config.EnabledColor3, Color3.fromHSV(0.6,1,1))
	local HintBackgroundColor3 = _import(config.HintBackgroundColor3, Color3.fromHSV(0,0,0.5))
	local TextColor3 = _import(config.TextColor3, Color3.fromHSV(0,0,0.2))
	local TickSound = _import(config.TickSound, nil)
	local EnableSound = _import(config.EnableSound, nil)
	local DisableSound = _import(config.DisableSound, nil)
	local Input = _Value(if typeof(config.Input) == "number" then config.Input elseif typeof(config.Input) == "table" then config.Input:Get() else 5)
	local Minimum = _import(config.Minimum, 0)
	local Maximum = _import(config.Maximum, 10)
	local Increment = _import(config.Increment, 1)
	local BorderSizePixel = _import(config.BorderSizePixel, 4)
	local Padding = _import(config.Padding, UDim.new(0,4))
	local Size = _import(config.Size, UDim2.fromOffset(150,50))
	local BubbleEnabled = _import(config.BubbleEnabled, true)
	local HintEnabled = _import(config.HintEnabled, true)

	-- construct signals
	local OnRelease = Signal.new(); _Maid:GiveTask(OnRelease)

	-- init internal states
	local Dragging = _Value(false)
	local ButtonAbsolutePosition = _Value(Vector2.new(0,0))
	local ButtonAbsoluteSize = _Value(Vector2.new(0,0))
	local Value = _Computed(function(input: number, min: number, max: number, inc: number): number
		local val = input-(input%inc)--math.round(input * inc)/inc
		if val ~= val then val = min end
		return math.clamp(val, min, max)
	end, Input, Minimum, Maximum, Increment)
	local Alpha = _Computed(function(val: number, min: number, max: number)
		return (val - min)/(max-min)
	end, Value, Minimum, Maximum)

	-- bind internal states
	_Maid:GiveTask(Value:Connect(function()
		local tickSound = TickSound:Get()
		if tickSound then
			SoundService:PlayLocalSound(tickSound)
		end
	end))
	local Diameter = _Computed(function(size:UDim2, padding:UDim)
		return size.Y.Offset - padding.Offset*2
	end, Size, Padding)

	-- construct sub-instances
	local Knob: any = _Fuse.new "Frame" {
		Name = "Knob",
		ZIndex = 2,
		Position = _Computed(
			function(val: number): UDim2
				return UDim2.fromScale(val,0.5)
			end,
			Alpha
		),
		AnchorPoint = _Computed(
			function(val: number): Vector2
				return Vector2.new(val,0.5)
			end,
			Alpha
		),
		Size = UDim2.fromScale(1,1),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundTransparency = 1,
		[_CHILDREN] = {
			_Fuse.new "Frame" {
				Name = "Frame",
				ZIndex = 2,
				Position = UDim2.fromScale(0.5,0.5),
				AnchorPoint = Vector2.new(0.5,0.5),
				BackgroundColor3 = EnabledColor3:Tween(),
				Size = _Computed(function(diameter: number)
					return UDim2.fromOffset(diameter,diameter)
				end, Diameter),
				BorderSizePixel = 0,
				[_CHILDREN] = {
					_Fuse.new "UICorner" {
						CornerRadius = _Computed(function(padding: UDim)
							return UDim.new(1,0)
						end, Padding)
					},
					_Fuse.new "UIStroke" {
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Thickness = _Computed(function(padding: UDim)
							return 1--math.round(padding*0.25)
						end, Padding),
						Transparency = 0.8,
					}
				} :: {Instance}
			},
		} :: {Instance}
	}

	local _Hint = Hint(_Maid){
		Parent = Knob,
		Override = true,
		AnchorPoint = Vector2.new(0,-1),
		BackgroundColor3 = HintBackgroundColor3,
		TextColor3 = TextColor3,
		Padding = UDim.new(0,4),
		Enabled = _Computed(function(drag, enab): boolean
			return drag and enab
		end, Dragging, HintEnabled),
		Text = _Computed(function(val): string
			return tostring(val)
		end, Value)
	}

	local Button = _Fuse.new "ImageButton" {
		Name = "Button",
		ZIndex = 3,
		BackgroundTransparency = 1,
		ImageTransparency = 1,
		Position = UDim2.fromScale(0.5,0.5),
		Size = UDim2.fromScale(1,1),
		AnchorPoint = Vector2.new(0.5,0.5),
		[_OUT "AbsolutePosition"] = ButtonAbsolutePosition :: any,
		[_OUT "AbsoluteSize"] = ButtonAbsoluteSize :: any,	
		[_ON_EVENT "MouseButton1Down"] = function()
			Dragging:Set(true)
			if BubbleEnabled:Get() then	
				local bubble = Bubble(_Maid){
					Parent = Knob,
					FinalTransparency = 0.7,
					BackgroundTransparency = 1,
					BackgroundColor3 = EnabledColor3,
					Scale = 1.75,
				}
				_Maid._currentBubble = function()
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

	}

	-- assemble output parameters
	local parameters = {
		Name = Name,
		Size = Size,
		BackgroundTransparency = 1,
		[_CHILDREN] = {
			Button,
			_Fuse.new "Frame" {
				Name = "Frame",
				ZIndex = 1,
				Size = UDim2.fromScale(1,1),
				Position = UDim2.fromScale(0.5,0.5),
				AnchorPoint = Vector2.new(0.5,0.5),
				BackgroundTransparency = 1,
				[_CHILDREN] = {
						_Fuse.new "Frame" {
							Name = "Track",
							ZIndex = 1,
							BackgroundTransparency = 0.5,
							Position = UDim2.fromScale(0.5,0.5),
							AnchorPoint = Vector2.new(0.5,0.5),
							Size = _Computed(function(diameter, bsp)
								return UDim2.new(1, -diameter, 0, bsp)
							end, Diameter, BorderSizePixel),
							BackgroundColor3 = Color3.new(1,1,1),
							[_CHILDREN] = {
								_Fuse.new "UICorner" {
									CornerRadius = UDim.new(0.5,0),
								},
								_Fuse.new "UIGradient" {
									Color = _Computed(function(back, enab, alpha: number)
										local bump = 0.001
										return ColorSequence.new({
											ColorSequenceKeypoint.new(0, enab),
											ColorSequenceKeypoint.new(math.clamp(alpha-bump, bump, 1-bump*2), enab),
											ColorSequenceKeypoint.new(math.clamp(alpha, bump*2, 1-bump), back),
											ColorSequenceKeypoint.new(1, back),
										})
									end, BackgroundColor3, EnabledColor3, Alpha)
								},
							} :: {Instance},
						},
						Knob,
					} :: {Instance},
			},
		} :: {Instance}
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
	local Output: Frame = _Fuse.new("Frame")(parameters) :: any

	_Computed(function(dragging): nil
		_Maid._dragStep = nil
		_Maid._dragRelease = nil
		if dragging then
			_Maid._dragStep = UserInputService.InputChanged:Connect(function(inputObj: InputObject)
				if inputObj.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = Vector2.new(inputObj.Position.X, inputObj.Position.Y)
					local absPos = ButtonAbsolutePosition:Get()
					local absSize = ButtonAbsoluteSize:Get()
					local min = Minimum:Get()
					local max = Maximum:Get()
					Input:Set(min + (max-min)*math.clamp((pos.X - absPos.X)/absSize.X, 0, 1))
				end
			end)
			_Maid._dragRelease = UserInputService.InputEnded:Connect(function(inputObj: InputObject)
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
			_Maid._currentBubble = nil
		end
		return nil
	end, Dragging)

	_Maid:GiveTask(Value:Connect(function(cur)
		Output:SetAttribute("Value", cur)
	end))

	Util.cleanUpPrep(_Maid, Output)

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