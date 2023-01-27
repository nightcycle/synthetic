--!strict
local SoundService = game:GetService("SoundService")

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
	local Scale = _import(config.Scale, 1)
	local BorderColor3: State<Color3> = _import(config.BorderColor3, Color3.fromHSV(0, 0, 0.4)) :: any
	local BackgroundColor3: State<Color3> = _import(config.BackgroundColor3, Color3.fromHSV(0.6, 1, 1)) :: any
	local Value = config.Value
	local EnableSound: State<Sound?> = _import(config.EnableSound, nil) :: any
	local DisableSound: State<Sound?> = _import(config.DisableSound, nil) :: any

	-- construct signals
	local Activated = Signal.new()
	_Maid:GiveTask(Activated)

	-- init internal states
	local OutputState = (config :: any)[_REF] or _Value(nil :: RadioButton?)
	local BubbleEnabled = _Value(false)
	local Padding = _Computed(function(scale)
		return math.round(6 * scale)
	end, Scale)
	local Width = _Computed(function(scale: number)
		return math.round(scale * 20)
	end, Scale)

	-- bind signal
	_Maid:GiveTask(Activated:Connect(function()
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
		[_REF] = OutputState :: any,
		Name = Name,
		Size = _Computed(function(width: number)
			return UDim2.fromOffset(width * 2, width * 2)
		end, Width),
		BackgroundTransparency = 1,
		[_CHILDREN] = {
			_new("ImageButton")({
				Name = "Button",
				ZIndex = 3,
				BackgroundTransparency = 1,
				ImageTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				[_ON_EVENT("Activated")] = function()
					Activated:Fire()
					if BubbleEnabled:Get() then
						local bubble = Bubble(_Maid)({
							Parent = OutputState :: any,
						})
						local fireFunction: Instance? = bubble:WaitForChild("Fire")
						assert(fireFunction ~= nil and fireFunction:IsA("BindableFunction"))
						fireFunction:Invoke()
					end
				end,
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
				[_CHILDREN] = {
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
						[_CHILDREN] = {
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
	Util.cleanUpPrep(_Maid, Output)

	Util.bindSignal(Output, _Maid, "Activated", Activated)

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
