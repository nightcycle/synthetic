local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild('attributer'))

local multiplier = 2.5
local elevationToValueGain = {
	[0] = 0*multiplier,
	[1] = 0.05*multiplier,
	[2] = 0.07*multiplier,
	[3] = 0.08*multiplier,
	[4] = 0.09*multiplier,
	[5] = 0.11*multiplier,
	[6] = 0.12*multiplier,
	[7] = 0.14*multiplier,
	[8] = 0.15*multiplier,
	[9] = 0.16*multiplier,
}


local maxShadowDistance = 7
local minShadowDistance = 1
local minTransparency = 0.2
local maxTransparency = 0.7

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

function constructor.new(config)
	config = config or {}
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
		local avgValue = maxVal - range*alpha
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

	-- local goalTransparencySequence = fusion.Computed(function()
	-- 	return NumberSequence.new(0.16, 0.16-lightValue:get())
	-- end)
	local inst
	local goalColorSequence = fusion.Computed(function()
		local minVal = 1-0.16
		local val = minVal+lightValue:get()
		if inst then
			inst:SetAttribute("_val", val)
		end
		local highVal = math.clamp(val,0,1)
		local lowVal = math.clamp(val-0.03, 0, 1)
		local highCol = Color3.new(highVal,highVal,highVal)
		local lowCol = Color3.new(lowVal,lowVal,lowVal)
		return ColorSequence.new(highCol, lowCol)
	end)

	--create inst
	config.Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
	config.Name = config.Name or script.Name
	config.Color = config.Color or fusion.Tween(goalColorSequence, newTweenInfo())
	inst = fusion.New "UIGradient" (config)

	--connect goals to currents & parent with tweenCompat
	maid:GiveTask(inst)
	local function setParent(par)
		currentParent = inst.Parent
		if currentParent == nil then return end
		netElevation:set((currentParent:GetAttribute("AbsoluteElevation") or 0)+(currentParent:GetAttribute("ElevationIncrease") or 0))
		parentMaid:GiveTask(currentParent:GetAttributeChangedSignal("AbsoluteElevation"):Connect(function()
			if not inst:IsDescendantOf(game.Players.LocalPlayer) then return end
			if not currentParent then return end
			netElevation:set((currentParent:GetAttribute("AbsoluteElevation") or 0)+(currentParent:GetAttribute("ElevationIncrease") or 0))
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
			netElevation:set(0)
			currentParent = nil
		end
	end))
	if config.Parent then
		setParent(config.Parent)
	end
	return inst, maid
end

return constructor