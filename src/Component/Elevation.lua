local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild('attributer'))

local maxShadowDistance = 4
local minShadowDistance = 1
local minTransparency = 0.6
local maxTransparency = 0.95

function resetParent(parent: Instance, maid)
	local isViable = parent:GetAttribute("StartElevationConfig")
	if not isViable then return end
	parent:SetAttribute("StartElevationConfig", false)
	if not parent or not parent:IsA("GuiObject") then return end

	parent:SetAttribute("StartElevationConfig", nil)
	maid:DoCleaning()
end

local ed = Enum.EasingDirection
local es = Enum.EasingStyle
function newTweenInfo(params)  --default is a nice smooth transition
	params = params or {}
	local duration = params.Duration or 0.8
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
	local grandParentAbsElevation = fusion.State(0)
	local increasedElevation = fusion.State(0)
	local absoluteElevation = fusion.Computed(function()

		local absElev = grandParentAbsElevation:get() + increasedElevation:get()
		-- print("Compute ", absElev)
		if currentParent then
			currentParent:SetAttribute("AbsoluteElevation", absElev)
		end
		return absElev
	end)

	--solve for goals
	local alpha = fusion.Computed(function()
		return (math.clamp(increasedElevation:get(), 0, 9)/9)^2
	end)

	local transparencyGoal = fusion.Computed(function()
		local range = maxTransparency - minTransparency
		return minTransparency + range*alpha:get()
	end)

	local thicknessGoal = fusion.Computed(function()
		local range = maxShadowDistance - minShadowDistance
		return minShadowDistance + range*alpha:get()
	end)

	--connect goals to currents & parent with tweenCompat
	local currentTransparency = fusion.Tween(transparencyGoal, newTweenInfo())
	local currentThickness = fusion.Tween(thicknessGoal, newTweenInfo())

	--create inst
	local inst = fusion.New "UIStroke" {
		Name = script.Name,
		LineJoinMode = Enum.LineJoinMode.Round,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
		Thickness = currentThickness,
		Transparency = currentTransparency,
	}

	maid:GiveTask(inst)

	maid:GiveTask(inst.AncestryChanged:Connect(function()
		if inst:IsDescendantOf(game.Players.LocalPlayer:WaitForChild("PlayerGui")) == false then
			maid:Destroy()
			print("Cleaning up "..tostring(script.Name))
		elseif inst.Parent ~= nil or currentParent ~= nil then
			currentParent = inst.Parent

			currentParent:SetAttribute("ElevationIncrease", currentParent:GetAttribute("ElevationIncrease") or 1)
			parentMaid:GiveTask(currentParent:GetAttributeChangedSignal("ElevationIncrease"):Connect(function()
				increasedElevation:set(currentParent:GetAttribute("ElevationIncrease"))
				absoluteElevation:get()
			end))

			local grandParent = currentParent.Parent
			if grandParent then
				grandParent:SetAttribute("AbsoluteElevation", grandParent:GetAttribute("AbsoluteElevation") or 0)
				parentMaid:GiveTask(grandParent:GetAttributeChangedSignal("AbsoluteElevation"):Connect(function()
					grandParentAbsElevation:set(grandParent:GetAttribute("AbsoluteElevation"))
				end))
			end

		else
			resetParent(currentParent, parentMaid)
			currentParent = nil
		end
	end))

	return inst
end

return constructor