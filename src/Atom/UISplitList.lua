local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	local maid = maidConstructor.new()
	--public states
	local public = {}

	public.OddEntryPlacement = util.import(params.OddEntryPlacement) or fusion.State(Enum.HorizontalAlignment.Left.Name)

	public.VerticalAlignment = util.import(params.VerticalAlignment) or fusion.State(Enum.VerticalAlignment.Center.Name)

	public.Padding = util.import(params.Padding) or fusion.State(UDim.new(0, 4))

	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)

	local tweenParams = {
		Duration = 0.8,
		EasingStyle = Enum.EasingStyle.Cubic,
		EasingDirection = Enum.EasingDirection.Out,
	}


	--construct
	local inst = util.set(fusion.New "Configuration", public, params, {
		AnchorPoint = Vector2.new(0.5,0.5),
		Size = util.tween(fusion.Computed(function()
			return UDim2.new(public.Size:get(), public.Size:get())
		end), tweenParams),
		BackgroundColor3 = util.tween(public.Color, tweenParams),
		BackgroundTransparency = util.tween(public.Transparency, tweenParams),
		Position = public.Position,
		[fusion.Children] = {
			fusion.New "UICorner" {
				CornerRadius = UDim.new(0.5,0),
			}
		}
	}, maid)

	local function solve()
		if not inst.Parent then return end
		local guiObjects = {}
		for i, guiObject in ipairs(inst:GetChildren()) do
			if guiObject:IsA("GuiObject") then
				table.insert(guiObjects, guiObject)
			end
		end
		table.sort(guiObjects, function(a,b)
			return a.LayoutOrder < b.LayoutOrder
		end)
		local isOdd = #guiObjects%2 == 0
		local medianIndex = #guiObjects/2
		if isOdd then

		end
	end

	for k, state in pairs(public) do
		maid:GiveTask(fusion.Compat(state):onChange(solve))
	end

	maid:GiveTask(inst.AncestryChanged:Connect(function()
		if not inst.Parent then return end
		maid._parentChildAdded = inst.Parent.ChildAdded:Connect(function(child)
			local childMaid = maidConstructor.new()
			maid[child] = childMaid
			childMaid:GiveTask(inst:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				solve()
			end))
			childMaid:GiveTask(inst:GetPropertyChangedSignal("LayoutOrder"):Connect(function()
				solve()
			end))
		end)
		maid._parentChildRemoved = inst.Parent.ChildRemoved:Connect(function(child)
			if maid[child] then
				maid[child]:Destroy()
			end
			solve()
		end)
	end))
	return inst
end

return constructor