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

export type SwitchParameters = Types.FrameParameters & {
	Scale: CanBeState<number>?,
	EnabledColor3: CanBeState<Color3>?,
	Value: ValueState<boolean>,
	EnableSound: CanBeState<Sound>?,
	DisableSound: CanBeState<Sound>?,
	BubbleEnabled: CanBeState<boolean>?,
}

export type Switch = Frame

function Constructor(config: SwitchParameters): Switch
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
	local BackgroundColor3 = _import(config.BackgroundColor3, Color3.fromHSV(0, 0, 0.9))
	local EnabledColor3 = _import(config.EnabledColor3, Color3.fromHSV(0.6, 1, 1))
	local Value = config.Value :: any
	local ES: any = _import(config.EnableSound, nil)
	local EnableSound: State<Sound?> = ES
	local DS: any = _import(config.DisableSound, nil)
	local DisableSound: State<Sound?> = DS
	local BubbleEnabled = _Value(
		if typeof(config.BubbleEnabled) == "boolean"
			then config.BubbleEnabled
			elseif typeof(config.BubbleEnabled) == "table" then config.BubbleEnabled:Get()
			else false
	)

	-- construct signals
	local Activated = Signal.new()
	maid:GiveTask(Activated)

	-- init internal states
	local Padding = _Computed(function(scale)
		return math.round(6 * scale)
	end, Scale)
	local Width = _Computed(function(scale: number)
		return math.round(scale * 20)
	end, Scale)
	local ActiveColor3 = _Computed(function(val: boolean, back: Color3, col: Color3): Color3
		if val then
			return col
		else
			return back
		end
	end, Value, BackgroundColor3, EnabledColor3)

	-- bind states
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

	-- construct sub-instances
	local Knob = _new("Frame")({
		Name = "Knob",
		ZIndex = 2,
		Position = _Computed(function(val)
			if val then
				return UDim2.fromScale(1, 0.5)
			else
				return UDim2.fromScale(0, 0.5)
			end
		end, Value):Tween(),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundTransparency = 1,
		Children = {
			_new("Frame")({
				Name = "Frame",
				ZIndex = 2,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = ActiveColor3:Tween(),
				Size = _Computed(function(width: number, padding: number)
					return UDim2.fromOffset(width - padding, width - padding)
				end, Width, Padding),
				BorderSizePixel = 0,
				Children = {
					_new("UICorner")({
						CornerRadius = _Computed(function(padding)
							return UDim.new(1, 0)
						end, Padding),
					}),
					_new("UIStroke")({
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Thickness = _Computed(function(padding)
							return 1 --math.round(padding*0.25)
						end, Padding),
						Transparency = 0.8,
					}),
				} :: { Instance },
			}),
		} :: { Instance },
	})

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
								Parent = Knob,
								-- BackgroundColor3 = ActiveColor3,
								-- BackgroundTransparency = 0.6,
							})
	
							local fireFunction = bubble:FindFirstChild("Fire")
							assert(fireFunction ~= nil and fireFunction:IsA("BindableFunction"))
							fireFunction:Invoke()
						end
					end,
				},

			}),
			_new("Frame")({
				Name = "Frame",
				ZIndex = 1,
				Size = _Computed(function(width: number, padding: number)
					local w = width - padding * 2
					return UDim2.new(0, 2 * w, 1, 0)
				end, Width, Padding),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Children = {
					_new("Frame")({
						Name = "Track",
						ZIndex = 1,
						BackgroundTransparency = 0.5,
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Size = _Computed(function(width: number, padding: number)
							local w = math.round(width - padding * 1.75)
							return UDim2.new(1, 0, 0, w)
						end, Width, Padding),
						BackgroundColor3 = _Computed(function(val, col)
							local h, _s, _v = col:ToHSV()
							if val then
								return Color3.fromHSV(h, 0.5, 1)
							else
								return Color3.fromHSV(h, 0, 1)
							end
						end, Value, EnabledColor3):Tween(),
						Children = {
							_new("UICorner")({
								CornerRadius = UDim.new(0.5, 0),
							}),
						} :: { Instance },
					}),
					Knob,
				} :: { Instance },
			}),
		} :: { Instance },
	}

	config.Scale = nil
	config.EnabledColor3 = nil
	config.Value = nil :: any
	config.EnableSound = nil
	config.DisableSound = nil
	config.BubbleEnabled = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- construct output instance
	local Output: Frame = _new("Frame")(parameters) :: any
	Util.cleanUpPrep(maid, Output)
	Util.bindSignal(Output, maid, "Activated", Activated)

	return Output
end

return function(maid: Maid?)
	return function(params: SwitchParameters): Switch
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
