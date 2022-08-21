--!strict
local package = script.Parent
local packages = package.Parent

local Util = require(package.Util)

local Types = require(package.Types)
type ParameterValue<T> = Types.ParameterValue<T>

local ColdFusion = require(packages.coldfusion)
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>

local Maid = require(packages.maid)
type Maid = Maid.Maid

local EffectGui = require(package:WaitForChild("EffectGui"))

export type BubbleParameters = {
	Name: ParameterValue<string>?,
	Parent: ParameterValue<Instance>?,
	Scale: ParameterValue<number>?,
	BackgroundTransparency: ParameterValue<number>?,
	FinalTransparency: ParameterValue<number>?,
	BackgroundColor3: ParameterValue<Color3>?,
}

export type Bubble = EffectGui.EffectGui

function Constructor(config: BubbleParameters): Bubble
	local _Maid: Maid = Maid.new()
	local _Fuse: Fuse = ColdFusion.fuse(_Maid)
	local _Computed = _Fuse.Computed
	local _Value = _Fuse.Value
	local _import = _Fuse.import
	local _new = _Fuse.new

	local Name = _import(config.Name, script.Name)
	local Parent = _import(config.Parent, nil)
	local Scale = _import(config.Scale, 1.25)
	local BackgroundTransparency = _import(config.BackgroundTransparency, 0.6)
	local FinalTransparency = _import(config.FinalTransparency, 1)
	local BackgroundColor3 = _import(config.BackgroundColor3, Color3.fromHSV(0,0,0.7))
	local Value = _Value(0)
	local ValueTween = Value:Tween(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local parameters: any = {
		Attributes = {
			ClassName = script.Name,
		},
		Name = Name,
		Parent = Parent,
	}

	local Output: any = EffectGui(parameters)
	_Maid:GiveTask(Instance)

	local AbsoluteSize = _Fuse.Attribute(Output, "AbsoluteSize"):Else(Vector2.new(0,0))
	-- local AnchorPosition = _Fuse.Attribute(Output, "AnchorPosition"):Else(UDim2.fromOffset(0,0))
	local CenterPosition = _Fuse.Attribute(Output, "CenterPosition"):Else(UDim2.fromOffset(0,0))

	local bubbleFrame = _new "Frame" {
		Name = "Bubble",
		Parent = Output,
		Position = CenterPosition,
		AnchorPoint = Vector2.new(0.5,0.5),
		BorderSizePixel = 0,
		ZIndex = 1,
		BackgroundColor3 = BackgroundColor3,
		Size = _Computed(function(val, size, scale)
			local diameter = math.max(size.X, size.Y) * val * scale
			return UDim2.fromOffset(diameter,diameter)
		end, ValueTween, AbsoluteSize, Scale),
		BackgroundTransparency = _Computed(function(val, background, max)
			if val == 0 then
				return background
			else
				return max
			end
		end, Value, BackgroundTransparency, FinalTransparency):Tween(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		Children = {
			_new "UICorner" {
				CornerRadius = UDim.new(0.5,0),
			},
		} :: {Instance},
	}
	_Maid:GiveTask(bubbleFrame)

	Util.cleanUpPrep(_Maid, Output)

	Util.bindFunction(Output, _Maid, "Fire", function()
		Value:Set(1)
		task.delay(0.4, function()
			pcall(function()
				Output:Destroy()
			end)
		end)
	end)

	Util.bindFunction(Output, _Maid, "Disable", function()
		Value:Set(1)
	end)

	Util.bindFunction(Output, _Maid, "Enable", function()
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