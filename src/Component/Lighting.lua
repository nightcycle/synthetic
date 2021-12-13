local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild('attributer'))


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

function resetParent(parent: Instance, maid)
	local isViable = parent:GetAttribute("StartLightConfig")
	if not isViable then return end
	parent:SetAttribute("StartLightConfig", false)
	if not parent or not parent:IsA("GuiObject") then return end

	parent:SetAttribute("StartLightConfig", nil)
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

function constructor.new()
	local maid = maidConstructor.new()
	local parentMaid = maidConstructor.new()
	maid:GiveTask(parentMaid)

	local currentParent

	local currentColor = fusion.State(Color3.new(1,1,1))

	--set control states
	local netElevation = fusion.State(0)

	local lightValue = fusion.Computed(function()
		local currentValue = math.clamp(netElevation:get(), 0, 9)
		local alpha = currentValue - math.floor(currentValue)
		local minVal = elevationToValueGain[math.floor(currentValue)]
		local maxVal = elevationToValueGain[math.ceil(currentValue)]
		local range = maxVal - minVal
		local avgValue = minVal + range*alpha
		return avgValue
	end)

	-- local goalColorSequence = fusion.Computed(function()
	-- 	local color = currentColor:get()
	-- 	local h,s,v = color:ToHSV()
	-- 	local val = lightValue:get()

	-- 	v = math.clamp(v + val, 0, 1)
	-- 	s = math.clamp(s - val, 0, 1)
	-- 	local finalColor = Color3.fromHSV(h,s,v)
	-- 	return ColorSequence.new(color, finalColor)
	-- end)

	local goalTransparencySequence = fusion.Computed(function()
		return NumberSequence.new(0.16, 0.16-lightValue:get())
	end)

	--create inst
	local inst = fusion.New "UIGradient" {
		Name = script.Name,
		Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
		Transparency = fusion.Tween(goalTransparencySequence, newTweenInfo()),
		-- Color = fusion.Tween(goalColorSequence, newTweenInfo())
	}

	--connect goals to currents & parent with tweenCompat
	maid:GiveTask(inst)
	maid:GiveTask(inst.AncestryChanged:Connect(function()
		if inst:IsDescendantOf(game.Players.LocalPlayer:WaitForChild("PlayerGui")) == false then
			maid:Destroy()
		elseif inst.Parent ~= nil or currentParent ~= nil then
			currentParent = inst.Parent
			parentMaid:GiveTask(currentParent:GetAttributeChangedSignal("AbsoluteElevation"):Connect(function()
				netElevation:set(currentParent:GetAttribute("AbsoluteElevation"))
			end))
		else
			resetParent(currentParent, parentMaid)
			netElevation:set(0)
			currentParent = nil
		end
	end))

	return inst
end

return constructor