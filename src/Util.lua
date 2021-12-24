local packages = script.Parent.Parent
local attributerConstructor = require(packages:WaitForChild("attributer"))
local fusion = require(packages:WaitForChild('fusion'))

local ed = Enum.EasingDirection
local es = Enum.EasingStyle

function updateElevation(inst)
	local newParent = inst.Parent
	if newParent:IsA("GuiObject") then
		local parentAbsElevation = newParent:GetAttribute("AbsoluteElevation") or 0
		inst:SetAttribute("AbsoluteElevation", parentAbsElevation + inst:GetAttribute("ElevationIncrease"))
	end
end

return {
	setPublicState = function(key, state, inst, maid)
		--bind to attributes
		local attributer = maid._attributer or attributerConstructor.new(inst, {})
		maid._attributer = attributer
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
		bindAttributeToState(key, state)
	end,

	init = function(key, inst, maid)
		inst:SetAttribute("SynthClass", key)
		inst:SetAttribute("ElevationIncrease", 1)
		inst:SetAttribute("AbsoluteElevation", 0)

		maid.deathSignal = inst.AncestryChanged:Connect(function()
			if not inst:IsDescendantOf(game.Players.LocalPlayer) then
				for i, desc in ipairs(inst:GetDescendants()) do
					desc:Destroy()
				end
				maid:Destroy()
			else
				updateElevation(inst)
			end
		end)
	end,

	newTweenInfo = function(params)  --default is a nice smooth transition
		params = params or {}
		local duration = params.Duration or 0.4
		local easingStyle = params.EasingStyle or es.Quint
		local easingDirection = params.EasingDirection or ed.InOut
		local repeatCount = params.RepeatCount or 0
		local reverses = params.Reverses or false
		local delayTime = params.DelayTime or 0
		return TweenInfo.new(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime)
	end,

	mergeConfig = function(baseConfig, changes, ignore)
		ignore = ignore or {}
		for k, v in ipairs(baseConfig) do
			if ignore[k] ~= true then
				baseConfig[k] = changes[k] or baseConfig[k]
			end
		end
		if not baseConfig.Parent then
			baseConfig.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
		end
		return baseConfig
	end
}