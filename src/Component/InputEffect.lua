local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild('attributer'))

local runService = game:GetService("RunService")

local elevationToValueGain = {
	[0] = 0,
	[1] = 0.05,
	[2] = 0.07,
	[3] = 0.08,
	[4] = 0.09,
	[5] = 0.11,
	[6] = 0.12,
	[7] = 0.14,
	[8] = 0.15,
	[9] = 0.16,
}


local maxShadowDistance = 7
local minShadowDistance = 1
local minTransparency = 0.1
local maxTransparency = 0.1

function setParent(parent: Instance)
	if not parent or not parent:IsA("GuiObject") then return end
	task.delay(1, function()
		parent:SetAttribute("SIFXC_Size", parent.Size)
	end)
	parent:SetAttribute("StartInputFXConfig", true)
end

function resetParent(parent: Instance, maid)
	local isViable = parent:GetAttribute("StartInputFXConfig")
	if not isViable then return end
	parent:SetAttribute("StartInputFXConfig", false)
	if not parent or not parent:IsA("GuiObject") then return end
	parent:SetAttribute("SIFXC_Size", parent.Size)
	parent.Size = parent:GetAttribute("SIFXC_Size")
	parent:SetAttribute("StartInputFXConfig", nil)
	parent:SetAttribute("StartInputFXConfig", nil)
	maid:DoCleaning()
end

local ed = Enum.EasingDirection
local es = Enum.EasingStyle
function newTweenInfo(params)  --default is a nice smooth transition
	params = params or {}
	local duration = params.Duration or 0.4
	local easingStyle = params.EasingStyle or es.Quad
	local easingDirection = params.EasingDirection or ed.InOut
	local repeatCount = params.RepeatCount or 0
	local reverses = params.Reverses or false
	local delayTime = params.DelayTime or 0
	return TweenInfo.new(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime)
end


local constructor = {}

function constructor.new(config)
	config = config or {}
	local maid = maidConstructor.new()
	local parentMaid = maidConstructor.new()
	maid:GiveTask(parentMaid)

	local currentParent

	--set control states
	local startSize = fusion.State(config.StartSize or UDim2.fromScale(0,0))
	local sizeBump = fusion.State(config.SizeBump or UDim.new(0,10))
	local elevationBump = fusion.State(config.ElevationBump or 1)

	--create inst
	local inst = fusion.New "Configuration" {
		Name = script.Name,
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}

	--bind to attributes
	local attributer = attributerConstructor.new(inst, {})
	maid:GiveTask(attributer)
	local function bindAttributeToState(key, state, constructor)
		if not constructor then
			constructor = function(v)
				return v
			end
		end
		attributer:Connect(key, constructor(state:get()))
		local compat = fusion.Compat(state)
		maid:GiveTask(compat:onChange(function()
			if inst:GetAttribute(key) ~= state:get() then
				inst:SetAttribute(key, constructor(state:get()))
			end
		end))
		maid:GiveTask(attributer.OnChanged:Connect(function(k, val)
			if k == key then
				state:set(val)
			end
		end))
	end

	bindAttributeToState("StartSize", startSize, UDim2.new)
	bindAttributeToState("SizeBump", sizeBump, UDim.new)
	bindAttributeToState("ElevationBump", elevationBump)

	local isSelected = fusion.State(false)
	local size = fusion.Computed(function()
		if currentParent ~= nil and currentParent:IsA("GuiObject") then
			local absSize = currentParent.AbsoluteSize
			local size = currentParent.Size
			local b = sizeBump:get() or UDim.new(0,0)
			if isSelected:get() == true then
				currentParent:SetAttribute("ElevationIncrease", elevationBump:get())
				return UDim2.new(
					size.X.Scale+b.Scale,
					size.X.Offset+b.Offset,
					size.Y.Scale+b.Scale,
					size.Y.Offset+b.Offset
				)
			else
				currentParent:SetAttribute("ElevationIncrease", 1)
				return startSize:get()
			end
		else
			return startSize:get()
		end
	end)

	local currentSizeTween = fusion.Tween(size, newTweenInfo())
	local sizeTweenCompat = fusion.Compat(currentSizeTween)

	maid:GiveTask(sizeTweenCompat:onChange(function()
		print("Update")
		if currentParent ~= nil and currentParent:IsA("GuiObject") then
			currentParent.Size = currentSizeTween:get()
		end
	end))

	--connect goals to currents & parent with tweenCompat
	maid:GiveTask(inst)
	local function sPar(par)
		currentParent = par
		if currentParent:IsA("GuiObject") then
			setParent(currentParent)
			parentMaid:GiveTask(currentParent.InputBegan:Connect(function()
				isSelected:set(true)
				-- currentParent.Size = size:get()
			end))
			parentMaid:GiveTask(currentParent.InputEnded:Connect(function()
				isSelected:set(false)
				-- currentParent.Size = size:get()
			end))
		end
	end
	maid:GiveTask(inst.AncestryChanged:Connect(function()
		if inst:IsDescendantOf(game.Players.LocalPlayer:WaitForChild("PlayerGui")) == false then
			maid:Destroy()
			print("Cleaning up "..tostring(script.Name))
		elseif inst.Parent ~= nil or currentParent ~= nil then
			sPar(inst.Parent)
		else
			resetParent(currentParent, parentMaid)
			currentParent = nil
		end
	end))
	if config.Parent then
		sPar(config.Parent)
	end
	return inst
end

return constructor