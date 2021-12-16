local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
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
	-- local grandParentAbsElevation = fusion.State(0)
	local increasedElevation = fusion.State(0)

	local absoluteElevation = fusion.State(0)
	local absElevationCompat = fusion.Compat(absoluteElevation)

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
	local function setParent(par)
		currentParent = par
		parentMaid:GiveTask(currentParent:GetAttributeChangedSignal("ElevationIncrease"):Connect(function()
			if not inst:IsDescendantOf(game.Players.LocalPlayer) then return end
			if not currentParent then return end
			increasedElevation:set(currentParent:GetAttribute("ElevationIncrease") or 0)
		end))
		parentMaid:GiveTask(currentParent:GetAttributeChangedSignal("AbsoluteElevation"):Connect(function()
			if not inst:IsDescendantOf(game.Players.LocalPlayer) then return end
			if not currentParent then return end
			absoluteElevation:set(currentParent:GetAttribute("AbsoluteElevation") or 0)
		end))
	end
	maid:GiveTask(inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then return end
		if inst:IsDescendantOf(game.Players.LocalPlayer:WaitForChild("PlayerGui")) == false then
			maid:Destroy()
			print("Cleaning up "..tostring(script.Name))
		elseif inst.Parent ~= nil or currentParent ~= nil then
			setParent(inst.Parent)
		else
			resetParent(currentParent, parentMaid)
			currentParent = nil
		end
	end))
	if config.Parent then
		setParent(config.Parent)
	end
	return inst, maid
end

return constructor