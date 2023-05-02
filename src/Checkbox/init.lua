--!strict
local SoundService = game:GetService("SoundService")

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

export type CheckboxParameters = Types.FrameParameters & {
	Scale: CanBeState<number>?,
	Value: ValueState<boolean>,
	EnableSound: CanBeState<Sound>?,
	DisableSound: CanBeState<Sound>?,
	TextColor3: CanBeState<Color3>?,
}

export type Checkbox = Frame

function Constructor(config: CheckboxParameters): Checkbox
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
	local Scale = _import(config.Scale, 1)
	local BorderColor3 = _import(config.BorderColor3, Color3.fromHSV(0, 0, 0.4))
	local TextColor3 = _import(config.TextColor3, Color3.fromHSV(0, 0, 0.4))
	local BackgroundColor3 = _import(config.BackgroundColor3, Color3.fromHSV(0.6, 1, 1))
	local Value = config.Value :: any
	local EnableSound: State<Sound?> = _import(config.EnableSound, nil :: Sound?)
	local DisableSound: State<Sound?> = _import(config.DisableSound, nil :: Sound?)

	-- construct signals
	local Activated = Signal.new()
	maid:GiveTask(Activated)

	-- init internal states
	local BubbleEnabled = _Value(false)
	local Padding = _Computed(function(scale: number)
		return math.round(6 * scale)
	end, Scale)
	local Width = _Computed(function(scale: number)
		return math.round(scale * 20)
	end, Scale)
	local TweenColor = _Computed(function(val, borderColor3, backgroundColor3)
		if not val then
			return borderColor3
		else
			return backgroundColor3
		end
	end, Value, BorderColor3, BackgroundColor3):Tween()

	-- bind signals
	maid:GiveTask(Activated:Connect(function()
		if not (Value:Get() == true) then
			local clickSound = EnableSound:Get()
			if clickSound then
				SoundService:PlayLocalSound(clickSound)
			end
		else
			local clickSound = DisableSound:Get()
			if clickSound then
				SoundService:PlayLocalSound(clickSound)
			end
		end
		if Value.Set then
			Value:Set(not Value:Get())
		end
		if BubbleEnabled:Get() == false then
			BubbleEnabled:Set(true)
			task.wait(0.2)
			BubbleEnabled:Set(false)
		end
	end))

	-- assemble final parameters
	local Output: Frame
	local parameters = {
		Name = Name,
		Size = _Computed(function(width: number)
			return UDim2.fromOffset(width * 2, width * 2)
		end, Width),
		BackgroundTransparency = 1,
		Children = {
			_new("ImageButton")({
				Name = "Button",
				ZIndex = 3,
				BackgroundTransparency = 1,
				ImageTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Events = {
					Activated = function()
						Activated:Fire()
						if BubbleEnabled:Get() then
							local bubble = Bubble(maid)({
								Parent = Output,
							})
							local fireFunction: Instance? = bubble:WaitForChild("Fire")
							assert(fireFunction ~= nil and fireFunction:IsA("BindableFunction"))
							fireFunction:Invoke()
							-- maid._bubble = bubble
						end
					end,
				},
			}),
			_new("ImageLabel")({
				Name = "ImageLabel",
				ZIndex = 2,
				Image = "rbxassetid://3926305904",
				ImageRectOffset = Vector2.new(312, 4),
				ImageRectSize = Vector2.new(24, 24),
				ImageColor3 = TextColor3,
				ImageTransparency = _Computed(function(val)
					if val then
						return 0
					else
						return 1
					end
				end, Value):Tween(),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = TweenColor,
				BackgroundTransparency = _Computed(function(val)
					if val then
						return 0
					else
						return 0.999
					end
				end, Value):Tween(),
				Size = _Computed(function(width: number, padding: number)
					return UDim2.fromOffset(width - padding, width - padding)
				end, Width, Padding),
				BorderSizePixel = 0,
				Children = {
					_new("UICorner")({
						CornerRadius = _Computed(function(padding: number)
							return UDim.new(0, math.round(padding * 0.5))
						end, Padding),
					}),
					_new("UIStroke")({
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Thickness = _Computed(function(padding: number)
							return math.round(padding * 0.25)
						end, Padding),
						Transparency = 0,
						Color = TweenColor,
					}),
				} :: { Instance },
			}),
		} :: { Instance },
	}

	config.Scale = nil
	config.Value = nil :: any
	config.EnableSound = nil
	config.DisableSound = nil
	config.TextColor3 = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- Construct final gui
	Output = _new("Frame")(parameters :: any) :: Frame

	-- Bind gui's life to maid
	Util.cleanUpPrep(maid, Output)
	Util.bindSignal(Output, maid, "Activated", Activated)

	return Output
end

return function(maid: Maid?)
	return function(params: CheckboxParameters): Checkbox
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
