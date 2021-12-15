local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild("attributer"))

--used to make sure two prompts are never opened at the same time
local dropdownRegistry = Instance.new("Folder", game)
dropdownRegistry.Name = "DropdownRegistry"
dropdownRegistry:SetAttribute("Selected", 0)
dropdownRegistry:SetAttribute("Index", 0)

local Component = synthetic:WaitForChild("Component")
local styleConstructor = require(Component:WaitForChild("Style"))
local elevationConstructor = require(Component:WaitForChild("Elevation"))
local lightingConstructor = require(Component:WaitForChild("Lighting"))
local inputEffectConstructor = require(Component:WaitForChild("InputEffect"))
local paddingConstructor = require(Component:WaitForChild("Padding"))
local listLayoutConstructor = require(Component:WaitForChild("ListLayout"))

local atom = synthetic:WaitForChild("Atom")
local buttonConstructor = require(atom:WaitForChild("Button"))

local ed = Enum.EasingDirection
local es = Enum.EasingStyle
function newTweenInfo(params)
	params = params or {}
	local duration = params.Duration or 0.5
	local easingStyle = params.EasingStyle or es.Quint
	local easingDirection = params.EasingDirection or ed.InOut
	local repeatCount = params.RepeatCount or 0
	local reverses = params.Reverses or false
	local delayTime = params.DelayTime or 0
	return TweenInfo.new(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime)
end

local constructor = {}

function addOption(inst, index, text)

end

function removeOption(inst, index)

end

function constructor.new(config)
	config = config or {}
	local Value = fusion.State("")
	local maid = maidConstructor.new()
	local inst = buttonConstructor.new({
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
		Size = config.Size or UDim2.fromScale(1,1),
		Position = config.Position or UDim2.fromScale(0.5,0.5),
		AnchorPoint = config.AnchorPoint or Vector2.new(0.5,0.5),
		LayoutOrder = config.LayoutOrder or 0,
		SizeConstraint = config.SizeConstraint or Enum.SizeConstraint.RelativeXY,
		Visible = config.Visible or true,
		Name = config.Name or script.Name,
	})

	local id = dropdownRegistry:GetAttribute("Index")
	dropdownRegistry:SetAttribute("Index", id+1)

	maid:GiveTask(inst)

	local textUpdater = fusion.Compat(Value)
	maid:GiveTask(textUpdater:onChange(function()
		inst.Text = tostring(Value:get())
	end))

	inst:WaitForChild("Style"):SetAttribute("Category", "Surface")
	inst:WaitForChild("Style"):SetAttribute("TextClass", "Body")

	local open = fusion.State(false)

	local buffer = 3
	local framePadding = 2
	local buttonHeight = fusion.State(inst.AbsoluteSize.Y)
	maid:GiveTask(inst:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		buttonHeight:set(inst.AbsoluteSize.Y)
	end))

	local optionList = fusion.State({})
	local optionCount = fusion.Computed(function()
		return #optionList:get()
	end)
	local expansionAlpha = fusion.Computed(function()
		if open:get() then
			return 1
		else
			return 0
		end
	end)
	local frameSize = fusion.Tween(fusion.Computed(function()
		local alpha = expansionAlpha:get()
		local options = optionCount:get()
		local buttonSlot = buffer+buttonHeight:get()
		local offset = -alpha*framePadding*2
		return UDim2.new(1, 0, 0, math.max(0, alpha*options*buttonSlot-offset))
	end), newTweenInfo())
	local buttonSize = fusion.Computed(function()
		return UDim2.new(1, 0, 0, buttonHeight:get())
	end)
	local frame = fusion.New "Frame" {
		Parent = inst,
		Size = frameSize,
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0,0),
		Visible = true,
		ClipsDescendants = true,
	}
	maid:GiveTask(paddingConstructor.new({
		Parent = frame,
		Padding = UDim.new(0,framePadding),
	}))
	maid._listLayout = listLayoutConstructor.new({
		Parent = frame,
	})
	maid._listLayout.Padding = UDim.new(0,buffer)
	maid._listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	maid._listLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	maid:GiveTask(styleConstructor.new({
		Category = "Background",
		TextClass = "Body",
		Parent = frame,
	}))
	maid._elevation = elevationConstructor.new({
		Parent = frame,
	})
	maid:GiveTask(lightingConstructor.new({
		Parent = frame,
	}))
	local openUpdate = fusion.Compat(open)
	maid._elevation.Enabled = open:get()
	maid:GiveTask(openUpdate:onChange(function()
		maid._elevation.Enabled = open:get()
	end))
	local SetOption = fusion.New "BindableEvent" {
		Parent = inst,
		Name = "SetOption",
	}
	frame:SetAttribute("ElevationIncrease",2)
	SetOption.Event:Connect(function(text)
		local current = optionList:get()
		table.insert(current, text)
		optionList:set(current)
	end)

	local SetOptions = fusion.New "BindableEvent" {
		Parent = inst,
		Name = "SetOptions",
	}
	SetOptions.Event:Connect(function(list)
		optionList:set(list)
	end)

	local RemoveOption = fusion.New "BindableEvent" {
		Parent = inst,
		Name = "RemoveOption",
	}
	RemoveOption.Event:Connect(function(index)
		local current = optionList:get()
		table.remove(current, index)
		optionList:set(current)
	end)

	local ClearAllOptions = fusion.New "BindableEvent" {
		Parent = inst,
		Name = "ClearAllOptions",
	}
	ClearAllOptions.Event:Connect(function()
		optionList:set({})
	end)
	local OnSelected = fusion.New "BindableEvent" {
		Parent = inst,
		Name = "OnSelected",
	}
	fusion.ComputedPairs(optionList, function(index, value)
		local optionMaid = maidConstructor.new()
		maid:GiveTask(optionMaid)

		local button = buttonConstructor.new({
			Name = "Option",
			Size = buttonSize,
			LayoutOrder = index,
			Parent = frame,
		})
		button.Text = value
		button:WaitForChild("Style"):SetAttribute("Category", "Surface")
		button:WaitForChild("Style"):SetAttribute("TextClass", "Body")
		optionMaid:GiveTask(button.Activated:Connect(function()
			open:set(false)
			dropdownRegistry:SetAttribute("Selected", id)
			Value:set(value)
			OnSelected:Fire(value)
		end))

		optionMaid:GiveTask(button)
		optionMaid:GiveTask(inst.AncestryChanged:Connect(function()
			if not inst:IsDescendantOf(game.Players.LocalPlayer) then
				maid:Destroy()
				print("Cleaning up "..tostring(script.Name))
			end
		end))
		return optionMaid
	end)

	local clickMaid = maidConstructor.new()
	maid:GiveTask(clickMaid)
	maid:GiveTask(inst.Activated:Connect(function()
		if dropdownRegistry:GetAttribute("Selected") ~= 0 then return end
		dropdownRegistry:SetAttribute("Selected", id)
		open:set(true)
		clickMaid:GiveTask(frame.InputEnded:Connect(function()
			open:set(false)
			dropdownRegistry:SetAttribute("Selected", 0)
		end))
		local closed = fusion.Compat(open)
		clickMaid:GiveTask(closed:onChange(function()
			if open:get() == false then
				clickMaid:DoCleaning()
			end
		end))
	end))

	--bind to attributes
	local attributer = attributerConstructor.new(inst, {})
	maid:GiveTask(attributer)
	local function bindAttributeToState(key, state)
		attributer:Connect(key, state:get())
		local compat = fusion.Compat(state)
		maid:GiveTask(compat:onChange(function()
			if inst:GetAttribute(key) ~= state:get() then
				inst:SetAttribute(key, state:get())
			end
		end))
		maid:GiveTask(attributer.OnChanged:Connect(function(k, val)
			if k == key then
				state:set(val)
			end
		end))
	end
	bindAttributeToState("Value", Value)

	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			if open:get() == true or dropdownRegistry:GetAttribute("Selected") == id then
				dropdownRegistry:SetAttribute("Selected", 0)
			end
			maid:Destroy()
			print("Cleaning up "..tostring(script.Name))
		end
	end)

	return inst
end

return constructor