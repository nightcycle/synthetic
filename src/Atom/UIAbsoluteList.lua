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
		@class UIAbsoluteList
		@tag Component
		@tag Atom
		Tired of automatic size not working? This list component attempts to find the tightest fit for you.
	]=]

	local maid = maidConstructor.new()
	--public states
	local public = {}

	--[=[
		@prop SynthClassName string
		Read-Only attribute used to identify what type of component it is
		@within UIAbsoluteList
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)

	--construct
	local inst = util.set(fusion.New "UIListLayout", public, params, {}, maid)

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
			if guiObject:IsA("GuiObject") then
				table.insert(guiObjects, guiObject)
			end
		end
		table.sort(guiObjects, function(a,b)
			return a.LayoutOrder < b.LayoutOrder
		end)

		local parentPadding = parent:FindFirstChildOfClass("UIPadding")
		local function getAbsolutePadding(padProp, absSize)
			if not parentPadding then return 0 end
			local pad = parentPadding[padProp]
			return math.round(absSize*pad.Scale) + pad.Offset
		end

		local contentX = 0
		local contentY = 0
		for i=1, #guiObjects do
			local gui = guiObjects[i]
			if inst.FillDirection == Enum.FillDirection.Horizontal then
				if #guiObjects < i then
					contentX += inst.Padding.Offset
				end
				contentX += gui.AbsoluteSize.X
				contentY = math.max(contentY, gui.AbsoluteSize.Y)
			else
				if #guiObjects < i then
					contentY += inst.Padding.Offset
				end
				contentY += gui.AbsoluteSize.Y
				contentX = math.max(contentX, gui.AbsoluteSize.X)
			end
		end

		local x = contentX + getAbsolutePadding("PaddingLeft", parent.AbsoluteSize.X) + getAbsolutePadding("PaddingRight", parent.AbsoluteSize.X)
		local y = contentY + getAbsolutePadding("PaddingBottom", parent.AbsoluteSize.Y) + getAbsolutePadding("PaddingTop", parent.AbsoluteSize.Y)
		parent.Size = UDim2.fromOffset(x,y)
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