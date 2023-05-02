--!strict
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)

local Util = require(Package:WaitForChild("Util"))

local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>
type CanBeState<T> = ColdFusion.CanBeState<T>

local Maid = require(Packages:WaitForChild("Maid"))
type Maid = Maid.Maid

local EffectGui = require(Package:WaitForChild("EffectGui"))

export type BubbleParameters = {
	Name: CanBeState<string>?,
	Parent: CanBeState<Instance>?,
	Scale: CanBeState<number>?,
	BackgroundTransparency: CanBeState<number>?,
	FinalTransparency: CanBeState<number>?,
	BackgroundColor3: CanBeState<Color3>?,
}

export type Bubble = EffectGui.EffectGui

function Constructor(config: BubbleParameters): Bubble
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
	local Parent = _import(config.Parent, nil)
	local Scale = _import(config.Scale, 1.25)
	local BackgroundTransparency = _import(config.BackgroundTransparency, 0.6)
	local FinalTransparency = _import(config.FinalTransparency, 1)
	local BackgroundColor3 = _import(config.BackgroundColor3, Color3.fromHSV(0, 0, 0.7))

	-- init internal states
	local Value = _Value(0)
	local ValueTween = Value:Tween(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local AbsoluteSize = _Value(Vector2.new(0, 0))
	local CenterPosition = _Value(UDim2.fromOffset(0, 0))

	-- construct internal instances
	local bubbleFrame = _new("Frame")({
		Name = "Bubble",
		Position = CenterPosition,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		ZIndex = 1,
		BackgroundColor3 = BackgroundColor3,
		Size = _Computed(function(val: number, size: Vector2, scale: number)
			local diameter = math.max(size.X, size.Y) * val * scale
			return UDim2.fromOffset(diameter, diameter)
		end, ValueTween, AbsoluteSize, Scale),
		BackgroundTransparency = _Computed(function(val: number, background: number, max: number)
			if val == 0 then
				return background
			else
				return max
			end
		end, Value, BackgroundTransparency, FinalTransparency):Tween(
			0.3,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.In
		),
		Children = {
			_new("UICorner")({
				CornerRadius = UDim.new(0.5, 0),
			}),
		} :: { Instance },
	})
	maid:GiveTask(bubbleFrame)

	-- construct output instance
	local Output: ScreenGui = EffectGui(maid)({
		Name = Name,
		Parent = Parent,
	} :: any)
	bubbleFrame.Parent = Output
	Util.cleanUpPrep(maid, Output)

	-- bind states to attributes
	maid:GiveTask(Output:GetAttributeChangedSignal("AbsoluteSize"):Connect(function()
		AbsoluteSize:Set(Output:GetAttribute("AbsoluteSize") or Vector2.new(0, 0))
	end))
	AbsoluteSize:Set(Output:GetAttribute("AbsoluteSize") or Vector2.new(0, 0))
	maid:GiveTask(Output:GetAttributeChangedSignal("CenterPosition"):Connect(function()
		CenterPosition:Set(Output:GetAttribute("CenterPosition") or UDim2.fromOffset(0, 0))
	end))
	CenterPosition:Set(Output:GetAttribute("CenterPosition") or UDim2.fromOffset(0, 0))

	-- bind functions to output
	Util.bindFunction(Output, maid, "Fire", function()
		Value:Set(1)
		task.delay(0.4, function()
			pcall(function()
				Output:Destroy()
			end)
		end)
	end)
	Util.bindFunction(Output, maid, "Enable", function()
		Value:Set(1)
	end)
	Util.bindFunction(Output, maid, "Disable", function()
		Value:Set(0)
		task.delay(0.4, function()
			pcall(function()
				Output:Destroy()
			end)
		end)
	end)

	return Output
end

return function(maid: Maid?)
	return function(params: BubbleParameters): Bubble
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
