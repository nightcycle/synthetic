local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild('attributer'))

function update(parent: Instance)
	if not parent or not parent:IsA("GuiObject") then return end

	parent:SetAttribute("StartStyleConfig", true)
end

function resetParent(parent: Instance, maid)
	local isViable = parent:GetAttribute("StartStyleConfig")
	if not isViable then return end
	parent:SetAttribute("StartStyleConfig", false)
	if not parent or not parent:IsA("GuiObject") then return end

	parent:SetAttribute("StartStyleConfig", nil)
	maid:DoCleaning()
end

function tweenCompat(state, maid, tweenInfo, func)
	local stateTween = fusion.Tween(state, tweenInfo) --newTweenInfo())
	local stateTweenCompat = fusion.Compat(stateTween)
	maid:GiveTask(stateTweenCompat:onChange(func))
	return stateTween
end

local constructor = {}

function constructor.new()
	local maid = maidConstructor.new()
	local parentMaid = maidConstructor.new()
	maid:GiveTask(parentMaid)

	local currentParent

	--set control states

	--create inst
	local inst = fusion.New "Configuration" {
		Name = "Component",
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}

	--bind to attributes
	local attributer = attributerConstructor.new(inst, {})
	maid:GiveTask(attributer)
	local function bindAttributeToState(key, state)
		attributer:Connect(key, state:get())
		maid:GiveTask(attributer.OnChanged:Connect(function(k, val)
			if k == key then
				state:set(val)
			end
		end))
	end

	--solve for goals


	--connect goals to currents & parent with tweenCompat

	local function fireUpdate()
		update(currentParent)
	end

	maid:GiveTask(inst)

	maid:GiveTask(inst.AncestryChanged:Connect(function()
		if inst:IsDescendantOf(game.Players.LocalPlayer:WaitForChild("PlayerGui")) == false then
			maid:Destroy()
		elseif inst.Parent ~= nil or currentParent ~= nil then
			currentParent = inst.Parent
			fireUpdate()
		else
			resetParent(currentParent, parentMaid)
			currentParent = nil
		end
	end))

	return inst
end

return constructor