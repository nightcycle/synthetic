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

export type EffectGuiParameters = Types.ScreenGuiParameters & {}

export type EffectGui = ScreenGui

function Constructor(config: EffectGuiParameters): EffectGui
	local _Maid: Maid = Maid.new()
	local _Fuse: Fuse = ColdFusion.fuse(_Maid)
	local _Computed = _Fuse.Computed
	local _Value = _Fuse.Value
	local _import = _Fuse.import
	local _new = _Fuse.new
	
	local Name = _import(config.Name, script.Name)
	local Par: any = _import(config.Parent, nil); local Parent: State<Instance?> = Par
	local Enabled = _Value(if typeof(config.Enabled) == "boolean" then config.Enabled elseif typeof(config.Enabled) == "table" then config.Enabled:Get() else false)
	local ZIndexBehavior = _import(config.ZIndexBehavior, Enum.ZIndexBehavior.Sibling)
	local ParentAnchorPoint: State<Vector2> = _Fuse.Property(Parent, "AnchorPoint"):Else(Vector2.new(0,0))
	local AbsolutePosition: State<Vector2> = _Fuse.Property(Parent, "AbsolutePosition", 60):Else(Vector2.new(0,0))
	local AbsoluteSize: State<Vector2> = _Fuse.Property(Parent, "AbsoluteSize", 60):Else(Vector2.new(0,0))
	
	local Position: State<UDim2> = _Computed(function(absPos): UDim2
		absPos = absPos or Vector2.new(0,0)
		return UDim2.fromOffset(absPos.X, absPos.Y)
	end, AbsolutePosition):Else(UDim2.fromOffset(0,0))

	local AnchorPosition: State<UDim2> = _Computed(function(absPos, absSize, anchorPoint): UDim2
		absPos = absPos or Vector2.new(0,0)
		absSize = absSize or Vector2.new(0,0)
		anchorPoint = anchorPoint or Vector2.new(0,0)
		return UDim2.fromOffset(absPos.X+anchorPoint.X*absSize.X, absPos.Y+anchorPoint.Y*absSize.Y)
	end, AbsolutePosition, AbsoluteSize, ParentAnchorPoint):Else(UDim2.fromOffset(0,0))

	local CenterPosition: State<UDim2> = _Computed(function(absPos, absSize, anchorPoint): UDim2
		absPos = absPos or Vector2.new(0,0)
		absSize = absSize or Vector2.new(0,0)
		return UDim2.fromOffset(absPos.X+0.5*absSize.X, absPos.Y+0.5*absSize.Y)
	end, AbsolutePosition, AbsoluteSize):Else(Vector2.new(0,0))

	local Size: State<UDim2> = _Computed(function(absSize)
		absSize = absSize or Vector2.new(0,0)
		return UDim2.fromOffset(absSize.X, absSize.Y)
	end, AbsoluteSize):Else(UDim2.fromOffset(0,0))
	
	local _KnownAncestorGui: ValueState<any> = _Value(nil)
	local Output: ScreenGui
	local _AncestorGui = _Computed(function(known: ScreenGui?): any
		if not Output then return end
		local expected: ScreenGui? = Output:FindFirstAncestorWhichIsA("ScreenGui")
		if known == expected then
			return expected
		elseif known ~= nil then
			return known
		else
			return expected
		end
	end, _KnownAncestorGui)
	local AncestorDisplayOrder = _Fuse.Property(_AncestorGui, "DisplayOrder")

	local DisplayOrder = _Computed(function(gui: ScreenGui?, displayOrder: number)
		if not gui then return 1000 end
		assert(gui ~= nil and gui:IsA("ScreenGui"))
		return (displayOrder or gui.DisplayOrder) + 1
	end, _AncestorGui, AncestorDisplayOrder)

	local parameters: any = {
		Name = Name,
		DisplayOrder = DisplayOrder,
		Enabled = Enabled,
		ZIndexBehavior = ZIndexBehavior,
		Parent = Parent,
		Attributes = {
			ClassName = script.Name,
			Position = Position,
			AnchorPosition = AnchorPosition,
			CenterPosition = CenterPosition,
			Size = Size,
		},
		Children = {
			_Fuse.new "Frame" {
				BackgroundTransparency = 1,
				Size = _Computed(function(absSize)
					if not absSize then return UDim2.fromOffset(0,0) end
					return UDim2.fromOffset(absSize.X, absSize.Y)
				end, AbsoluteSize),
				Position = _Computed(function(absPos)
					if not absPos then return UDim2.fromOffset(0,0) end
					return UDim2.fromOffset(absPos.X, absPos.Y)
				end, AbsolutePosition),
			}
		} :: {Instance}
	}
	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	Output = _Fuse.new("ScreenGui")(parameters)
	Util.cleanUpPrep(_Maid, Output)

	if Output:FindFirstAncestorWhichIsA("ScreenGui") then
		_KnownAncestorGui:Set(Output:FindFirstAncestorWhichIsA("ScreenGui"))
	end
	_Maid:GiveTask(Output.AncestryChanged:Connect(function(ancestor)
		_KnownAncestorGui:Set(Output:FindFirstAncestorWhichIsA("ScreenGui"))
	end))

	return Output
end


return function(maid: Maid?)
	return function(params: EffectGuiParameters): EffectGui
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end