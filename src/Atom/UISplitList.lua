local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)

	--[=[
		@class UISplitList
		@tag Component
		@tag Atom
		A component used to split and align a list along a vertical axis.
	]=]

	local maid = maidConstructor.new()
	--public states
	local public = {}


	--[=[
		@prop OddEntryPlacement HorizontalAlignment.Name | FusionState | nil
		If the list has an odd number of entries, how should the middle instance be aligned?
		@within UISplitList
	]=]
	public.OddEntryPlacement = util.import(params.OddEntryPlacement) or fusion.State(Enum.HorizontalAlignment.Left.Name)

	--[=[
		@prop VerticalAlignment VerticalAlignment.Name | FusionState | nil
		How should the list be aligned along the Y axis
		@within UISplitList
	]=]
	public.VerticalAlignment = util.import(params.VerticalAlignment) or fusion.State(Enum.VerticalAlignment.Center.Name)

	--[=[
		@prop Padding UDim | FusionState | nil
		How much padding to include between list entries
		@within UISplitList
	]=]
	public.Padding = util.import(params.Padding) or fusion.State(UDim.new(0, 4))

	--[=[
		@prop MinSizeY number | FusionState | nil
		The minimum size the parent can be along the Y axis in pixels.
		@within UISplitList
	]=]
	public.MinSizeY = util.import(params.MinSizeY) or fusion.State(0)

	--[=[
		@prop MedianOffset number | FusionState | nil
		If you want an unbalanced list, with more entries to one side of the true median than the other, use this to move the median.
		@within UISplitList
	]=]
	public.MedianOffset = util.import(params.MedianOffset) or fusion.State(0)

	--[=[
		@prop SynthClassName string
		Read-Only attribute used to identify what type of component it is
		@within UISplitList
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)

	local _AbsoluteMinimumWidth = fusion.State(0)

	--construct
	local inst = util.set(fusion.New "UISizeConstraint", public, params, {
		MinSize = fusion.Computed(function()
			local minY = public.MinSizeY:get()
			local minX = _AbsoluteMinimumWidth:get()
			return Vector2.new(minX, minY)
		end)
	}, maid)

	local enabled = true
	local function solve()
		if not enabled then return end
		enabled = false
		task.delay(0, function()
			enabled = true
		end)
		if not inst.Parent or not inst.Parent:IsA("GuiObject") then return end
		local parent = inst.Parent
		local guiObjects = {}
		for i, guiObject in ipairs(parent:GetChildren()) do
			if guiObject:IsA("GuiObject") and guiObject.Visible then
				table.insert(guiObjects, guiObject)
			end
		end
		table.sort(guiObjects, function(a,b)
			return a.LayoutOrder < b.LayoutOrder
		end)
		local canEvenlySplit = #guiObjects%2 == 0
		local median = #guiObjects/2 + public.MedianOffset:get()

		local anchorY = 0.5
		if public.VerticalAlignment:get() == Enum.VerticalAlignment.Bottom.Name then
			anchorY = 1
		elseif public.VerticalAlignment:get() == Enum.VerticalAlignment.Top.Name then
			anchorY = 0
		end

		local absoluteWidth = parent.AbsoluteSize.X
		local padding = public.Padding:get()
		local absolutePadding = math.round(absoluteWidth*padding.Scale) + padding.Offset

		local parentPadding = parent:FindFirstChildOfClass("UIPadding")
		local leftAbsPad = 0
		local rightAbsPad = 0
		local minWidth = 0

		if parentPadding then
			local leftPadding = parentPadding.PaddingLeft
			leftAbsPad = math.round(absoluteWidth*leftPadding.Scale) + leftPadding.Offset

			local rightPadding = parentPadding.PaddingRight
			rightAbsPad = math.round(absoluteWidth*rightPadding.Scale) + rightPadding.Offset
			minWidth += rightAbsPad + leftAbsPad
			absoluteWidth -= leftAbsPad + rightAbsPad
		end

		local leftX = leftAbsPad
		for i=1, math.floor(median) do
			local gui = guiObjects[i]
			gui.AnchorPoint = Vector2.new(0, anchorY)
			gui.Position = UDim2.new(UDim.new(0, leftX), UDim.new(anchorY,0))

			leftX += absolutePadding + gui.AbsoluteSize.X
			if i < math.floor(median) or (#guiObjects == 2) then
				minWidth += absolutePadding + gui.AbsoluteSize.X
			end
		end

		local rightX = rightAbsPad
		for i=math.max(math.min(math.ceil(median)+1, #guiObjects), 1), #guiObjects do
			local gui = guiObjects[i]
			gui.AnchorPoint = Vector2.new(1, anchorY)
			gui.Position = UDim2.new(UDim.new(1,-rightX), UDim.new(anchorY,0))
			rightX += absolutePadding + gui.AbsoluteSize.X
			if i < #guiObjects or (#guiObjects == 2) then
				minWidth += absolutePadding + gui.AbsoluteSize.X
			end
		end

		if not canEvenlySplit then
			local placementStyle = public.OddEntryPlacement:get()
			local middleObject = guiObjects[math.ceil(median)]
			if placementStyle == Enum.HorizontalAlignment.Left.Name then
				minWidth += absolutePadding + middleObject.AbsoluteSize.X
				middleObject.AnchorPoint = Vector2.new(0, anchorY)
				middleObject.Position = UDim2.new(UDim.new(leftX,0), UDim.new(anchorY,0))
			elseif placementStyle == Enum.HorizontalAlignment.Right.Name then
				minWidth += absolutePadding + middleObject.AbsoluteSize.X
				middleObject.AnchorPoint = Vector2.new(1, anchorY)
				middleObject.Position = UDim2.new(UDim.new(1,-rightX), UDim.new(anchorY,0))
			else
				minWidth += absolutePadding*2 + middleObject.AbsoluteSize.X
				middleObject.Position = UDim2.fromScale(0.5, anchorY)
			end
		end

		_AbsoluteMinimumWidth:set(minWidth)
	end

	for k, state in pairs(public) do
		maid:GiveTask(fusion.Compat(state):onChange(solve))
	end

	maid:GiveTask(inst.AncestryChanged:Connect(function()
		if not inst.Parent or not inst.Parent:IsA("GuiObject") then return end
		local parent = inst.Parent
		maid._parentResize = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			solve()
		end)

		maid._parentChildAdded = parent.ChildAdded:Connect(function(child)
			if not child:IsA("GuiObject") then return end
			local childMaid = maidConstructor.new()
			maid[child] = childMaid
			childMaid:GiveTask(child:GetPropertyChangedSignal("Visible"):Connect(function()
				solve()
			end))
			childMaid:GiveTask(child:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				solve()
			end))
			childMaid:GiveTask(child:GetPropertyChangedSignal("LayoutOrder"):Connect(function()
				solve()
			end))
		end)
		maid._parentChildRemoved = parent.ChildRemoved:Connect(function(child)
			if maid[child] then
				maid[child]:Destroy()
			end
			solve()
		end)
	end))
	if inst.Parent then
		solve()
	end
	return inst
end

return constructor