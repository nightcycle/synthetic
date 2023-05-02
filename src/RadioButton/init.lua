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

local RadioButton = {}
RadioButton.__index = RadioButton

export type RadioButtonParameters = Types.FrameParameters & {
	Scale: CanBeState<number>?,
	BorderColor3: CanBeState<Color3>?,
	BackgroundColor3: CanBeState<Color3>?,
	Value: ValueState<boolean>,
	EnableSound: CanBeState<Sound>?,
	DisableSound: CanBeState<Sound>?,
}

export type RadioButton = Frame

function Constructor(config: RadioButtonParameters): RadioButton
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
	local Scale = _import(config.Scale, 1)
	local BorderColor3: State<Color3> = _import(config.BorderColor3, Color3.fromHSV(0, 0, 0.4)) :: any
	local BackgroundColor3: State<Color3> = _import(config.BackgroundColor3, Color3.fromHSV(0.6, 1, 1)) :: any
	local Value = config.Value
	local EnableSound: State<Sound?> = _import(config.EnableSound, nil) :: any
	local DisableSound: State<Sound?> = _import(config.DisableSound, nil) :: any

	-- construct signals
	local Activated = Signal.new()
	maid:GiveTask(Activated)

	-- init internal states
	local OutputState = _Value(nil :: RadioButton?)
	local BubbleEnabled = _Value(false)
	local Padding = _Computed(function(scale)
		return math.round(6 * scale)
	end, Scale)
	local Width = _Computed(function(scale: number)
		return math.round(scale * 20)
	end, Scale)

	-- bind Signal
	maid:GiveTask(Activated:Connect(function()
		if Value:Get() == true then
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
	local parameters: any = {
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
								Parent = OutputState :: any,
							})
							local fireFunction: Instance? = bubble:WaitForChild("Fire")
							assert(fireFunction ~= nil and fireFunction:IsA("BindableFunction"))
							fireFunction:Invoke()
						end
					end,
				},
			}),
			_new("Frame")({
				Name = "Frame",
				ZIndex = 2,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = BackgroundColor3,
				BackgroundTransparency = 0.999,
				Size = _Computed(function(width: number, padding: number)
					return UDim2.fromOffset(width - padding, width - padding)
				end, Width, Padding),
				BorderSizePixel = 0,
				Children = {
					_new("Frame")({
						Name = "Fill",
						Size = _Computed(function(width: number, padding: number): UDim2
							local w = math.round(width - padding * 2)
							return UDim2.fromOffset(w, w)
						end, Width, Padding),
						BackgroundColor3 = BackgroundColor3,
						BackgroundTransparency = _Computed(function(val)
							if val then
								return 0
							else
								return 1
							end
						end, Value):Tween(),
						Children = {
							_new("UICorner")({
								CornerRadius = _Computed(function(padding)
									return UDim.new(1, 0)
								end, Padding),
							}),
						} :: { Instance },
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
					}),
					_new("UICorner")({
						CornerRadius = _Computed(function(padding)
							return UDim.new(1, 0)
						end, Padding),
					}),
					_new("UIStroke")({
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Thickness = _Computed(function(padding: number)
							return math.round(padding * 0.25)
						end, Padding),
						Transparency = 0,
						Color = _Computed(function(val: boolean, border: Color3, background: Color3)
							if val then
								return background
							else
								return border
							end
						end, Value, BorderColor3, BackgroundColor3):Tween(),
					}),
				} :: { Instance },
			}),
		} :: { Instance },
	}

	config.Scale = nil
	config.BorderColor3 = nil
	config.BackgroundColor3 = nil
	config.Value = nil :: any
	config.EnableSound = nil
	config.DisableSound = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- construct output instance
	local Output = _new("Frame")(parameters) :: any
	OutputState:Set(Output)
	Util.cleanUpPrep(maid, Output)

	Util.bindSignal(Output, maid, "Activated", Activated)

	return Output
end

return function(maid: Maid?)
	return function(params: RadioButtonParameters): RadioButton
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
