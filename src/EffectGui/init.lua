--!strict
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

export type EffectGuiParameters = {
	Enabled: ValueState<boolean>,
} & Types.ScreenGuiParameters

export type EffectGui = ScreenGui

function Constructor(config: EffectGuiParameters): EffectGui
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
	local Parent: State<GuiObject?> = _import(config.Parent, nil) :: any
	local Enabled = config.Enabled
	local ZIndexBehavior = _import(config.ZIndexBehavior, Enum.ZIndexBehavior.Sibling)

	-- init internal states
	local OutputState = _Value(nil :: ScreenGui?)
	local AncestorDisplayOrder = _Value(0)
	local ParentAnchorPoint: ValueState<Vector2> = _Value(Vector2.new(0, 0))
	local AbsolutePosition: ValueState<Vector2> = _Value(Vector2.new(0, 0))
	local AbsoluteSize: ValueState<Vector2> = _Value(Vector2.new(0, 0))
	local Position: State<UDim2> = _Computed(function(absPos): UDim2
		absPos = absPos or Vector2.new(0, 0)
		return UDim2.fromOffset(absPos.X, absPos.Y)
	end, AbsolutePosition):Else(UDim2.fromOffset(0, 0))
	local AnchorPosition: State<UDim2> = _Computed(function(absPos, absSize, anchorPoint): UDim2
		absPos = absPos or Vector2.new(0, 0)
		absSize = absSize or Vector2.new(0, 0)
		anchorPoint = anchorPoint or Vector2.new(0, 0)
		return UDim2.fromOffset(absPos.X + anchorPoint.X * absSize.X, absPos.Y + anchorPoint.Y * absSize.Y)
	end, AbsolutePosition, AbsoluteSize, ParentAnchorPoint):Else(UDim2.fromOffset(0, 0))
	local CenterPosition: State<UDim2> = _Computed(function(absPos, absSize, anchorPoint): UDim2
		absPos = absPos or Vector2.new(0, 0)
		absSize = absSize or Vector2.new(0, 0)
		return UDim2.fromOffset(absPos.X + 0.5 * absSize.X, absPos.Y + 0.5 * absSize.Y)
	end, AbsolutePosition, AbsoluteSize):Else(UDim2.new(0, 0))
	local Size: State<UDim2> = _Computed(function(absSize)
		absSize = absSize or Vector2.new(0, 0)
		return UDim2.fromOffset(absSize.X, absSize.Y)
	end, AbsoluteSize):Else(UDim2.fromOffset(0, 0))
	local _KnownAncestorGui: ValueState<ScreenGui?> = _Value(nil :: ScreenGui?)
	local _AncestorGui = _Computed(function(known: ScreenGui?, output: ScreenGui?): ScreenGui?
		if not output then
			return
		end
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
			maid.onAncestorDisplayChange = result:GetPropertyChangedSignal("DisplayOrder"):Connect(function()
				AncestorDisplayOrder:Set(result.DisplayOrder)
			end)
			AncestorDisplayOrder:Set(result.DisplayOrder)
		else
			AncestorDisplayOrder:Set(0)
		end
		return result
	end, _KnownAncestorGui, OutputState)
	local DisplayOrder = _Computed(function(gui: ScreenGui?, displayOrder: number)
		if not gui then
			return 1000
		end
		assert(gui ~= nil and gui:IsA("ScreenGui"))
		return (displayOrder or gui.DisplayOrder) + 1
	end, _AncestorGui, AncestorDisplayOrder)

	-- bind states to frame
	maid:GiveTask(RunService.RenderStepped:Connect(function(dt: number)
		local parent = Parent:Get()
		if parent then
			ParentAnchorPoint:Set(parent.AnchorPoint)
			AbsolutePosition:Set(parent.AbsolutePosition)
			AbsoluteSize:Set(parent.AbsoluteSize)
		end
	end))

	-- assemble final parameters
	local parameters: any = {
		Name = Name,
		DisplayOrder = DisplayOrder,
		Enabled = Enabled,
		ZIndexBehavior = ZIndexBehavior,
		Parent = Parent,
		Children = {
			_new("Frame")({
				BackgroundTransparency = 1,
				Size = _Computed(function(absSize: Vector2)
					if not absSize then
						return UDim2.fromOffset(0, 0)
					end
					return UDim2.fromOffset(absSize.X, absSize.Y)
				end, AbsoluteSize),
				Position = _Computed(function(absPos: Vector2)
					if not absPos then
						return UDim2.fromOffset(0, 0)
					end
					return UDim2.fromOffset(absPos.X, absPos.Y)
				end, AbsolutePosition),
			}),
		} :: { Instance },
	}
	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- construct output instance
	local Output = _fuse.new("ScreenGui")(parameters) :: any
	OutputState:Set(Output)
	Util.cleanUpPrep(maid, Output)

	-- bind states to output attributes
	maid:GiveTask(Position:Connect(function(cur: UDim2)
		Output:SetAttribute("Position", cur)
	end))
	Output:SetAttribute("Position", Position:Get())

	maid:GiveTask(AnchorPosition:Connect(function(cur: UDim2)
		Output:SetAttribute("AnchorPosition", cur)
	end))
	Output:SetAttribute("AnchorPosition", AnchorPosition:Get())

	maid:GiveTask(AbsoluteSize:Connect(function(cur: Vector2)
		Output:SetAttribute("AbsoluteSize", cur)
	end))
	Output:SetAttribute("AbsoluteSize", AbsoluteSize:Get())

	maid:GiveTask(CenterPosition:Connect(function(cur: UDim2)
		Output:SetAttribute("CenterPosition", cur)
	end))
	Output:SetAttribute("CenterPosition", CenterPosition:Get())

	maid:GiveTask(Size:Connect(function(cur: UDim2)
		Output:SetAttribute("Size", cur)
	end))
	Output:SetAttribute("Size", Size:Get())

	if Output:FindFirstAncestorWhichIsA("ScreenGui") then
		_KnownAncestorGui:Set(Output:FindFirstAncestorWhichIsA("ScreenGui"))
	end
	maid:GiveTask(Output.AncestryChanged:Connect(function(ancestor)
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
