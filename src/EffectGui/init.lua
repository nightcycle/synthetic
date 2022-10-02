--!strict
local RunService = game:GetService("RunService")

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

export type EffectGuiParameters = Types.ScreenGuiParameters & {}

export type EffectGui = ScreenGui

function Constructor(config: EffectGuiParameters): EffectGui
	-- init workspace
	local _Maid: Maid = Maid.new()
	local _Fuse: Fuse = ColdFusion.fuse(_Maid)

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
	local Parent: State<GuiObject?> = _import(config.Parent, nil) :: any
	local Enabled = _Value(if typeof(config.Enabled) == "boolean" then config.Enabled elseif typeof(config.Enabled) == "table" then config.Enabled:Get() else true)
	local ZIndexBehavior = _import(config.ZIndexBehavior, Enum.ZIndexBehavior.Sibling)
	
	-- init internal states
	local OutputState = (config :: any)[_REF] or _Value(nil :: ScreenGui?)
	local AncestorDisplayOrder = _Value(0)
	local ParentAnchorPoint: ValueState<Vector2> = _Value(Vector2.new(0,0))
	local AbsolutePosition: ValueState<Vector2> = _Value(Vector2.new(0,0))
	local AbsoluteSize: ValueState<Vector2> = _Value(Vector2.new(0,0))
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
	end, AbsolutePosition, AbsoluteSize):Else(UDim2.new(0,0))
	local Size: State<UDim2> = _Computed(function(absSize)
		absSize = absSize or Vector2.new(0,0)
		return UDim2.fromOffset(absSize.X, absSize.Y)
	end, AbsoluteSize):Else(UDim2.fromOffset(0,0))
	local _KnownAncestorGui: ValueState<ScreenGui?> = _Value(nil :: ScreenGui?)
	local _AncestorGui = _Computed(function(known: ScreenGui?, output: ScreenGui?): ScreenGui?
		if not output then return end
		assert(output ~= nil)
		local expected: ScreenGui? = output:FindFirstAncestorWhichIsA("ScreenGui")
		local result
		if known == expected then

			result = expected
		elseif known ~= nil then

			result = known
		else

			result = expected
		end
		if result then
			_Maid.onAncestorDisplayChange = result:GetPropertyChangedSignal("DisplayOrder"):Connect(function()
				AncestorDisplayOrder:Set(result.DisplayOrder)
			end)
			AncestorDisplayOrder:Set(result.DisplayOrder)
		else
			AncestorDisplayOrder:Set(0)
		end
		return result
	end, _KnownAncestorGui, OutputState)
	local DisplayOrder = _Computed(function(gui: ScreenGui?, displayOrder: number)
		if not gui then return 1000 end
		assert(gui ~= nil and gui:IsA("ScreenGui"))
		return (displayOrder or gui.DisplayOrder) + 1
	end, _AncestorGui, AncestorDisplayOrder)

	-- bind states to frame
	_Maid:GiveTask(RunService.RenderStepped:Connect(function(dt: number)
		local parent = Parent:Get()
		if parent then
			ParentAnchorPoint:Set(parent.AnchorPoint)
			AbsolutePosition:Set(parent.AbsolutePosition)
			AbsoluteSize:Set(parent.AbsoluteSize)
		end
	end))	

	-- assemble final parameters
	local parameters: any = {
		[_REF] = OutputState :: any,
		Name = Name,
		DisplayOrder = DisplayOrder,
		Enabled = Enabled,
		ZIndexBehavior = ZIndexBehavior,
		Parent = Parent,
		[_CHILDREN] = {
			_new "Frame" {
				BackgroundTransparency = 1,
				Size = _Computed(function(absSize: Vector2)
					if not absSize then return UDim2.fromOffset(0,0) end
					return UDim2.fromOffset(absSize.X, absSize.Y)
				end, AbsoluteSize),
				Position = _Computed(function(absPos: Vector2)
					if not absPos then return UDim2.fromOffset(0,0) end
					return UDim2.fromOffset(absPos.X, absPos.Y)
				end, AbsolutePosition),
			},
		} :: {Instance}
	}
	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- construct output instance
	local Output = _Fuse.new("ScreenGui")(parameters) :: any
	Util.cleanUpPrep(_Maid, Output)

	-- bind states to output attributes
	_Maid:GiveTask(Position:Connect(function(cur: UDim2)
		Output:SetAttribute("Position", cur)
	end)); Output:SetAttribute("Position", Position:Get())

	_Maid:GiveTask(AnchorPosition:Connect(function(cur: UDim2)
		Output:SetAttribute("AnchorPosition", cur)
	end)); Output:SetAttribute("AnchorPosition", AnchorPosition:Get())

	_Maid:GiveTask(AbsoluteSize:Connect(function(cur: Vector2)
		Output:SetAttribute("AbsoluteSize", cur)
	end)); Output:SetAttribute("AbsoluteSize", AbsoluteSize:Get())

	_Maid:GiveTask(CenterPosition:Connect(function(cur: UDim2)
		Output:SetAttribute("CenterPosition", cur)
	end)); Output:SetAttribute("CenterPosition", CenterPosition:Get())

	_Maid:GiveTask(Size:Connect(function(cur: UDim2)
		Output:SetAttribute("Size", cur)
	end)); Output:SetAttribute("Size", Size:Get())


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