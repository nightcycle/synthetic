local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))

local enums = require(script.Parent.Parent:WaitForChild("Enums"))

--used to make sure two prompts are never opened at the same time
local dropdownRegistry = Instance.new("Folder", game)
dropdownRegistry.Name = "DropdownRegistry"
dropdownRegistry:SetAttribute("Selected", 0)
dropdownRegistry:SetAttribute("Index", 0)

local ed = Enum.EasingDirection
local es = Enum.EasingStyle

local constructor = {}

function addOption(inst, index, text)

end

function removeOption(inst, index)

end

function constructor.new(params)
	local maid = maidConstructor.new()
	local config = {}
	util.mergeConfig(config, params)

	local Value = fusion.State("")

	local inst = synthetic("Button", config)

	local id = dropdownRegistry:GetAttribute("Index")
	dropdownRegistry:SetAttribute("Index", id+1)

	maid:GiveTask(inst)

	local textUpdater = fusion.Compat(Value)
	maid:GiveTask(textUpdater:onChange(function()
		inst.Text = tostring(Value:get())
	end))
	inst:WaitForChild("InputEffect"):SetAttribute("InputStyleCategory", "Primary")
	inst:WaitForChild("Theme"):SetAttribute("ThemeCategory", "Surface")
	inst:WaitForChild("Theme"):SetAttribute("TextClass", "Body")

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
	end), util.newTweenInfo())
	local buttonSize = fusion.Computed(function()
		return UDim2.new(1, 0, 0, buttonHeight:get())
	end)
	local frame = fusion.New "Frame" {
		Parent = inst,
		Size = frameSize,
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromScale(0,1),
		Visible = true,
		ClipsDescendants = true,
	}
	maid:GiveTask(synthetic("Padding",{
		Parent = frame,
		Padding = UDim.new(0,framePadding),
	}))
	maid._listLayout = synthetic("ListLayout",{
		Parent = frame,
	})
	maid._listLayout.Padding = UDim.new(0,buffer)
	maid._listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	maid._listLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	maid:GiveTask(synthetic("Theme",{
		ThemeCategory = "Background",
		TextClass = "Body",
		Parent = frame,
	}))
	maid._elevation = synthetic("Elevation",{
		Parent = frame,
	})
	maid:GiveTask(synthetic("Dropshadow",{
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
	local function updateFrameElevation()
		local parAbsElev = inst:GetAttribute("AbsoluteElevation") or 0
		local delta = frame:GetAttribute("ElevationIncrease") or 0
		frame:SetAttribute("AbsoluteElevation", parAbsElev+delta)
	end
	maid:GiveTask(inst:GetAttributeChangedSignal("AbsoluteElevation"):Connect(updateFrameElevation))
	maid:GiveTask(inst:GetAttributeChangedSignal("AbsoluteElevation"):Connect(updateFrameElevation))
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

		local button = synthetic("Button",{
			Name = "Option",
			Size = buttonSize,
			LayoutOrder = index,
			Parent = frame,
		})
		button.Text = value
		button:WaitForChild("Theme"):SetAttribute("ThemeCategory", "Surface")
		button:WaitForChild("Theme"):SetAttribute("TextClass", "Body")
		button:WaitForChild("InputEffect"):SetAttribute("StartSize", buttonSize:get())
		button:WaitForChild("InputEffect"):SetAttribute("InputSizeBump", UDim.new(0,0))
		optionMaid:GiveTask(button.Activated:Connect(function()
			open:set(false)
			inst:WaitForChild("InputEffect"):SetAttribute("InputSizeBump", UDim.new(0,3))
			dropdownRegistry:SetAttribute("Selected", id)
			Value:set(value)
			OnSelected:Fire(value)
		end))
		local function updateButtonElevation()
			local parAbsElev = frame:GetAttribute("AbsoluteElevation") or 0
			local delta = button:GetAttribute("ElevationIncrease") or 0
			button:SetAttribute("AbsoluteElevation", parAbsElev+delta)
		end
		optionMaid:GiveTask(frame:GetAttributeChangedSignal("AbsoluteElevation"):Connect(updateButtonElevation))
		optionMaid:GiveTask(frame:GetAttributeChangedSignal("AbsoluteElevation"):Connect(updateButtonElevation))
		optionMaid:GiveTask(button)
		optionMaid:GiveTask(inst.AncestryChanged:Connect(function()
			if not button:IsDescendantOf(game.Players.LocalPlayer) then
				optionMaid:Destroy()
				-- print("Cleaning up "..tostring(script.Name))
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
		inst:WaitForChild("InputEffect"):SetAttribute("InputSizeBump", UDim.new(0,0))
		clickMaid:GiveTask(frame.InputEnded:Connect(function()
			open:set(false)
			inst:WaitForChild("InputEffect"):SetAttribute("InputSizeBump", UDim.new(0,3))
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
	util.setPublicState("Value", Value, inst, maid)

	maid:GiveTask({
		Destroy = function(s)
			if open:get() == true or dropdownRegistry:GetAttribute("Selected") == id then
				dropdownRegistry:SetAttribute("Selected", 0)
			end
		end
	})

	util.set(script.Name, inst, maid)
	return inst
end

return constructor